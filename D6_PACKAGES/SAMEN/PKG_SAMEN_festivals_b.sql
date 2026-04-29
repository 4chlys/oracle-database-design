CREATE OR REPLACE PACKAGE BODY PKG_SAMEN_festivals AS

    -- =========================================================
    -- MILESTONE 5 – SAMEN package body (festivals domain)
    -- =========================================================
    -- Lookup arrays are declared at package level and populated
    -- ONCE in the initialization block at the bottom of this body.
    -- This avoids re-initializing 10–20 element arrays on every
    -- call to a give_random_* function during bulk generation.
    -- =========================================================

    TYPE t_str_list IS TABLE OF VARCHAR2(200) INDEX BY PLS_INTEGER;

    g_genres            t_str_list;
    g_locations         t_str_list;
    g_countries         t_str_list;
    g_artist_prefixes   t_str_list;
    g_stage_suffixes    t_str_list;
    g_festival_suffixes t_str_list;
    g_ticket_types      t_str_list;
    g_ticket_statuses   t_str_list;
    g_currencies        t_str_list;
    g_genders           t_str_list;
    g_streets           t_str_list;
    g_first_names       t_str_list;
    g_last_names        t_str_list;
    g_permit_categories t_str_list;
    g_platform_names    t_str_list;

    -- Description-builder pools (some entries are NULL on purpose
    -- so the corresponding sentence segment is dropped sometimes)
    g_desc_opener  t_str_list;
    g_desc_adj1    t_str_list;
    g_desc_adj2    t_str_list;
    g_desc_noun    t_str_list;
    g_desc_verb    t_str_list;
    g_desc_loc     t_str_list;
    g_desc_with    t_str_list;
    g_desc_for     t_str_list;
    g_desc_impact  t_str_list;
    g_desc_closing t_str_list;

    -- -------------------------------------------------------
    -- PRIVATE helper: pick a random element from a t_str_list
    -- -------------------------------------------------------
    FUNCTION pick(p_list IN t_str_list) RETURN VARCHAR2 IS
    BEGIN
        RETURN p_list(give_random_number(1, p_list.COUNT));
    END pick;

    -- =========================================================
    -- STEP 1 – Helper functions
    -- =========================================================

    -- 1) Random integer within [p_min, p_max]
    FUNCTION give_random_number(p_min IN NUMBER, p_max IN NUMBER)
        RETURN NUMBER IS
    BEGIN
        RETURN TRUNC(DBMS_RANDOM.VALUE(p_min, p_max + 1));
    END give_random_number;

    -- 2) Random date between p_start and p_end (inclusive)
    FUNCTION give_random_date(p_start IN DATE, p_end IN DATE)
        RETURN DATE IS
    BEGIN
        RETURN p_start + give_random_number(0, p_end - p_start);
    END give_random_date;

    -- 3) Random genre
    FUNCTION give_random_genre RETURN VARCHAR2 IS
    BEGIN
        RETURN pick(g_genres);
    END give_random_genre;

    FUNCTION give_random_location RETURN VARCHAR2 IS
    BEGIN
        RETURN pick(g_locations);
    END give_random_location;

    FUNCTION give_random_country RETURN VARCHAR2 IS
    BEGIN
        RETURN pick(g_countries);
    END give_random_country;

    FUNCTION give_random_artist_prefix RETURN VARCHAR2 IS
    BEGIN
        RETURN pick(g_artist_prefixes);
    END give_random_artist_prefix;

    FUNCTION give_random_stage_suffix RETURN VARCHAR2 IS
    BEGIN
        RETURN pick(g_stage_suffixes);
    END give_random_stage_suffix;

    FUNCTION give_random_festival_suffix RETURN VARCHAR2 IS
    BEGIN
        RETURN pick(g_festival_suffixes);
    END give_random_festival_suffix;

    FUNCTION give_random_ticket_type RETURN VARCHAR2 IS
    BEGIN
        RETURN pick(g_ticket_types);
    END give_random_ticket_type;

    FUNCTION give_random_ticket_status RETURN VARCHAR2 IS
    BEGIN
        RETURN pick(g_ticket_statuses);
    END give_random_ticket_status;

    FUNCTION give_random_currency RETURN VARCHAR2 IS
    BEGIN
        RETURN pick(g_currencies);
    END give_random_currency;

    FUNCTION give_random_gender RETURN VARCHAR2 IS
    BEGIN
        RETURN pick(g_genders);
    END give_random_gender;

    FUNCTION give_random_street RETURN VARCHAR2 IS
    BEGIN
        RETURN pick(g_streets);
    END give_random_street;

    FUNCTION give_random_first_name RETURN VARCHAR2 IS
    BEGIN
        RETURN pick(g_first_names);
    END give_random_first_name;

    FUNCTION give_random_last_name RETURN VARCHAR2 IS
    BEGIN
        RETURN pick(g_last_names);
    END give_random_last_name;

    FUNCTION give_random_permit_category RETURN VARCHAR2 IS
    BEGIN
        RETURN pick(g_permit_categories);
    END give_random_permit_category;

    FUNCTION give_random_platform_name RETURN VARCHAR2 IS
    BEGIN
        RETURN pick(g_platform_names);
    END give_random_platform_name;

    -- Random description: 10 composable segments, three of them
    -- optional (NULL entries in the source list are skipped),
    -- giving billions of distinct sentences.
    FUNCTION give_random_description RETURN VARCHAR2 IS
        v_result VARCHAR2(4000);
        v_tmp    VARCHAR2(200);
    BEGIN
        v_result := pick(g_desc_opener) || ' ' || pick(g_desc_adj1);

        v_tmp := pick(g_desc_adj2);
        IF v_tmp IS NOT NULL THEN
            v_result := v_result || ' ' || v_tmp;
        END IF;

        v_result := v_result || ' ' || pick(g_desc_noun)
                             || ' ' || pick(g_desc_verb)
                             || ' ' || pick(g_desc_loc)
                             || ' ' || pick(g_desc_with);

        v_tmp := pick(g_desc_for);
        IF v_tmp IS NOT NULL THEN
            v_result := v_result || ' ' || v_tmp;
        END IF;

        v_tmp := pick(g_desc_impact);
        IF v_tmp IS NOT NULL THEN
            v_result := v_result || ', ' || v_tmp;
        END IF;

        RETURN v_result || ' ' || pick(g_desc_closing);
    END give_random_description;

    -- 4) Random combo: base string + zero-padded counter
    FUNCTION give_random_combo(p_base IN VARCHAR2, p_counter IN NUMBER)
        RETURN VARCHAR2 IS
    BEGIN
        RETURN p_base || '_' || LPAD(TO_CHAR(p_counter), 4, '0');
    END give_random_combo;

    -- Precision timer (provided by assignment)
    FUNCTION timestamp_diff(a TIMESTAMP, b TIMESTAMP)
        RETURN NUMBER IS
    BEGIN
        RETURN EXTRACT(DAY    FROM (a - b)) * 24 * 60 * 60
             + EXTRACT(HOUR   FROM (a - b)) * 60 * 60
             + EXTRACT(MINUTE FROM (a - b)) * 60
             + EXTRACT(SECOND FROM (a - b));
    END timestamp_diff;

    -- =========================================================
    -- STAP 4 – bewijs_Random_M5
    --   Demonstrates every helper function with DBMS_OUTPUT
    --   and reports total duration via timestamp_diff.
    -- =========================================================
    PROCEDURE bewijs_Random_M5 IS
        v_start TIMESTAMP := SYSTIMESTAMP;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== bewijs_Random_M5 START ===');

        -- 1) Random integer in [5, 25]
        DBMS_OUTPUT.PUT_LINE('give_random_number(5,25)        = ' || give_random_number(5, 25));

        -- 2) Random date between 2020-01-01 and today
        DBMS_OUTPUT.PUT_LINE('give_random_date(2020-01-01..today) = '
            || TO_CHAR(give_random_date(TO_DATE('01-01-2020','DD-MM-YYYY'), SYSDATE),
                       'DD-MM-YYYY'));

        -- 3) Domain lists
        DBMS_OUTPUT.PUT_LINE('give_random_genre               = ' || give_random_genre);
        DBMS_OUTPUT.PUT_LINE('give_random_location            = ' || give_random_location);
        DBMS_OUTPUT.PUT_LINE('give_random_country             = ' || give_random_country);
        DBMS_OUTPUT.PUT_LINE('give_random_artist_prefix       = ' || give_random_artist_prefix);
        DBMS_OUTPUT.PUT_LINE('give_random_stage_suffix        = ' || give_random_stage_suffix);
        DBMS_OUTPUT.PUT_LINE('give_random_festival_suffix     = ' || give_random_festival_suffix);
        DBMS_OUTPUT.PUT_LINE('give_random_ticket_type         = ' || give_random_ticket_type);
        DBMS_OUTPUT.PUT_LINE('give_random_ticket_status       = ' || give_random_ticket_status);
        DBMS_OUTPUT.PUT_LINE('give_random_currency            = ' || give_random_currency);
        DBMS_OUTPUT.PUT_LINE('give_random_gender              = ' || give_random_gender);
        DBMS_OUTPUT.PUT_LINE('give_random_street              = ' || give_random_street);
        DBMS_OUTPUT.PUT_LINE('give_random_first_name          = ' || give_random_first_name);
        DBMS_OUTPUT.PUT_LINE('give_random_last_name           = ' || give_random_last_name);
        DBMS_OUTPUT.PUT_LINE('give_random_permit_category     = ' || give_random_permit_category);
        DBMS_OUTPUT.PUT_LINE('give_random_platform_name       = ' || give_random_platform_name);
        DBMS_OUTPUT.PUT_LINE('give_random_description         = ' || give_random_description);

        -- 4) Combo
        DBMS_OUTPUT.PUT_LINE('give_random_combo(stage, n)     = '
            || give_random_combo(give_random_stage_suffix, give_random_number(1, 9999)));

        DBMS_OUTPUT.PUT_LINE('=== bewijs_Random_M5 END | duration: '
            || ROUND(timestamp_diff(SYSTIMESTAMP, v_start) * 1000) || ' ms ===');
    END bewijs_Random_M5;

