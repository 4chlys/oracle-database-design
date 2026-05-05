CREATE OR REPLACE PACKAGE BODY PKG_S2_festivals AS

    -- Bulk-insert plumbing (PKG_SAMEN_festivals.bulk_errors,
    -- PKG_SAMEN_festivals.C_BULK_CHUNK) and the log / log_bulk_errors
    -- helpers live in the SAMEN package and are referenced in-line below.

    -- PUBLIC LOOKUP (also used internally by this package)
    FUNCTION lookup_festival_id(p_festival_name IN FESTIVAL.FESTIVAL_NAME%type) RETURN FESTIVAL.FESTIVAL_ID%type IS
        v_id FESTIVAL.FESTIVAL_ID%type;
    BEGIN
        SELECT Festival_ID
        INTO v_id
        FROM Festival
        WHERE Festival_Name = p_festival_name;
        RETURN v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20013,
                                    'Festival "' || p_festival_name || '" not found.');
    END lookup_festival_id;

    -- PRIVATE LOOKUP FUNCTIONS
    FUNCTION lookup_company_id(p_company_name IN COMPANY.COMPANY_NAME%type) RETURN COMPANY.COMPANY_ID%type IS
        v_id COMPANY.COMPANY_ID%type;
    BEGIN
        SELECT Company_ID
        INTO v_id
        FROM Company
        WHERE Company_Name = p_company_name;
        RETURN v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20014,
                                    'Company "' || p_company_name || '" not found.');
    END lookup_company_id;

    -- ---------------------------------------------------------

    FUNCTION lookup_city_id(p_zipcode IN CITY.ZIPCODE%type, p_country IN CITY.COUNTRY%type) RETURN CITY.CITY_ID%type IS
        v_id CITY.CITY_ID%type;
    BEGIN
        SELECT City_ID
        INTO v_id
        FROM City
        WHERE Zipcode = p_zipcode
          AND Country = p_country;
        RETURN v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20015,
                                    'City with zipcode "' || p_zipcode || '" in ' || p_country || ' not found.');
    END lookup_city_id;

    -- ---------------------------------------------------------

    FUNCTION lookup_genre_id(p_genre_name IN GENRE.GENRE_NAME%type) RETURN GENRE.GENRE_ID%type IS
        v_id GENRE.GENRE_ID%type;
    BEGIN
        SELECT Genre_ID
        INTO v_id
        FROM Genre
        WHERE Genre_Name = p_genre_name;
        RETURN v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20016,
                                    'Genre "' || p_genre_name || '" not found.');
    END lookup_genre_id;

    -- ---------------------------------------------------------

    FUNCTION lookup_artist_id(p_artist_name IN ARTIST.ARTIST_NAME%type) RETURN ARTIST.ARTIST_ID%type IS
        v_id ARTIST.ARTIST_ID%type;
    BEGIN
        SELECT Artist_ID
        INTO v_id
        FROM Artist
        WHERE Artist_Name = p_artist_name;
        RETURN v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20017,
                                    'Artist "' || p_artist_name || '" not found.');
    END lookup_artist_id;

    -- ---------------------------------------------------------

    FUNCTION lookup_stage_id(p_stage_name IN STAGE.STAGE_NAME%type,
                             p_festival_name IN FESTIVAL.FESTIVAL_NAME%type) RETURN STAGE.STAGE_ID%type IS
        v_id          STAGE.STAGE_ID%type;
        v_festival_id FESTIVAL.FESTIVAL_ID%type;
    BEGIN
        v_festival_id := lookup_festival_id(p_festival_name);
        SELECT Stage_ID
        INTO v_id
        FROM Stage
        WHERE Stage_Name = p_stage_name
          AND Festival_ID = v_festival_id;
        RETURN v_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20018,
                                    'Stage "' || p_stage_name || '" for festival "' || p_festival_name || '" not found.');
    END lookup_stage_id;

