CREATE OR REPLACE PACKAGE BODY PKG_SAMEN_festivals AS

    -- =========================================================
    -- MILESTONE 5 – SAMEN package body (festivals domain)
    -- =========================================================

    -- -------------------------------------------------------
    -- PRIVATE helper: pick element i from a VARCHAR2 array
    -- -------------------------------------------------------
    TYPE t_str_list IS TABLE OF VARCHAR2(200) INDEX BY PLS_INTEGER;

    FUNCTION pick(p_list IN t_str_list) RETURN VARCHAR2 IS
    BEGIN
        RETURN p_list(give_random_number(1, p_list.COUNT));
    END pick;

    -- =========================================================
    -- STAP 1 – Helper functions
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
        v_days NUMBER;
    BEGIN
        v_days := p_end - p_start;
        RETURN p_start + give_random_number(0, v_days);
    END give_random_date;

    -- 3) Random genre from a festival-relevant list
    FUNCTION give_random_genre RETURN VARCHAR2 IS
        v_list t_str_list;
    BEGIN
        v_list(1)  := 'Electronic';
        v_list(2)  := 'Rock';
        v_list(3)  := 'Pop';
        v_list(4)  := 'Hip-Hop';
        v_list(5)  := 'Techno';
        v_list(6)  := 'House';
        v_list(7)  := 'Drum and Bass';
        v_list(8)  := 'Trance';
        v_list(9)  := 'Indie Rock';
        v_list(10) := 'Reggae';
        RETURN pick(v_list);
    END give_random_genre;

    -- Random festival location (city/venue names)
    FUNCTION give_random_location RETURN VARCHAR2 IS
        v_list t_str_list;
    BEGIN
        v_list(1) := 'Boom';         v_list(2)  := 'Werchter';
        v_list(3) := 'Hasselt';      v_list(4)  := 'Berlin';
        v_list(5) := 'Barcelona';    v_list(6)  := 'Budapest';
        v_list(7) := 'Roskilde';     v_list(8)  := 'Glastonbury';
        v_list(9) := 'Amsterdam';    v_list(10) := 'Brussels';
        v_list(11):= 'Paris';        v_list(12) := 'Manchester';
        v_list(13):= 'Zurich';       v_list(14) := 'Vienna';
        v_list(15):= 'Copenhagen';
        RETURN pick(v_list);
    END give_random_location;

    -- Random country
    FUNCTION give_random_country RETURN VARCHAR2 IS
        v_list t_str_list;
    BEGIN
        v_list(1) := 'Belgium';       v_list(2)  := 'Germany';
        v_list(3) := 'Netherlands';   v_list(4)  := 'France';
        v_list(5) := 'United Kingdom';v_list(6)  := 'Spain';
        v_list(7) := 'Hungary';       v_list(8)  := 'Denmark';
        v_list(9) := 'Austria';       v_list(10) := 'Switzerland';
        RETURN pick(v_list);
    END give_random_country;

    -- Random artist name prefix (realistic-sounding acts)
    FUNCTION give_random_artist_prefix RETURN VARCHAR2 IS
        v_list t_str_list;
    BEGIN
        v_list(1) := 'Neon';       v_list(2)  := 'Solar';
        v_list(3) := 'Bass';       v_list(4)  := 'Echo';
        v_list(5) := 'Storm';      v_list(6)  := 'Lunar';
        v_list(7) := 'Acid';       v_list(8)  := 'Prism';
        v_list(9) := 'Pulse';      v_list(10) := 'Voltage';
        v_list(11):= 'Orbit';      v_list(12) := 'Nova';
        v_list(13):= 'Flux';       v_list(14) := 'Drift';
        v_list(15):= 'Vibe';       v_list(16) := 'Surge';
        v_list(17):= 'Depth';      v_list(18) := 'Wave';
        v_list(19):= 'Crave';      v_list(20) := 'Blaze';
        RETURN pick(v_list);
    END give_random_artist_prefix;

    -- Random stage suffix
    FUNCTION give_random_stage_suffix RETURN VARCHAR2 IS
        v_list t_str_list;
    BEGIN
        v_list(1) := 'Stage';     v_list(2)  := 'Floor';
        v_list(3) := 'Arena';     v_list(4)  := 'Dome';
        v_list(5) := 'Tent';      v_list(6)  := 'Club';
        v_list(7) := 'Hall';      v_list(8)  := 'Garden';
        v_list(9) := 'Pit';       v_list(10) := 'Deck';
        RETURN pick(v_list);
    END give_random_stage_suffix;

    -- Random festival suffix
    FUNCTION give_random_festival_suffix RETURN VARCHAR2 IS
        v_list t_str_list;
    BEGIN
        v_list(1) := 'Festival';  v_list(2)  := 'Fest';
        v_list(3) := 'Live';      v_list(4)  := 'Rave';
        v_list(5) := 'Beats';     v_list(6)  := 'Sound';
        v_list(7) := 'Open Air';  v_list(8)  := 'Experience';
        RETURN pick(v_list);
    END give_random_festival_suffix;

    -- Random ticket type
    FUNCTION give_random_ticket_type RETURN VARCHAR2 IS
        v_list t_str_list;
    BEGIN
        v_list(1) := 'Day';         v_list(2) := 'Weekend';
        v_list(3) := 'Full Festival'; v_list(4) := 'Combi';
        v_list(5) := 'VIP';
        RETURN pick(v_list);
    END give_random_ticket_type;

    -- Random ticket status
    FUNCTION give_random_ticket_status RETURN VARCHAR2 IS
        v_list t_str_list;
    BEGIN
        v_list(1) := 'Valid';    v_list(2) := 'Used';
        v_list(3) := 'Expired';  v_list(4) := 'Cancelled';
        RETURN pick(v_list);
    END give_random_ticket_status;

    -- Random currency
    FUNCTION give_random_currency RETURN VARCHAR2 IS
        v_list t_str_list;
    BEGIN
        v_list(1) := 'EUR';  v_list(2) := 'GBP';
        v_list(3) := 'USD';  v_list(4) := 'DKK';
        RETURN pick(v_list);
    END give_random_currency;

    -- Random gender
    FUNCTION give_random_gender RETURN VARCHAR2 IS
        v_list t_str_list;
    BEGIN
        v_list(1) := 'Male';  v_list(2) := 'Female';  v_list(3) := 'Other';
        RETURN pick(v_list);
    END give_random_gender;

    -- Random street name
    FUNCTION give_random_street RETURN VARCHAR2 IS
        v_list t_str_list;
    BEGIN
        v_list(1)  := 'Meir';           v_list(2)  := 'Groenplaats';
        v_list(3)  := 'Kammenstraat';   v_list(4)  := 'Nationalestraat';
        v_list(5)  := 'Kerkstraat';     v_list(6)  := 'Stationslaan';
        v_list(7)  := 'Marktplein';     v_list(8)  := 'Havenstraat';
        v_list(9)  := 'Ringlaan';       v_list(10) := 'Festivalweg';
        RETURN pick(v_list);
    END give_random_street;

    -- Random first name
    FUNCTION give_random_first_name RETURN VARCHAR2 IS
        v_list t_str_list;
    BEGIN
        v_list(1)  := 'Amber';    v_list(2)  := 'Bram';
        v_list(3)  := 'Celeste';  v_list(4)  := 'Dylan';
        v_list(5)  := 'Eva';      v_list(6)  := 'Finn';
        v_list(7)  := 'Gilles';   v_list(8)  := 'Hannah';
        v_list(9)  := 'Igor';     v_list(10) := 'Jana';
        v_list(11) := 'Kevin';    v_list(12) := 'Lisa';
        v_list(13) := 'Mathias';  v_list(14) := 'Nina';
        v_list(15) := 'Olivier';  v_list(16) := 'Petra';
        v_list(17) := 'Quinten';  v_list(18) := 'Roos';
        v_list(19) := 'Simon';    v_list(20) := 'Tine';
        RETURN pick(v_list);
    END give_random_first_name;

    -- Random last name
    FUNCTION give_random_last_name RETURN VARCHAR2 IS
        v_list t_str_list;
    BEGIN
        v_list(1)  := 'Aerts';    v_list(2)  := 'Bogaert';
        v_list(3)  := 'Claes';    v_list(4)  := 'Dubois';
        v_list(5)  := 'Engels';   v_list(6)  := 'Franck';
        v_list(7)  := 'Goossens'; v_list(8)  := 'Hermans';
        v_list(9)  := 'Ivens';    v_list(10) := 'Jacobs';
        v_list(11) := 'Klein';    v_list(12) := 'Leclercq';
        v_list(13) := 'Martens';  v_list(14) := 'Nijs';
        v_list(15) := 'Ooms';     v_list(16) := 'Peters';
        v_list(17) := 'Quintens'; v_list(18) := 'Raes';
        v_list(19) := 'Stevens';  v_list(20) := 'Thijs';
        RETURN pick(v_list);
    END give_random_last_name;

    -- Random permit category
    FUNCTION give_random_permit_category RETURN VARCHAR2 IS
        v_list t_str_list;
    BEGIN
        v_list(1) := 'Noise';        v_list(2) := 'Alcohol';
        v_list(3) := 'Traffic';      v_list(4) := 'Fire Safety';
        v_list(5) := 'Public Safety';v_list(6) := 'Health';
        v_list(7) := 'Construction'; v_list(8) := 'Environmental';
        v_list(9) := 'Security';
        RETURN pick(v_list);
    END give_random_permit_category;

    -- Random ticket platform name
    FUNCTION give_random_platform_name RETURN VARCHAR2 IS
        v_list t_str_list;
    BEGIN
        v_list(1)  := 'Ticketmaster Belgium'; v_list(2)  := 'Paylogic';
        v_list(3)  := 'See Tickets';          v_list(4)  := 'Eventbrite';
        v_list(5)  := 'Tele Ticket Service';  v_list(6)  := 'Dice FM';
        v_list(7)  := 'Fever Up';             v_list(8)  := 'Resident Advisor';
        v_list(9)  := 'StubHub International';v_list(10) := 'TicketSwap';
        RETURN pick(v_list);
    END give_random_platform_name;

    -- Random description: 10 composable parts, some optional → billions of combinations
    -- Generic enough for any entity (festival, stage, performance, permit, …)
    FUNCTION give_random_description RETURN VARCHAR2 IS
        v_opener  t_str_list;
        v_adj1    t_str_list;
        v_adj2    t_str_list;  -- optional
        v_noun    t_str_list;
        v_verb    t_str_list;
        v_loc     t_str_list;
        v_with    t_str_list;
        v_for     t_str_list;  -- optional
        v_impact  t_str_list;  -- optional
        v_closing t_str_list;
        v_result  VARCHAR2(4000);
        v_tmp     VARCHAR2(200);
    BEGIN
        v_opener(1) := 'A truly';        v_opener(2) := 'A genuinely';
        v_opener(3) := 'An absolutely';  v_opener(4) := 'A remarkably';
        v_opener(5) := 'A distinctly';   v_opener(6) := 'An incredibly';
        v_opener(7) := 'A thoroughly';   v_opener(8) := 'A deeply';

        v_adj1(1)  := 'legendary';      v_adj1(2)  := 'vibrant';
        v_adj1(3)  := 'iconic';         v_adj1(4)  := 'energetic';
        v_adj1(5)  := 'intimate';       v_adj1(6)  := 'exclusive';
        v_adj1(7)  := 'massive';        v_adj1(8)  := 'dynamic';
        v_adj1(9)  := 'immersive';      v_adj1(10) := 'unique';
        v_adj1(11) := 'breathtaking';   v_adj1(12) := 'unforgettable';

        -- optional: ~half the time empty
        v_adj2(1)  := '';                     v_adj2(2)  := '';
        v_adj2(3)  := 'and memorable';        v_adj2(4)  := 'and electric';
        v_adj2(5)  := 'and passionate';       v_adj2(6)  := 'and powerful';
        v_adj2(7)  := 'and innovative';       v_adj2(8)  := 'and celebrated';
        v_adj2(9)  := 'and world-renowned';   v_adj2(10) := 'and beloved';
        v_adj2(11) := 'and captivating';      v_adj2(12) := 'and inspiring';

        v_noun(1)  := 'experience';    v_noun(2)  := 'showcase';
        v_noun(3)  := 'celebration';   v_noun(4)  := 'gathering';
        v_noun(5)  := 'event';         v_noun(6)  := 'spectacle';
        v_noun(7)  := 'highlight';     v_noun(8)  := 'occasion';
        v_noun(9)  := 'display';       v_noun(10) := 'show';

        v_verb(1) := 'drawing passionate crowds';
        v_verb(2) := 'blending music and culture';
        v_verb(3) := 'showcasing emerging talent';
        v_verb(4) := 'uniting fans from all over';
        v_verb(5) := 'celebrating the art of live music';
        v_verb(6) := 'pushing creative boundaries';
        v_verb(7) := 'capturing unforgettable moments';
        v_verb(8) := 'bringing together music lovers';

        v_loc(1) := 'from across Europe';
        v_loc(2) := 'from around the world';
        v_loc(3) := 'across all genres';
        v_loc(4) := 'from every corner of the globe';
        v_loc(5) := 'throughout the festival scene';
        v_loc(6) := 'across multiple stages';
        v_loc(7) := 'from the local community';
        v_loc(8) := 'across generations';

        v_with(1)  := 'with world-class production';
        v_with(2)  := 'with cutting-edge visuals';
        v_with(3)  := 'with immersive sound design';
        v_with(4)  := 'with premium facilities';
        v_with(5)  := 'with an electric atmosphere';
        v_with(6)  := 'with unmatched energy';
        v_with(7)  := 'with stunning stage design';
        v_with(8)  := 'with passionate performances';
        v_with(9)  := 'with top-tier artists';
        v_with(10) := 'with a devoted fanbase';

        -- optional: ~one-third of the time empty
        v_for(1) := '';                              v_for(2) := '';
        v_for(3) := '';                              v_for(4) := 'for all music lovers';
        v_for(5) := 'for dedicated fans';            v_for(6) := 'for those seeking something special';
        v_for(7) := 'for the passionate few';        v_for(8) := 'for every festival-goer';
        v_for(9) := 'for audiophiles and newcomers'; v_for(10):= 'for an unforgettable night';

        -- optional: ~one-third of the time empty
        v_impact(1) := '';                                    v_impact(2) := '';
        v_impact(3) := '';                                    v_impact(4) := 'leaving a lasting impression';
        v_impact(5) := 'creating memories that endure';       v_impact(6) := 'setting the standard for live events';
        v_impact(7) := 'redefining what is possible';         v_impact(8) := 'raising the bar for the industry';
        v_impact(9) := 'inspiring a new generation';          v_impact(10):= 'earning rave reviews';
        v_impact(11):= 'cementing its place in history';

        v_closing(1) := 'like no other';
        v_closing(2) := 'year after year';
        v_closing(3) := 'beyond compare';
        v_closing(4) := 'in a class of its own';
        v_closing(5) := 'not to be missed';
        v_closing(6) := 'that speaks for itself';
        v_closing(7) := 'worth every moment';
        v_closing(8) := 'time and time again';

        -- Build sentence, skipping empty optional parts cleanly
        v_result := pick(v_opener) || ' ' || pick(v_adj1);

        v_tmp := pick(v_adj2);
        IF v_tmp IS NOT NULL AND v_tmp != '' THEN
            v_result := v_result || ' ' || v_tmp;
        END IF;

        v_result := v_result || ' ' || pick(v_noun)
                             || ' ' || pick(v_verb)
                             || ' ' || pick(v_loc)
                             || ' ' || pick(v_with);

        v_tmp := pick(v_for);
        IF v_tmp IS NOT NULL AND v_tmp != '' THEN
            v_result := v_result || ' ' || v_tmp;
        END IF;

        v_tmp := pick(v_impact);
        IF v_tmp IS NOT NULL AND v_tmp != '' THEN
            v_result := v_result || ', ' || v_tmp;
        END IF;

        RETURN v_result || ' ' || pick(v_closing);
    END give_random_description;

    -- 4) Random combo: base string + zero-padded counter
    FUNCTION give_random_combo(p_base IN VARCHAR2, p_counter IN NUMBER)
        RETURN VARCHAR2 IS
    BEGIN
        RETURN p_base || '_' || LPAD(TO_CHAR(p_counter), 4, '0');
    END give_random_combo;

    -- Precision timer (given by assignment)
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
    -- =========================================================
    PROCEDURE bewijs_Random_M5 IS
        v_start TIMESTAMP := SYSTIMESTAMP;
        v_num   NUMBER;
        v_date  DATE;
        v_str   VARCHAR2(200);
        v_combo VARCHAR2(200);
    BEGIN

        -- 1. Random number
        v_num := give_random_number(5, 25);

        -- 2. Random date
        v_date := give_random_date(TO_DATE('01-01-2020','DD-MM-YYYY'), SYSDATE);


        -- 3. Random genre (domain list)
        v_str := give_random_genre;


        -- 4. Random combo
        v_combo := give_random_combo(give_random_stage_suffix, give_random_number(1, 9999));

    END bewijs_Random_M5;

END PKG_SAMEN_festivals;
/