-- =========================================================
-- Package initialization: populate all lookup arrays exactly
-- once per session.
-- =========================================================
BEGIN
    g_genres(1)  := 'Electronic';     g_genres(2)  := 'Rock';
    g_genres(3)  := 'Pop';             g_genres(4)  := 'Hip-Hop';
    g_genres(5)  := 'Techno';          g_genres(6)  := 'House';
    g_genres(7)  := 'Drum and Bass';   g_genres(8)  := 'Trance';
    g_genres(9)  := 'Indie Rock';      g_genres(10) := 'Reggae';

    g_locations(1)  := 'Boom';         g_locations(2)  := 'Werchter';
    g_locations(3)  := 'Hasselt';      g_locations(4)  := 'Berlin';
    g_locations(5)  := 'Barcelona';    g_locations(6)  := 'Budapest';
    g_locations(7)  := 'Roskilde';     g_locations(8)  := 'Glastonbury';
    g_locations(9)  := 'Amsterdam';    g_locations(10) := 'Brussels';
    g_locations(11) := 'Paris';        g_locations(12) := 'Manchester';
    g_locations(13) := 'Zurich';       g_locations(14) := 'Vienna';
    g_locations(15) := 'Copenhagen';

    g_countries(1) := 'Belgium';        g_countries(2)  := 'Germany';
    g_countries(3) := 'Netherlands';    g_countries(4)  := 'France';
    g_countries(5) := 'United Kingdom'; g_countries(6)  := 'Spain';
    g_countries(7) := 'Hungary';        g_countries(8)  := 'Denmark';
    g_countries(9) := 'Austria';        g_countries(10) := 'Switzerland';

    g_artist_prefixes(1)  := 'Neon';   g_artist_prefixes(2)  := 'Solar';
    g_artist_prefixes(3)  := 'Bass';   g_artist_prefixes(4)  := 'Echo';
    g_artist_prefixes(5)  := 'Storm';  g_artist_prefixes(6)  := 'Lunar';
    g_artist_prefixes(7)  := 'Acid';   g_artist_prefixes(8)  := 'Prism';
    g_artist_prefixes(9)  := 'Pulse';  g_artist_prefixes(10) := 'Voltage';
    g_artist_prefixes(11) := 'Orbit';  g_artist_prefixes(12) := 'Nova';
    g_artist_prefixes(13) := 'Flux';   g_artist_prefixes(14) := 'Drift';
    g_artist_prefixes(15) := 'Vibe';   g_artist_prefixes(16) := 'Surge';
    g_artist_prefixes(17) := 'Depth';  g_artist_prefixes(18) := 'Wave';
    g_artist_prefixes(19) := 'Crave';  g_artist_prefixes(20) := 'Blaze';

    g_stage_suffixes(1) := 'Stage';   g_stage_suffixes(2)  := 'Floor';
    g_stage_suffixes(3) := 'Arena';   g_stage_suffixes(4)  := 'Dome';
    g_stage_suffixes(5) := 'Tent';    g_stage_suffixes(6)  := 'Club';
    g_stage_suffixes(7) := 'Hall';    g_stage_suffixes(8)  := 'Garden';
    g_stage_suffixes(9) := 'Pit';     g_stage_suffixes(10) := 'Deck';

    g_festival_suffixes(1) := 'Festival'; g_festival_suffixes(2) := 'Fest';
    g_festival_suffixes(3) := 'Live';     g_festival_suffixes(4) := 'Rave';
    g_festival_suffixes(5) := 'Beats';    g_festival_suffixes(6) := 'Sound';
    g_festival_suffixes(7) := 'Open Air'; g_festival_suffixes(8) := 'Experience';

    g_ticket_types(1) := 'Day';            g_ticket_types(2) := 'Weekend';
    g_ticket_types(3) := 'Full Festival';  g_ticket_types(4) := 'Combi';
    g_ticket_types(5) := 'VIP';

    g_ticket_statuses(1) := 'Valid';   g_ticket_statuses(2) := 'Used';
    g_ticket_statuses(3) := 'Expired'; g_ticket_statuses(4) := 'Cancelled';

    g_currencies(1) := 'EUR';  g_currencies(2) := 'GBP';
    g_currencies(3) := 'USD';  g_currencies(4) := 'DKK';

    g_genders(1) := 'Male';  g_genders(2) := 'Female';  g_genders(3) := 'Other';

    g_streets(1)  := 'Meir';           g_streets(2)  := 'Groenplaats';
    g_streets(3)  := 'Kammenstraat';   g_streets(4)  := 'Nationalestraat';
    g_streets(5)  := 'Kerkstraat';     g_streets(6)  := 'Stationslaan';
    g_streets(7)  := 'Marktplein';     g_streets(8)  := 'Havenstraat';
    g_streets(9)  := 'Ringlaan';       g_streets(10) := 'Festivalweg';

    g_first_names(1)  := 'Amber';    g_first_names(2)  := 'Bram';
    g_first_names(3)  := 'Celeste';  g_first_names(4)  := 'Dylan';
    g_first_names(5)  := 'Eva';      g_first_names(6)  := 'Finn';
    g_first_names(7)  := 'Gilles';   g_first_names(8)  := 'Hannah';
    g_first_names(9)  := 'Igor';     g_first_names(10) := 'Jana';
    g_first_names(11) := 'Kevin';    g_first_names(12) := 'Lisa';
    g_first_names(13) := 'Mathias';  g_first_names(14) := 'Nina';
    g_first_names(15) := 'Olivier';  g_first_names(16) := 'Petra';
    g_first_names(17) := 'Quinten';  g_first_names(18) := 'Roos';
    g_first_names(19) := 'Simon';    g_first_names(20) := 'Tine';

    g_last_names(1)  := 'Aerts';    g_last_names(2)  := 'Bogaert';
    g_last_names(3)  := 'Claes';    g_last_names(4)  := 'Dubois';
    g_last_names(5)  := 'Engels';   g_last_names(6)  := 'Franck';
    g_last_names(7)  := 'Goossens'; g_last_names(8)  := 'Hermans';
    g_last_names(9)  := 'Ivens';    g_last_names(10) := 'Jacobs';
    g_last_names(11) := 'Klein';    g_last_names(12) := 'Leclercq';
    g_last_names(13) := 'Martens';  g_last_names(14) := 'Nijs';
    g_last_names(15) := 'Ooms';     g_last_names(16) := 'Peters';
    g_last_names(17) := 'Quintens'; g_last_names(18) := 'Raes';
    g_last_names(19) := 'Stevens';  g_last_names(20) := 'Thijs';

    g_permit_categories(1) := 'Noise';         g_permit_categories(2) := 'Alcohol';
    g_permit_categories(3) := 'Traffic';       g_permit_categories(4) := 'Fire Safety';
    g_permit_categories(5) := 'Public Safety'; g_permit_categories(6) := 'Health';
    g_permit_categories(7) := 'Construction';  g_permit_categories(8) := 'Environmental';
    g_permit_categories(9) := 'Security';

    g_platform_names(1)  := 'Ticketmaster Belgium'; g_platform_names(2)  := 'Paylogic';
    g_platform_names(3)  := 'See Tickets';          g_platform_names(4)  := 'Eventbrite';
    g_platform_names(5)  := 'Tele Ticket Service';  g_platform_names(6)  := 'Dice FM';
    g_platform_names(7)  := 'Fever Up';             g_platform_names(8)  := 'Resident Advisor';
    g_platform_names(9)  := 'StubHub International';g_platform_names(10) := 'TicketSwap';

    -- ----- description-builder pools -------------------------
    g_desc_opener(1) := 'A truly';        g_desc_opener(2) := 'A genuinely';
    g_desc_opener(3) := 'An absolutely';  g_desc_opener(4) := 'A remarkably';
    g_desc_opener(5) := 'A distinctly';   g_desc_opener(6) := 'An incredibly';
    g_desc_opener(7) := 'A thoroughly';   g_desc_opener(8) := 'A deeply';

    g_desc_adj1(1)  := 'legendary';      g_desc_adj1(2)  := 'vibrant';
    g_desc_adj1(3)  := 'iconic';         g_desc_adj1(4)  := 'energetic';
    g_desc_adj1(5)  := 'intimate';       g_desc_adj1(6)  := 'exclusive';
    g_desc_adj1(7)  := 'massive';        g_desc_adj1(8)  := 'dynamic';
    g_desc_adj1(9)  := 'immersive';      g_desc_adj1(10) := 'unique';
    g_desc_adj1(11) := 'breathtaking';   g_desc_adj1(12) := 'unforgettable';

    -- NULL entries → segment is omitted ~1/6 of the time
    g_desc_adj2(1)  := NULL;                      g_desc_adj2(2)  := NULL;
    g_desc_adj2(3)  := 'and memorable';           g_desc_adj2(4)  := 'and electric';
    g_desc_adj2(5)  := 'and passionate';          g_desc_adj2(6)  := 'and powerful';
    g_desc_adj2(7)  := 'and innovative';          g_desc_adj2(8)  := 'and celebrated';
    g_desc_adj2(9)  := 'and world-renowned';      g_desc_adj2(10) := 'and beloved';
    g_desc_adj2(11) := 'and captivating';         g_desc_adj2(12) := 'and inspiring';

    g_desc_noun(1) := 'experience';   g_desc_noun(2)  := 'showcase';
    g_desc_noun(3) := 'celebration';  g_desc_noun(4)  := 'gathering';
    g_desc_noun(5) := 'event';        g_desc_noun(6)  := 'spectacle';
    g_desc_noun(7) := 'highlight';    g_desc_noun(8)  := 'occasion';
    g_desc_noun(9) := 'display';      g_desc_noun(10) := 'show';

    g_desc_verb(1) := 'drawing passionate crowds';
    g_desc_verb(2) := 'blending music and culture';
    g_desc_verb(3) := 'showcasing emerging talent';
    g_desc_verb(4) := 'uniting fans from all over';
    g_desc_verb(5) := 'celebrating the art of live music';
    g_desc_verb(6) := 'pushing creative boundaries';
    g_desc_verb(7) := 'capturing unforgettable moments';
    g_desc_verb(8) := 'bringing together music lovers';

    g_desc_loc(1) := 'from across Europe';
    g_desc_loc(2) := 'from around the world';
    g_desc_loc(3) := 'across all genres';
    g_desc_loc(4) := 'from every corner of the globe';
    g_desc_loc(5) := 'throughout the festival scene';
    g_desc_loc(6) := 'across multiple stages';
    g_desc_loc(7) := 'from the local community';
    g_desc_loc(8) := 'across generations';

    g_desc_with(1)  := 'with world-class production';
    g_desc_with(2)  := 'with cutting-edge visuals';
    g_desc_with(3)  := 'with immersive sound design';
    g_desc_with(4)  := 'with premium facilities';
    g_desc_with(5)  := 'with an electric atmosphere';
    g_desc_with(6)  := 'with unmatched energy';
    g_desc_with(7)  := 'with stunning stage design';
    g_desc_with(8)  := 'with passionate performances';
    g_desc_with(9)  := 'with top-tier artists';
    g_desc_with(10) := 'with a devoted fanbase';

    g_desc_for(1)  := NULL;                          g_desc_for(2) := NULL;
    g_desc_for(3)  := NULL;                          g_desc_for(4) := 'for all music lovers';
    g_desc_for(5)  := 'for dedicated fans';          g_desc_for(6) := 'for those seeking something special';
    g_desc_for(7)  := 'for the passionate few';      g_desc_for(8) := 'for every festival-goer';
    g_desc_for(9)  := 'for audiophiles and newcomers'; g_desc_for(10) := 'for an unforgettable night';

    g_desc_impact(1)  := NULL;                                 g_desc_impact(2)  := NULL;
    g_desc_impact(3)  := NULL;                                 g_desc_impact(4)  := 'leaving a lasting impression';
    g_desc_impact(5)  := 'creating memories that endure';      g_desc_impact(6)  := 'setting the standard for live events';
    g_desc_impact(7)  := 'redefining what is possible';        g_desc_impact(8)  := 'raising the bar for the industry';
    g_desc_impact(9)  := 'inspiring a new generation';         g_desc_impact(10) := 'earning rave reviews';
    g_desc_impact(11) := 'cementing its place in history';

    g_desc_closing(1) := 'like no other';
    g_desc_closing(2) := 'year after year';
    g_desc_closing(3) := 'beyond compare';
    g_desc_closing(4) := 'in a class of its own';
    g_desc_closing(5) := 'not to be missed';
    g_desc_closing(6) := 'that speaks for itself';
    g_desc_closing(7) := 'worth every moment';
    g_desc_closing(8) := 'time and time again';
END PKG_SAMEN_festivals;
/