-- ------------------------------------------------------M5-------------------------------------------------------------

    PROCEDURE generateRandomGenres(p_amount IN NUMBER) IS
        v_start     TIMESTAMP := SYSTIMESTAMP;
        v_gen_done  TIMESTAMP;
        v_end       TIMESTAMP;
        v_rows      PLS_INTEGER;
        TYPE t_names     IS TABLE OF VARCHAR2(200) INDEX BY PLS_INTEGER;
        TYPE t_years     IS TABLE OF NUMBER        INDEX BY PLS_INTEGER;
        TYPE t_locations IS TABLE OF VARCHAR2(200) INDEX BY PLS_INTEGER;
        TYPE t_bpms      IS TABLE OF NUMBER        INDEX BY PLS_INTEGER;
        v_names      t_names;
        v_years      t_years;
        v_locations  t_locations;
        v_bpms       t_bpms;
        v_max_year   PLS_INTEGER := EXTRACT(YEAR FROM SYSDATE) - 1;
    BEGIN
        FOR i IN 1 .. p_amount LOOP
            -- give_random_combo guarantees a unique-looking name even though
            -- give_random_genre only has 10 entries to pick from.
            v_names(i)     := PKG_SAMEN_festivals.give_random_combo(
                                  PKG_SAMEN_festivals.give_random_genre, i);
            v_years(i)     := PKG_SAMEN_festivals.give_random_number(1900, v_max_year);
            v_locations(i) := PKG_SAMEN_festivals.give_random_location;
            v_bpms(i)      := PKG_SAMEN_festivals.give_random_number(60, 200);
        END LOOP;
        v_gen_done := SYSTIMESTAMP;

        BEGIN
            FORALL i IN 1 .. p_amount SAVE EXCEPTIONS
                INSERT INTO Genre (Genre_Name, Genre_Origin_Year, Genre_Origin_Location, Genre_BPM)
                VALUES (v_names(i), v_years(i), v_locations(i), v_bpms(i));
        EXCEPTION
            WHEN PKG_SAMEN_festivals.bulk_errors THEN
                PKG_SAMEN_festivals.log_bulk_errors('generateRandomGenres');
        END;
        v_rows := SQL%ROWCOUNT;
        v_end  := SYSTIMESTAMP;

        PKG_SAMEN_festivals.log('generateRandomGenres', 'p_amount=' || p_amount,
            v_rows,
            PKG_SAMEN_festivals.timestamp_diff(v_gen_done, v_start),
            PKG_SAMEN_festivals.timestamp_diff(v_end,      v_gen_done),
            PKG_SAMEN_festivals.timestamp_diff(v_end,      v_start));
    END generateRandomGenres;

    PROCEDURE generateRandomArtists(p_amount IN NUMBER) IS
        v_start     TIMESTAMP := SYSTIMESTAMP;
        v_gen_done  TIMESTAMP;
        v_end       TIMESTAMP;
        v_rows      PLS_INTEGER;
        TYPE t_names IS TABLE OF VARCHAR2(200) INDEX BY PLS_INTEGER;
        TYPE t_countries IS TABLE OF VARCHAR2(200) INDEX BY PLS_INTEGER;
        TYPE t_dates IS TABLE OF DATE INDEX BY PLS_INTEGER;
        TYPE t_numbers IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
        TYPE t_currs IS TABLE OF VARCHAR2(10) INDEX BY PLS_INTEGER;
        v_names     t_names;
        v_countries t_countries;
        v_bdays     t_dates;
        v_prices    t_numbers;
        v_currs     t_currs;
    BEGIN
        FOR i IN 1 .. p_amount
            LOOP
                v_names(i) := PKG_SAMEN_festivals.give_random_combo(
                        PKG_SAMEN_festivals.give_random_artist_prefix, i);
                v_countries(i) := PKG_SAMEN_festivals.give_random_country;
                v_bdays(i) := PKG_SAMEN_festivals.give_random_date(
                        TO_DATE('01-01-1960', 'DD-MM-YYYY'),
                        TO_DATE('31-12-2000', 'DD-MM-YYYY'));
                v_prices(i) := PKG_SAMEN_festivals.give_random_number(10000, 500000);
                v_currs(i)  := PKG_SAMEN_festivals.give_random_currency;
            END LOOP;
        v_gen_done := SYSTIMESTAMP;

        BEGIN
            FORALL i IN 1 .. p_amount SAVE EXCEPTIONS
                INSERT INTO Artist (Artist_Name, Artist_Birthday, Artist_Price,
                                    Artist_Price_Currency, Artist_Land_Of_Birth)
                VALUES (v_names(i), v_bdays(i), v_prices(i), v_currs(i), v_countries(i));
        EXCEPTION
            WHEN PKG_SAMEN_festivals.bulk_errors THEN
                PKG_SAMEN_festivals.log_bulk_errors('generateRandomArtists');
        END;
        v_rows := SQL%ROWCOUNT;
        v_end  := SYSTIMESTAMP;

        PKG_SAMEN_festivals.log('generateRandomArtists', 'p_amount=' || p_amount,
            v_rows,
            PKG_SAMEN_festivals.timestamp_diff(v_gen_done, v_start),
            PKG_SAMEN_festivals.timestamp_diff(v_end,      v_gen_done),
            PKG_SAMEN_festivals.timestamp_diff(v_end,      v_start));
    END generateRandomArtists;

    PROCEDURE generateRandomFestivals(p_amount IN NUMBER) IS
        v_start      TIMESTAMP := SYSTIMESTAMP;
        v_gen_done   TIMESTAMP;
        v_end        TIMESTAMP;
        v_rows       PLS_INTEGER;

        TYPE t_id_tab   IS TABLE OF NUMBER                              INDEX BY PLS_INTEGER;
        TYPE t_name_tab IS TABLE OF VARCHAR2(200)                       INDEX BY PLS_INTEGER;
        TYPE t_date_tab IS TABLE OF DATE                                INDEX BY PLS_INTEGER;
        TYPE t_hour_tab IS TABLE OF FESTIVAL.FESTIVAL_OPENING_HOUR%TYPE INDEX BY PLS_INTEGER;

        -- Reference pools (BULK COLLECT replaces row-by-row cursor loops)
        v_comp_pool  t_id_tab;
        v_city_pool  t_id_tab;

        -- Insert arrays (one slot per festival)
        v_names      t_name_tab;
        v_comp_arr   t_id_tab;
        v_city_arr   t_id_tab;
        v_starts     t_date_tab;
        v_ends       t_date_tab;
        v_locs       t_name_tab;
        v_opens      t_hour_tab;
        v_closes     t_hour_tab;
        v_caps       t_id_tab;

        v_comp_count PLS_INTEGER;
        v_city_count PLS_INTEGER;
        v_open       FESTIVAL.FESTIVAL_OPENING_HOUR%TYPE;
    BEGIN
        SELECT COMPANY_ID BULK COLLECT INTO v_comp_pool FROM COMPANY;
        SELECT CITY_ID    BULK COLLECT INTO v_city_pool FROM CITY;
        v_comp_count := v_comp_pool.COUNT;
        v_city_count := v_city_pool.COUNT;

        IF v_comp_count = 0 OR v_city_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20019,
                                    'generateRandomFestivals requires Company and City to be populated first');
        END IF;

        FOR i IN 1 .. p_amount LOOP
            v_names(i)    := PKG_SAMEN_festivals.give_unique_combo(
                                 PKG_SAMEN_festivals.give_random_location
                                     || ' ' || PKG_SAMEN_festivals.give_random_festival_suffix, i);
            v_comp_arr(i) := v_comp_pool(PKG_SAMEN_festivals.give_random_number(1, v_comp_count));
            v_city_arr(i) := v_city_pool(PKG_SAMEN_festivals.give_random_number(1, v_city_count));
            v_starts(i)   := PKG_SAMEN_festivals.give_random_date(
                                 TO_DATE('01-06-2024', 'DD-MM-YYYY'),
                                 TO_DATE('01-09-2026', 'DD-MM-YYYY'));
            v_ends(i)     := v_starts(i) + PKG_SAMEN_festivals.give_random_number(2, 5);
            v_locs(i)     := PKG_SAMEN_festivals.give_random_location;
            v_open        := TRUNC(SYSDATE) + PKG_SAMEN_festivals.give_random_number(9, 14) / 24;
            v_opens(i)    := v_open;
            v_closes(i)   := v_open + PKG_SAMEN_festivals.give_random_number(10, 18) / 24;
            v_caps(i)     := PKG_SAMEN_festivals.give_random_number(10000, 200000);
        END LOOP;
        v_gen_done := SYSTIMESTAMP;

        BEGIN
            FORALL i IN 1 .. p_amount SAVE EXCEPTIONS
                INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate,
                                      Festival_EndDate, Festival_Location, City_ID,
                                      Festival_Opening_Hour, Festival_Closing_Hour,
                                      Festival_Capacity)
                VALUES (v_names(i), v_comp_arr(i), v_starts(i),
                        v_ends(i), v_locs(i), v_city_arr(i),
                        v_opens(i), v_closes(i), v_caps(i));
        EXCEPTION
            WHEN PKG_SAMEN_festivals.bulk_errors THEN
                PKG_SAMEN_festivals.log_bulk_errors('generateRandomFestivals');
        END;
        v_rows := SQL%ROWCOUNT;
        v_end  := SYSTIMESTAMP;

        PKG_SAMEN_festivals.log('generateRandomFestivals', 'p_amount=' || p_amount,
            v_rows,
            PKG_SAMEN_festivals.timestamp_diff(v_gen_done, v_start),
            PKG_SAMEN_festivals.timestamp_diff(v_end,      v_gen_done),
            PKG_SAMEN_festivals.timestamp_diff(v_end,      v_start));
    END generateRandomFestivals;

    -- ===========================================================
    -- M5 STAP 3 – generateRandomStages
    --   Tabel Y: generates p_per_festival Stage rows for EACH
    --   Festival currently in the DB.
    --
    --   Mandatory: uses a NESTED TABLE collection to load Festival IDs.
    -- ===========================================================
    PROCEDURE generateRandomStages(p_per_festival IN NUMBER) IS
        v_start        TIMESTAMP := SYSTIMESTAMP;
        v_gen_secs     NUMBER    := 0;   -- accumulates random-data-prep time
        v_ins_secs     NUMBER    := 0;   -- accumulates FORALL bulk-insert time
        v_seg_start    TIMESTAMP;        -- start of the current generation segment

        -- NESTED TABLE collection (required by assignment for Tabel Y)
        TYPE t_festival_tab IS TABLE OF FESTIVAL.FESTIVAL_ID%TYPE;
        v_festival_ids t_festival_tab;

        TYPE t_id_tab  IS TABLE OF NUMBER       INDEX BY PLS_INTEGER;
        TYPE t_str_tab IS TABLE OF VARCHAR2(500) INDEX BY PLS_INTEGER;

        -- Insert arrays (one chunk's worth of rows; reset on each flush)
        v_fid_arr  t_id_tab;
        v_names    t_str_tab;
        v_styles   t_str_tab;
        v_caps     t_id_tab;
        v_toilets  t_id_tab;
        v_descs    t_str_tab;
        v_roofed   t_id_tab;

        v_roofed_val NUMBER;
        k            PLS_INTEGER := 0;
        v_total      PLS_INTEGER := 0;
        v_style_max  PLS_INTEGER;
        v_desc_max   PLS_INTEGER;

        PROCEDURE flush IS
            t_ins_start TIMESTAMP;
        BEGIN
            IF k = 0 THEN RETURN; END IF;
            t_ins_start := SYSTIMESTAMP;
            BEGIN
                FORALL i IN 1 .. k SAVE EXCEPTIONS
                    INSERT INTO Stage (Stage_Name, Festival_ID,
                                       Stage_Style_Description,
                                       Stage_Standing_Capacity,
                                       Stage_Toilet_Count,
                                       Stage_Description,
                                       Stage_Roofed_Status)
                    VALUES (v_names(i), v_fid_arr(i), v_styles(i),
                            v_caps(i), v_toilets(i), v_descs(i), v_roofed(i));
            EXCEPTION
                WHEN PKG_SAMEN_festivals.bulk_errors THEN
                    PKG_SAMEN_festivals.log_bulk_errors('generateRandomStages', v_total);
            END;
            v_ins_secs := v_ins_secs
                + PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, t_ins_start);
            v_total := v_total + SQL%ROWCOUNT;
            v_fid_arr.DELETE; v_names.DELETE; v_styles.DELETE;
            v_caps.DELETE; v_toilets.DELETE; v_descs.DELETE; v_roofed.DELETE;
            k := 0;
        END flush;
    BEGIN
        SELECT DATA_LENGTH INTO v_style_max
        FROM USER_TAB_COLUMNS
        WHERE TABLE_NAME = 'STAGE' AND COLUMN_NAME = 'STAGE_STYLE_DESCRIPTION';

        SELECT DATA_LENGTH INTO v_desc_max
        FROM USER_TAB_COLUMNS
        WHERE TABLE_NAME = 'STAGE' AND COLUMN_NAME = 'STAGE_DESCRIPTION';

        SELECT Festival_ID BULK COLLECT INTO v_festival_ids FROM Festival;

        IF v_festival_ids.COUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20020,
                                    'generateRandomStages requires at least one Festival row '
                );
        END IF;

        -- Build rows in PL/SQL, flushing every PKG_SAMEN_festivals.C_BULK_CHUNK to bound PGA usage.
        -- Pause the gen timer around each flush so v_gen_secs only counts
        -- random-data preparation, not the FORALL bulk insert.
        v_seg_start := SYSTIMESTAMP;
        FOR fi IN 1 .. v_festival_ids.COUNT LOOP
            FOR si IN 1 .. p_per_festival LOOP
                k := k + 1;
                v_fid_arr(k)  := v_festival_ids(fi);
                v_names(k)    := PKG_SAMEN_festivals.give_unique_combo(
                                     PKG_SAMEN_festivals.give_random_artist_prefix
                                         || ' ' || PKG_SAMEN_festivals.give_random_stage_suffix,
                                     (fi - 1) * p_per_festival + si);
                v_roofed_val  := PKG_SAMEN_festivals.give_random_number(0, 1);
                v_roofed(k)   := v_roofed_val;
                v_caps(k)     := PKG_SAMEN_festivals.give_random_number(3000, 80000);
                v_toilets(k)  := PKG_SAMEN_festivals.give_random_number(20, 300);
                v_styles(k)   := SUBSTR(
                                     CASE v_roofed_val
                                         WHEN 1 THEN 'Indoor covered venue: '
                                         ELSE 'Open air stage: '
                                     END
                                     || PKG_SAMEN_festivals.give_random_description,
                                     1, v_style_max);
                v_descs(k)    := SUBSTR(PKG_SAMEN_festivals.give_random_description, 1, v_desc_max);

                IF k >= PKG_SAMEN_festivals.C_BULK_CHUNK THEN
                    v_gen_secs := v_gen_secs
                        + PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_seg_start);
                    flush;
                    v_seg_start := SYSTIMESTAMP;
                END IF;
            END LOOP;
        END LOOP;
        v_gen_secs := v_gen_secs
            + PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_seg_start);
        flush;

        PKG_SAMEN_festivals.log('generateRandomStages',
            'p_per_festival=' || p_per_festival
                || ', festivals_processed=' || v_festival_ids.COUNT,
            v_total,
            v_gen_secs,
            v_ins_secs,
            PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_start));
    END generateRandomStages;

    -- ===========================================================
    -- M5 STAP 3 – generateRandomPerformances
    --   Tabel Z: generates p_per_stage Performance rows for EACH
    --   Stage currently in the DB.
    --
    --   Mandatory: uses an ASSOCIATIVE ARRAY (INDEX BY) to load
    --   Stage data (id + festival start/end dates).
    -- ===========================================================
    PROCEDURE generateRandomPerformances(p_per_stage IN NUMBER) IS
        v_start      TIMESTAMP := SYSTIMESTAMP;
        v_gen_secs   NUMBER    := 0;   -- accumulates random-data-prep time
        v_ins_secs   NUMBER    := 0;   -- accumulates FORALL bulk-insert time
        v_seg_start  TIMESTAMP;        -- start of the current generation segment

        -- Record type for stage context
        TYPE t_stage_rec IS RECORD
        (
            stage_id       STAGE.STAGE_ID%TYPE,
            festival_start FESTIVAL.FESTIVAL_STARTDATE%TYPE,
            festival_end   FESTIVAL.FESTIVAL_ENDDATE%TYPE
        );

        -- ASSOCIATIVE ARRAY (INDEX BY PLS_INTEGER) – required by assignment
        TYPE t_stage_map IS TABLE OF t_stage_rec INDEX BY PLS_INTEGER;
        v_stages     t_stage_map;
        v_idx        PLS_INTEGER := 0;

        -- Bulk-load helpers for stages
        TYPE t_id_list   IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
        TYPE t_date_list IS TABLE OF DATE   INDEX BY PLS_INTEGER;
        v_s_ids    t_id_list;
        v_f_starts t_date_list;
        v_f_ends   t_date_list;

        -- Reference pools loaded with BULK COLLECT
        v_artist_ids t_id_list;
        v_genre_ids  t_id_list;
        v_art_count  PLS_INTEGER;
        v_gen_count  PLS_INTEGER;

        -- Insert arrays (one chunk's worth of rows; reset on each flush)
        TYPE t_str_list IS TABLE OF VARCHAR2(500) INDEX BY PLS_INTEGER;
        v_perf_starts t_date_list;
        v_perf_ends   t_date_list;
        v_ins_artist  t_id_list;
        v_ins_genre   t_id_list;
        v_ins_stage   t_id_list;
        v_descs       t_str_list;

        v_perf_start   DATE;
        v_duration_hr  PLS_INTEGER;
        v_latest_start DATE;
        k              PLS_INTEGER := 0;
        v_total        PLS_INTEGER := 0;
        v_desc_max     PLS_INTEGER;

        PROCEDURE flush IS
            t_ins_start TIMESTAMP;
        BEGIN
            IF k = 0 THEN RETURN; END IF;
            t_ins_start := SYSTIMESTAMP;
            BEGIN
                FORALL i IN 1 .. k SAVE EXCEPTIONS
                    INSERT INTO Performance (Performance_Start_Time,
                                             Performance_End_Time,
                                             Artist_ID, Genre_ID, Stage_ID,
                                             Performance_Description)
                    VALUES (v_perf_starts(i), v_perf_ends(i),
                            v_ins_artist(i), v_ins_genre(i),
                            v_ins_stage(i), v_descs(i));
            EXCEPTION
                WHEN PKG_SAMEN_festivals.bulk_errors THEN
                    PKG_SAMEN_festivals.log_bulk_errors('generateRandomPerformances', v_total);
            END;
            v_ins_secs := v_ins_secs
                + PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, t_ins_start);
            v_total := v_total + SQL%ROWCOUNT;
            v_perf_starts.DELETE; v_perf_ends.DELETE;
            v_ins_artist.DELETE; v_ins_genre.DELETE; v_ins_stage.DELETE;
            v_descs.DELETE;
            k := 0;
        END flush;
    BEGIN
        SELECT DATA_LENGTH INTO v_desc_max
        FROM USER_TAB_COLUMNS
        WHERE TABLE_NAME = 'PERFORMANCE' AND COLUMN_NAME = 'PERFORMANCE_DESCRIPTION';

        -- Bulk load stage + festival dates, then populate the required associative array of records
        SELECT s.Stage_ID, f.Festival_StartDate, f.Festival_EndDate
        BULK COLLECT INTO v_s_ids, v_f_starts, v_f_ends
        FROM Stage s JOIN Festival f ON f.Festival_ID = s.Festival_ID;

        IF v_s_ids.COUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20021,
                'generateRandomPerformances requires at least one Stage row '
                || '(call generateRandomStages or bewijs_M4_S2 first).');
        END IF;

        FOR i IN 1 .. v_s_ids.COUNT LOOP
            v_idx := v_idx + 1;
            v_stages(v_idx).stage_id       := v_s_ids(i);
            v_stages(v_idx).festival_start := v_f_starts(i);
            v_stages(v_idx).festival_end   := v_f_ends(i);
        END LOOP;

        -- Bulk load artist and genre reference pools
        SELECT Artist_ID BULK COLLECT INTO v_artist_ids FROM Artist;
        SELECT Genre_ID  BULK COLLECT INTO v_genre_ids  FROM Genre;
        v_art_count := v_artist_ids.COUNT;
        v_gen_count := v_genre_ids.COUNT;

        IF v_art_count = 0 OR v_gen_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20022,
                'generateRandomPerformances requires Artist and Genre to be populated first.');
        END IF;

        -- Build rows in PL/SQL, flushing every PKG_SAMEN_festivals.C_BULK_CHUNK to bound PGA usage.
        -- Constrain so the END time still falls within the festival's date range
        -- (add_performance only checks the start, but the bulk path enforces both).
        -- Pause the gen timer around each flush so v_gen_secs only counts
        -- random-data preparation, not the FORALL bulk insert.
        v_seg_start := SYSTIMESTAMP;
        FOR si IN 1 .. v_idx LOOP
            FOR pi IN 1 .. p_per_stage LOOP
                k := k + 1;
                v_duration_hr  := PKG_SAMEN_festivals.give_random_number(1, 3);
                v_latest_start := v_stages(si).festival_end + (24 - v_duration_hr) / 24;
                v_perf_start   := TRUNC(
                                      PKG_SAMEN_festivals.give_random_date(
                                          v_stages(si).festival_start + 18/24,
                                          v_latest_start),
                                      'HH24');
                v_perf_starts(k) := v_perf_start;
                v_perf_ends(k)   := v_perf_start + v_duration_hr / 24;
                v_ins_artist(k)  := v_artist_ids(PKG_SAMEN_festivals.give_random_number(1, v_art_count));
                v_ins_genre(k)   := v_genre_ids(PKG_SAMEN_festivals.give_random_number(1, v_gen_count));
                v_ins_stage(k)   := v_stages(si).stage_id;
                v_descs(k)       := SUBSTR(PKG_SAMEN_festivals.give_random_description, 1, v_desc_max);

                IF k >= PKG_SAMEN_festivals.C_BULK_CHUNK THEN
                    v_gen_secs := v_gen_secs
                        + PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_seg_start);
                    flush;
                    v_seg_start := SYSTIMESTAMP;
                END IF;
            END LOOP;
        END LOOP;
        v_gen_secs := v_gen_secs
            + PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_seg_start);
        flush;

        PKG_SAMEN_festivals.log('generateRandomPerformances',
            'p_per_stage=' || p_per_stage
                || ', stages_processed=' || v_idx,
            v_total,
            v_gen_secs,
            v_ins_secs,
            PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_start));
    END generateRandomPerformances;

    PROCEDURE bewijs_M5_S2(p_genres    IN NUMBER,
                                    p_festivals IN NUMBER,
                                    p_stages    IN NUMBER,
                                    p_perfs     IN NUMBER) IS
        v_start TIMESTAMP := SYSTIMESTAMP;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== bewijs_milestone_5_S2 START ===');
        DBMS_OUTPUT.PUT_LINE('params: p_genres=' || p_genres
            || ' | p_festivals=' || p_festivals
            || ' | p_stages=' || p_stages
            || ' | p_perfs=' || p_perfs);

        -- p_genres is reused as the Artist count too: every Genre row gets a
        -- companion Artist so the Performance generator has variety on both axes.
        -- Genres must exist before Performances (FK) and before any code that
        -- references Genre, so generate them first.
        generateRandomGenres(p_genres);
        generateRandomArtists(p_genres);

        -- Tabel W/X: Festivals
        generateRandomFestivals(p_festivals);

        -- Tabel Y: Stages
        generateRandomStages(p_stages);

        -- Tabel Z: Performances
        generateRandomPerformances(p_perfs);

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('=== bewijs_milestone_5_S2 END | total duration: '
            || ROUND(PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_start) * 1000)
            || ' ms ===');
    END bewijs_M5_S2;

