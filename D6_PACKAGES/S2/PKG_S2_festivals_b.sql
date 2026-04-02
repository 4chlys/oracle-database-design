CREATE OR REPLACE PACKAGE BODY PKG_S2_festival AS

    -- PUBLIC LOOKUP (also used internally by this package)
    FUNCTION lookup_festival_id(p_festival_name IN VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT Festival_ID
        INTO v_id
        FROM Festival
        WHERE Festival_Name = p_festival_name;
        RETURN v_id;
    END lookup_festival_id;

    -- PRIVATE LOOKUP FUNCTIONS
    FUNCTION lookup_company_id(p_company_name IN VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT Company_ID
        INTO v_id
        FROM Company
        WHERE Company_Name = p_company_name;
        RETURN v_id;
    END lookup_company_id;

    -- ---------------------------------------------------------

    FUNCTION lookup_city_id(p_zipcode IN VARCHAR2, p_country IN VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT City_ID
        INTO v_id
        FROM City
        WHERE Zipcode = p_zipcode
          AND Country = p_country;
        RETURN v_id;
    END lookup_city_id;

    -- ---------------------------------------------------------

    FUNCTION lookup_genre_id(p_genre_name IN VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT Genre_ID
        INTO v_id
        FROM Genre
        WHERE Genre_Name = p_genre_name;
        RETURN v_id;
    END lookup_genre_id;

    -- ---------------------------------------------------------

    FUNCTION lookup_artist_id(p_artist_name IN VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT Artist_ID
        INTO v_id
        FROM Artist
        WHERE Artist_Name = p_artist_name;
        RETURN v_id;
    END lookup_artist_id;

    -- ---------------------------------------------------------

    FUNCTION lookup_stage_id(p_stage_name    IN VARCHAR2,
                             p_festival_name IN VARCHAR2) RETURN NUMBER IS
        v_id          NUMBER;
        v_festival_id NUMBER;
    BEGIN
        v_festival_id := lookup_festival_id(p_festival_name);
        SELECT Stage_ID
        INTO v_id
        FROM Stage
        WHERE Stage_Name  = p_stage_name
          AND Festival_ID = v_festival_id;
        RETURN v_id;
    END lookup_stage_id;

-- ---------------------------------------------------------------------------------------------------------------------
    -- PRIVATE ADD PROCEDURES

    PROCEDURE add_festival(p_name          IN VARCHAR2,
                           p_company_name  IN VARCHAR2,
                           p_start_date    IN DATE,
                           p_end_date      IN DATE,
                           p_location      IN VARCHAR2,
                           p_zipcode       IN VARCHAR2,
                           p_country       IN VARCHAR2,
                           p_opening_hour  IN DATE,
                           p_closing_hour  IN DATE,
                           p_capacity      IN NUMBER) IS
        v_company_id NUMBER;
        v_city_id    NUMBER;
    BEGIN
        -- Pre-fetch IDs into variables (PL/SQL functions cannot be called
        -- directly inside a SQL VALUES clause within the same package)
        v_company_id := lookup_company_id(p_company_name);
        v_city_id    := lookup_city_id(p_zipcode, p_country);

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

    PROCEDURE add_genre(p_name            IN VARCHAR2,
                        p_origin_year     IN NUMBER,
                        p_origin_location IN VARCHAR2,
                        p_bpm             IN NUMBER) IS
    BEGIN
        INSERT INTO Genre (Genre_Name, Genre_Origin_Year, Genre_Origin_Location, Genre_BPM)
        VALUES (p_name, p_origin_year, p_origin_location, p_bpm);
    END add_genre;

    -- ---------------------------------------------------------

    PROCEDURE add_artist(p_name          IN VARCHAR2,
                         p_birthday      IN DATE,
                         p_price         IN NUMBER,
                         p_currency      IN CHAR,
                         p_land_of_birth IN VARCHAR2) IS
    BEGIN
        INSERT INTO Artist (Artist_Name, Artist_Birthday, Artist_Price,
                            Artist_Price_Currency, Artist_Land_Of_Birth)
        VALUES (p_name, p_birthday, p_price, p_currency, p_land_of_birth);
    END add_artist;

    -- ---------------------------------------------------------

    PROCEDURE add_stage(p_stage_name    IN VARCHAR2,
                        p_festival_name IN VARCHAR2,
                        p_style_desc    IN VARCHAR2,
                        p_capacity      IN NUMBER,
                        p_toilet_count  IN NUMBER,
                        p_description   IN VARCHAR2,
                        p_roofed        IN NUMBER) IS
        v_festival_id NUMBER;
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

    PROCEDURE add_performance(p_start_time    IN DATE,
                              p_end_time      IN DATE,
                              p_artist_name   IN VARCHAR2,
                              p_genre_name    IN VARCHAR2,
                              p_stage_name    IN VARCHAR2,
                              p_festival_name IN VARCHAR2,
                              p_description   IN VARCHAR2) IS
        v_festival_start DATE;
        v_festival_end   DATE;
        v_artist_id      NUMBER;
        v_genre_id       NUMBER;
        v_stage_id       NUMBER;
    BEGIN
        -- S2 date rule: performance start must fall within the parent Festival's dates
        v_artist_id := lookup_artist_id(p_artist_name);
        v_genre_id  := lookup_genre_id(p_genre_name);
        v_stage_id  := lookup_stage_id(p_stage_name, p_festival_name);

        SELECT Festival_StartDate, Festival_EndDate
        INTO v_festival_start, v_festival_end
        FROM Festival
        WHERE Festival_Name = p_festival_name;

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

        -- Reset identity sequences
        EXECUTE IMMEDIATE 'ALTER TABLE Performance MODIFY Performance_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
        EXECUTE IMMEDIATE 'ALTER TABLE Stage       MODIFY Stage_ID       GENERATED ALWAYS AS IDENTITY (START WITH 1)';
        EXECUTE IMMEDIATE 'ALTER TABLE Festival    MODIFY Festival_ID    GENERATED ALWAYS AS IDENTITY (START WITH 1)';
        EXECUTE IMMEDIATE 'ALTER TABLE Artist      MODIFY Artist_ID      GENERATED ALWAYS AS IDENTITY (START WITH 1)';
        EXECUTE IMMEDIATE 'ALTER TABLE Genre       MODIFY Genre_ID       GENERATED ALWAYS AS IDENTITY (START WITH 1)';

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
                     TO_DATE('19-07-2024','DD-MM-YYYY'), TO_DATE('21-07-2024','DD-MM-YYYY'),
                     'De Schorre', '2850', 'Belgium',
                     TO_DATE('10:00','HH24:MI'), TO_DATE('10:00','HH24:MI') + INTERVAL '17' HOUR, 200000);

        add_festival('Rock Werchter 2024', 'Rock Werchter Productions',
                     TO_DATE('04-07-2024','DD-MM-YYYY'), TO_DATE('07-07-2024','DD-MM-YYYY'),
                     'Festivalpark Werchter', '3118', 'Belgium',
                     TO_DATE('11:00','HH24:MI'), TO_DATE('11:00','HH24:MI') + INTERVAL '15' HOUR, 90000);

        add_festival('Pukkelpop 2024', 'Pukkelpop VZW',
                     TO_DATE('15-08-2024','DD-MM-YYYY'), TO_DATE('18-08-2024','DD-MM-YYYY'),
                     'Hasselt Kiewit', '3500', 'Belgium',
                     TO_DATE('12:00','HH24:MI'), TO_DATE('12:00','HH24:MI') + INTERVAL '13' HOUR, 65000);

        add_festival('Sziget Festival 2024', 'Sziget Cultural Management',
                     TO_DATE('07-08-2024','DD-MM-YYYY'), TO_DATE('12-08-2024','DD-MM-YYYY'),
                     'Óbudai-sziget', '1117BP', 'Hungary',
                     TO_DATE('10:00','HH24:MI'), TO_DATE('10:00','HH24:MI') + INTERVAL '18' HOUR, 100000);

        add_festival('Roskilde Festival 2024', 'Roskilde Festival Society',
                     TO_DATE('29-06-2024','DD-MM-YYYY'), TO_DATE('06-07-2024','DD-MM-YYYY'),
                     'Roskilde Dyrskueplads', '4000', 'Denmark',
                     TO_DATE('09:00','HH24:MI'), TO_DATE('09:00','HH24:MI') + INTERVAL '18' HOUR, 130000);

        add_festival('Glastonbury 2025', 'Glastonbury Festivals Ltd',
                     TO_DATE('25-06-2025','DD-MM-YYYY'), TO_DATE('29-06-2025','DD-MM-YYYY'),
                     'Worthy Farm Pilton', 'BA44AF', 'United Kingdom',
                     TO_DATE('08:00','HH24:MI'), TO_DATE('08:00','HH24:MI') + INTERVAL '21' HOUR, 210000);

        add_festival('Primavera Sound 2025', 'Primavera Sound SL',
                     TO_DATE('29-05-2025','DD-MM-YYYY'), TO_DATE('01-06-2025','DD-MM-YYYY'),
                     'Parc del Fòrum', '08003', 'Spain',
                     TO_DATE('14:00','HH24:MI'), TO_DATE('14:00','HH24:MI') + INTERVAL '14' HOUR, 75000);

        add_festival('Melt! Festival 2025', 'Melt! Festival GmbH',
                     TO_DATE('18-07-2025','DD-MM-YYYY'), TO_DATE('20-07-2025','DD-MM-YYYY'),
                     'Ferropolis Industriepark', '06773', 'Germany',
                     TO_DATE('13:00','HH24:MI'), TO_DATE('13:00','HH24:MI') + INTERVAL '16' HOUR, 25000);

        add_festival('Tomorrowland Winter 2025', 'Tomorrowland NV',
                     TO_DATE('08-03-2025','DD-MM-YYYY'), TO_DATE('15-03-2025','DD-MM-YYYY'),
                     'Alpe d''Huez', '1000', 'Belgium',
                     TO_DATE('10:00','HH24:MI'), TO_DATE('10:00','HH24:MI') + INTERVAL '16' HOUR, 30000);

        add_festival('Lollapalooza Berlin 2025', 'AEG Presents Europe',
                     TO_DATE('07-09-2025','DD-MM-YYYY'), TO_DATE('08-09-2025','DD-MM-YYYY'),
                     'Olympiastadion Berlin', '10115', 'Germany',
                     TO_DATE('11:00','HH24:MI'), TO_DATE('11:00','HH24:MI') + INTERVAL '12' HOUR, 85000);

        -- 2. GENRE
        add_genre('Electronic',    1970, 'Chicago, USA',         128);
        add_genre('Rock',          1955, 'Memphis, USA',         120);
        add_genre('Pop',           1960, 'New York, USA',        110);
        add_genre('Hip-Hop',       1973, 'Bronx, New York, USA',  90);
        add_genre('Techno',        1985, 'Detroit, USA',         140);
        add_genre('House',         1983, 'Chicago, USA',         125);
        add_genre('Drum and Bass', 1991, 'London, UK',           170);
        add_genre('Trance',        1990, 'Frankfurt, Germany',   138);
        add_genre('Indie Rock',    1980, 'New York, USA',        115);
        add_genre('Reggae',        1960, 'Kingston, Jamaica',     80);

        -- 3. ARTIST
        add_artist('Martin Garrix',      TO_DATE('14-05-1996','DD-MM-YYYY'), 500000,  'EUR', 'Netherlands');
        add_artist('Kendrick Lamar',     TO_DATE('17-06-1987','DD-MM-YYYY'), 1200000, 'USD', 'United States');
        add_artist('Billie Eilish',      TO_DATE('18-12-2001','DD-MM-YYYY'), 900000,  'USD', 'United States');
        add_artist('Stromae',            TO_DATE('12-03-1985','DD-MM-YYYY'), 400000,  'EUR', 'Belgium');
        add_artist('David Guetta',       TO_DATE('07-11-1967','DD-MM-YYYY'), 600000,  'EUR', 'France');
        add_artist('Rammstein',          TO_DATE('01-01-1994','DD-MM-YYYY'), 800000,  'EUR', 'Germany');
        add_artist('Arctic Monkeys',     TO_DATE('01-06-2002','DD-MM-YYYY'), 750000,  'GBP', 'United Kingdom');
        add_artist('Bad Bunny',          TO_DATE('10-03-1994','DD-MM-YYYY'), 1500000, 'USD', 'Puerto Rico');
        add_artist('Charlotte de Witte', TO_DATE('15-10-1992','DD-MM-YYYY'), 80000,   'EUR', 'Belgium');
        add_artist('Bicep',              TO_DATE('01-01-2009','DD-MM-YYYY'), 120000,  'GBP', 'United Kingdom');

        -- 4. STAGE
        -- Tomorrowland Summer 2024
        add_stage('Mainstage',     'Tomorrowland Summer 2024', 'Grand pyramid structure with full LED canopy',              80000, 200, 'The iconic main stage with world-class production',      0);
        add_stage('Freedom Stage', 'Tomorrowland Summer 2024', 'Underground bunker-style enclosed venue',                  15000,  80, 'Dark and deep electronic music venue',                   1);
        -- Rock Werchter 2024
        add_stage('Main Stage',    'Rock Werchter 2024',       'Open air classic rock stage with massive screens',         65000, 180, 'The legendary open air rock stage',                      0);
        add_stage('Club Stage',    'Rock Werchter 2024',       'Covered intimate club venue',                               8000,  40, 'Intimate covered stage for emerging artists',             1);
        -- Pukkelpop 2024
        add_stage('Chateau Stage', 'Pukkelpop 2024',           'Open air stage near the castle pond',                     40000, 120, 'Flagship stage overlooking the castle',                   0);
        add_stage('Boiler Room',   'Pukkelpop 2024',           'Concrete underground club stage',                          3000,  20, 'Exclusive underground electronic stage',                  1);
        -- Sziget Festival 2024
        add_stage('Main Stage',    'Sziget Festival 2024',     'Grand island stage with LED towers',                      70000, 250, 'The heart of Sziget on the island',                       0);
        add_stage('A38 Stage',     'Sziget Festival 2024',     'Covered secondary stage named after the famous ship bar', 12000,  60, 'Popular covered stage for alternative acts',              1);
        -- Roskilde Festival 2024
        add_stage('Orange Stage',  'Roskilde Festival 2024',   'Iconic orange tent main stage',                           75000, 200, 'The legendary main stage of Roskilde',                    0);
        add_stage('Arena Stage',   'Roskilde Festival 2024',   'Covered arena for mid-size acts',                         15000,  70, 'Covered arena stage at Roskilde',                         1);
        -- Glastonbury 2025
        add_stage('Pyramid Stage', 'Glastonbury 2025',         'The world-famous pyramid-shaped headline stage',         100000, 300, 'The most iconic festival stage in the world',             0);
        add_stage('Other Stage',   'Glastonbury 2025',         'Second largest stage at Glastonbury',                     50000, 150, 'Alternative headline stage at Glastonbury',                0);
        -- Primavera Sound 2025
        add_stage('ATP Stage',     'Primavera Sound 2025',     'Covered indoor arena stage',                              12000,  60, 'Air-conditioned indoor arena stage',                      1);
        add_stage('Heineken Stage','Primavera Sound 2025',     'Large open air stage overlooking the sea',                40000, 110, 'Main outdoor stage with sea views',                       0);
        -- Melt! Festival 2025
        add_stage('Ferropolis Stage', 'Melt! Festival 2025',   'Open air stage surrounded by industrial cranes',          20000,  80, 'Unique stage set among giant mining excavators',          0);
        add_stage('Sleepless Floor',  'Melt! Festival 2025',   'Open air techno floor running all night',                  8000,  30, 'The legendary all-night Melt techno floor',               0);
        -- Tomorrowland Winter 2025
        add_stage('Alpe Stage',    'Tomorrowland Winter 2025', 'Alpine outdoor stage with mountain backdrop',             25000,  90, 'Main stage set against the French Alps',                  0);
        add_stage('Ice Club',      'Tomorrowland Winter 2025', 'Indoor heated club stage in a ski chalet',                 4000,  20, 'Intimate indoor club stage for the winter edition',        1);
        -- Lollapalooza Berlin 2025
        add_stage('Main Stage',    'Lollapalooza Berlin 2025', 'Grand open air stage in the Olympic stadium grounds',     60000, 200, 'The main headline stage of Lollapalooza Berlin',          0);
        add_stage('Perry Stage',   'Lollapalooza Berlin 2025', 'Second stage named after Lolla founder Perry Farrell',   25000,  80, 'Second headline stage at Lollapalooza Berlin',            0);

        -- 5. PERFORMANCE
        -- Parent-date check runs inside add_performance.

        -- Tomorrowland Summer 2024 (19-07 to 21-07)
        add_performance(TO_DATE('19-07-2024 22:00','DD-MM-YYYY HH24:MI'), TO_DATE('20-07-2024 00:00','DD-MM-YYYY HH24:MI'),
                        'Martin Garrix',      'Electronic', 'Mainstage',     'Tomorrowland Summer 2024', 'Martin Garrix closing set Mainstage');
        add_performance(TO_DATE('20-07-2024 20:00','DD-MM-YYYY HH24:MI'), TO_DATE('20-07-2024 22:00','DD-MM-YYYY HH24:MI'),
                        'David Guetta',       'House',      'Mainstage',     'Tomorrowland Summer 2024', 'David Guetta pre-closing set Mainstage');
        add_performance(TO_DATE('20-07-2024 02:00','DD-MM-YYYY HH24:MI'), TO_DATE('20-07-2024 05:00','DD-MM-YYYY HH24:MI'),
                        'Charlotte de Witte', 'Techno',     'Freedom Stage', 'Tomorrowland Summer 2024', 'Charlotte de Witte deep techno set');
        add_performance(TO_DATE('21-07-2024 00:00','DD-MM-YYYY HH24:MI'), TO_DATE('21-07-2024 02:00','DD-MM-YYYY HH24:MI'),
                        'Bicep',              'Electronic', 'Freedom Stage', 'Tomorrowland Summer 2024', 'Bicep live AV on Freedom Stage');

        -- Rock Werchter 2024 (04-07 to 07-07)
        add_performance(TO_DATE('04-07-2024 21:00','DD-MM-YYYY HH24:MI'), TO_DATE('04-07-2024 23:00','DD-MM-YYYY HH24:MI'),
                        'Arctic Monkeys',     'Indie Rock', 'Main Stage',    'Rock Werchter 2024', 'Arctic Monkeys headliner set');
        add_performance(TO_DATE('05-07-2024 20:00','DD-MM-YYYY HH24:MI'), TO_DATE('05-07-2024 22:30','DD-MM-YYYY HH24:MI'),
                        'Kendrick Lamar',     'Hip-Hop',    'Main Stage',    'Rock Werchter 2024', 'Kendrick Lamar Saturday headline');
        add_performance(TO_DATE('05-07-2024 23:30','DD-MM-YYYY HH24:MI'), TO_DATE('06-07-2024 01:30','DD-MM-YYYY HH24:MI'),
                        'David Guetta',       'House',      'Club Stage',    'Rock Werchter 2024', 'David Guetta electronic crossover set');
        add_performance(TO_DATE('06-07-2024 02:00','DD-MM-YYYY HH24:MI'), TO_DATE('06-07-2024 05:00','DD-MM-YYYY HH24:MI'),
                        'Charlotte de Witte', 'Techno',     'Club Stage',    'Rock Werchter 2024', 'Charlotte de Witte closing Club Stage');

        -- Pukkelpop 2024 (15-08 to 18-08)
        add_performance(TO_DATE('15-08-2024 20:00','DD-MM-YYYY HH24:MI'), TO_DATE('15-08-2024 22:00','DD-MM-YYYY HH24:MI'),
                        'Stromae',            'Pop',        'Chateau Stage', 'Pukkelpop 2024', 'Stromae Belgian icon live performance');
        add_performance(TO_DATE('16-08-2024 21:00','DD-MM-YYYY HH24:MI'), TO_DATE('16-08-2024 23:00','DD-MM-YYYY HH24:MI'),
                        'Billie Eilish',      'Pop',        'Chateau Stage', 'Pukkelpop 2024', 'Billie Eilish headline Chateau Stage');
        add_performance(TO_DATE('16-08-2024 01:00','DD-MM-YYYY HH24:MI'), TO_DATE('16-08-2024 03:00','DD-MM-YYYY HH24:MI'),
                        'Bicep',              'House',      'Boiler Room',   'Pukkelpop 2024', 'Bicep live electronic AV show');
        add_performance(TO_DATE('17-08-2024 02:00','DD-MM-YYYY HH24:MI'), TO_DATE('17-08-2024 04:00','DD-MM-YYYY HH24:MI'),
                        'Martin Garrix',      'Electronic', 'Boiler Room',   'Pukkelpop 2024', 'Martin Garrix secret Boiler Room set');

        -- Sziget Festival 2024 (07-08 to 12-08)
        add_performance(TO_DATE('09-08-2024 21:00','DD-MM-YYYY HH24:MI'), TO_DATE('09-08-2024 23:00','DD-MM-YYYY HH24:MI'),
                        'Bad Bunny',          'Hip-Hop',    'Main Stage',    'Sziget Festival 2024', 'Bad Bunny Friday headline Sziget');
        add_performance(TO_DATE('10-08-2024 21:00','DD-MM-YYYY HH24:MI'), TO_DATE('10-08-2024 23:30','DD-MM-YYYY HH24:MI'),
                        'Kendrick Lamar',     'Hip-Hop',    'Main Stage',    'Sziget Festival 2024', 'Kendrick Lamar Saturday headline Sziget');
        add_performance(TO_DATE('08-08-2024 22:00','DD-MM-YYYY HH24:MI'), TO_DATE('09-08-2024 01:00','DD-MM-YYYY HH24:MI'),
                        'Charlotte de Witte', 'Techno',     'A38 Stage',     'Sziget Festival 2024', 'Charlotte de Witte techno night A38');
        add_performance(TO_DATE('11-08-2024 23:00','DD-MM-YYYY HH24:MI'), TO_DATE('12-08-2024 01:30','DD-MM-YYYY HH24:MI'),
                        'Bicep',              'House',      'A38 Stage',     'Sziget Festival 2024', 'Bicep closing night A38 Stage');

        -- Roskilde Festival 2024 (29-06 to 06-07)
        add_performance(TO_DATE('30-06-2024 21:00','DD-MM-YYYY HH24:MI'), TO_DATE('30-06-2024 23:00','DD-MM-YYYY HH24:MI'),
                        'Billie Eilish',      'Pop',        'Orange Stage',  'Roskilde Festival 2024', 'Billie Eilish headline Orange Stage');
        add_performance(TO_DATE('04-07-2024 20:00','DD-MM-YYYY HH24:MI'), TO_DATE('04-07-2024 22:30','DD-MM-YYYY HH24:MI'),
                        'Rammstein',          'Rock',       'Orange Stage',  'Roskilde Festival 2024', 'Rammstein industrial metal headline');
        add_performance(TO_DATE('01-07-2024 22:00','DD-MM-YYYY HH24:MI'), TO_DATE('02-07-2024 00:00','DD-MM-YYYY HH24:MI'),
                        'Martin Garrix',      'Electronic', 'Arena Stage',   'Roskilde Festival 2024', 'Martin Garrix Arena Stage Roskilde');
        add_performance(TO_DATE('03-07-2024 23:00','DD-MM-YYYY HH24:MI'), TO_DATE('04-07-2024 01:00','DD-MM-YYYY HH24:MI'),
                        'Bad Bunny',          'Hip-Hop',    'Arena Stage',   'Roskilde Festival 2024', 'Bad Bunny reggaeton night Arena Stage');

        -- Glastonbury 2025 (25-06 to 29-06)
        add_performance(TO_DATE('26-06-2025 22:00','DD-MM-YYYY HH24:MI'), TO_DATE('27-06-2025 00:00','DD-MM-YYYY HH24:MI'),
                        'Billie Eilish',      'Pop',        'Pyramid Stage', 'Glastonbury 2025', 'Billie Eilish Pyramid Stage headline');
        add_performance(TO_DATE('28-06-2025 21:30','DD-MM-YYYY HH24:MI'), TO_DATE('28-06-2025 23:30','DD-MM-YYYY HH24:MI'),
                        'Arctic Monkeys',     'Indie Rock', 'Pyramid Stage', 'Glastonbury 2025', 'Arctic Monkeys closing Pyramid Stage');
        add_performance(TO_DATE('27-06-2025 19:00','DD-MM-YYYY HH24:MI'), TO_DATE('27-06-2025 21:00','DD-MM-YYYY HH24:MI'),
                        'Stromae',            'Pop',        'Other Stage',   'Glastonbury 2025', 'Stromae Friday evening Other Stage');
        add_performance(TO_DATE('29-06-2025 20:00','DD-MM-YYYY HH24:MI'), TO_DATE('29-06-2025 22:30','DD-MM-YYYY HH24:MI'),
                        'Kendrick Lamar',     'Hip-Hop',    'Other Stage',   'Glastonbury 2025', 'Kendrick Lamar closing Other Stage');

        -- Primavera Sound 2025 (29-05 to 01-06)
        add_performance(TO_DATE('30-05-2025 23:00','DD-MM-YYYY HH24:MI'), TO_DATE('31-05-2025 01:00','DD-MM-YYYY HH24:MI'),
                        'Bad Bunny',          'Hip-Hop',    'ATP Stage',      'Primavera Sound 2025', 'Bad Bunny Latin trap headline Primavera');
        add_performance(TO_DATE('31-05-2025 21:00','DD-MM-YYYY HH24:MI'), TO_DATE('31-05-2025 23:00','DD-MM-YYYY HH24:MI'),
                        'Arctic Monkeys',     'Indie Rock', 'ATP Stage',      'Primavera Sound 2025', 'Arctic Monkeys Saturday headline Primavera');
        add_performance(TO_DATE('29-05-2025 22:00','DD-MM-YYYY HH24:MI'), TO_DATE('30-05-2025 00:00','DD-MM-YYYY HH24:MI'),
                        'David Guetta',       'House',      'Heineken Stage', 'Primavera Sound 2025', 'David Guetta opening night Heineken Stage');
        add_performance(TO_DATE('01-06-2025 20:00','DD-MM-YYYY HH24:MI'), TO_DATE('01-06-2025 22:00','DD-MM-YYYY HH24:MI'),
                        'Stromae',            'Pop',        'Heineken Stage', 'Primavera Sound 2025', 'Stromae closing night Heineken Stage');

        -- Melt! Festival 2025 (18-07 to 20-07)
        add_performance(TO_DATE('18-07-2025 22:00','DD-MM-YYYY HH24:MI'), TO_DATE('19-07-2025 00:30','DD-MM-YYYY HH24:MI'),
                        'Rammstein',          'Rock',       'Ferropolis Stage', 'Melt! Festival 2025', 'Rammstein opening night Ferropolis Stage');
        add_performance(TO_DATE('19-07-2025 21:00','DD-MM-YYYY HH24:MI'), TO_DATE('19-07-2025 23:00','DD-MM-YYYY HH24:MI'),
                        'Bicep',              'Electronic', 'Ferropolis Stage', 'Melt! Festival 2025', 'Bicep live set Ferropolis Stage');
        add_performance(TO_DATE('19-07-2025 02:00','DD-MM-YYYY HH24:MI'), TO_DATE('19-07-2025 06:00','DD-MM-YYYY HH24:MI'),
                        'Charlotte de Witte', 'Techno',     'Sleepless Floor',  'Melt! Festival 2025', 'Charlotte de Witte all-night Sleepless Floor');
        add_performance(TO_DATE('20-07-2025 01:00','DD-MM-YYYY HH24:MI'), TO_DATE('20-07-2025 03:00','DD-MM-YYYY HH24:MI'),
                        'Martin Garrix',      'Electronic', 'Sleepless Floor',  'Melt! Festival 2025', 'Martin Garrix closing Sleepless Floor');

        -- Tomorrowland Winter 2025 (08-03 to 15-03)
        add_performance(TO_DATE('08-03-2025 18:00','DD-MM-YYYY HH24:MI'), TO_DATE('08-03-2025 20:00','DD-MM-YYYY HH24:MI'),
                        'David Guetta',       'House',      'Alpe Stage', 'Tomorrowland Winter 2025', 'David Guetta opening Alpe Stage');
        add_performance(TO_DATE('14-03-2025 20:00','DD-MM-YYYY HH24:MI'), TO_DATE('14-03-2025 22:00','DD-MM-YYYY HH24:MI'),
                        'Martin Garrix',      'Electronic', 'Alpe Stage', 'Tomorrowland Winter 2025', 'Martin Garrix closing Alpe Stage');
        add_performance(TO_DATE('10-03-2025 23:00','DD-MM-YYYY HH24:MI'), TO_DATE('11-03-2025 03:00','DD-MM-YYYY HH24:MI'),
                        'Charlotte de Witte', 'Techno',     'Ice Club',   'Tomorrowland Winter 2025', 'Charlotte de Witte intimate Ice Club set');
        add_performance(TO_DATE('13-03-2025 01:00','DD-MM-YYYY HH24:MI'), TO_DATE('13-03-2025 03:30','DD-MM-YYYY HH24:MI'),
                        'Bicep',              'House',      'Ice Club',   'Tomorrowland Winter 2025', 'Bicep live AV Ice Club');

        -- Lollapalooza Berlin 2025 (07-09 to 08-09)
        add_performance(TO_DATE('07-09-2025 20:00','DD-MM-YYYY HH24:MI'), TO_DATE('07-09-2025 22:30','DD-MM-YYYY HH24:MI'),
                        'Rammstein',          'Rock',    'Main Stage',  'Lollapalooza Berlin 2025', 'Rammstein Friday headline Lollapalooza');
        add_performance(TO_DATE('08-09-2025 20:00','DD-MM-YYYY HH24:MI'), TO_DATE('08-09-2025 22:30','DD-MM-YYYY HH24:MI'),
                        'Kendrick Lamar',     'Hip-Hop', 'Main Stage',  'Lollapalooza Berlin 2025', 'Kendrick Lamar Saturday headline Lollapalooza');
        add_performance(TO_DATE('07-09-2025 22:00','DD-MM-YYYY HH24:MI'), TO_DATE('08-09-2025 00:00','DD-MM-YYYY HH24:MI'),
                        'Bad Bunny',          'Hip-Hop', 'Perry Stage', 'Lollapalooza Berlin 2025', 'Bad Bunny Friday night Perry Stage');
        add_performance(TO_DATE('08-09-2025 22:00','DD-MM-YYYY HH24:MI'), TO_DATE('09-09-2025 00:00','DD-MM-YYYY HH24:MI'),
                        'David Guetta',       'House',   'Perry Stage', 'Lollapalooza Berlin 2025', 'David Guetta closing Perry Stage');

        COMMIT;

    END bewijs_M4_S2;

END PKG_S2_festival;
/