-- ---------------------------------------------------------------------------------------------------------------------
    -- PRIVATE ADD PROCEDURES

    PROCEDURE add_festival(p_name IN FESTIVAL.FESTIVAL_NAME%type,
                           p_company_name IN COMPANY.COMPANY_NAME%type,
                           p_start_date IN FESTIVAL.FESTIVAL_STARTDATE%type,
                           p_end_date IN FESTIVAL.FESTIVAL_ENDDATE%type,
                           p_location IN FESTIVAL.FESTIVAL_LOCATION%type,
                           p_zipcode IN CITY.ZIPCODE%type,
                           p_country IN CITY.COUNTRY%type,
                           p_opening_hour IN FESTIVAL.FESTIVAL_OPENING_HOUR%type,
                           p_closing_hour IN FESTIVAL.FESTIVAL_CLOSING_HOUR%type,
                           p_capacity IN FESTIVAL.FESTIVAL_CAPACITY%type) IS
        v_company_id FESTIVAL.COMPANY_ID%type;
        v_city_id    FESTIVAL.CITY_ID%type;
    BEGIN
        -- Pre-fetch IDs into variables (PL/SQL functions cannot be called
        -- directly inside a SQL VALUES clause within the same package)
        v_company_id := lookup_company_id(p_company_name);
        v_city_id := lookup_city_id(p_zipcode, p_country);

        INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                              Festival_Location, City_ID,
                              Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
        VALUES (p_name,
                v_company_id,
                p_start_date,
                p_end_date,
                p_location,
                v_city_id,
                p_opening_hour,
                p_closing_hour,
                p_capacity);
    END add_festival;

    -- ---------------------------------------------------------

    PROCEDURE add_genre(p_name IN GENRE.GENRE_NAME%type,
                        p_origin_year IN GENRE.GENRE_ORIGIN_YEAR%type,
                        p_origin_location IN GENRE.GENRE_ORIGIN_LOCATION%type,
                        p_bpm IN GENRE.GENRE_BPM%type) IS
    BEGIN
        IF p_origin_year >= EXTRACT(YEAR FROM SYSDATE) THEN
            RAISE_APPLICATION_ERROR(-20003,
                                    'Genre origin year must be in the past.');
        END IF;
        INSERT INTO Genre (Genre_Name, Genre_Origin_Year, Genre_Origin_Location, Genre_BPM)
        VALUES (p_name, p_origin_year, p_origin_location, p_bpm);
    END add_genre;

    -- ---------------------------------------------------------

    PROCEDURE add_artist(p_name IN ARTIST.ARTIST_NAME%type,
                         p_birthday IN ARTIST.ARTIST_BIRTHDAY%type,
                         p_price IN ARTIST.ARTIST_PRICE%type,
                         p_currency IN ARTIST.ARTIST_PRICE_CURRENCY%type,
                         p_land_of_birth IN ARTIST.ARTIST_LAND_OF_BIRTH%type) IS
    BEGIN
        IF p_birthday >= SYSDATE THEN
            RAISE_APPLICATION_ERROR(-20002,
                                    'Artist birthday must be in the past.');
        END IF;
        INSERT INTO Artist (Artist_Name, Artist_Birthday, Artist_Price,
                            Artist_Price_Currency, Artist_Land_Of_Birth)
        VALUES (p_name, p_birthday, p_price, p_currency, p_land_of_birth);
    END add_artist;

    -- ---------------------------------------------------------

    PROCEDURE add_stage(p_stage_name IN STAGE.STAGE_NAME%type,
                        p_festival_name IN FESTIVAL.FESTIVAL_NAME%type,
                        p_style_desc IN STAGE.STAGE_STYLE_DESCRIPTION%type,
                        p_capacity IN STAGE.STAGE_STANDING_CAPACITY%type,
                        p_toilet_count IN STAGE.STAGE_TOILET_COUNT%type,
                        p_description IN STAGE.STAGE_STYLE_DESCRIPTION%type,
                        p_roofed IN STAGE.STAGE_ROOFED_STATUS%type) IS
        v_festival_id STAGE.FESTIVAL_ID%type;
    BEGIN
        v_festival_id := lookup_festival_id(p_festival_name);

        INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description,
                           Stage_Standing_Capacity, Stage_Toilet_Count,
                           Stage_Description, Stage_Roofed_Status)
        VALUES (p_stage_name,
                v_festival_id,
                p_style_desc,
                p_capacity,
                p_toilet_count,
                p_description,
                p_roofed);
    END add_stage;

    -- ---------------------------------------------------------

    PROCEDURE add_performance(p_start_time IN PERFORMANCE.PERFORMANCE_START_TIME%type,
                              p_end_time IN PERFORMANCE.PERFORMANCE_END_TIME%type,
                              p_artist_name IN ARTIST.ARTIST_NAME%type,
                              p_genre_name IN GENRE.GENRE_NAME%type,
                              p_stage_name IN STAGE.STAGE_NAME%type,
                              p_festival_name IN FESTIVAL.FESTIVAL_NAME%type,
                              p_description IN PERFORMANCE.PERFORMANCE_DESCRIPTION%type) IS
        v_festival_start FESTIVAL.FESTIVAL_STARTDATE%type;
        v_festival_end   FESTIVAL.FESTIVAL_ENDDATE%type;
        v_artist_id      PERFORMANCE.ARTIST_ID%type;
        v_genre_id       PERFORMANCE.GENRE_ID%type;
        v_stage_id       PERFORMANCE.STAGE_ID%type;
    BEGIN
        v_artist_id := lookup_artist_id(p_artist_name);
        v_genre_id := lookup_genre_id(p_genre_name);
        v_stage_id := lookup_stage_id(p_stage_name, p_festival_name);

        SELECT Festival_StartDate, Festival_EndDate
        INTO v_festival_start, v_festival_end
        FROM Festival
        WHERE Festival_Name = p_festival_name;

        -- M4 S2 rule: performance start date must fall within the festival's date range
        IF TRUNC(p_start_time) < v_festival_start OR TRUNC(p_start_time) > v_festival_end THEN
            RAISE_APPLICATION_ERROR(-20001,
                                    'Performance start date ' || TO_CHAR(p_start_time, 'DD-MM-YYYY') ||
                                    ' must fall within festival dates (' ||
                                    TO_CHAR(v_festival_start, 'DD-MM-YYYY') || ' - ' ||
                                    TO_CHAR(v_festival_end, 'DD-MM-YYYY') || ').');
        END IF;

        INSERT INTO Performance (Performance_Start_Time, Performance_End_Time,
                                 Artist_ID, Genre_ID, Stage_ID,
                                 Performance_Description)
        VALUES (p_start_time,
                p_end_time,
                v_artist_id,
                v_genre_id,
                v_stage_id,
                p_description);
    END add_performance;

-- ---------------------------------------------------------------------------------------------------------------------

    -- PUBLIC: EMPTY TABLES

    PROCEDURE empty_tables_S2 IS
    BEGIN
        -- Delete in FK order: deepest children first
        -- Performance references Stage, Artist, Genre
        -- Stage references Festival
        -- Festival is referenced by Ticket and Permit (S1 tables)
        --   → S1 must call empty_tables_S1 BEFORE this, or
        --     S1 must empty Ticket/Permit before we delete Festival.
        -- In the SAMEN script we call S1 empty first, then S2 empty.
        DELETE FROM Performance;
        DELETE FROM Stage;
        DELETE FROM Festival;
        DELETE FROM Artist;
        DELETE FROM Genre;
        -- Purge orphaned identity sequences of previously dropped tables.
        EXECUTE IMMEDIATE 'PURGE RECYCLEBIN';
        COMMIT;
    END empty_tables_S2;

    -- PUBLIC: FILL TABLES (bewijs_M4_S2)

    PROCEDURE bewijs_M4_S2 IS
    BEGIN

        -- -------------------------------------------------------
        -- 1. FESTIVAL
        -- Company and City are S1 tables and must already exist.
        -- -------------------------------------------------------
        add_festival('Tomorrowland Summer 2024', 'Tomorrowland NV',
                     TO_DATE('19-07-2024', 'DD-MM-YYYY'), TO_DATE('21-07-2024', 'DD-MM-YYYY'),
                     'De Schorre', '2850', 'Belgium',
                     TO_DATE('10:00', 'HH24:MI'), TO_DATE('10:00', 'HH24:MI') + INTERVAL '17' HOUR, 200000);

        add_festival('Rock Werchter 2024', 'Rock Werchter Productions',
                     TO_DATE('04-07-2024', 'DD-MM-YYYY'), TO_DATE('07-07-2024', 'DD-MM-YYYY'),
                     'Festivalpark Werchter', '3118', 'Belgium',
                     TO_DATE('11:00', 'HH24:MI'), TO_DATE('11:00', 'HH24:MI') + INTERVAL '15' HOUR, 90000);

        add_festival('Pukkelpop 2024', 'Pukkelpop VZW',
                     TO_DATE('15-08-2024', 'DD-MM-YYYY'), TO_DATE('18-08-2024', 'DD-MM-YYYY'),
                     'Hasselt Kiewit', '3500', 'Belgium',
                     TO_DATE('12:00', 'HH24:MI'), TO_DATE('12:00', 'HH24:MI') + INTERVAL '13' HOUR, 65000);

        add_festival('Sziget Festival 2024', 'Sziget Cultural Management',
                     TO_DATE('07-08-2024', 'DD-MM-YYYY'), TO_DATE('12-08-2024', 'DD-MM-YYYY'),
                     'Óbudai-sziget', '1117BP', 'Hungary',
                     TO_DATE('10:00', 'HH24:MI'), TO_DATE('10:00', 'HH24:MI') + INTERVAL '18' HOUR, 100000);

        add_festival('Roskilde Festival 2024', 'Roskilde Festival Society',
                     TO_DATE('29-06-2024', 'DD-MM-YYYY'), TO_DATE('06-07-2024', 'DD-MM-YYYY'),
                     'Roskilde Dyrskueplads', '4000', 'Denmark',
                     TO_DATE('09:00', 'HH24:MI'), TO_DATE('09:00', 'HH24:MI') + INTERVAL '18' HOUR, 130000);

        add_festival('Glastonbury 2025', 'Glastonbury Festivals Ltd',
                     TO_DATE('25-06-2025', 'DD-MM-YYYY'), TO_DATE('29-06-2025', 'DD-MM-YYYY'),
                     'Worthy Farm Pilton', 'BA44AF', 'United Kingdom',
                     TO_DATE('08:00', 'HH24:MI'), TO_DATE('08:00', 'HH24:MI') + INTERVAL '21' HOUR, 210000);

        add_festival('Primavera Sound 2025', 'Primavera Sound SL',
                     TO_DATE('29-05-2025', 'DD-MM-YYYY'), TO_DATE('01-06-2025', 'DD-MM-YYYY'),
                     'Parc del Fòrum', '08003', 'Spain',
                     TO_DATE('14:00', 'HH24:MI'), TO_DATE('14:00', 'HH24:MI') + INTERVAL '14' HOUR, 75000);

        add_festival('Melt! Festival 2025', 'Melt! Festival GmbH',
                     TO_DATE('18-07-2025', 'DD-MM-YYYY'), TO_DATE('20-07-2025', 'DD-MM-YYYY'),
                     'Ferropolis Industriepark', '06773', 'Germany',
                     TO_DATE('13:00', 'HH24:MI'), TO_DATE('13:00', 'HH24:MI') + INTERVAL '16' HOUR, 25000);

        add_festival('Tomorrowland Winter 2025', 'Tomorrowland NV',
                     TO_DATE('08-03-2025', 'DD-MM-YYYY'), TO_DATE('15-03-2025', 'DD-MM-YYYY'),
                     'Alpe d''Huez', '1000', 'Belgium',
                     TO_DATE('10:00', 'HH24:MI'), TO_DATE('10:00', 'HH24:MI') + INTERVAL '16' HOUR, 30000);

        add_festival('Lollapalooza Berlin 2025', 'AEG Presents Europe',
                     TO_DATE('07-09-2025', 'DD-MM-YYYY'), TO_DATE('08-09-2025', 'DD-MM-YYYY'),
                     'Olympiastadion Berlin', '10115', 'Germany',
                     TO_DATE('11:00', 'HH24:MI'), TO_DATE('11:00', 'HH24:MI') + INTERVAL '12' HOUR, 85000);

        -- 2. GENRE
        add_genre('Electronic', 1970, 'Chicago, USA', 128);
        add_genre('Rock', 1955, 'Memphis, USA', 120);
        add_genre('Pop', 1960, 'New York, USA', 110);
        add_genre('Hip-Hop', 1973, 'Bronx, New York, USA', 90);
        add_genre('Techno', 1985, 'Detroit, USA', 140);
        add_genre('House', 1983, 'Chicago, USA', 125);
        add_genre('Drum and Bass', 1991, 'London, UK', 170);
        add_genre('Trance', 1990, 'Frankfurt, Germany', 138);
        add_genre('Indie Rock', 1980, 'New York, USA', 115);
        add_genre('Reggae', 1960, 'Kingston, Jamaica', 80);

        -- 3. ARTIST
        add_artist('Martin Garrix', TO_DATE('14-05-1996', 'DD-MM-YYYY'), 500000, 'EUR', 'Netherlands');
        add_artist('Kendrick Lamar', TO_DATE('17-06-1987', 'DD-MM-YYYY'), 1200000, 'USD', 'United States');
        add_artist('Billie Eilish', TO_DATE('18-12-2001', 'DD-MM-YYYY'), 900000, 'USD', 'United States');
        add_artist('Stromae', TO_DATE('12-03-1985', 'DD-MM-YYYY'), 400000, 'EUR', 'Belgium');
        add_artist('David Guetta', TO_DATE('07-11-1967', 'DD-MM-YYYY'), 600000, 'EUR', 'France');
        add_artist('Rammstein', TO_DATE('01-01-1994', 'DD-MM-YYYY'), 800000, 'EUR', 'Germany');
        add_artist('Arctic Monkeys', TO_DATE('01-06-2002', 'DD-MM-YYYY'), 750000, 'GBP', 'United Kingdom');
        add_artist('Bad Bunny', TO_DATE('10-03-1994', 'DD-MM-YYYY'), 1500000, 'USD', 'Puerto Rico');
        add_artist('Charlotte de Witte', TO_DATE('15-10-1992', 'DD-MM-YYYY'), 80000, 'EUR', 'Belgium');
        add_artist('Bicep', TO_DATE('01-01-2009', 'DD-MM-YYYY'), 120000, 'GBP', 'United Kingdom');

        -- 4. STAGE
        -- Tomorrowland Summer 2024
        add_stage('Mainstage', 'Tomorrowland Summer 2024', 'Grand pyramid structure with full LED canopy', 80000, 200,
                  'The iconic main stage with world-class production', 0);
        add_stage('Freedom Stage', 'Tomorrowland Summer 2024', 'Underground bunker-style enclosed venue', 15000, 80,
                  'Dark and deep electronic music venue', 1);
        -- Rock Werchter 2024
        add_stage('Main Stage', 'Rock Werchter 2024', 'Open air classic rock stage with massive screens', 65000, 180,
                  'The legendary open air rock stage', 0);
        add_stage('Club Stage', 'Rock Werchter 2024', 'Covered intimate club venue', 8000, 40,
                  'Intimate covered stage for emerging artists', 1);
        -- Pukkelpop 2024
        add_stage('Chateau Stage', 'Pukkelpop 2024', 'Open air stage near the castle pond', 40000, 120,
                  'Flagship stage overlooking the castle', 0);
        add_stage('Boiler Room', 'Pukkelpop 2024', 'Concrete underground club stage', 3000, 20,
                  'Exclusive underground electronic stage', 1);
        -- Sziget Festival 2024
        add_stage('Main Stage', 'Sziget Festival 2024', 'Grand island stage with LED towers', 70000, 250,
                  'The heart of Sziget on the island', 0);
        add_stage('A38 Stage', 'Sziget Festival 2024', 'Covered secondary stage named after the famous ship bar', 12000,
                  60, 'Popular covered stage for alternative acts', 1);
        -- Roskilde Festival 2024
        add_stage('Orange Stage', 'Roskilde Festival 2024', 'Iconic orange tent main stage', 75000, 200,
                  'The legendary main stage of Roskilde', 0);
        add_stage('Arena Stage', 'Roskilde Festival 2024', 'Covered arena for mid-size acts', 15000, 70,
                  'Covered arena stage at Roskilde', 1);
        -- Glastonbury 2025
        add_stage('Pyramid Stage', 'Glastonbury 2025', 'The world-famous pyramid-shaped headline stage', 100000, 300,
                  'The most iconic festival stage in the world', 0);
        add_stage('Other Stage', 'Glastonbury 2025', 'Second largest stage at Glastonbury', 50000, 150,
                  'Alternative headline stage at Glastonbury', 0);
        -- Primavera Sound 2025
        add_stage('ATP Stage', 'Primavera Sound 2025', 'Covered indoor arena stage', 12000, 60,
                  'Air-conditioned indoor arena stage', 1);
        add_stage('Heineken Stage', 'Primavera Sound 2025', 'Large open air stage overlooking the sea', 40000, 110,
                  'Main outdoor stage with sea views', 0);
        -- Melt! Festival 2025
        add_stage('Ferropolis Stage', 'Melt! Festival 2025', 'Open air stage surrounded by industrial cranes', 20000,
                  80, 'Unique stage set among giant mining excavators', 0);
        add_stage('Sleepless Floor', 'Melt! Festival 2025', 'Open air techno floor running all night', 8000, 30,
                  'The legendary all-night Melt techno floor', 0);
        -- Tomorrowland Winter 2025
        add_stage('Alpe Stage', 'Tomorrowland Winter 2025', 'Alpine outdoor stage with mountain backdrop', 25000, 90,
                  'Main stage set against the French Alps', 0);
        add_stage('Ice Club', 'Tomorrowland Winter 2025', 'Indoor heated club stage in a ski chalet', 4000, 20,
                  'Intimate indoor club stage for the winter edition', 1);
        -- Lollapalooza Berlin 2025
        add_stage('Main Stage', 'Lollapalooza Berlin 2025', 'Grand open air stage in the Olympic stadium grounds',
                  60000, 200, 'The main headline stage of Lollapalooza Berlin', 0);
        add_stage('Perry Stage', 'Lollapalooza Berlin 2025', 'Second stage named after Lolla founder Perry Farrell',
                  25000, 80, 'Second headline stage at Lollapalooza Berlin', 0);

        -- 5. PERFORMANCE
        -- Parent-date check runs inside add_performance.

        -- Tomorrowland Summer 2024 (19-07 to 21-07)
        add_performance(TO_DATE('19-07-2024 22:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('20-07-2024 00:00', 'DD-MM-YYYY HH24:MI'),
                        'Martin Garrix', 'Electronic', 'Mainstage', 'Tomorrowland Summer 2024',
                        'Martin Garrix closing set Mainstage');
        add_performance(TO_DATE('20-07-2024 20:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('20-07-2024 22:00', 'DD-MM-YYYY HH24:MI'),
                        'David Guetta', 'House', 'Mainstage', 'Tomorrowland Summer 2024',
                        'David Guetta pre-closing set Mainstage');
        add_performance(TO_DATE('20-07-2024 02:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('20-07-2024 05:00', 'DD-MM-YYYY HH24:MI'),
                        'Charlotte de Witte', 'Techno', 'Freedom Stage', 'Tomorrowland Summer 2024',
                        'Charlotte de Witte deep techno set');
        add_performance(TO_DATE('21-07-2024 00:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('21-07-2024 02:00', 'DD-MM-YYYY HH24:MI'),
                        'Bicep', 'Electronic', 'Freedom Stage', 'Tomorrowland Summer 2024',
                        'Bicep live AV on Freedom Stage');

        -- Rock Werchter 2024 (04-07 to 07-07)
        add_performance(TO_DATE('04-07-2024 21:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('04-07-2024 23:00', 'DD-MM-YYYY HH24:MI'),
                        'Arctic Monkeys', 'Indie Rock', 'Main Stage', 'Rock Werchter 2024',
                        'Arctic Monkeys headliner set');
        add_performance(TO_DATE('05-07-2024 20:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('05-07-2024 22:30', 'DD-MM-YYYY HH24:MI'),
                        'Kendrick Lamar', 'Hip-Hop', 'Main Stage', 'Rock Werchter 2024',
                        'Kendrick Lamar Saturday headline');
        add_performance(TO_DATE('05-07-2024 23:30', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('06-07-2024 01:30', 'DD-MM-YYYY HH24:MI'),
                        'David Guetta', 'House', 'Club Stage', 'Rock Werchter 2024',
                        'David Guetta electronic crossover set');
        add_performance(TO_DATE('06-07-2024 02:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('06-07-2024 05:00', 'DD-MM-YYYY HH24:MI'),
                        'Charlotte de Witte', 'Techno', 'Club Stage', 'Rock Werchter 2024',
                        'Charlotte de Witte closing Club Stage');

        -- Pukkelpop 2024 (15-08 to 18-08)
        add_performance(TO_DATE('15-08-2024 20:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('15-08-2024 22:00', 'DD-MM-YYYY HH24:MI'),
                        'Stromae', 'Pop', 'Chateau Stage', 'Pukkelpop 2024', 'Stromae Belgian icon live performance');
        add_performance(TO_DATE('16-08-2024 21:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('16-08-2024 23:00', 'DD-MM-YYYY HH24:MI'),
                        'Billie Eilish', 'Pop', 'Chateau Stage', 'Pukkelpop 2024',
                        'Billie Eilish headline Chateau Stage');
        add_performance(TO_DATE('16-08-2024 01:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('16-08-2024 03:00', 'DD-MM-YYYY HH24:MI'),
                        'Bicep', 'House', 'Boiler Room', 'Pukkelpop 2024', 'Bicep live electronic AV show');
        add_performance(TO_DATE('17-08-2024 02:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('17-08-2024 04:00', 'DD-MM-YYYY HH24:MI'),
                        'Martin Garrix', 'Electronic', 'Boiler Room', 'Pukkelpop 2024',
                        'Martin Garrix secret Boiler Room set');

        -- Sziget Festival 2024 (07-08 to 12-08)
        add_performance(TO_DATE('09-08-2024 21:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('09-08-2024 23:00', 'DD-MM-YYYY HH24:MI'),
                        'Bad Bunny', 'Hip-Hop', 'Main Stage', 'Sziget Festival 2024',
                        'Bad Bunny Friday headline Sziget');
        add_performance(TO_DATE('10-08-2024 21:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('10-08-2024 23:30', 'DD-MM-YYYY HH24:MI'),
                        'Kendrick Lamar', 'Hip-Hop', 'Main Stage', 'Sziget Festival 2024',
                        'Kendrick Lamar Saturday headline Sziget');
        add_performance(TO_DATE('08-08-2024 22:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('09-08-2024 01:00', 'DD-MM-YYYY HH24:MI'),
                        'Charlotte de Witte', 'Techno', 'A38 Stage', 'Sziget Festival 2024',
                        'Charlotte de Witte techno night A38');
        add_performance(TO_DATE('11-08-2024 23:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('12-08-2024 01:30', 'DD-MM-YYYY HH24:MI'),
                        'Bicep', 'House', 'A38 Stage', 'Sziget Festival 2024', 'Bicep closing night A38 Stage');

        -- Roskilde Festival 2024 (29-06 to 06-07)
        add_performance(TO_DATE('30-06-2024 21:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('30-06-2024 23:00', 'DD-MM-YYYY HH24:MI'),
                        'Billie Eilish', 'Pop', 'Orange Stage', 'Roskilde Festival 2024',
                        'Billie Eilish headline Orange Stage');
        add_performance(TO_DATE('04-07-2024 20:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('04-07-2024 22:30', 'DD-MM-YYYY HH24:MI'),
                        'Rammstein', 'Rock', 'Orange Stage', 'Roskilde Festival 2024',
                        'Rammstein industrial metal headline');
        add_performance(TO_DATE('01-07-2024 22:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('02-07-2024 00:00', 'DD-MM-YYYY HH24:MI'),
                        'Martin Garrix', 'Electronic', 'Arena Stage', 'Roskilde Festival 2024',
                        'Martin Garrix Arena Stage Roskilde');
        add_performance(TO_DATE('03-07-2024 23:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('04-07-2024 01:00', 'DD-MM-YYYY HH24:MI'),
                        'Bad Bunny', 'Hip-Hop', 'Arena Stage', 'Roskilde Festival 2024',
                        'Bad Bunny reggaeton night Arena Stage');

        -- Glastonbury 2025 (25-06 to 29-06)
        add_performance(TO_DATE('26-06-2025 22:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('27-06-2025 00:00', 'DD-MM-YYYY HH24:MI'),
                        'Billie Eilish', 'Pop', 'Pyramid Stage', 'Glastonbury 2025',
                        'Billie Eilish Pyramid Stage headline');
        add_performance(TO_DATE('28-06-2025 21:30', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('28-06-2025 23:30', 'DD-MM-YYYY HH24:MI'),
                        'Arctic Monkeys', 'Indie Rock', 'Pyramid Stage', 'Glastonbury 2025',
                        'Arctic Monkeys closing Pyramid Stage');
        add_performance(TO_DATE('27-06-2025 19:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('27-06-2025 21:00', 'DD-MM-YYYY HH24:MI'),
                        'Stromae', 'Pop', 'Other Stage', 'Glastonbury 2025', 'Stromae Friday evening Other Stage');
        add_performance(TO_DATE('29-06-2025 20:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('29-06-2025 22:30', 'DD-MM-YYYY HH24:MI'),
                        'Kendrick Lamar', 'Hip-Hop', 'Other Stage', 'Glastonbury 2025',
                        'Kendrick Lamar closing Other Stage');

        -- Primavera Sound 2025 (29-05 to 01-06)
        add_performance(TO_DATE('30-05-2025 23:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('31-05-2025 01:00', 'DD-MM-YYYY HH24:MI'),
                        'Bad Bunny', 'Hip-Hop', 'ATP Stage', 'Primavera Sound 2025',
                        'Bad Bunny Latin trap headline Primavera');
        add_performance(TO_DATE('31-05-2025 21:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('31-05-2025 23:00', 'DD-MM-YYYY HH24:MI'),
                        'Arctic Monkeys', 'Indie Rock', 'ATP Stage', 'Primavera Sound 2025',
                        'Arctic Monkeys Saturday headline Primavera');
        add_performance(TO_DATE('29-05-2025 22:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('30-05-2025 00:00', 'DD-MM-YYYY HH24:MI'),
                        'David Guetta', 'House', 'Heineken Stage', 'Primavera Sound 2025',
                        'David Guetta opening night Heineken Stage');
        add_performance(TO_DATE('01-06-2025 20:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('01-06-2025 22:00', 'DD-MM-YYYY HH24:MI'),
                        'Stromae', 'Pop', 'Heineken Stage', 'Primavera Sound 2025',
                        'Stromae closing night Heineken Stage');

        -- Melt! Festival 2025 (18-07 to 20-07)
        add_performance(TO_DATE('18-07-2025 22:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('19-07-2025 00:30', 'DD-MM-YYYY HH24:MI'),
                        'Rammstein', 'Rock', 'Ferropolis Stage', 'Melt! Festival 2025',
                        'Rammstein opening night Ferropolis Stage');
        add_performance(TO_DATE('19-07-2025 21:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('19-07-2025 23:00', 'DD-MM-YYYY HH24:MI'),
                        'Bicep', 'Electronic', 'Ferropolis Stage', 'Melt! Festival 2025',
                        'Bicep live set Ferropolis Stage');
        add_performance(TO_DATE('19-07-2025 02:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('19-07-2025 06:00', 'DD-MM-YYYY HH24:MI'),
                        'Charlotte de Witte', 'Techno', 'Sleepless Floor', 'Melt! Festival 2025',
                        'Charlotte de Witte all-night Sleepless Floor');
        add_performance(TO_DATE('20-07-2025 01:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('20-07-2025 03:00', 'DD-MM-YYYY HH24:MI'),
                        'Martin Garrix', 'Electronic', 'Sleepless Floor', 'Melt! Festival 2025',
                        'Martin Garrix closing Sleepless Floor');

        -- Tomorrowland Winter 2025 (08-03 to 15-03)
        add_performance(TO_DATE('08-03-2025 18:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('08-03-2025 20:00', 'DD-MM-YYYY HH24:MI'),
                        'David Guetta', 'House', 'Alpe Stage', 'Tomorrowland Winter 2025',
                        'David Guetta opening Alpe Stage');
        add_performance(TO_DATE('14-03-2025 20:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('14-03-2025 22:00', 'DD-MM-YYYY HH24:MI'),
                        'Martin Garrix', 'Electronic', 'Alpe Stage', 'Tomorrowland Winter 2025',
                        'Martin Garrix closing Alpe Stage');
        add_performance(TO_DATE('10-03-2025 23:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('11-03-2025 03:00', 'DD-MM-YYYY HH24:MI'),
                        'Charlotte de Witte', 'Techno', 'Ice Club', 'Tomorrowland Winter 2025',
                        'Charlotte de Witte intimate Ice Club set');
        add_performance(TO_DATE('13-03-2025 01:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('13-03-2025 03:30', 'DD-MM-YYYY HH24:MI'),
                        'Bicep', 'House', 'Ice Club', 'Tomorrowland Winter 2025', 'Bicep live AV Ice Club');

        -- Lollapalooza Berlin 2025 (07-09 to 08-09)
        add_performance(TO_DATE('07-09-2025 20:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('07-09-2025 22:30', 'DD-MM-YYYY HH24:MI'),
                        'Rammstein', 'Rock', 'Main Stage', 'Lollapalooza Berlin 2025',
                        'Rammstein Friday headline Lollapalooza');
        add_performance(TO_DATE('08-09-2025 20:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('08-09-2025 22:30', 'DD-MM-YYYY HH24:MI'),
                        'Kendrick Lamar', 'Hip-Hop', 'Main Stage', 'Lollapalooza Berlin 2025',
                        'Kendrick Lamar Saturday headline Lollapalooza');
        add_performance(TO_DATE('07-09-2025 22:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('08-09-2025 00:00', 'DD-MM-YYYY HH24:MI'),
                        'Bad Bunny', 'Hip-Hop', 'Perry Stage', 'Lollapalooza Berlin 2025',
                        'Bad Bunny Friday night Perry Stage');
        add_performance(TO_DATE('08-09-2025 22:00', 'DD-MM-YYYY HH24:MI'),
                        TO_DATE('09-09-2025 00:00', 'DD-MM-YYYY HH24:MI'),
                        'David Guetta', 'House', 'Perry Stage', 'Lollapalooza Berlin 2025',
                        'David Guetta closing Perry Stage');

        COMMIT;

    END bewijs_M4_S2;

END PKG_S2_festivals;
/