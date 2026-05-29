CREATE OR REPLACE PACKAGE BODY PKG_S1_festivals AS
    -- Private collection types
    TYPE t_id_tab    IS TABLE OF NUMBER         INDEX BY PLS_INTEGER;
    TYPE t_date_tab  IS TABLE OF DATE           INDEX BY PLS_INTEGER;
    TYPE t_num10_2   IS TABLE OF NUMBER(10, 2)  INDEX BY PLS_INTEGER;
    TYPE t_str500    IS TABLE OF VARCHAR2(500)  INDEX BY PLS_INTEGER;
    TYPE t_str100    IS TABLE OF VARCHAR2(100)  INDEX BY PLS_INTEGER;
    TYPE t_str50     IS TABLE OF VARCHAR2(50)   INDEX BY PLS_INTEGER;
    TYPE t_str14     IS TABLE OF VARCHAR2(14)   INDEX BY PLS_INTEGER;
    TYPE t_str10     IS TABLE OF VARCHAR2(10)   INDEX BY PLS_INTEGER;
    TYPE t_char3     IS TABLE OF VARCHAR2(3)    INDEX BY PLS_INTEGER;
    TYPE t_combo_set IS TABLE OF PLS_INTEGER    INDEX BY VARCHAR2(40);

    -- Private: realistic email domain selector
    FUNCTION random_email_domain RETURN VARCHAR2 IS
        TYPE t_domains IS TABLE OF VARCHAR2(30) INDEX BY PLS_INTEGER;
        v_d t_domains;
    BEGIN
        v_d(1) := 'gmail.com';      v_d(2) := 'outlook.com';
        v_d(3) := 'hotmail.com';    v_d(4) := 'yahoo.com';
        v_d(5) := 'live.com';       v_d(6) := 'icloud.com';
        v_d(7) := 'protonmail.com';
        RETURN v_d(PKG_SAMEN_festivals.give_random_number(1, 7));
    END random_email_domain;

    -- Private: unique company name from a sequential index, three-tier slab design (11,000 unique).
    FUNCTION random_company_name_seq(p_seq IN NUMBER) RETURN VARCHAR2 IS
        TYPE t_name_pool IS TABLE OF VARCHAR2(40) INDEX BY PLS_INTEGER;
        v_brand_words    t_name_pool;   -- real/creative brand prefixes (25)
        v_domain_words   t_name_pool;   -- event-industry domain nouns  (20)
        v_geo_qualifiers t_name_pool;   -- geographic/business qualifiers (20)
        v_legal_forms    t_name_pool;   -- corporate legal suffixes (20) for tier 4
        v_sub_seq        PLS_INTEGER;
        v_brand_idx      PLS_INTEGER;
        v_domain_idx     PLS_INTEGER;
        v_geo_idx        PLS_INTEGER;
        v_suffix_idx     PLS_INTEGER;
    BEGIN
        -- brand pool: real industry names + invented words (disjoint from domain and geo pools)
        v_brand_words(1)  := 'Live Nation';   v_brand_words(2)  := 'AEG';
        v_brand_words(3)  := 'SFX';           v_brand_words(4)  := 'DEAG';
        v_brand_words(5)  := 'Mojo';          v_brand_words(6)  := 'FKP Scorpio';
        v_brand_words(7)  := 'SJM';           v_brand_words(8)  := 'Metropolis';
        v_brand_words(9)  := 'Rock Steady';   v_brand_words(10) := 'NightLife';
        v_brand_words(11) := 'Peak';          v_brand_words(12) := 'Sonic';
        v_brand_words(13) := 'Wave';          v_brand_words(14) := 'Summit';
        v_brand_words(15) := 'Pulse';         v_brand_words(16) := 'Nova';
        v_brand_words(17) := 'Volt';          v_brand_words(18) := 'Echo';
        v_brand_words(19) := 'Apex';          v_brand_words(20) := 'Crest';
        v_brand_words(21) := 'Flux';          v_brand_words(22) := 'Spark';
        v_brand_words(23) := 'Beat';          v_brand_words(24) := 'Orbit';
        v_brand_words(25) := 'Prism';

        v_domain_words(1)  := 'Events';        v_domain_words(2)  := 'Productions';
        v_domain_words(3)  := 'Entertainment'; v_domain_words(4)  := 'Concerts';
        v_domain_words(5)  := 'Music';         v_domain_words(6)  := 'Festivals';
        v_domain_words(7)  := 'Group';         v_domain_words(8)  := 'Agency';
        v_domain_words(9)  := 'Experience';    v_domain_words(10) := 'Collective';
        v_domain_words(11) := 'Works';         v_domain_words(12) := 'Touring';
        v_domain_words(13) := 'Artists';       v_domain_words(14) := 'Media';
        v_domain_words(15) := 'Booking';       v_domain_words(16) := 'Records';
        v_domain_words(17) := 'Promotions';    v_domain_words(18) := 'Network';
        v_domain_words(19) := 'Stage';         v_domain_words(20) := 'Ventures';

        v_geo_qualifiers(1)  := 'Belgium';      v_geo_qualifiers(2)  := 'Netherlands';
        v_geo_qualifiers(3)  := 'Germany';      v_geo_qualifiers(4)  := 'France';
        v_geo_qualifiers(5)  := 'UK';           v_geo_qualifiers(6)  := 'Spain';
        v_geo_qualifiers(7)  := 'Europe';       v_geo_qualifiers(8)  := 'Scandinavia';
        v_geo_qualifiers(9)  := 'Austria';      v_geo_qualifiers(10) := 'International';
        v_geo_qualifiers(11) := 'Benelux';      v_geo_qualifiers(12) := 'Iberia';
        v_geo_qualifiers(13) := 'Switzerland';  v_geo_qualifiers(14) := 'Nordic';
        v_geo_qualifiers(15) := 'Global';       v_geo_qualifiers(16) := 'Holdings';
        v_geo_qualifiers(17) := 'Partners';     v_geo_qualifiers(18) := 'Worldwide';
        v_geo_qualifiers(19) := 'Alliance';     v_geo_qualifiers(20) := 'Foundation';

        -- Four-tier slab: 500 + 500 + 10,000 + 200,000 = 211,000 unique names
        -- tier 1 (1-500)    brand+domain
        -- tier 2 (501-1000) brand+geo
        -- tier 3 (1001-11000) brand+domain+geo (geo NOT modded → no wrap within tier)
        -- tier 4 (11001+)   brand+domain+geo+legal suffix (20 corporate forms × 10K = 200K)
        IF p_seq <= 500 THEN
            v_brand_idx  := MOD(p_seq - 1, 25) + 1;
            v_domain_idx := TRUNC((p_seq - 1) / 25) + 1;
            RETURN v_brand_words(v_brand_idx) || ' ' || v_domain_words(v_domain_idx);
        ELSIF p_seq <= 1000 THEN
            v_sub_seq   := p_seq - 501;
            v_brand_idx := MOD(v_sub_seq, 25) + 1;
            v_geo_idx   := TRUNC(v_sub_seq / 25) + 1;
            RETURN v_brand_words(v_brand_idx) || ' ' || v_geo_qualifiers(v_geo_idx);
        ELSIF p_seq <= 11000 THEN
            v_sub_seq    := p_seq - 1001;                       -- 0..9999
            v_brand_idx  := MOD(v_sub_seq, 25) + 1;
            v_domain_idx := MOD(TRUNC(v_sub_seq / 25), 20) + 1;
            v_geo_idx    := TRUNC(v_sub_seq / 500) + 1;        -- 1..20, no MOD → no wrap
            RETURN v_brand_words(v_brand_idx) || ' ' || v_domain_words(v_domain_idx)
                   || ' ' || v_geo_qualifiers(v_geo_idx);
        ELSE
            v_legal_forms(1)  := 'Ltd';   v_legal_forms(2)  := 'GmbH';
            v_legal_forms(3)  := 'Corp';  v_legal_forms(4)  := 'Inc';
            v_legal_forms(5)  := 'SA';    v_legal_forms(6)  := 'NV';
            v_legal_forms(7)  := 'BV';    v_legal_forms(8)  := 'AG';
            v_legal_forms(9)  := 'Plc';   v_legal_forms(10) := 'SRL';
            v_legal_forms(11) := 'SARL';  v_legal_forms(12) := 'SpA';
            v_legal_forms(13) := 'AB';    v_legal_forms(14) := 'AS';
            v_legal_forms(15) := 'Oy';    v_legal_forms(16) := 'SL';
            v_legal_forms(17) := 'BVBA';  v_legal_forms(18) := 'SAS';
            v_legal_forms(19) := 'LLC';   v_legal_forms(20) := 'KG';
            v_sub_seq    := p_seq - 11001;                      -- 0..199999 per cycle
            v_brand_idx  := MOD(v_sub_seq, 25) + 1;
            v_domain_idx := MOD(TRUNC(v_sub_seq / 25), 20) + 1;
            v_geo_idx    := MOD(TRUNC(v_sub_seq / 500), 20) + 1;
            v_suffix_idx := MOD(TRUNC(v_sub_seq / 10000), 20) + 1;
            RETURN v_brand_words(v_brand_idx) || ' ' || v_domain_words(v_domain_idx)
                   || ' ' || v_geo_qualifiers(v_geo_idx) || ' ' || v_legal_forms(v_suffix_idx);
        END IF;
    END random_company_name_seq;

    -- Private: platform display name + canonical URL from sequential index (30×25×10 = 7,500 unique pairs; version suffix beyond that).
    PROCEDURE platform_name_and_url(p_seq  IN  NUMBER,
                                     p_name OUT VARCHAR2,
                                     p_url  OUT VARCHAR2) IS
        TYPE t_list30n IS TABLE OF VARCHAR2(30) INDEX BY PLS_INTEGER;
        TYPE t_list25s IS TABLE OF VARCHAR2(10) INDEX BY PLS_INTEGER;
        TYPE t_list10n IS TABLE OF VARCHAR2(15) INDEX BY PLS_INTEGER;
        TYPE t_list10p IS TABLE OF VARCHAR2(10) INDEX BY PLS_INTEGER;
        v_brand_names   t_list30n;
        v_brand_slugs   t_list30n;
        v_region_names  t_list30n;
        v_region_tlds   t_list25s;
        v_type_suffixes t_list10n;
        v_url_prefixes  t_list10p;
        v_brand_idx     PLS_INTEGER;
        v_region_idx    PLS_INTEGER;
        v_type_idx      PLS_INTEGER;
        v_version       PLS_INTEGER;
    BEGIN
        v_brand_names(1)  := 'Ticketmaster';     v_brand_slugs(1)  := 'ticketmaster';
        v_brand_names(2)  := 'Paylogic';         v_brand_slugs(2)  := 'paylogic';
        v_brand_names(3)  := 'Eventbrite';       v_brand_slugs(3)  := 'eventbrite';
        v_brand_names(4)  := 'See Tickets';      v_brand_slugs(4)  := 'seetickets';
        v_brand_names(5)  := 'DICE';             v_brand_slugs(5)  := 'dice';
        v_brand_names(6)  := 'TicketSwap';       v_brand_slugs(6)  := 'ticketswap';
        v_brand_names(7)  := 'Festicket';        v_brand_slugs(7)  := 'festicket';
        v_brand_names(8)  := 'Skiddle';          v_brand_slugs(8)  := 'skiddle';
        v_brand_names(9)  := 'StubHub';          v_brand_slugs(9)  := 'stubhub';
        v_brand_names(10) := 'Feverup';          v_brand_slugs(10) := 'feverup';
        v_brand_names(11) := 'Resident Advisor'; v_brand_slugs(11) := 'ra';
        v_brand_names(12) := 'Songkick';         v_brand_slugs(12) := 'songkick';
        v_brand_names(13) := 'Vivaticket';       v_brand_slugs(13) := 'vivaticket';
        v_brand_names(14) := 'Tixler';           v_brand_slugs(14) := 'tixler';
        v_brand_names(15) := 'TicketPortal';     v_brand_slugs(15) := 'ticketportal';
        v_brand_names(16) := 'Weezevent';        v_brand_slugs(16) := 'weezevent';
        v_brand_names(17) := 'Eventim';          v_brand_slugs(17) := 'eventim';
        v_brand_names(18) := 'Fever';            v_brand_slugs(18) := 'fever';
        v_brand_names(19) := 'Bandcamp';         v_brand_slugs(19) := 'bandcamp';
        v_brand_names(20) := 'YPlan';            v_brand_slugs(20) := 'yplan';
        v_brand_names(21) := 'Tiqets';           v_brand_slugs(21) := 'tiqets';
        v_brand_names(22) := 'Viagogo';          v_brand_slugs(22) := 'viagogo';
        v_brand_names(23) := 'AXS';              v_brand_slugs(23) := 'axs';
        v_brand_names(24) := 'Bandsintown';      v_brand_slugs(24) := 'bandsintown';
        v_brand_names(25) := 'TicketNetwork';    v_brand_slugs(25) := 'ticketnetwork';
        v_brand_names(26) := 'Encore';           v_brand_slugs(26) := 'encore';
        v_brand_names(27) := 'Oeticket';         v_brand_slugs(27) := 'oeticket';
        v_brand_names(28) := 'TicketLine';       v_brand_slugs(28) := 'ticketline';
        v_brand_names(29) := 'LiveBook';         v_brand_slugs(29) := 'livebook';
        v_brand_names(30) := 'GoTix';            v_brand_slugs(30) := 'gotix';

        v_region_names(1)  := 'Belgium';         v_region_tlds(1)  := 'be';
        v_region_names(2)  := 'Netherlands';     v_region_tlds(2)  := 'nl';
        v_region_names(3)  := 'Germany';         v_region_tlds(3)  := 'de';
        v_region_names(4)  := 'France';          v_region_tlds(4)  := 'fr';
        v_region_names(5)  := 'United Kingdom';  v_region_tlds(5)  := 'co.uk';
        v_region_names(6)  := 'Austria';         v_region_tlds(6)  := 'at';
        v_region_names(7)  := 'Spain';           v_region_tlds(7)  := 'es';
        v_region_names(8)  := 'Italy';           v_region_tlds(8)  := 'it';
        v_region_names(9)  := 'Switzerland';     v_region_tlds(9)  := 'ch';
        v_region_names(10) := 'Poland';          v_region_tlds(10) := 'pl';
        v_region_names(11) := 'Czech Republic';  v_region_tlds(11) := 'cz';
        v_region_names(12) := 'Portugal';        v_region_tlds(12) := 'pt';
        v_region_names(13) := 'Hungary';         v_region_tlds(13) := 'hu';
        v_region_names(14) := 'Norway';          v_region_tlds(14) := 'no';
        v_region_names(15) := 'Denmark';         v_region_tlds(15) := 'dk';
        v_region_names(16) := 'Sweden';          v_region_tlds(16) := 'se';
        v_region_names(17) := 'Finland';         v_region_tlds(17) := 'fi';
        v_region_names(18) := 'Ireland';         v_region_tlds(18) := 'ie';
        v_region_names(19) := 'Romania';         v_region_tlds(19) := 'ro';
        v_region_names(20) := 'International';   v_region_tlds(20) := 'com';
        v_region_names(21) := 'Greece';          v_region_tlds(21) := 'gr';
        v_region_names(22) := 'Turkey';          v_region_tlds(22) := 'tr';
        v_region_names(23) := 'Japan';           v_region_tlds(23) := 'jp';
        v_region_names(24) := 'Australia';       v_region_tlds(24) := 'com.au';
        v_region_names(25) := 'Canada';          v_region_tlds(25) := 'ca';

        v_url_prefixes(1)  := 'www.';      v_type_suffixes(1)  := '';
        v_url_prefixes(2)  := 'app.';      v_type_suffixes(2)  := ' App';
        v_url_prefixes(3)  := 'm.';        v_type_suffixes(3)  := ' Mobile';
        v_url_prefixes(4)  := 'pro.';      v_type_suffixes(4)  := ' Pro';
        v_url_prefixes(5)  := 'b2b.';      v_type_suffixes(5)  := ' Business';
        v_url_prefixes(6)  := 'vip.';      v_type_suffixes(6)  := ' Premium';
        v_url_prefixes(7)  := 'student.';  v_type_suffixes(7)  := ' Student';
        v_url_prefixes(8)  := 'api.';      v_type_suffixes(8)  := ' API';
        v_url_prefixes(9)  := 'shop.';     v_type_suffixes(9)  := ' Shop';
        v_url_prefixes(10) := 'live.';     v_type_suffixes(10) := ' Live';

        v_brand_idx  := MOD(p_seq - 1, 30) + 1;
        v_region_idx := MOD(TRUNC((p_seq - 1) / 30), 25) + 1;
        v_type_idx   := MOD(TRUNC((p_seq - 1) / 750), 10) + 1;
        v_version    := TRUNC((p_seq - 1) / 7500) + 1;

        p_name := v_brand_names(v_brand_idx) || ' ' || v_region_names(v_region_idx)
                  || v_type_suffixes(v_type_idx)
                  || CASE WHEN v_version > 1 THEN ' v' || v_version ELSE '' END;
        p_url  := 'https://' || v_url_prefixes(v_type_idx)
                  || v_brand_slugs(v_brand_idx) || '.' || v_region_tlds(v_region_idx)
                  || CASE WHEN v_version > 1 THEN '/v' || v_version ELSE '' END;
    END platform_name_and_url;

    -- Private: strip https://www. or https:// prefix to return the bare hostname.
    FUNCTION url_host(p_url IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        IF LOWER(p_url) LIKE 'https://www.%' THEN RETURN SUBSTR(p_url, 13); END IF;
        IF LOWER(p_url) LIKE 'https://%'     THEN RETURN SUBSTR(p_url,  9); END IF;
        RETURN p_url;
    END url_host;

    -- Private: country-aware zipcode formatter; unique per (p_country, p_seq).
    FUNCTION format_zipcode(p_country IN VARCHAR2, p_seq IN NUMBER) RETURN VARCHAR2 IS
        v_n  PLS_INTEGER := MOD(ABS(p_seq) - 1, 89999) + 1;
        v_l1 VARCHAR2(1);
        v_l2 VARCHAR2(1);
        v_l3 VARCHAR2(1);
    BEGIN
        CASE p_country
            -- 4-digit numeric (BE, HU, DK, AT, CH)
            WHEN 'Belgium'        THEN RETURN LPAD(TO_CHAR(MOD(v_n, 8999)  + 1001), 4, '0');
            WHEN 'Hungary'        THEN RETURN LPAD(TO_CHAR(MOD(v_n, 8998)  + 1001), 4, '0');
            WHEN 'Denmark'        THEN RETURN LPAD(TO_CHAR(MOD(v_n, 8999)  + 1000), 4, '0');
            WHEN 'Austria'        THEN RETURN LPAD(TO_CHAR(MOD(v_n, 8989)  + 1010), 4, '0');
            WHEN 'Switzerland'    THEN RETURN LPAD(TO_CHAR(MOD(v_n, 8999)  + 1000), 4, '0');
            -- 4-digit + 2 letters (NL): e.g. 1234 AB
            WHEN 'Netherlands'    THEN
                v_l1 := CHR(65 + MOD(TRUNC(v_n / 26), 26));
                v_l2 := CHR(65 + MOD(v_n, 26));
                RETURN LPAD(TO_CHAR(MOD(v_n, 8999) + 1000), 4, '0') || ' ' || v_l1 || v_l2;
            -- 5-digit numeric (DE, FR, ES)
            WHEN 'Germany'        THEN RETURN LPAD(TO_CHAR(MOD(v_n, 89999) + 10000), 5, '0');
            WHEN 'France'         THEN RETURN LPAD(TO_CHAR(MOD(v_n, 89999) + 10000), 5, '0');
            WHEN 'Spain'          THEN RETURN LPAD(TO_CHAR(MOD(v_n, 49999) +  1001), 5, '0');
            -- Simplified UK postcode: e.g. SW12 3AB
            WHEN 'United Kingdom' THEN
                v_l1 := CHR(65 + MOD(v_n, 26));
                v_l2 := CHR(65 + MOD(TRUNC(v_n / 26), 26));
                v_l3 := CHR(65 + MOD(TRUNC(v_n / 676), 26));
                RETURN v_l1 || v_l2 || LPAD(TO_CHAR(MOD(v_n, 99) + 1), 2, '0')
                       || ' ' || TO_CHAR(MOD(v_n, 9) + 1) || v_l2 || v_l3;
            -- Default: 5-digit numeric
            ELSE RETURN LPAD(TO_CHAR(MOD(v_n, 89999) + 10000), 5, '0');
        END CASE;
    END format_zipcode;

    -- ---------------------------------------------------------

    FUNCTION lookup_company_id(p_company_name IN COMPANY.COMPANY_NAME%type) RETURN COMPANY.COMPANY_ID%type IS
        v_id COMPANY.COMPANY_ID%type;
    BEGIN
        SELECT COMPANY_ID
        INTO v_id
        FROM COMPANY
        WHERE COMPANY_NAME = p_company_name;
        RETURN v_id;
    END lookup_company_id;

    -- ---------------------------------------------------------

    FUNCTION lookup_city_id(p_zipcode IN CITY.ZIPCODE%type,
                            p_country IN CITY.COUNTRY%type) RETURN CITY.CITY_ID%type IS
        v_id CITY.CITY_ID%type;
    BEGIN
        SELECT City_ID
        INTO v_id
        FROM City
        WHERE Zipcode = p_zipcode
          AND Country = p_country;
        RETURN v_id;
    END lookup_city_id;

    -- PRIVATE LOOKUP FUNCTIONS
    FUNCTION lookup_visitor_id(p_visitor_firstname IN VISITOR.VISITOR_FIRSTNAME%type,
                               p_visitor_lastname IN VISITOR.VISITOR_LASTNAME%type)
        RETURN VISITOR.VISITOR_ID%type IS
        v_id VISITOR.VISITOR_ID%type;
    BEGIN
        SELECT VISITOR_ID
        INTO v_id
        FROM VISITOR
        WHERE VISITOR_FIRSTNAME = p_visitor_firstname
          AND VISITOR_LASTNAME = p_visitor_lastname;
        RETURN v_id;
    END lookup_visitor_id;

    -- ---------------------------------------------------------

    FUNCTION lookup_ticket_id(p_ticketplatform_id IN TICKET.TICKETPLATFORM_ID%type,
                              p_visitor_id IN TICKET.VISITOR_ID%type,
                              p_festival_id IN TICKET.FESTIVAL_ID%type)
        RETURN TICKET.TICKET_ID%type IS
        v_id TICKET.TICKET_ID%type;
    BEGIN
        SELECT TICKET_ID
        INTO v_id
        FROM TICKET
        WHERE TICKETPLATFORM_ID = p_ticketplatform_id
          AND VISITOR_ID = p_visitor_id
          AND FESTIVAL_ID = p_festival_id;
        RETURN v_id;
    END lookup_ticket_id;

    -- ---------------------------------------------------------

    FUNCTION lookup_ticketplatform_id(p_ticketplatform_name IN TICKETPLATFORM.TICKETPLATFORM_NAME%type)
        RETURN TICKETPLATFORM.TICKETPLATFORM_ID%type IS
        v_id TICKETPLATFORM.TICKETPLATFORM_ID%type;
    BEGIN
        SELECT TICKETPLATFORM_ID
        INTO v_id
        FROM TICKETPLATFORM
        WHERE TICKETPLATFORM_NAME = p_ticketplatform_name;
        RETURN v_id;
    END lookup_ticketplatform_id;

    -- ---------------------------------------------------------

    FUNCTION lookup_permit_id(p_festival_id IN PERMIT.FESTIVAL_ID%type,
                              p_category IN PERMIT.PERMIT_CATEGORY%type,
                              p_application_date IN PERMIT.PERMIT_APPLICATION_DATE%type)
        RETURN PERMIT.PERMIT_ID%type IS
        v_id PERMIT.PERMIT_ID%type;
    BEGIN
        SELECT PERMIT_ID
        INTO v_id
        FROM PERMIT
        WHERE FESTIVAL_ID = p_festival_id
          AND PERMIT_CATEGORY = p_category
          AND PERMIT_APPLICATION_DATE = p_application_date;
        RETURN v_id;
    END lookup_permit_id;

    -- ---------------------------------------------------------------------------------------------------------------------
    -- PRIVATE ADD PROCEDURES

    PROCEDURE add_company(p_company_name IN COMPANY.COMPANY_NAME%type,
                          p_company_founding_year IN COMPANY.COMPANY_FOUNDING_YEAR%type) IS
    BEGIN
        INSERT INTO COMPANY (COMPANY_NAME, COMPANY_FOUNDING_YEAR)
        VALUES (p_company_name, p_company_founding_year);
    END add_company;

    -- ---------------------------------------------------------

    PROCEDURE add_city(p_zipcode IN CITY.ZIPCODE%type,
                       p_city IN CITY.CITY%type,
                       p_country IN CITY.COUNTRY%type) IS
    BEGIN
        INSERT INTO CITY (ZIPCODE, CITY, COUNTRY)
        VALUES (p_zipcode, p_city, p_country);
    END add_city;

    -- ---------------------------------------------------------

    PROCEDURE add_visitor(p_firstname IN VISITOR.VISITOR_FIRSTNAME%type,
                          p_lastname IN VISITOR.VISITOR_LASTNAME%type,
                          p_birthdate IN VISITOR.VISITOR_BIRTHDATE%type,
                          p_email IN VISITOR.VISITOR_EMAIL%type,
                          p_street_name IN VISITOR.VISITOR_STREET_NAME%type,
                          p_street_number IN VISITOR.VISITOR_STREET_NUMBER%type,
                          p_zipcode IN CITY.ZIPCODE%type,
                          p_country IN CITY.COUNTRY%type,
                          p_gender IN VISITOR.VISITOR_GENDER%type) IS
        v_city_id VISITOR.CITY_ID%type;
    BEGIN
        IF p_birthdate > SYSDATE THEN
            RAISE_APPLICATION_ERROR(-20010,
                                    'Visitor birthdate ' || TO_CHAR(p_birthdate, 'DD-MM-YYYY') ||
                                    ' cannot be later than today.');
        END IF;
        v_city_id := lookup_city_id(p_zipcode, p_country);
        INSERT INTO VISITOR (VISITOR_FIRSTNAME, VISITOR_LASTNAME, VISITOR_BIRTHDATE, VISITOR_EMAIL, VISITOR_STREET_NAME,
                             VISITOR_STREET_NUMBER, CITY_ID, VISITOR_GENDER)
        VALUES (p_firstname, p_lastname, p_birthdate, p_email, p_street_name, p_street_number, v_city_id, p_gender);
    END add_visitor;

    -- ---------------------------------------------------------

    PROCEDURE add_ticketplatform(p_name IN TICKETPLATFORM.TICKETPLATFORM_NAME%type,
                                 p_url IN TICKETPLATFORM.TICKETPLATFORM_URL%type) IS
    BEGIN
        INSERT INTO TICKETPLATFORM (TICKETPLATFORM_NAME, TICKETPLATFORM_URL)
        VALUES (p_name, p_url);
    END add_ticketplatform;

    -- ---------------------------------------------------------

    PROCEDURE add_permit(p_category IN PERMIT.PERMIT_CATEGORY%type,
                         p_description IN PERMIT.PERMIT_DESCRIPTION%type,
                         p_reception_date IN PERMIT.PERMIT_RECEPTION_DATE%type,
                         p_expiration_date IN PERMIT.PERMIT_EXPIRATION_DATE%type,
                         p_application_date IN PERMIT.PERMIT_APPLICATION_DATE%type,
                         p_festival_name IN FESTIVAL.FESTIVAL_NAME%type) IS
        v_festival_id PERMIT.FESTIVAL_ID%type;
    BEGIN
        IF p_application_date > SYSDATE THEN
            RAISE_APPLICATION_ERROR(-20011,
                                    'Permit application_date ' || TO_CHAR(p_application_date, 'DD-MM-YYYY') ||
                                    ' cannot be later than today.');
        END IF;
        v_festival_id := PKG_S2_festivals.lookup_festival_id(p_festival_name);

        INSERT INTO PERMIT (PERMIT_CATEGORY, PERMIT_DESCRIPTION, PERMIT_RECEPTION_DATE, PERMIT_EXPIRATION_DATE,
                            PERMIT_APPLICATION_DATE, FESTIVAL_ID)
        VALUES (p_category, p_description, p_reception_date, p_expiration_date, p_application_date, v_festival_id);
    END add_permit;

    -- ---------------------------------------------------------

    PROCEDURE add_ticket(p_price IN TICKET.TICKET_PRICE%type,
                         p_currency IN TICKET.TICKET_CURRENCY%type,
                         p_date IN TICKET.TICKET_DATE%type,
                         p_purchase_date IN TICKET.TICKET_PURCHASE_DATE%type,
                         p_description IN TICKET.TICKET_DESCRIPTION%type,
                         p_barcode IN TICKET.TICKET_BARCODE%type,
                         p_type IN TICKET.TICKET_TYPE%type,
                         p_status IN TICKET.TICKET_STATUS%type,
                         p_qr_code IN TICKET.TICKET_QR_CODE%type,
                         p_ticketplatform_name IN TICKETPLATFORM.TICKETPLATFORM_NAME%type,
                         p_visitor_firstname IN VISITOR.VISITOR_FIRSTNAME%type,
                         p_visitor_lastname IN VISITOR.VISITOR_LASTNAME%type,
                         p_festival_name IN FESTIVAL.FESTIVAL_NAME%type) IS
        v_festival_start    FESTIVAL.FESTIVAL_STARTDATE%type;
        v_festival_end      FESTIVAL.FESTIVAL_ENDDATE%type;
        v_ticketplatform_id TICKET.TICKETPLATFORM_ID%type;
        v_visitor_id        TICKET.VISITOR_ID%type;
        v_festival_id       TICKET.FESTIVAL_ID%type;
    BEGIN
        IF p_purchase_date > SYSDATE THEN
            RAISE_APPLICATION_ERROR(-20012,
                                    'Ticket purchase_date ' || TO_CHAR(p_purchase_date, 'DD-MM-YYYY') ||
                                    ' cannot be later than today.');
        END IF;
        -- S2 date rule: performance start must fall within the parent Festival's dates
        v_ticketplatform_id := lookup_ticketplatform_id(p_ticketplatform_name);
        v_visitor_id := lookup_visitor_id(p_visitor_firstname, p_visitor_lastname);
        v_festival_id := PKG_S2_festivals.lookup_festival_id(p_festival_name);

        SELECT FESTIVAL_STARTDATE, FESTIVAL_ENDDATE
        INTO v_festival_start, v_festival_end
        FROM FESTIVAL
        WHERE FESTIVAL_ID = v_festival_id;

        IF (p_date NOT BETWEEN v_festival_start AND v_festival_end)
            OR p_purchase_date > v_festival_end
            OR p_purchase_date > p_date THEN
            RAISE_APPLICATION_ERROR(-20001,
                                    'Ticket date ' || TO_CHAR(p_date, 'DD-MM-YYYY') ||
                                    ' must fall within festival dates (' ||
                                    TO_CHAR(v_festival_start, 'DD-MM-YYYY') || ' - ' ||
                                    TO_CHAR(v_festival_end, 'DD-MM-YYYY') || ') and after the purchase date (' ||
                                    TO_CHAR(p_purchase_date, 'DD-MM-YYYY') || ').');
        END IF;

        INSERT INTO TICKET (TICKET_PRICE, TICKET_CURRENCY, TICKET_DATE, TICKET_PURCHASE_DATE, TICKET_DESCRIPTION,
                            TICKET_BARCODE, TICKET_TYPE, TICKET_STATUS, TICKET_QR_CODE, TICKETPLATFORM_ID, VISITOR_ID,
                            FESTIVAL_ID)
        VALUES (p_price, p_currency, p_date, p_purchase_date, p_description, p_barcode, p_type, p_status, p_qr_code,
                v_ticketplatform_id, v_visitor_id, v_festival_id);
    END add_ticket;

-- ---------------------------------------------------------------------------------------------------------------------

-- PUBLIC: EMPTY TABLES (phased)
-- Cross-schema FK forces interleaving with PKG_S2_festivals.empty_tables_S2:
--   1) empty_s1_children    -> TICKET, PERMIT      (children of S2.FESTIVAL)
--   2) empty_tables_S2      -> S2 tables incl. FESTIVAL
--   3) empty_s1_base        -> TICKETPLATFORM, VISITOR, COMPANY, CITY

    PROCEDURE empty_s1_children IS
    BEGIN
        DELETE FROM TICKET;
        DELETE FROM PERMIT;
        -- Purge orphaned identity sequences of previously dropped tables.
        EXECUTE IMMEDIATE 'PURGE RECYCLEBIN';
        COMMIT;
    END empty_s1_children;

    PROCEDURE empty_s1_base IS
    BEGIN
        DELETE FROM TICKETPLATFORM;
        DELETE FROM VISITOR;
        DELETE FROM COMPANY;
        DELETE FROM CITY;
        EXECUTE IMMEDIATE 'PURGE RECYCLEBIN';
        COMMIT;
    END empty_s1_base;

    -- Convenience wrapper: only safe when S2 tables (esp. FESTIVAL) are already empty
    PROCEDURE empty_tables_S1 IS
    BEGIN
        empty_s1_children;
        empty_s1_base;
    END empty_tables_S1;

-- =============================================================
-- fill_s1_base: COMPANY, CITY, VISITOR, TICKETPLATFORM
--   Must run BEFORE PKG_S2_festivals.bewijs_M4_S2 (FESTIVAL needs COMPANY).
-- =============================================================

    PROCEDURE fill_s1_base IS
    BEGIN
        -- ----------------------------------------------------------------
        -- COMPANY  (10 rows)
        -- ----------------------------------------------------------------
        add_company('Tomorrowland NV', 2005);
        add_company('Rock Werchter Productions', 1975);
        add_company('Pukkelpop VZW', 1985);
        add_company('Live Nation Belgium', 1996);
        add_company('AEG Presents Europe', 2000);
        add_company('Sziget Cultural Management', 1993);
        add_company('Roskilde Festival Society', 1971);
        add_company('Glastonbury Festivals Ltd', 1970);
        add_company('Primavera Sound SL', 2001);
        add_company('Melt! Festival GmbH', 1997);

        -- ----------------------------------------------------------------
        -- 3. CITY  (12 rows)
        -- ----------------------------------------------------------------
        add_city('2000', 'Antwerp', 'Belgium');
        add_city('2850', 'Boom', 'Belgium');
        add_city('3118', 'Werchter', 'Belgium');
        add_city('3500', 'Hasselt', 'Belgium');
        add_city('1000', 'Brussels', 'Belgium');
        add_city('1117BP', 'Budapest', 'Hungary');
        add_city('4000', 'Roskilde', 'Denmark');
        add_city('BA44AF', 'Glastonbury', 'United Kingdom');
        add_city('08003', 'Barcelona', 'Spain');
        add_city('06773', 'Ferropolis', 'Germany');
        add_city('10115', 'Berlin', 'Germany');
        add_city('73150', 'Alpe d''Huez', 'France');

        -- ----------------------------------------------------------------
        -- 4. VISITOR  (10 rows)
        -- ----------------------------------------------------------------
        add_visitor(
                'Lena', 'Maes',
                TO_DATE('15-03-1995', 'DD-MM-YYYY'),
                'lena.maes@gmail.com',
                'Meir', '42',
                '2000', 'Belgium', 'Female');

        add_visitor(
                'Jonas', 'De Wolf',
                TO_DATE('22-07-1990', 'DD-MM-YYYY'),
                'jonas.dewolf@hotmail.com',
                'Nationalestraat', '17',
                '2000', 'Belgium', 'Male');

        add_visitor(
                'Sophie', 'Janssen',
                TO_DATE('08-11-1998', 'DD-MM-YYYY'),
                'sophie.janssen@outlook.com',
                'Groenplaats', '5',
                '2000', 'Belgium', 'Female');

        add_visitor(
                'Pieter', 'Claes',
                TO_DATE('30-04-1985', 'DD-MM-YYYY'),
                'pieter.claes@yahoo.com',
                'Kammenstraat', '88',
                '2000', 'Belgium', 'Male');

        add_visitor(
                'Nathalie', 'Hermans',
                TO_DATE('12-02-2000', 'DD-MM-YYYY'),
                'nathalie.hermans@gmail.com',
                'Lange Nieuwstraat', '33',
                '2000', 'Belgium', 'Female');

        add_visitor(
                'Adrien', 'Dupont',
                TO_DATE('19-09-1993', 'DD-MM-YYYY'),
                'adrien.dupont@gmail.com',
                'Rue Royale', '12',
                '1000', 'Belgium', 'Male');

        add_visitor(
                'Zara', 'Ahmed',
                TO_DATE('03-01-1997', 'DD-MM-YYYY'),
                'zara.ahmed@gmail.com',
                'Leopoldstraat', '7',
                '2000', 'Belgium', 'Female');

        add_visitor(
                'Markus', 'Bauer',
                TO_DATE('27-08-1988', 'DD-MM-YYYY'),
                'markus.bauer@web.de',
                'Hauptstrasse', '55',
                '10115', 'Germany', 'Male');

        add_visitor(
                'Elena', 'Kovacs',
                TO_DATE('14-12-2001', 'DD-MM-YYYY'),
                'elena.kovacs@gmail.com',
                'Váci utca', '23',
                '1117BP', 'Hungary', 'Female');

        add_visitor(
                'Chloe', 'Martin',
                TO_DATE('05-06-1996', 'DD-MM-YYYY'),
                'chloe.martin@gmail.com',
                'Brederodestraat', '9',
                '2000', 'Belgium', 'Female');

        -- ----------------------------------------------------------------
        -- 5. TICKETPLATFORM  (10 rows)
        -- ----------------------------------------------------------------
        add_ticketplatform('Ticketmaster Belgium', 'https://www.ticketmaster.be');
        add_ticketplatform('See Tickets', 'https://www.seetickets.com');
        add_ticketplatform('Paylogic', 'https://www.paylogic.com');
        add_ticketplatform('Eventbrite', 'https://www.eventbrite.be');
        add_ticketplatform('Tele Ticket Service', 'https://www.teleticketservice.com');
        add_ticketplatform('Dice FM', 'https://dice.fm');
        add_ticketplatform('Fever Up', 'https://feverup.com');
        add_ticketplatform('TicketSwap', 'https://www.ticketswap.com');
        add_ticketplatform('Resident Advisor', 'https://ra.co');
        add_ticketplatform('StubHub International', 'https://www.stubhub.com');

        COMMIT;
    END fill_s1_base;

-- =============================================================
-- fill_s1_children: PERMIT, TICKET
--   Must run AFTER PKG_S2_festivals.bewijs_M4_S2 (FESTIVAL must exist).
-- =============================================================

    PROCEDURE fill_s1_children IS
    BEGIN
        -- ----------------------------------------------------------------
        -- PERMIT  (20 rows) – Festival rows must already exist (S2 fill).
        -- ----------------------------------------------------------------

        -- Tomorrowland Summer 2024
        add_permit(
                'Noise', 'Noise exemption permit for outdoor amplified music',
                TO_DATE('15-02-2024', 'DD-MM-YYYY'), TO_DATE('22-07-2024', 'DD-MM-YYYY'),
                TO_DATE('01-01-2024', 'DD-MM-YYYY'), 'Tomorrowland Summer 2024');

        add_permit(
                'Alcohol', 'Beer and spirits vendor license Tomorrowland',
                TO_DATE('20-03-2024', 'DD-MM-YYYY'), TO_DATE('22-07-2024', 'DD-MM-YYYY'),
                TO_DATE('05-02-2024', 'DD-MM-YYYY'), 'Tomorrowland Summer 2024');

        add_permit(
                'Traffic', 'Road closure permit A12 motorway approach',
                TO_DATE('01-05-2024', 'DD-MM-YYYY'), TO_DATE('22-07-2024', 'DD-MM-YYYY'),
                TO_DATE('10-03-2024', 'DD-MM-YYYY'), 'Tomorrowland Summer 2024');

        -- Rock Werchter 2024
        add_permit(
                'Environmental', 'Environmental impact clearance for large outdoor event',
                TO_DATE('20-02-2024', 'DD-MM-YYYY'), TO_DATE('08-07-2024', 'DD-MM-YYYY'),
                TO_DATE('10-01-2024', 'DD-MM-YYYY'), 'Rock Werchter 2024');

        add_permit(
                'Public Safety', 'Emergency services coordination permit Rock Werchter',
                TO_DATE('15-03-2024', 'DD-MM-YYYY'), TO_DATE('08-07-2024', 'DD-MM-YYYY'),
                TO_DATE('01-02-2024', 'DD-MM-YYYY'), 'Rock Werchter 2024');

        add_permit(
                'Noise', 'Extended late-night noise exemption Rock Werchter',
                TO_DATE('01-04-2024', 'DD-MM-YYYY'), TO_DATE('08-07-2024', 'DD-MM-YYYY'),
                TO_DATE('15-02-2024', 'DD-MM-YYYY'), 'Rock Werchter 2024');

        -- Pukkelpop 2024
        add_permit(
                'Public Safety', 'Crowd management and emergency exit permit',
                TO_DATE('01-03-2024', 'DD-MM-YYYY'), TO_DATE('19-08-2024', 'DD-MM-YYYY'),
                TO_DATE('05-02-2024', 'DD-MM-YYYY'), 'Pukkelpop 2024');

        add_permit(
                'Alcohol', 'Alcohol sales license Pukkelpop',
                TO_DATE('20-04-2024', 'DD-MM-YYYY'), TO_DATE('19-08-2024', 'DD-MM-YYYY'),
                TO_DATE('10-03-2024', 'DD-MM-YYYY'), 'Pukkelpop 2024');

        -- Sziget Festival 2024
        add_permit(
                'Alcohol', 'License for on-site alcohol sales and distribution',
                TO_DATE('15-04-2024', 'DD-MM-YYYY'), TO_DATE('15-08-2024', 'DD-MM-YYYY'),
                TO_DATE('01-03-2024', 'DD-MM-YYYY'), 'Sziget Festival 2024');

        add_permit(
                'Health', 'First aid and medical tent permit Sziget',
                TO_DATE('01-05-2024', 'DD-MM-YYYY'), TO_DATE('13-08-2024', 'DD-MM-YYYY'),
                TO_DATE('01-04-2024', 'DD-MM-YYYY'), 'Sziget Festival 2024');

        -- Roskilde Festival 2024
        add_permit(
                'Fire Safety', 'Pyrotechnics and open flame usage permit',
                TO_DATE('05-03-2024', 'DD-MM-YYYY'), TO_DATE('10-07-2024', 'DD-MM-YYYY'),
                TO_DATE('10-02-2024', 'DD-MM-YYYY'), 'Roskilde Festival 2024');

        add_permit(
                'Construction', 'Temporary structure permit Roskilde camping',
                TO_DATE('01-02-2024', 'DD-MM-YYYY'), TO_DATE('07-07-2024', 'DD-MM-YYYY'),
                TO_DATE('01-01-2024', 'DD-MM-YYYY'), 'Roskilde Festival 2024');

        -- Glastonbury 2025
        add_permit(
                'Construction', 'Temporary stage and infrastructure construction permit',
                TO_DATE('15-12-2024', 'DD-MM-YYYY'), TO_DATE('03-07-2025', 'DD-MM-YYYY'),
                TO_DATE('01-11-2024', 'DD-MM-YYYY'), 'Glastonbury 2025');

        add_permit(
                'Noise', 'Glastonbury 2025 late-night noise exemption',
                TO_DATE('01-02-2025', 'DD-MM-YYYY'), TO_DATE('30-06-2025', 'DD-MM-YYYY'),
                TO_DATE('15-12-2024', 'DD-MM-YYYY'), 'Glastonbury 2025');

        -- Primavera Sound 2025
        add_permit(
                'Health', 'Medical services and first aid station permit',
                TO_DATE('20-01-2025', 'DD-MM-YYYY'), TO_DATE('05-06-2025', 'DD-MM-YYYY'),
                TO_DATE('01-12-2024', 'DD-MM-YYYY'), 'Primavera Sound 2025');

        add_permit(
                'Noise', 'Late-night amplified music permit Primavera',
                TO_DATE('01-02-2025', 'DD-MM-YYYY'), TO_DATE('02-06-2025', 'DD-MM-YYYY'),
                TO_DATE('15-12-2024', 'DD-MM-YYYY'), 'Primavera Sound 2025');

        -- Melt! Festival 2025
        add_permit(
                'Traffic', 'Road closure and traffic management permit',
                TO_DATE('01-03-2025', 'DD-MM-YYYY'), TO_DATE('25-07-2025', 'DD-MM-YYYY'),
                TO_DATE('15-01-2025', 'DD-MM-YYYY'), 'Melt! Festival 2025');

        add_permit(
                'Traffic', 'Melt Festival site access road permit',
                TO_DATE('15-04-2025', 'DD-MM-YYYY'), TO_DATE('21-07-2025', 'DD-MM-YYYY'),
                TO_DATE('01-03-2025', 'DD-MM-YYYY'), 'Melt! Festival 2025');

        -- Tomorrowland Winter 2025
        add_permit(
                'Noise', 'Night noise exemption permit for alpine event',
                TO_DATE('01-11-2024', 'DD-MM-YYYY'), TO_DATE('16-03-2025', 'DD-MM-YYYY'),
                TO_DATE('01-10-2024', 'DD-MM-YYYY'), 'Tomorrowland Winter 2025');

        add_permit(
                'Public Safety', 'Mountain rescue coordination permit',
                TO_DATE('15-11-2024', 'DD-MM-YYYY'), TO_DATE('16-03-2025', 'DD-MM-YYYY'),
                TO_DATE('15-10-2024', 'DD-MM-YYYY'), 'Tomorrowland Winter 2025');

        -- Lollapalooza Berlin 2025
        add_permit(
                'Security', 'Private security and perimeter control permit',
                TO_DATE('15-04-2025', 'DD-MM-YYYY'), TO_DATE('10-09-2025', 'DD-MM-YYYY'),
                TO_DATE('01-03-2025', 'DD-MM-YYYY'), 'Lollapalooza Berlin 2025');

        add_permit(
                'Fire Safety', 'Lollapalooza Berlin pyrotechnics permit',
                TO_DATE('01-06-2025', 'DD-MM-YYYY'), TO_DATE('09-09-2025', 'DD-MM-YYYY'),
                TO_DATE('01-04-2025', 'DD-MM-YYYY'), 'Lollapalooza Berlin 2025');

        -- ----------------------------------------------------------------
        -- 7. TICKET  (22 rows)
        --    Parameter order (from package body add_ticket):
        --      price, currency, ticket_date, purchase_date, description,
        --      barcode, type, status, qr_code,
        --      ticketplatform_name, visitor_firstname, visitor_lastname,
        --      festival_name
        -- ----------------------------------------------------------------

        -- Lena: Tomorrowland Summer 2024
        add_ticket(
                320.00, 'EUR',
                TO_DATE('19-07-2024', 'DD-MM-YYYY'), TO_DATE('10-01-2024', 'DD-MM-YYYY'),
                'Full weekend pass Tomorrowland', 'TML20240001AA', 'Weekend', 'Used',
                'https://qr.tomorrowland.com/TML20240001AA',
                'Ticketmaster Belgium', 'Lena', 'Maes', 'Tomorrowland Summer 2024');

        -- Lena: Pukkelpop 2024
        add_ticket(
                195.00, 'EUR',
                TO_DATE('15-08-2024', 'DD-MM-YYYY'), TO_DATE('03-05-2024', 'DD-MM-YYYY'),
                'Pukkelpop combi ticket – Lena', 'PKP20240001AA', 'Combi', 'Used',
                'https://qr.pukkelpop.be/PKP20240001AA',
                'Paylogic', 'Lena', 'Maes', 'Pukkelpop 2024');

        -- Lena: Lollapalooza Berlin 2025
        add_ticket(
                99.00, 'EUR',
                TO_DATE('07-09-2025', 'DD-MM-YYYY'), TO_DATE('25-05-2025', 'DD-MM-YYYY'),
                'Lollapalooza Berlin 2-day pass – Lena', 'LLP20250001AA', 'Weekend', 'Valid',
                'https://qr.lollaberlin.de/LLP20250001AA',
                'Ticketmaster Belgium', 'Lena', 'Maes', 'Lollapalooza Berlin 2025');

        -- Jonas: Rock Werchter 2024
        add_ticket(
                89.50, 'EUR',
                TO_DATE('04-07-2024', 'DD-MM-YYYY'), TO_DATE('15-03-2024', 'DD-MM-YYYY'),
                'Single day Friday Rock Werchter', 'RWF20240001BB', 'Day', 'Used',
                'https://qr.rockwerchter.be/RWF20240001BB',
                'See Tickets', 'Jonas', 'De Wolf', 'Rock Werchter 2024');

        -- Jonas: Tomorrowland Summer 2024
        add_ticket(
                320.00, 'EUR',
                TO_DATE('19-07-2024', 'DD-MM-YYYY'), TO_DATE('20-02-2024', 'DD-MM-YYYY'),
                'Tomorrowland weekend ticket – Jonas', 'TML20240001BB', 'Weekend', 'Used',
                'https://qr.tomorrowland.com/TML20240001BB',
                'Paylogic', 'Jonas', 'De Wolf', 'Tomorrowland Summer 2024');

        -- Sophie: Pukkelpop 2024
        add_ticket(
                195.00, 'EUR',
                TO_DATE('15-08-2024', 'DD-MM-YYYY'), TO_DATE('01-04-2024', 'DD-MM-YYYY'),
                '4-day combi ticket Pukkelpop', 'PKP20240001CC', 'Combi', 'Used',
                'https://qr.pukkelpop.be/PKP20240001CC',
                'Paylogic', 'Sophie', 'Janssen', 'Pukkelpop 2024');

        -- Sophie: Glastonbury 2025
        add_ticket(
                375.00, 'GBP',
                TO_DATE('25-06-2025', 'DD-MM-YYYY'), TO_DATE('01-11-2024', 'DD-MM-YYYY'),
                'Glastonbury full festival ticket – Sophie', 'GLA20250001CC', 'Full Festival', 'Valid',
                'https://qr.glastonbury.co.uk/GLA20250001CC',
                'Dice FM', 'Sophie', 'Janssen', 'Glastonbury 2025');

        -- Pieter: Sziget Festival 2024
        add_ticket(
                290.00, 'EUR',
                TO_DATE('07-08-2024', 'DD-MM-YYYY'), TO_DATE('20-02-2024', 'DD-MM-YYYY'),
                '7-day full island ticket Sziget', 'SZI20240001DD', 'Full Festival', 'Used',
                'https://qr.szigetfestival.com/SZI20240001DD',
                'Eventbrite', 'Pieter', 'Claes', 'Sziget Festival 2024');

        -- Pieter: Roskilde Festival 2024
        add_ticket(
                145.00, 'EUR',
                TO_DATE('29-06-2024', 'DD-MM-YYYY'), TO_DATE('10-02-2024', 'DD-MM-YYYY'),
                'Roskilde weekend ticket – Pieter', 'RSK20240001DD', 'Weekend', 'Used',
                'https://qr.roskilde.dk/RSK20240001DD',
                'Tele Ticket Service', 'Pieter', 'Claes', 'Roskilde Festival 2024');

        -- Nathalie: Roskilde Festival 2024
        add_ticket(
                145.00, 'EUR',
                TO_DATE('29-06-2024', 'DD-MM-YYYY'), TO_DATE('05-01-2024', 'DD-MM-YYYY'),
                'Weekend ticket Roskilde', 'RSK20240001EE', 'Weekend', 'Used',
                'https://qr.roskilde.dk/RSK20240001EE',
                'Tele Ticket Service', 'Nathalie', 'Hermans', 'Roskilde Festival 2024');

        -- Nathalie: Primavera Sound 2025
        add_ticket(
                185.00, 'EUR',
                TO_DATE('29-05-2025', 'DD-MM-YYYY'), TO_DATE('05-01-2025', 'DD-MM-YYYY'),
                'Primavera Sound 3-day pass – Nathalie', 'PRM20250001EE', 'Combi', 'Valid',
                'https://qr.primaverasound.com/PRM20250001EE',
                'Fever Up', 'Nathalie', 'Hermans', 'Primavera Sound 2025');

        -- Adrien: Glastonbury 2025
        add_ticket(
                375.00, 'GBP',
                TO_DATE('25-06-2025', 'DD-MM-YYYY'), TO_DATE('15-10-2024', 'DD-MM-YYYY'),
                'Full Glastonbury ticket – Adrien', 'GLA20250001FF', 'Full Festival', 'Valid',
                'https://qr.glastonbury.co.uk/GLA20250001FF',
                'Dice FM', 'Adrien', 'Dupont', 'Glastonbury 2025');

        -- Adrien: Sziget Festival 2024
        add_ticket(
                290.00, 'EUR',
                TO_DATE('07-08-2024', 'DD-MM-YYYY'), TO_DATE('01-03-2024', 'DD-MM-YYYY'),
                'Sziget full festival ticket – Adrien', 'SZI20240001FF', 'Full Festival', 'Used',
                'https://qr.szigetfestival.com/SZI20240001FF',
                'Eventbrite', 'Adrien', 'Dupont', 'Sziget Festival 2024');

        -- Zara: Primavera Sound 2025
        add_ticket(
                185.00, 'EUR',
                TO_DATE('29-05-2025', 'DD-MM-YYYY'), TO_DATE('01-12-2024', 'DD-MM-YYYY'),
                '3-day Primavera Sound pass – Zara', 'PRM20250001GG', 'Combi', 'Valid',
                'https://qr.primaverasound.com/PRM20250001GG',
                'Fever Up', 'Zara', 'Ahmed', 'Primavera Sound 2025');

        -- Zara: Lollapalooza Berlin 2025
        add_ticket(
                99.00, 'EUR',
                TO_DATE('07-09-2025', 'DD-MM-YYYY'), TO_DATE('10-05-2025', 'DD-MM-YYYY'),
                'Lollapalooza Berlin weekend – Zara', 'LLP20250001GG', 'Weekend', 'Valid',
                'https://qr.lollaberlin.de/LLP20250001GG',
                'StubHub International', 'Zara', 'Ahmed', 'Lollapalooza Berlin 2025');

        -- Markus: Melt! Festival 2025
        add_ticket(
                98.00, 'EUR',
                TO_DATE('18-07-2025', 'DD-MM-YYYY'), TO_DATE('10-02-2025', 'DD-MM-YYYY'),
                'Weekend ticket Melt Festival – Markus', 'MLT20250001HH', 'Weekend', 'Valid',
                'https://qr.meltfestival.de/MLT20250001HH',
                'TicketSwap', 'Markus', 'Bauer', 'Melt! Festival 2025');

        -- Markus: Tomorrowland Winter 2025
        add_ticket(
                220.00, 'EUR',
                TO_DATE('08-03-2025', 'DD-MM-YYYY'), TO_DATE('15-10-2024', 'DD-MM-YYYY'),
                'Tomorrowland Winter full package – Markus', 'TMW20250001HH', 'Full Festival', 'Used',
                'https://qr.tomorrowland.com/TMW20250001HH',
                'Resident Advisor', 'Markus', 'Bauer', 'Tomorrowland Winter 2025');

        -- Elena: Tomorrowland Winter 2025
        add_ticket(
                220.00, 'EUR',
                TO_DATE('08-03-2025', 'DD-MM-YYYY'), TO_DATE('01-09-2024', 'DD-MM-YYYY'),
                'Full week Tomorrowland Winter – Elena', 'TMW20250001II', 'Full Festival', 'Used',
                'https://qr.tomorrowland.com/TMW20250001II',
                'Resident Advisor', 'Elena', 'Kovacs', 'Tomorrowland Winter 2025');

        -- Elena: Melt! Festival 2025
        add_ticket(
                98.00, 'EUR',
                TO_DATE('18-07-2025', 'DD-MM-YYYY'), TO_DATE('01-03-2025', 'DD-MM-YYYY'),
                'Melt Festival weekend ticket – Elena', 'MLT20250001II', 'Weekend', 'Valid',
                'https://qr.meltfestival.de/MLT20250001II',
                'TicketSwap', 'Elena', 'Kovacs', 'Melt! Festival 2025');

        -- Chloe: Lollapalooza Berlin 2025
        add_ticket(
                99.00, 'EUR',
                TO_DATE('07-09-2025', 'DD-MM-YYYY'), TO_DATE('20-04-2025', 'DD-MM-YYYY'),
                '2-day Lollapalooza Berlin pass – Chloe', 'LLP20250001JJ', 'Weekend', 'Valid',
                'https://qr.lollaberlin.de/LLP20250001JJ',
                'StubHub International', 'Chloe', 'Martin', 'Lollapalooza Berlin 2025');

        -- Chloe: Rock Werchter 2024
        add_ticket(
                89.50, 'EUR',
                TO_DATE('05-07-2024', 'DD-MM-YYYY'), TO_DATE('20-04-2024', 'DD-MM-YYYY'),
                'Rock Werchter Saturday day ticket – Chloe', 'RWF20240001JJ', 'Day', 'Used',
                'https://qr.rockwerchter.be/RWF20240001JJ',
                'See Tickets', 'Chloe', 'Martin', 'Rock Werchter 2024');

        COMMIT;

    END fill_s1_children;

-- bewijs_M4_S1
    PROCEDURE bewijs_M4_S1 IS
    BEGIN
        fill_s1_base;
        fill_s1_children;
    END bewijs_M4_S1;

-- =============================================================
-- M5 – RANDOM GENERATORS  (Stap 2)
-- =============================================================

    -- generateRandomCities
    PROCEDURE generateRandomCities(p_amount IN NUMBER) IS
        v_start    TIMESTAMP := SYSTIMESTAMP;
        v_gen_done TIMESTAMP;
        v_end      TIMESTAMP;
        v_offset   NUMBER;
        v_zips     t_str10;
        v_names    t_str50;
        v_cntrs    t_str50;
        v_rows     PLS_INTEGER;
    BEGIN
        SELECT COUNT(*) INTO v_offset FROM CITY;
        FOR i IN 1..p_amount
            LOOP
                v_cntrs(i) := PKG_SAMEN_festivals.give_random_country;
                v_names(i) := PKG_SAMEN_festivals.give_random_location;
                v_zips(i)  := format_zipcode(v_cntrs(i), v_offset + i);
            END LOOP;
        v_gen_done := SYSTIMESTAMP;
        BEGIN
            FORALL i IN 1..p_amount SAVE EXCEPTIONS
                INSERT INTO CITY (ZIPCODE, CITY, COUNTRY)
                VALUES (v_zips(i), v_names(i), v_cntrs(i));
        EXCEPTION
            WHEN PKG_SAMEN_festivals.bulk_errors THEN
                PKG_SAMEN_festivals.log_bulk_errors('generateRandomCities');
        END;
        v_rows := SQL%ROWCOUNT;
        v_end := SYSTIMESTAMP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomCities', 'p_amount=' || p_amount,
                                v_rows,
                                PKG_SAMEN_festivals.timestamp_diff(v_gen_done, v_start),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_gen_done),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start));
    END generateRandomCities;

    -- generateRandomCompanies
    PROCEDURE generateRandomCompanies(p_amount IN NUMBER) IS
        v_start    TIMESTAMP := SYSTIMESTAMP;
        v_gen_done TIMESTAMP;
        v_end      TIMESTAMP;
        v_offset   NUMBER;
        v_names    t_str50;
        v_years    t_id_tab;
        v_rows     PLS_INTEGER;
    BEGIN
        SELECT COUNT(*) INTO v_offset FROM COMPANY;
        FOR i IN 1..p_amount
            LOOP
                v_names(i) := random_company_name_seq(v_offset + i);
                v_years(i) := PKG_SAMEN_festivals.give_random_number(1800, 2025);
            END LOOP;
        v_gen_done := SYSTIMESTAMP;
        BEGIN
            FORALL i IN 1..p_amount SAVE EXCEPTIONS
                INSERT INTO COMPANY (COMPANY_NAME, COMPANY_FOUNDING_YEAR)
                VALUES (v_names(i), v_years(i));
        EXCEPTION
            WHEN PKG_SAMEN_festivals.bulk_errors THEN
                PKG_SAMEN_festivals.log_bulk_errors('generateRandomCompanies');
        END;
        v_rows := SQL%ROWCOUNT;
        v_end := SYSTIMESTAMP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomCompanies', 'p_amount=' || p_amount,
                                v_rows,
                                PKG_SAMEN_festivals.timestamp_diff(v_gen_done, v_start),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_gen_done),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start));
    END generateRandomCompanies;

    -- generateRandomTicketplatforms
    PROCEDURE generateRandomTicketplatforms(p_amount IN NUMBER) IS
        v_start    TIMESTAMP := SYSTIMESTAMP;
        v_gen_done TIMESTAMP;
        v_end      TIMESTAMP;
        v_offset   NUMBER;
        v_names    t_str100;
        v_urls     t_str500;
        v_rows     PLS_INTEGER;
    BEGIN
        SELECT COUNT(*) INTO v_offset FROM TICKETPLATFORM;
        FOR i IN 1..p_amount
            LOOP
                platform_name_and_url(v_offset + i, v_names(i), v_urls(i));
            END LOOP;
        v_gen_done := SYSTIMESTAMP;
        BEGIN
            FORALL i IN 1..p_amount SAVE EXCEPTIONS
                INSERT INTO TICKETPLATFORM (TICKETPLATFORM_NAME, TICKETPLATFORM_URL)
                VALUES (v_names(i), v_urls(i));
        EXCEPTION
            WHEN PKG_SAMEN_festivals.bulk_errors THEN
                PKG_SAMEN_festivals.log_bulk_errors('generateRandomTicketplatforms');
        END;
        v_rows := SQL%ROWCOUNT;
        v_end := SYSTIMESTAMP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomTicketplatforms', 'p_amount=' || p_amount,
                                v_rows,
                                PKG_SAMEN_festivals.timestamp_diff(v_gen_done, v_start),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_gen_done),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start));
    END generateRandomTicketplatforms;

    -- generateRandomVisitors
    PROCEDURE generateRandomVisitors(p_amount IN NUMBER) IS
        v_start    TIMESTAMP := SYSTIMESTAMP;
        v_gen_done TIMESTAMP;
        v_end      TIMESTAMP;
        v_city_ids t_id_tab;
        v_offset   NUMBER;
        v_fnames   t_str50;
        v_lnames   t_str50;
        v_births   t_date_tab;
        v_emails   t_str100;
        v_streets  t_str50;
        v_snums    t_str10;
        v_cids     t_id_tab;
        v_genders  t_str50;
        v_fname    VARCHAR2(50);
        v_lname    VARCHAR2(50);
        v_city_idx PLS_INTEGER;
        v_rows     PLS_INTEGER;
    BEGIN
        SELECT CITY_ID BULK COLLECT INTO v_city_ids FROM CITY;
        IF v_city_ids.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomVisitors: no cities – run generateRandomCities first');
            RETURN;
        END IF;

        SELECT COUNT(*) INTO v_offset FROM VISITOR;

        FOR i IN 1..p_amount
            LOOP
                v_city_idx := PKG_SAMEN_festivals.give_random_number(1, v_city_ids.COUNT);
                v_fname := PKG_SAMEN_festivals.give_random_first_name;
                v_lname := PKG_SAMEN_festivals.give_random_last_name;
                v_fnames(i) := v_fname;
                v_lnames(i) := v_lname;
                v_births(i) := PKG_SAMEN_festivals.give_random_date(DATE '1960-01-01', DATE '2005-12-31');
                v_emails(i) := LOWER(v_fname) || '.' || LOWER(v_lname)
                            || (v_offset + i) || '@' || random_email_domain;
                v_streets(i) := PKG_SAMEN_festivals.give_random_street;
                v_snums(i) := TO_CHAR(PKG_SAMEN_festivals.give_random_number(1, 999));
                v_cids(i) := v_city_ids(v_city_idx);
                v_genders(i) := PKG_SAMEN_festivals.give_random_gender;
            END LOOP;
        v_gen_done := SYSTIMESTAMP;

        BEGIN
            FORALL i IN 1..p_amount SAVE EXCEPTIONS
                INSERT INTO VISITOR (VISITOR_FIRSTNAME, VISITOR_LASTNAME, VISITOR_BIRTHDATE,
                                     VISITOR_EMAIL, VISITOR_STREET_NAME, VISITOR_STREET_NUMBER,
                                     CITY_ID, VISITOR_GENDER)
                VALUES (v_fnames(i), v_lnames(i), v_births(i), v_emails(i),
                        v_streets(i), v_snums(i), v_cids(i), v_genders(i));
        EXCEPTION
            WHEN PKG_SAMEN_festivals.bulk_errors THEN
                PKG_SAMEN_festivals.log_bulk_errors('generateRandomVisitors');
        END;
        v_rows := SQL%ROWCOUNT;
        v_end := SYSTIMESTAMP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomVisitors', 'p_amount=' || p_amount,
                                v_rows,
                                PKG_SAMEN_festivals.timestamp_diff(v_gen_done, v_start),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_gen_done),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start));
    END generateRandomVisitors;

    -- generateRandomTickets
    PROCEDURE generateRandomTickets(p_amount IN NUMBER) IS
        -- parent pools
        v_fest_ids     t_id_tab;
        v_fest_names   t_str100;
        v_fest_starts  t_date_tab;
        v_fest_ends    t_date_tab;
        v_vis_ids      t_id_tab;
        v_plat_ids     t_id_tab;
        v_plat_urls    t_str500;
        -- distribution
        v_fest_budgets t_id_tab;
        v_vis_shuffle  t_id_tab;
        -- INSERT arrays
        v_prices       t_num10_2;
        v_currencies   t_char3;
        v_tkt_dates    t_date_tab;
        v_purch_dates  t_date_tab;
        v_descs        t_str100;
        v_barcodes     t_str14;
        v_types        t_str50;
        v_statuses     t_str50;
        v_qr_codes     t_str500;
        v_ins_plats    t_id_tab;
        v_ins_vis      t_id_tab;
        v_ins_fests    t_id_tab;
        v_start        TIMESTAMP   := SYSTIMESTAMP;
        v_gen_done     TIMESTAMP;
        v_end          TIMESTAMP;
        v_offset       NUMBER;
        v_vis_count    PLS_INTEGER;
        v_fest_count   PLS_INTEGER;
        v_remaining    PLS_INTEGER;
        v_budget            PLS_INTEGER;
        v_prepared          PLS_INTEGER := 0;
        v_vis_idx      PLS_INTEGER;
        v_plat_idx           PLS_INTEGER;
        v_j            PLS_INTEGER;
        v_swap_i        PLS_INTEGER;
        v_swap_j        PLS_INTEGER;
        v_tkt_date     DATE;
        v_max_purch    DATE;
        v_barcode      VARCHAR2(14);
        v_rows         PLS_INTEGER;
        v_tmp_id        NUMBER;
        v_tmp_date        DATE;
        v_tmp_name        VARCHAR2(100);
    BEGIN
        SELECT FESTIVAL_ID,
               FESTIVAL_NAME,
               FESTIVAL_STARTDATE,
               FESTIVAL_ENDDATE
            BULK COLLECT
        INTO v_fest_ids, v_fest_names, v_fest_starts, v_fest_ends
        FROM FESTIVAL;

        SELECT VISITOR_ID BULK COLLECT INTO v_vis_ids FROM VISITOR;
        SELECT TICKETPLATFORM_ID, TICKETPLATFORM_URL
            BULK COLLECT INTO v_plat_ids, v_plat_urls FROM TICKETPLATFORM;

        IF v_fest_ids.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomTickets: no festivals – run S2 generators first');
            RETURN;
        END IF;
        IF v_vis_ids.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomTickets: no visitors – run generateRandomVisitors first');
            RETURN;
        END IF;
        IF v_plat_ids.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomTickets: no ticketplatforms – run generateRandomTicketplatforms first');
            RETURN;
        END IF;

        SELECT COUNT(*) INTO v_offset FROM TICKET;

        v_vis_count := v_vis_ids.COUNT;
        v_fest_count := v_fest_ids.COUNT;

        -- Fisher-Yates: randomise festival order before stick-breaking
        FOR k IN REVERSE 2..v_fest_count
            LOOP
                v_j := PKG_SAMEN_festivals.give_random_number(1, k);
                v_tmp_id := v_fest_ids(k); v_fest_ids(k) := v_fest_ids(v_j); v_fest_ids(v_j) := v_tmp_id;
                v_tmp_name := v_fest_names(k); v_fest_names(k) := v_fest_names(v_j); v_fest_names(v_j) := v_tmp_name;
                v_tmp_date := v_fest_starts(k); v_fest_starts(k) := v_fest_starts(v_j); v_fest_starts(v_j) := v_tmp_date;
                v_tmp_date := v_fest_ends(k); v_fest_ends(k) := v_fest_ends(v_j); v_fest_ends(v_j) := v_tmp_date;
            END LOOP;

        -- Stick-breaking: random budget per festival, sum = p_amount
        v_remaining := p_amount;
        FOR f IN 1..v_fest_count - 1
            LOOP
                IF v_remaining > 0 THEN
                    v_fest_budgets(f) := PKG_SAMEN_festivals.give_random_number(
                            v_remaining/((v_fest_count-f)*v_vis_count), LEAST(v_remaining, v_vis_count));
                    v_remaining := v_remaining - v_fest_budgets(f);
                ELSE
                    v_fest_budgets(f) := 0;
                END IF;
            END LOOP;
        v_fest_budgets(v_fest_count) := LEAST(v_remaining, v_vis_count);

        -- Sparse partial Fisher-Yates: pick unique visitors per festival
        FOR f IN 1..v_fest_count
            LOOP
                v_budget := LEAST(v_fest_budgets(f), v_vis_count);
                v_vis_shuffle.DELETE;

                FOR s IN 1..v_budget
                    LOOP
                        v_j := PKG_SAMEN_festivals.give_random_number(s - 1, v_vis_count - 1);
                        v_swap_i := CASE WHEN v_vis_shuffle.EXISTS(s - 1) THEN v_vis_shuffle(s - 1) ELSE s - 1 END;
                        v_swap_j := CASE WHEN v_vis_shuffle.EXISTS(v_j) THEN v_vis_shuffle(v_j) ELSE v_j END;
                        v_vis_shuffle(s - 1) := v_swap_j;
                        IF v_j != s - 1 THEN v_vis_shuffle(v_j) := v_swap_i; END IF;

                        v_vis_idx := v_swap_j + 1;
                        v_plat_idx := PKG_SAMEN_festivals.give_random_number(1, v_plat_ids.COUNT);
                        v_prepared := v_prepared + 1;

                        v_tkt_date := PKG_SAMEN_festivals.give_random_date(v_fest_starts(f), v_fest_ends(f));
                        v_max_purch := LEAST(v_tkt_date, SYSDATE);
                        v_barcode := 'R' || LPAD(TO_CHAR(v_offset + v_prepared), 12, '0');

                        v_types(v_prepared) := PKG_SAMEN_festivals.give_random_ticket_type;
                        v_prices(v_prepared) := PKG_SAMEN_festivals.give_random_number(50, 500);
                        v_currencies(v_prepared) := PKG_SAMEN_festivals.give_random_currency;
                        v_tkt_dates(v_prepared) := v_tkt_date;
                        v_purch_dates(v_prepared) := PKG_SAMEN_festivals.give_random_date(
                                GREATEST(v_max_purch - 365, DATE '2020-01-01'), v_max_purch);
                        v_descs(v_prepared) := v_types(v_prepared) || ' ticket for ' || v_fest_names(f);
                        v_barcodes(v_prepared) := v_barcode;
                        v_statuses(v_prepared) := PKG_SAMEN_festivals.give_random_ticket_status;
                        v_qr_codes(v_prepared) := 'https://qr.' || url_host(v_plat_urls(v_plat_idx)) || '/' || v_barcode;
                        v_ins_plats(v_prepared) := v_plat_ids(v_plat_idx);
                        v_ins_vis(v_prepared) := v_vis_ids(v_vis_idx);
                        v_ins_fests(v_prepared) := v_fest_ids(f);
                    END LOOP;
            END LOOP;
        v_gen_done := SYSTIMESTAMP;

        BEGIN
            FORALL i IN 1..v_prepared SAVE EXCEPTIONS
                INSERT INTO TICKET (TICKET_PRICE, TICKET_CURRENCY, TICKET_DATE,
                                    TICKET_PURCHASE_DATE, TICKET_DESCRIPTION,
                                    TICKET_BARCODE, TICKET_TYPE, TICKET_STATUS,
                                    TICKET_QR_CODE, TICKETPLATFORM_ID, VISITOR_ID, FESTIVAL_ID)
                VALUES (v_prices(i), v_currencies(i), v_tkt_dates(i), v_purch_dates(i),
                        v_descs(i), v_barcodes(i), v_types(i), v_statuses(i),
                        v_qr_codes(i), v_ins_plats(i), v_ins_vis(i), v_ins_fests(i));
        EXCEPTION
            WHEN PKG_SAMEN_festivals.bulk_errors THEN
                PKG_SAMEN_festivals.log_bulk_errors('generateRandomTickets');
        END;
        v_rows := SQL%ROWCOUNT;
        v_end := SYSTIMESTAMP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomTickets', 'p_amount=' || p_amount,
                                v_rows,
                                PKG_SAMEN_festivals.timestamp_diff(v_gen_done, v_start),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_gen_done),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start));
    END generateRandomTickets;

    -- generateRandomPermits
    PROCEDURE generateRandomPermits(p_per_festival IN NUMBER) IS
        v_fest_ids    t_id_tab;
        v_fest_names  t_str100;
        v_fest_starts t_date_tab;
        v_cats        t_str50;
        v_descs       t_str100;
        v_app_dates   t_date_tab;
        v_rec_dates   t_date_tab;
        v_exp_dates   t_date_tab;
        v_fids        t_id_tab;
        v_start       TIMESTAMP   := SYSTIMESTAMP;
        v_gen_done    TIMESTAMP;
        v_end         TIMESTAMP;
        v_total       PLS_INTEGER;
        v_prepared         PLS_INTEGER := 1;
        v_max_app     DATE;
        v_min_app     DATE;
        v_app_date    DATE;
        v_rec_date    DATE;
        v_rows        PLS_INTEGER;
    BEGIN
        SELECT FESTIVAL_ID,
               FESTIVAL_NAME,
               FESTIVAL_STARTDATE
            BULK COLLECT
        INTO v_fest_ids, v_fest_names, v_fest_starts
        FROM FESTIVAL;

        IF v_fest_ids.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomPermits: no festivals – run S2 generators first');
            RETURN;
        END IF;

        v_total := v_fest_ids.COUNT * p_per_festival;

        FOR fi IN 1..v_fest_ids.COUNT
            LOOP
                v_max_app := LEAST(v_fest_starts(fi) - 1, SYSDATE);
                v_min_app := GREATEST(v_max_app - 365, DATE '2020-01-01');
                IF v_min_app > v_max_app THEN v_min_app := v_max_app; END IF;

                FOR j IN 1..p_per_festival
                    LOOP
                        v_app_date := PKG_SAMEN_festivals.give_random_date(v_min_app, v_max_app);
                        v_rec_date := PKG_SAMEN_festivals.give_random_date(v_app_date + 1, v_app_date + 60);
                        v_cats(v_prepared) := PKG_SAMEN_festivals.give_random_permit_category;
                        v_descs(v_prepared) := v_cats(v_prepared) || ' permit for '
                            || v_fest_names(fi);
                        v_app_dates(v_prepared) := v_app_date;
                        v_rec_dates(v_prepared) := v_rec_date;
                        v_exp_dates(v_prepared) := PKG_SAMEN_festivals.give_random_date(v_rec_date + 1, v_rec_date + 180);
                        v_fids(v_prepared) := v_fest_ids(fi);
                        v_prepared := v_prepared + 1;
                    END LOOP;
            END LOOP;
        v_gen_done := SYSTIMESTAMP;

        BEGIN
            FORALL i IN 1..v_total SAVE EXCEPTIONS
                INSERT INTO PERMIT (PERMIT_CATEGORY, PERMIT_DESCRIPTION,
                                    PERMIT_RECEPTION_DATE, PERMIT_EXPIRATION_DATE,
                                    PERMIT_APPLICATION_DATE, FESTIVAL_ID)
                VALUES (v_cats(i), v_descs(i), v_rec_dates(i), v_exp_dates(i),
                        v_app_dates(i), v_fids(i));
        EXCEPTION
            WHEN PKG_SAMEN_festivals.bulk_errors THEN
                PKG_SAMEN_festivals.log_bulk_errors('generateRandomPermits');
        END;
        v_rows := SQL%ROWCOUNT;
        v_end := SYSTIMESTAMP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomPermits', 'p_per_festival=' || p_per_festival,
                                v_rows,
                                PKG_SAMEN_festivals.timestamp_diff(v_gen_done, v_start),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_gen_done),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start));
    END generateRandomPermits;

    -- ---------------------------------------------------------
    -- bewijs_milestone_5_S1_base  (Phase 1 – no S2 dependency)
    -- ---------------------------------------------------------
    PROCEDURE bewijs_milestone_5_S1_base(p_cities IN NUMBER,
                                         p_companies IN NUMBER,
                                         p_platforms IN NUMBER,
                                         p_visitors IN NUMBER) IS
        v_start TIMESTAMP := SYSTIMESTAMP;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== bewijs_milestone_5_S1_base START ===');
        generateRandomCities(p_cities);
        generateRandomCompanies(p_companies);
        generateRandomTicketplatforms(p_platforms);
        generateRandomVisitors(p_visitors);
        DBMS_OUTPUT.PUT_LINE('=== bewijs_milestone_5_S1_base DONE | total duration: '
            || ROUND(PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_start) * 1000) || ' ms ===');
    END bewijs_milestone_5_S1_base;

    -- ---------------------------------------------------------
    -- bewijs_milestone_5_S1_children  (Phase 2 – requires S2 festivals)
    -- ---------------------------------------------------------
    PROCEDURE bewijs_milestone_5_S1_children(p_tickets IN NUMBER,
                                             p_permits_per_fest IN NUMBER) IS
        v_start TIMESTAMP := SYSTIMESTAMP;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== bewijs_milestone_5_S1_children START ===');
        generateRandomTickets(p_tickets);
        generateRandomPermits(p_permits_per_fest);
        DBMS_OUTPUT.PUT_LINE('=== bewijs_milestone_5_S1_children DONE | total duration: '
            || ROUND(PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_start) * 1000) || ' ms ===');
    END bewijs_milestone_5_S1_children;

    -- bewijs_milestone_5_S1  (convenience wrapper – requires S2 festivals)
    PROCEDURE bewijs_milestone_5_S1(p_cities IN NUMBER,
                                    p_companies IN NUMBER,
                                    p_platforms IN NUMBER,
                                    p_visitors IN NUMBER,
                                    p_tickets IN NUMBER,
                                    p_permits_per_fest IN NUMBER) IS
        v_start TIMESTAMP := SYSTIMESTAMP;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== bewijs_milestone_5_S1 START ===');
        bewijs_milestone_5_S1_base(p_cities, p_companies, p_platforms, p_visitors);
        bewijs_milestone_5_S1_children(p_tickets, p_permits_per_fest);
        DBMS_OUTPUT.PUT_LINE('=== bewijs_milestone_5_S1 DONE | total duration: '
            || ROUND(PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_start) * 1000) || ' ms ===');
    END bewijs_milestone_5_S1;

-- =============================================================
-- M6 – SINGLE-INSERT GENERATORS
-- =============================================================

    -- generateRandomCities_single
    PROCEDURE generateRandomCities_single(p_amount IN NUMBER) IS
        v_start    TIMESTAMP   := SYSTIMESTAMP;
        v_gen_done TIMESTAMP;
        v_end      TIMESTAMP;
        v_offset   NUMBER;
        v_rows     PLS_INTEGER := 0;
        v_zipcodes t_str100;
        v_names    t_str500;
        v_countries t_str100;
    BEGIN
        SELECT COUNT(*) INTO v_offset FROM CITY;
        FOR i IN 1 .. p_amount LOOP
            v_countries(i) := PKG_SAMEN_festivals.give_random_country;
            v_names(i)     := PKG_SAMEN_festivals.give_random_location;
            v_zipcodes(i)  := format_zipcode(v_countries(i), v_offset + i);
        END LOOP;
        v_gen_done := SYSTIMESTAMP;
        FOR i IN 1 .. p_amount LOOP
            BEGIN
                INSERT INTO CITY (ZIPCODE, CITY, COUNTRY)
                VALUES (v_zipcodes(i), v_names(i), v_countries(i));
                v_rows := v_rows + 1;
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN NULL;
            END;
        END LOOP;
        v_end := SYSTIMESTAMP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomCities_single', 'p_amount=' || p_amount,
                                v_rows,
                                PKG_SAMEN_festivals.timestamp_diff(v_gen_done, v_start),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_gen_done),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start));
    END generateRandomCities_single;

    -- generateRandomCompanies_single
    PROCEDURE generateRandomCompanies_single(p_amount IN NUMBER) IS
        v_start    TIMESTAMP   := SYSTIMESTAMP;
        v_gen_done TIMESTAMP;
        v_end      TIMESTAMP;
        v_offset   NUMBER;
        v_rows     PLS_INTEGER := 0;
        v_names    t_str500;
        v_years    t_id_tab;
    BEGIN
        SELECT COUNT(*) INTO v_offset FROM COMPANY;
        v_offset := v_offset + 1000;
        FOR i IN 1 .. p_amount LOOP
            v_names(i) := random_company_name_seq(v_offset + i);
            v_years(i) := PKG_SAMEN_festivals.give_random_number(1800, 2025);
        END LOOP;
        v_gen_done := SYSTIMESTAMP;
        FOR i IN 1 .. p_amount LOOP
            BEGIN
                INSERT INTO COMPANY (COMPANY_NAME, COMPANY_FOUNDING_YEAR)
                VALUES (v_names(i), v_years(i));
                v_rows := v_rows + 1;
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN NULL;
            END;
        END LOOP;
        v_end := SYSTIMESTAMP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomCompanies_single', 'p_amount=' || p_amount,
                                v_rows,
                                PKG_SAMEN_festivals.timestamp_diff(v_gen_done, v_start),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_gen_done),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start));
    END generateRandomCompanies_single;

    -- generateRandomTicketplatforms_single
    PROCEDURE generateRandomTicketplatforms_single(p_amount IN NUMBER) IS
        v_start    TIMESTAMP   := SYSTIMESTAMP;
        v_gen_done TIMESTAMP;
        v_end      TIMESTAMP;
        v_offset   NUMBER;
        v_rows     PLS_INTEGER := 0;
        v_names    t_str500;
        v_urls     t_str500;
    BEGIN
        SELECT COUNT(*) INTO v_offset FROM TICKETPLATFORM;
        v_offset := v_offset + 750;
        FOR i IN 1 .. p_amount LOOP
            platform_name_and_url(v_offset + i, v_names(i), v_urls(i));
        END LOOP;
        v_gen_done := SYSTIMESTAMP;
        FOR i IN 1 .. p_amount LOOP
            BEGIN
                INSERT INTO TICKETPLATFORM (TICKETPLATFORM_NAME, TICKETPLATFORM_URL)
                VALUES (v_names(i), v_urls(i));
                v_rows := v_rows + 1;
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN NULL;
            END;
        END LOOP;
        v_end := SYSTIMESTAMP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomTicketplatforms_single', 'p_amount=' || p_amount,
                                v_rows,
                                PKG_SAMEN_festivals.timestamp_diff(v_gen_done, v_start),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_gen_done),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start));
    END generateRandomTicketplatforms_single;

    -- generateRandomVisitors_single
    PROCEDURE generateRandomVisitors_single(p_amount IN NUMBER) IS
        v_city_pool t_id_tab;
        v_start     TIMESTAMP   := SYSTIMESTAMP;
        v_gen_done  TIMESTAMP;
        v_end       TIMESTAMP;
        v_offset    NUMBER;
        v_rows      PLS_INTEGER := 0;
        v_fnames    t_str50;
        v_lnames    t_str50;
        v_emails    t_str500;
        v_births    t_date_tab;
        v_streets   t_str100;
        v_str_nums  t_str10;
        v_city_ids  t_id_tab;
        v_genders   t_str10;
        v_fname     VARCHAR2(50);
        v_lname     VARCHAR2(50);
    BEGIN
        SELECT CITY_ID BULK COLLECT INTO v_city_pool FROM CITY;
        IF v_city_pool.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomVisitors_single: no cities – run generateRandomCities first');
            RETURN;
        END IF;
        SELECT COUNT(*) INTO v_offset FROM VISITOR;
        FOR i IN 1 .. p_amount LOOP
            v_fname       := PKG_SAMEN_festivals.give_random_first_name;
            v_lname       := PKG_SAMEN_festivals.give_random_last_name;
            v_fnames(i)   := v_fname;
            v_lnames(i)   := v_lname;
            v_emails(i)   := LOWER(v_fname) || '.' || LOWER(v_lname)
                                 || (v_offset + i) || '@' || random_email_domain;
            v_births(i)   := PKG_SAMEN_festivals.give_random_date(DATE '1960-01-01', DATE '2005-12-31');
            v_streets(i)  := PKG_SAMEN_festivals.give_random_street;
            v_str_nums(i) := TO_CHAR(PKG_SAMEN_festivals.give_random_number(1, 999));
            v_city_ids(i) := v_city_pool(PKG_SAMEN_festivals.give_random_number(1, v_city_pool.COUNT));
            v_genders(i)  := PKG_SAMEN_festivals.give_random_gender;
        END LOOP;
        v_gen_done := SYSTIMESTAMP;
        FOR i IN 1 .. p_amount LOOP
            BEGIN
                INSERT INTO VISITOR (VISITOR_FIRSTNAME, VISITOR_LASTNAME, VISITOR_BIRTHDATE,
                                     VISITOR_EMAIL, VISITOR_STREET_NAME, VISITOR_STREET_NUMBER,
                                     CITY_ID, VISITOR_GENDER)
                VALUES (v_fnames(i), v_lnames(i), v_births(i), v_emails(i),
                        v_streets(i), v_str_nums(i), v_city_ids(i), v_genders(i));
                v_rows := v_rows + 1;
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN NULL;
            END;
        END LOOP;
        v_end := SYSTIMESTAMP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomVisitors_single', 'p_amount=' || p_amount,
                                v_rows,
                                PKG_SAMEN_festivals.timestamp_diff(v_gen_done, v_start),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_gen_done),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start));
    END generateRandomVisitors_single;

    -- generateRandomTickets_single
    PROCEDURE generateRandomTickets_single(p_amount IN NUMBER) IS
        v_fest_pool   t_id_tab;
        v_fest_names  t_str100;
        v_fest_starts t_date_tab;
        v_fest_ends   t_date_tab;
        v_vis_pool    t_id_tab;
        v_plat_pool   t_id_tab;
        v_plat_urls   t_str500;
        v_start       TIMESTAMP   := SYSTIMESTAMP;
        v_gen_done    TIMESTAMP;
        v_end         TIMESTAMP;
        v_offset      NUMBER;
        v_rows        PLS_INTEGER := 0;
        v_attempt     PLS_INTEGER := 0;
        v_used_combos t_combo_set;
        v_combo       VARCHAR2(40);
        -- pre-generated arrays
        v_prices      t_num10_2;
        v_currencies  t_char3;
        v_tkt_dates   t_date_tab;
        v_purch_dates t_date_tab;
        v_descs       t_str500;
        v_barcodes    t_str14;
        v_types       t_str50;
        v_statuses    t_str50;
        v_qr_codes    t_str500;
        v_plat_ids    t_id_tab;
        v_vis_ids     t_id_tab;
        v_f_ids       t_id_tab;
        v_fest_idx    PLS_INTEGER;
        v_vis_idx     PLS_INTEGER;
        v_plat_idx    PLS_INTEGER;
        v_tkt_date    DATE;
        v_max_purch   DATE;
        v_barcode     VARCHAR2(14);
        v_type        VARCHAR2(50);
    BEGIN
        SELECT FESTIVAL_ID, FESTIVAL_NAME, FESTIVAL_STARTDATE, FESTIVAL_ENDDATE
            BULK COLLECT INTO v_fest_pool, v_fest_names, v_fest_starts, v_fest_ends
        FROM FESTIVAL;
        SELECT VISITOR_ID BULK COLLECT INTO v_vis_pool FROM VISITOR;
        SELECT TICKETPLATFORM_ID, TICKETPLATFORM_URL
            BULK COLLECT INTO v_plat_pool, v_plat_urls FROM TICKETPLATFORM;

        IF v_fest_pool.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomTickets_single: no festivals');  RETURN;
        END IF;
        IF v_vis_pool.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomTickets_single: no visitors');   RETURN;
        END IF;
        IF v_plat_pool.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomTickets_single: no platforms');  RETURN;
        END IF;

        SELECT COUNT(*) INTO v_offset FROM TICKET;

        WHILE v_rows < p_amount LOOP
            v_attempt  := v_attempt + 1;
            v_fest_idx := PKG_SAMEN_festivals.give_random_number(1, v_fest_pool.COUNT);
            v_vis_idx  := PKG_SAMEN_festivals.give_random_number(1, v_vis_pool.COUNT);
            v_plat_idx := PKG_SAMEN_festivals.give_random_number(1, v_plat_pool.COUNT);
            v_tkt_date := PKG_SAMEN_festivals.give_random_date(v_fest_starts(v_fest_idx), v_fest_ends(v_fest_idx));
            v_combo    := TO_CHAR(v_vis_pool(v_vis_idx)) || '_' || TO_CHAR(v_fest_pool(v_fest_idx))
                              || '_' || TO_CHAR(v_tkt_date, 'YYYYMMDD');
            CONTINUE WHEN v_used_combos.EXISTS(v_combo);
            v_used_combos(v_combo) := 1;
            v_max_purch     := LEAST(v_tkt_date, SYSDATE);
            v_barcode       := 'S' || LPAD(TO_CHAR(v_offset + v_attempt), 12, '0');
            v_type          := PKG_SAMEN_festivals.give_random_ticket_type;
            v_rows          := v_rows + 1;
            v_prices(v_rows)      := PKG_SAMEN_festivals.give_random_number(50, 500);
            v_currencies(v_rows)  := PKG_SAMEN_festivals.give_random_currency;
            v_tkt_dates(v_rows)   := v_tkt_date;
            v_purch_dates(v_rows) := PKG_SAMEN_festivals.give_random_date(
                                         GREATEST(v_max_purch - 365, DATE '2020-01-01'), v_max_purch);
            v_descs(v_rows)       := v_type || ' ticket for ' || v_fest_names(v_fest_idx);
            v_barcodes(v_rows)    := v_barcode;
            v_types(v_rows)       := v_type;
            v_statuses(v_rows)    := PKG_SAMEN_festivals.give_random_ticket_status;
            v_qr_codes(v_rows)    := 'https://qr.' || url_host(v_plat_urls(v_plat_idx)) || '/' || v_barcode;
            v_plat_ids(v_rows)    := v_plat_pool(v_plat_idx);
            v_vis_ids(v_rows)     := v_vis_pool(v_vis_idx);
            v_f_ids(v_rows)       := v_fest_pool(v_fest_idx);
        END LOOP;
        v_gen_done := SYSTIMESTAMP;
        FOR i IN 1 .. v_rows LOOP
            INSERT INTO TICKET (TICKET_PRICE, TICKET_CURRENCY, TICKET_DATE,
                                TICKET_PURCHASE_DATE, TICKET_DESCRIPTION,
                                TICKET_BARCODE, TICKET_TYPE, TICKET_STATUS,
                                TICKET_QR_CODE, TICKETPLATFORM_ID, VISITOR_ID, FESTIVAL_ID)
            VALUES (v_prices(i), v_currencies(i), v_tkt_dates(i), v_purch_dates(i),
                    v_descs(i), v_barcodes(i), v_types(i), v_statuses(i),
                    v_qr_codes(i), v_plat_ids(i), v_vis_ids(i), v_f_ids(i));
        END LOOP;
        v_end := SYSTIMESTAMP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomTickets_single', 'p_amount=' || p_amount,
                                v_rows,
                                PKG_SAMEN_festivals.timestamp_diff(v_gen_done, v_start),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_gen_done),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start));
    END generateRandomTickets_single;

    -- generateRandomPermits_single
    PROCEDURE generateRandomPermits_single(p_per_festival IN NUMBER) IS
        v_fest_pool   t_id_tab;
        v_fest_names  t_str100;
        v_fest_starts t_date_tab;
        v_start       TIMESTAMP   := SYSTIMESTAMP;
        v_gen_done    TIMESTAMP;
        v_end         TIMESTAMP;
        v_rows        PLS_INTEGER := 0;
        v_max_app     DATE;
        v_min_app     DATE;
        v_app_date    DATE;
        v_rec_date    DATE;
        v_cat         VARCHAR2(50);
        -- pre-generated arrays
        v_cats        t_str50;
        v_descs       t_str500;
        v_rec_dates   t_date_tab;
        v_exp_dates   t_date_tab;
        v_app_dates   t_date_tab;
        v_f_ids       t_id_tab;
    BEGIN
        SELECT FESTIVAL_ID, FESTIVAL_NAME, FESTIVAL_STARTDATE
            BULK COLLECT INTO v_fest_pool, v_fest_names, v_fest_starts
        FROM FESTIVAL;
        IF v_fest_pool.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomPermits_single: no festivals');  RETURN;
        END IF;
        -- Gen phase
        FOR fi IN 1 .. v_fest_pool.COUNT LOOP
            v_max_app := LEAST(v_fest_starts(fi) - 1, SYSDATE);
            v_min_app := GREATEST(v_max_app - 365, DATE '2020-01-01');
            IF v_min_app > v_max_app THEN v_min_app := v_max_app; END IF;
            FOR j IN 1 .. p_per_festival LOOP
                v_app_date := PKG_SAMEN_festivals.give_random_date(v_min_app, v_max_app);
                v_rec_date := PKG_SAMEN_festivals.give_random_date(v_app_date + 1, v_app_date + 60);
                v_cat      := PKG_SAMEN_festivals.give_random_permit_category;
                v_rows     := v_rows + 1;
                v_cats(v_rows)      := v_cat;
                v_descs(v_rows)     := v_cat || ' permit for ' || v_fest_names(fi);
                v_rec_dates(v_rows) := v_rec_date;
                v_exp_dates(v_rows) := PKG_SAMEN_festivals.give_random_date(v_rec_date + 1, v_rec_date + 180);
                v_app_dates(v_rows) := v_app_date;
                v_f_ids(v_rows)     := v_fest_pool(fi);
            END LOOP;
        END LOOP;
        v_gen_done := SYSTIMESTAMP;
        FOR i IN 1 .. v_rows LOOP
            BEGIN
                INSERT INTO PERMIT (PERMIT_CATEGORY, PERMIT_DESCRIPTION,
                                    PERMIT_RECEPTION_DATE, PERMIT_EXPIRATION_DATE,
                                    PERMIT_APPLICATION_DATE, FESTIVAL_ID)
                VALUES (v_cats(i), v_descs(i), v_rec_dates(i), v_exp_dates(i),
                        v_app_dates(i), v_f_ids(i));
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN NULL;
            END;
        END LOOP;
        v_end := SYSTIMESTAMP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomPermits_single', 'p_per_festival=' || p_per_festival,
                                v_rows,
                                PKG_SAMEN_festivals.timestamp_diff(v_gen_done, v_start),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_gen_done),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start));
    END generateRandomPermits_single;

-- =============================================================
-- M6 – BULK GENERATORS WITH CHUNKING
-- =============================================================

    -- generateRandomCities_bulk
    PROCEDURE generateRandomCities_bulk(p_amount IN NUMBER) IS
        v_start      TIMESTAMP   := SYSTIMESTAMP;
        v_gen_acc    NUMBER      := 0;
        v_ins_acc    NUMBER      := 0;
        v_t0         TIMESTAMP;
        v_t1         TIMESTAMP;
        v_offset     NUMBER;
        v_zips       t_str10;
        v_names      t_str50;
        v_cntrs      t_str50;
        v_chunk      PLS_INTEGER;
        v_done       PLS_INTEGER := 0;
        v_total_rows PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(*) INTO v_offset FROM CITY;
        WHILE v_done < p_amount LOOP
            v_chunk := LEAST(p_amount - v_done, PKG_SAMEN_festivals.C_BULK_CHUNK);
            v_t0 := SYSTIMESTAMP;
            FOR i IN 1 .. v_chunk LOOP
                v_cntrs(i) := PKG_SAMEN_festivals.give_random_country;
                v_names(i) := PKG_SAMEN_festivals.give_random_location;
                v_zips(i)  := format_zipcode(v_cntrs(i), v_offset + v_done + i);
            END LOOP;
            v_t1      := SYSTIMESTAMP;
            v_gen_acc := v_gen_acc + PKG_SAMEN_festivals.timestamp_diff(v_t1, v_t0);
            BEGIN
                FORALL i IN 1 .. v_chunk SAVE EXCEPTIONS
                    INSERT INTO CITY (ZIPCODE, CITY, COUNTRY)
                    VALUES (v_zips(i), v_names(i), v_cntrs(i));
            EXCEPTION
                WHEN PKG_SAMEN_festivals.bulk_errors THEN
                    PKG_SAMEN_festivals.log_bulk_errors('generateRandomCities_bulk');
            END;
            v_total_rows := v_total_rows + SQL%ROWCOUNT;
            v_ins_acc    := v_ins_acc + PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_t1);
            v_done       := v_done + v_chunk;
            v_zips.DELETE; v_names.DELETE; v_cntrs.DELETE;
        END LOOP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomCities_bulk', 'p_amount=' || p_amount,
                                v_total_rows, v_gen_acc, v_ins_acc,
                                PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_start));
    END generateRandomCities_bulk;

    -- generateRandomCompanies_bulk
    PROCEDURE generateRandomCompanies_bulk(p_amount IN NUMBER) IS
        v_start      TIMESTAMP   := SYSTIMESTAMP;
        v_gen_acc    NUMBER      := 0;
        v_ins_acc    NUMBER      := 0;
        v_t0         TIMESTAMP;
        v_t1         TIMESTAMP;
        v_offset     NUMBER;
        v_names      t_str50;
        v_years      t_id_tab;
        v_chunk      PLS_INTEGER;
        v_done       PLS_INTEGER := 0;
        v_total_rows PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(*) INTO v_offset FROM COMPANY;
        v_offset := v_offset + 1000;
        WHILE v_done < p_amount LOOP
            v_chunk := LEAST(p_amount - v_done, PKG_SAMEN_festivals.C_BULK_CHUNK);
            v_t0 := SYSTIMESTAMP;
            FOR i IN 1 .. v_chunk LOOP
                v_names(i) := random_company_name_seq(v_offset + v_done + i);
                v_years(i) := PKG_SAMEN_festivals.give_random_number(1800, 2025);
            END LOOP;
            v_t1      := SYSTIMESTAMP;
            v_gen_acc := v_gen_acc + PKG_SAMEN_festivals.timestamp_diff(v_t1, v_t0);
            BEGIN
                FORALL i IN 1 .. v_chunk SAVE EXCEPTIONS
                    INSERT INTO COMPANY (COMPANY_NAME, COMPANY_FOUNDING_YEAR)
                    VALUES (v_names(i), v_years(i));
            EXCEPTION
                WHEN PKG_SAMEN_festivals.bulk_errors THEN
                    PKG_SAMEN_festivals.log_bulk_errors('generateRandomCompanies_bulk');
            END;
            v_total_rows := v_total_rows + SQL%ROWCOUNT;
            v_ins_acc    := v_ins_acc + PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_t1);
            v_done       := v_done + v_chunk;
            v_names.DELETE; v_years.DELETE;
        END LOOP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomCompanies_bulk', 'p_amount=' || p_amount,
                                v_total_rows, v_gen_acc, v_ins_acc,
                                PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_start));
    END generateRandomCompanies_bulk;

    -- generateRandomTicketplatforms_bulk
    PROCEDURE generateRandomTicketplatforms_bulk(p_amount IN NUMBER) IS
        v_start      TIMESTAMP   := SYSTIMESTAMP;
        v_gen_acc    NUMBER      := 0;
        v_ins_acc    NUMBER      := 0;
        v_t0         TIMESTAMP;
        v_t1         TIMESTAMP;
        v_offset     NUMBER;
        v_names      t_str100;
        v_urls       t_str500;
        v_chunk      PLS_INTEGER;
        v_done       PLS_INTEGER := 0;
        v_total_rows PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(*) INTO v_offset FROM TICKETPLATFORM;
        v_offset := v_offset + 750;
        WHILE v_done < p_amount LOOP
            v_chunk := LEAST(p_amount - v_done, PKG_SAMEN_festivals.C_BULK_CHUNK);
            v_t0 := SYSTIMESTAMP;
            FOR i IN 1 .. v_chunk LOOP
                platform_name_and_url(v_offset + v_done + i, v_names(i), v_urls(i));
            END LOOP;
            v_t1      := SYSTIMESTAMP;
            v_gen_acc := v_gen_acc + PKG_SAMEN_festivals.timestamp_diff(v_t1, v_t0);
            BEGIN
                FORALL i IN 1 .. v_chunk SAVE EXCEPTIONS
                    INSERT INTO TICKETPLATFORM (TICKETPLATFORM_NAME, TICKETPLATFORM_URL)
                    VALUES (v_names(i), v_urls(i));
            EXCEPTION
                WHEN PKG_SAMEN_festivals.bulk_errors THEN
                    PKG_SAMEN_festivals.log_bulk_errors('generateRandomTicketplatforms_bulk');
            END;
            v_total_rows := v_total_rows + SQL%ROWCOUNT;
            v_ins_acc    := v_ins_acc + PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_t1);
            v_done       := v_done + v_chunk;
            v_names.DELETE; v_urls.DELETE;
        END LOOP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomTicketplatforms_bulk', 'p_amount=' || p_amount,
                                v_total_rows, v_gen_acc, v_ins_acc,
                                PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_start));
    END generateRandomTicketplatforms_bulk;

    -- generateRandomVisitors_bulk
    PROCEDURE generateRandomVisitors_bulk(p_amount IN NUMBER) IS
        v_city_ids   t_id_tab;
        v_start      TIMESTAMP   := SYSTIMESTAMP;
        v_gen_acc    NUMBER      := 0;
        v_ins_acc    NUMBER      := 0;
        v_t0         TIMESTAMP;
        v_t1         TIMESTAMP;
        v_offset     NUMBER;
        v_fnames     t_str50;
        v_lnames     t_str50;
        v_births     t_date_tab;
        v_emails     t_str100;
        v_streets    t_str50;
        v_snums      t_str10;
        v_cids       t_id_tab;
        v_genders    t_str50;
        v_chunk      PLS_INTEGER;
        v_done       PLS_INTEGER := 0;
        v_total_rows PLS_INTEGER := 0;
        v_city_idx   PLS_INTEGER;
        v_fname      VARCHAR2(50);
        v_lname      VARCHAR2(50);
    BEGIN
        SELECT CITY_ID BULK COLLECT INTO v_city_ids FROM CITY;
        IF v_city_ids.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomVisitors_bulk: no cities');  RETURN;
        END IF;
        SELECT COUNT(*) INTO v_offset FROM VISITOR;

        WHILE v_done < p_amount LOOP
            v_chunk := LEAST(p_amount - v_done, PKG_SAMEN_festivals.C_BULK_CHUNK);
            v_t0 := SYSTIMESTAMP;
            FOR i IN 1 .. v_chunk LOOP
                v_city_idx   := PKG_SAMEN_festivals.give_random_number(1, v_city_ids.COUNT);
                v_fname      := PKG_SAMEN_festivals.give_random_first_name;
                v_lname      := PKG_SAMEN_festivals.give_random_last_name;
                v_fnames(i)  := v_fname;
                v_lnames(i)  := v_lname;
                v_births(i)  := PKG_SAMEN_festivals.give_random_date(DATE '1960-01-01', DATE '2005-12-31');
                v_emails(i)  := LOWER(v_fname) || '.' || LOWER(v_lname)
                             || (v_offset + v_done + i) || '@' || random_email_domain;
                v_streets(i) := PKG_SAMEN_festivals.give_random_street;
                v_snums(i)   := TO_CHAR(PKG_SAMEN_festivals.give_random_number(1, 999));
                v_cids(i)    := v_city_ids(v_city_idx);
                v_genders(i) := PKG_SAMEN_festivals.give_random_gender;
            END LOOP;
            v_t1      := SYSTIMESTAMP;
            v_gen_acc := v_gen_acc + PKG_SAMEN_festivals.timestamp_diff(v_t1, v_t0);
            BEGIN
                FORALL i IN 1 .. v_chunk SAVE EXCEPTIONS
                    INSERT INTO VISITOR (VISITOR_FIRSTNAME, VISITOR_LASTNAME, VISITOR_BIRTHDATE,
                                         VISITOR_EMAIL, VISITOR_STREET_NAME, VISITOR_STREET_NUMBER,
                                         CITY_ID, VISITOR_GENDER)
                    VALUES (v_fnames(i), v_lnames(i), v_births(i), v_emails(i),
                            v_streets(i), v_snums(i), v_cids(i), v_genders(i));
            EXCEPTION
                WHEN PKG_SAMEN_festivals.bulk_errors THEN
                    PKG_SAMEN_festivals.log_bulk_errors('generateRandomVisitors_bulk');
            END;
            v_total_rows := v_total_rows + SQL%ROWCOUNT;
            v_ins_acc    := v_ins_acc + PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_t1);
            v_done       := v_done + v_chunk;
            v_fnames.DELETE;  v_lnames.DELETE;  v_births.DELETE;
            v_emails.DELETE;  v_streets.DELETE; v_snums.DELETE;
            v_cids.DELETE;    v_genders.DELETE;
        END LOOP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomVisitors_bulk', 'p_amount=' || p_amount,
                                v_total_rows, v_gen_acc, v_ins_acc,
                                PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_start));
    END generateRandomVisitors_bulk;

    -- generateRandomTickets_bulk
    PROCEDURE generateRandomTickets_bulk(p_amount IN NUMBER) IS
        v_fest_ids     t_id_tab;
        v_fest_names   t_str100;
        v_fest_starts  t_date_tab;
        v_fest_ends    t_date_tab;
        v_vis_ids      t_id_tab;
        v_plat_ids     t_id_tab;
        v_plat_urls    t_str500;
        v_plat_hosts   t_str500;
        v_fest_budgets t_id_tab;
        v_vis_shuffle  t_id_tab;
        v_start        TIMESTAMP  := SYSTIMESTAMP;
        v_gen_acc      NUMBER     := 0;
        v_ins_acc      NUMBER     := 0;
        v_t0           TIMESTAMP;
        v_t1           TIMESTAMP;
        v_offset       NUMBER;
        v_prices       t_num10_2;
        v_currencies   t_char3;
        v_tkt_dates    t_date_tab;
        v_purch_dates  t_date_tab;
        v_descs        t_str100;
        v_barcodes     t_str14;
        v_types        t_str50;
        v_statuses     t_str50;
        v_qr_codes     t_str500;
        v_ins_plats    t_id_tab;
        v_ins_vis      t_id_tab;
        v_ins_fests    t_id_tab;
        v_total_rows   PLS_INTEGER := 0;
        v_vis_idx      PLS_INTEGER;
        v_plat_idx           PLS_INTEGER;
        v_tkt_date     DATE;
        v_max_purch    DATE;
        v_barcode      VARCHAR2(14);
        v_type         VARCHAR2(50);
        v_fest_count   PLS_INTEGER;
        v_vis_count    PLS_INTEGER;
        v_plat_count   PLS_INTEGER;
        v_remaining    PLS_INTEGER;
        v_budget            PLS_INTEGER;
        v_j            PLS_INTEGER;
        v_swap_i        PLS_INTEGER;
        v_swap_j        PLS_INTEGER;
        v_tmp_id        NUMBER;
        v_tmp_date        DATE;
        v_tmp_name        VARCHAR2(100);
        v_chunk_pos    PLS_INTEGER := 0;
    BEGIN
        SELECT FESTIVAL_ID, FESTIVAL_NAME, FESTIVAL_STARTDATE, FESTIVAL_ENDDATE
            BULK COLLECT INTO v_fest_ids, v_fest_names, v_fest_starts, v_fest_ends
        FROM FESTIVAL;
        SELECT VISITOR_ID BULK COLLECT INTO v_vis_ids FROM VISITOR;
        SELECT TICKETPLATFORM_ID, TICKETPLATFORM_URL
            BULK COLLECT INTO v_plat_ids, v_plat_urls FROM TICKETPLATFORM;

        FOR i IN 1..v_plat_urls.COUNT LOOP
            v_plat_hosts(i) := url_host(v_plat_urls(i));
        END LOOP;

        IF v_fest_ids.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomTickets_bulk: no festivals');  RETURN;
        END IF;
        IF v_vis_ids.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomTickets_bulk: no visitors');   RETURN;
        END IF;
        IF v_plat_ids.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomTickets_bulk: no platforms');  RETURN;
        END IF;

        v_fest_count := v_fest_ids.COUNT;
        v_vis_count  := v_vis_ids.COUNT;
        v_plat_count := v_plat_ids.COUNT;
        SELECT COUNT(*) INTO v_offset FROM TICKET;

        -- Fisher-Yates: randomise festival order before stick-breaking
        FOR k IN REVERSE 2..v_fest_count LOOP
            v_j := PKG_SAMEN_festivals.give_random_number(1, k);
            v_tmp_id := v_fest_ids(k);    v_fest_ids(k)    := v_fest_ids(v_j);    v_fest_ids(v_j)    := v_tmp_id;
            v_tmp_name := v_fest_names(k);  v_fest_names(k)  := v_fest_names(v_j);  v_fest_names(v_j)  := v_tmp_name;
            v_tmp_date := v_fest_starts(k); v_fest_starts(k) := v_fest_starts(v_j); v_fest_starts(v_j) := v_tmp_date;
            v_tmp_date := v_fest_ends(k);   v_fest_ends(k)   := v_fest_ends(v_j);   v_fest_ends(v_j)   := v_tmp_date;
        END LOOP;

        -- Stick-breaking: random budget per festival, sum = p_amount
        v_remaining := p_amount;
        FOR f IN 1..v_fest_count - 1 LOOP
            IF v_remaining > 0 THEN
                v_fest_budgets(f) := PKG_SAMEN_festivals.give_random_number(
                        v_remaining / ((v_fest_count - f) * v_vis_count),
                        LEAST(v_remaining, v_vis_count));
                v_remaining := v_remaining - v_fest_budgets(f);
            ELSE
                v_fest_budgets(f) := 0;
            END IF;
        END LOOP;
        v_fest_budgets(v_fest_count) := LEAST(v_remaining, v_vis_count);

        EXECUTE IMMEDIATE 'ALTER TABLE TICKET DISABLE CONSTRAINT Ticket_Barcode_UQ';
        EXECUTE IMMEDIATE 'ALTER TABLE TICKET DISABLE CONSTRAINT Ticket_VisitFestPlatform_UQ';

        v_t0 := SYSTIMESTAMP;

        -- Sparse partial Fisher-Yates: unique visitors per festival, no hash table
        FOR f IN 1..v_fest_count LOOP
            v_budget := LEAST(v_fest_budgets(f), v_vis_count);
            v_vis_shuffle.DELETE;

            FOR s IN 1..v_budget LOOP
                v_j     := PKG_SAMEN_festivals.give_random_number(s - 1, v_vis_count - 1);
                v_swap_i := CASE WHEN v_vis_shuffle.EXISTS(s - 1) THEN v_vis_shuffle(s - 1) ELSE s - 1 END;
                v_swap_j := CASE WHEN v_vis_shuffle.EXISTS(v_j)   THEN v_vis_shuffle(v_j)   ELSE v_j   END;
                v_vis_shuffle(s - 1) := v_swap_j;
                IF v_j != s - 1 THEN v_vis_shuffle(v_j) := v_swap_i; END IF;

                v_vis_idx   := v_swap_j + 1;
                v_plat_idx        := PKG_SAMEN_festivals.give_random_number(1, v_plat_count);
                v_chunk_pos := v_chunk_pos + 1;
                v_tkt_date  := PKG_SAMEN_festivals.give_random_date(v_fest_starts(f), v_fest_ends(f));
                v_max_purch := LEAST(v_tkt_date, SYSDATE);
                v_type      := PKG_SAMEN_festivals.give_random_ticket_type;
                v_barcode   := 'B' || LPAD(TO_CHAR(v_offset + v_total_rows + v_chunk_pos), 12, '0');

                v_types(v_chunk_pos)       := v_type;
                v_prices(v_chunk_pos)      := PKG_SAMEN_festivals.give_random_number(50, 500);
                v_currencies(v_chunk_pos)  := PKG_SAMEN_festivals.give_random_currency;
                v_tkt_dates(v_chunk_pos)   := v_tkt_date;
                v_purch_dates(v_chunk_pos) := PKG_SAMEN_festivals.give_random_date(
                                            GREATEST(v_max_purch - 365, DATE '2020-01-01'), v_max_purch);
                v_descs(v_chunk_pos)       := v_type || ' ticket for ' || v_fest_names(f);
                v_barcodes(v_chunk_pos)    := v_barcode;
                v_statuses(v_chunk_pos)    := PKG_SAMEN_festivals.give_random_ticket_status;
                v_qr_codes(v_chunk_pos)    := 'https://qr.' || v_plat_hosts(v_plat_idx) || '/' || v_barcode;
                v_ins_plats(v_chunk_pos)   := v_plat_ids(v_plat_idx);
                v_ins_vis(v_chunk_pos)     := v_vis_ids(v_vis_idx);
                v_ins_fests(v_chunk_pos)   := v_fest_ids(f);

                IF v_chunk_pos = PKG_SAMEN_festivals.C_BULK_CHUNK THEN
                    v_t1      := SYSTIMESTAMP;
                    v_gen_acc := v_gen_acc + PKG_SAMEN_festivals.timestamp_diff(v_t1, v_t0);
                    BEGIN
                        FORALL i IN 1..v_chunk_pos SAVE EXCEPTIONS
                            INSERT INTO TICKET (TICKET_PRICE, TICKET_CURRENCY, TICKET_DATE,
                                                TICKET_PURCHASE_DATE, TICKET_DESCRIPTION,
                                                TICKET_BARCODE, TICKET_TYPE, TICKET_STATUS,
                                                TICKET_QR_CODE, TICKETPLATFORM_ID, VISITOR_ID, FESTIVAL_ID)
                            VALUES (v_prices(i), v_currencies(i), v_tkt_dates(i), v_purch_dates(i),
                                    v_descs(i), v_barcodes(i), v_types(i), v_statuses(i),
                                    v_qr_codes(i), v_ins_plats(i), v_ins_vis(i), v_ins_fests(i));
                    EXCEPTION
                        WHEN PKG_SAMEN_festivals.bulk_errors THEN
                            PKG_SAMEN_festivals.log_bulk_errors('generateRandomTickets_bulk');
                    END;
                    v_total_rows := v_total_rows + SQL%ROWCOUNT;
                    v_ins_acc    := v_ins_acc + PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_t1);
                    v_prices.DELETE;      v_currencies.DELETE;  v_tkt_dates.DELETE;
                    v_purch_dates.DELETE; v_descs.DELETE;       v_barcodes.DELETE;
                    v_types.DELETE;       v_statuses.DELETE;    v_qr_codes.DELETE;
                    v_ins_plats.DELETE;   v_ins_vis.DELETE;     v_ins_fests.DELETE;
                    v_chunk_pos := 0;
                    v_t0  := SYSTIMESTAMP;
                END IF;
            END LOOP;
        END LOOP;

        -- Flush the final partial chunk
        IF v_chunk_pos > 0 THEN
            v_t1      := SYSTIMESTAMP;
            v_gen_acc := v_gen_acc + PKG_SAMEN_festivals.timestamp_diff(v_t1, v_t0);
            BEGIN
                FORALL i IN 1..v_chunk_pos SAVE EXCEPTIONS
                    INSERT INTO TICKET (TICKET_PRICE, TICKET_CURRENCY, TICKET_DATE,
                                        TICKET_PURCHASE_DATE, TICKET_DESCRIPTION,
                                        TICKET_BARCODE, TICKET_TYPE, TICKET_STATUS,
                                        TICKET_QR_CODE, TICKETPLATFORM_ID, VISITOR_ID, FESTIVAL_ID)
                    VALUES (v_prices(i), v_currencies(i), v_tkt_dates(i), v_purch_dates(i),
                            v_descs(i), v_barcodes(i), v_types(i), v_statuses(i),
                            v_qr_codes(i), v_ins_plats(i), v_ins_vis(i), v_ins_fests(i));
            EXCEPTION
                WHEN PKG_SAMEN_festivals.bulk_errors THEN
                    PKG_SAMEN_festivals.log_bulk_errors('generateRandomTickets_bulk');
            END;
            v_total_rows := v_total_rows + SQL%ROWCOUNT;
            v_ins_acc    := v_ins_acc + PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_t1);
        END IF;

        COMMIT;
        EXECUTE IMMEDIATE 'ALTER TABLE TICKET ENABLE NOVALIDATE CONSTRAINT Ticket_Barcode_UQ';
        EXECUTE IMMEDIATE 'ALTER TABLE TICKET ENABLE NOVALIDATE CONSTRAINT Ticket_VisitFestPlatform_UQ';
        PKG_SAMEN_festivals.log('generateRandomTickets_bulk', 'p_amount=' || p_amount,
                                v_total_rows, v_gen_acc, v_ins_acc,
                                PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_start));
    END generateRandomTickets_bulk;

    -- generateRandomPermits_bulk
    PROCEDURE generateRandomPermits_bulk(p_per_festival IN NUMBER) IS
        v_fest_ids    t_id_tab;
        v_fest_names  t_str100;
        v_fest_starts t_date_tab;
        v_start       TIMESTAMP   := SYSTIMESTAMP;
        v_gen_acc     NUMBER      := 0;
        v_ins_acc     NUMBER      := 0;
        v_t0          TIMESTAMP;
        v_t1          TIMESTAMP;
        v_cats        t_str50;
        v_descs       t_str100;
        v_app_dates   t_date_tab;
        v_rec_dates   t_date_tab;
        v_exp_dates   t_date_tab;
        v_fids        t_id_tab;
        v_buf_idx     PLS_INTEGER := 0;
        v_total_rows  PLS_INTEGER := 0;
        v_max_app     DATE;
        v_min_app     DATE;
        v_app_date    DATE;
        v_rec_date    DATE;
        v_cat         VARCHAR2(50);
    BEGIN
        SELECT FESTIVAL_ID, FESTIVAL_NAME, FESTIVAL_STARTDATE
            BULK COLLECT INTO v_fest_ids, v_fest_names, v_fest_starts
        FROM FESTIVAL;
        IF v_fest_ids.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomPermits_bulk: no festivals');  RETURN;
        END IF;

        v_t0 := SYSTIMESTAMP;

        FOR fi IN 1 .. v_fest_ids.COUNT LOOP
            v_max_app := LEAST(v_fest_starts(fi) - 1, SYSDATE);
            v_min_app := GREATEST(v_max_app - 365, DATE '2020-01-01');
            IF v_min_app > v_max_app THEN v_min_app := v_max_app; END IF;

            FOR j IN 1 .. p_per_festival LOOP
                v_app_date     := PKG_SAMEN_festivals.give_random_date(v_min_app, v_max_app);
                v_rec_date     := PKG_SAMEN_festivals.give_random_date(v_app_date + 1, v_app_date + 60);
                v_cat          := PKG_SAMEN_festivals.give_random_permit_category;
                v_buf_idx      := v_buf_idx + 1;
                v_cats(v_buf_idx)      := v_cat;
                v_descs(v_buf_idx)     := v_cat || ' permit for ' || v_fest_names(fi);
                v_app_dates(v_buf_idx) := v_app_date;
                v_rec_dates(v_buf_idx) := v_rec_date;
                v_exp_dates(v_buf_idx) := PKG_SAMEN_festivals.give_random_date(
                                              v_rec_date + 1, v_rec_date + 180);
                v_fids(v_buf_idx)      := v_fest_ids(fi);

                IF v_buf_idx >= PKG_SAMEN_festivals.C_BULK_CHUNK THEN
                    v_t1      := SYSTIMESTAMP;
                    v_gen_acc := v_gen_acc + PKG_SAMEN_festivals.timestamp_diff(v_t1, v_t0);
                    BEGIN
                        FORALL i IN 1 .. v_buf_idx SAVE EXCEPTIONS
                            INSERT INTO PERMIT (PERMIT_CATEGORY, PERMIT_DESCRIPTION,
                                                PERMIT_RECEPTION_DATE, PERMIT_EXPIRATION_DATE,
                                                PERMIT_APPLICATION_DATE, FESTIVAL_ID)
                            VALUES (v_cats(i), v_descs(i), v_rec_dates(i), v_exp_dates(i),
                                    v_app_dates(i), v_fids(i));
                    EXCEPTION
                        WHEN PKG_SAMEN_festivals.bulk_errors THEN
                            PKG_SAMEN_festivals.log_bulk_errors('generateRandomPermits_bulk');
                    END;
                    v_total_rows := v_total_rows + SQL%ROWCOUNT;
                    v_ins_acc    := v_ins_acc + PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_t1);
                    v_cats.DELETE; v_descs.DELETE; v_app_dates.DELETE;
                    v_rec_dates.DELETE; v_exp_dates.DELETE; v_fids.DELETE;
                    v_buf_idx := 0;
                    v_t0 := SYSTIMESTAMP;
                END IF;
            END LOOP;
        END LOOP;

        -- Flush remaining rows
        IF v_buf_idx > 0 THEN
            v_t1      := SYSTIMESTAMP;
            v_gen_acc := v_gen_acc + PKG_SAMEN_festivals.timestamp_diff(v_t1, v_t0);
            BEGIN
                FORALL i IN 1 .. v_buf_idx SAVE EXCEPTIONS
                    INSERT INTO PERMIT (PERMIT_CATEGORY, PERMIT_DESCRIPTION,
                                        PERMIT_RECEPTION_DATE, PERMIT_EXPIRATION_DATE,
                                        PERMIT_APPLICATION_DATE, FESTIVAL_ID)
                    VALUES (v_cats(i), v_descs(i), v_rec_dates(i), v_exp_dates(i),
                            v_app_dates(i), v_fids(i));
            EXCEPTION
                WHEN PKG_SAMEN_festivals.bulk_errors THEN
                    PKG_SAMEN_festivals.log_bulk_errors('generateRandomPermits_bulk');
            END;
            v_total_rows := v_total_rows + SQL%ROWCOUNT;
            v_ins_acc    := v_ins_acc + PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_t1);
        END IF;

        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomPermits_bulk', 'p_per_festival=' || p_per_festival,
                                v_total_rows, v_gen_acc, v_ins_acc,
                                PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_start));
    END generateRandomPermits_bulk;

-- =============================================================
-- M6 – PHASE WRAPPERS
-- =============================================================

    PROCEDURE bewijs_milestone_6_S1_base_single(p_cities    IN NUMBER,
                                                p_companies IN NUMBER,
                                                p_platforms IN NUMBER,
                                                p_visitors  IN NUMBER) IS
        v_start TIMESTAMP := SYSTIMESTAMP;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== bewijs_milestone_6_S1_base_single START ===');
        fill_s1_base;
        generateRandomCities_single(p_cities);
        generateRandomCompanies_single(p_companies);
        generateRandomTicketplatforms_single(p_platforms);
        generateRandomVisitors_single(p_visitors);
        DBMS_OUTPUT.PUT_LINE('=== bewijs_milestone_6_S1_base_single DONE | '
            || ROUND(PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_start) * 1000) || ' ms ===');
    END bewijs_milestone_6_S1_base_single;

    -- ---------------------------------------------------------

    PROCEDURE bewijs_milestone_6_S1_base_bulk(p_cities    IN NUMBER,
                                              p_companies IN NUMBER,
                                              p_platforms IN NUMBER,
                                              p_visitors  IN NUMBER) IS
        v_start TIMESTAMP := SYSTIMESTAMP;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== bewijs_milestone_6_S1_base_bulk START ===');
        fill_s1_base;
        generateRandomCities_bulk(p_cities);
        generateRandomCompanies_bulk(p_companies);
        generateRandomTicketplatforms_bulk(p_platforms);
        generateRandomVisitors_bulk(p_visitors);
        DBMS_OUTPUT.PUT_LINE('=== bewijs_milestone_6_S1_base_bulk DONE | '
            || ROUND(PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_start) * 1000) || ' ms ===');
    END bewijs_milestone_6_S1_base_bulk;

    -- ---------------------------------------------------------

    PROCEDURE bewijs_milestone_6_S1_children_single(p_tickets          IN NUMBER,
                                                    p_permits_per_fest IN NUMBER) IS
        v_start TIMESTAMP := SYSTIMESTAMP;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== bewijs_milestone_6_S1_children_single START ===');
        generateRandomTickets_single(p_tickets);
        generateRandomPermits_single(p_permits_per_fest);
        DBMS_OUTPUT.PUT_LINE('=== bewijs_milestone_6_S1_children_single DONE | '
            || ROUND(PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_start) * 1000) || ' ms ===');
    END bewijs_milestone_6_S1_children_single;

    -- ---------------------------------------------------------

    PROCEDURE bewijs_milestone_6_S1_children_bulk(p_tickets          IN NUMBER,
                                                  p_permits_per_fest IN NUMBER) IS
        v_start TIMESTAMP := SYSTIMESTAMP;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== bewijs_milestone_6_S1_children_bulk START ===');
        generateRandomTickets_bulk(p_tickets);
        generateRandomPermits_bulk(p_permits_per_fest);
        DBMS_OUTPUT.PUT_LINE('=== bewijs_milestone_6_S1_children_bulk DONE | '
            || ROUND(PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_start) * 1000) || ' ms ===');
    END bewijs_milestone_6_S1_children_bulk;

-- =============================================================
-- M6 – PROOF PROCEDURE
-- =============================================================

    PROCEDURE bewijs_milestone_6_S1(p_visitors         IN NUMBER,
                                    p_companies        IN NUMBER,
                                    p_platforms        IN NUMBER,
                                    p_tickets          IN NUMBER,
                                    p_permits_per_fest IN NUMBER,
                                    p_festivals        IN NUMBER,
                                    p_mode             IN VARCHAR2) IS
        v_mode           VARCHAR2(10) := UPPER(TRIM(p_mode));
        v_total_start    TIMESTAMP   := SYSTIMESTAMP;
        v_base_start     TIMESTAMP;
        v_s2_start       TIMESTAMP;
        v_children_start TIMESTAMP;
        v_single_total   NUMBER      := 0;
        v_bulk_total     NUMBER      := 0;
        v_aux_cities     PLS_INTEGER := GREATEST(CEIL(p_visitors / 20), 50);

        PROCEDURE reset_s1 IS
        BEGIN
            -- S1 children first (they reference S2.FESTIVAL)
            EXECUTE IMMEDIATE 'TRUNCATE TABLE Ticket';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE Permit';
            -- S2 tables (Festival referenced by S1 children, already empty above)
            EXECUTE IMMEDIATE 'TRUNCATE TABLE Performance';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE Stage';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE Festival';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE Artist';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE Genre';
            -- S1 base (Company/City referenced by Festival, already empty above)
            EXECUTE IMMEDIATE 'TRUNCATE TABLE TicketPlatform';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE Visitor';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE Company';
            EXECUTE IMMEDIATE 'TRUNCATE TABLE City';
        END reset_s1;
    BEGIN
        IF v_mode NOT IN ('BOTH', 'BULK', 'SINGLE') THEN
            RAISE_APPLICATION_ERROR(-20020,
                'bewijs_milestone_6_S1: invalid mode "' || p_mode
                || '". Use BOTH, BULK, or SINGLE.');
        END IF;

        DBMS_OUTPUT.PUT_LINE('=== bewijs_milestone_6_S1 START | mode=' || v_mode || ' ===');
        DBMS_OUTPUT.PUT_LINE('params: p_visitors=' || p_visitors
            || ' | p_companies='        || p_companies
            || ' | p_platforms='        || p_platforms
            || ' | p_tickets='          || p_tickets
            || ' | p_permits_per_fest=' || p_permits_per_fest
            || ' | p_festivals='        || p_festivals);

        -- ======================================================
        -- BULK-INSERT run
        -- ======================================================
        IF v_mode IN ('BOTH', 'BULK') THEN
            DBMS_OUTPUT.PUT_LINE('--- BULK run ---');
            reset_s1;
            v_base_start := SYSTIMESTAMP;
            bewijs_milestone_6_S1_base_bulk(v_aux_cities, p_companies, p_platforms, p_visitors);
            v_s2_start := SYSTIMESTAMP;
            PKG_S2_festivals.generateRandomFestivals(p_festivals);
            v_children_start := SYSTIMESTAMP;
            bewijs_milestone_6_S1_children_bulk(p_tickets, p_permits_per_fest);
            COMMIT;
            v_bulk_total := PKG_SAMEN_festivals.timestamp_diff(v_s2_start,       v_base_start)
                         + PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_children_start);
            DBMS_OUTPUT.PUT_LINE('BULK total (S2 excluded): ' || ROUND(v_bulk_total * 1000) || ' ms');
        END IF;

        -- ======================================================
        -- SINGLE-INSERT run
        -- ======================================================
        IF v_mode IN ('BOTH', 'SINGLE') THEN
            DBMS_OUTPUT.PUT_LINE('--- SINGLE run ---');
            reset_s1;
            v_base_start := SYSTIMESTAMP;
            bewijs_milestone_6_S1_base_single(v_aux_cities, p_companies, p_platforms, p_visitors);
            v_s2_start := SYSTIMESTAMP;
            PKG_S2_festivals.generateRandomFestivals(p_festivals);
            v_children_start := SYSTIMESTAMP;
            bewijs_milestone_6_S1_children_single(p_tickets, p_permits_per_fest);
            COMMIT;
            v_single_total := PKG_SAMEN_festivals.timestamp_diff(v_s2_start,       v_base_start)
                           + PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_children_start);
            DBMS_OUTPUT.PUT_LINE('SINGLE total (S2 excluded): ' || ROUND(v_single_total * 1000) || ' ms');
        END IF;

        -- ======================================================
        -- Comparison summary (only when both ran)
        -- ======================================================
        IF v_mode = 'BOTH' THEN
            DBMS_OUTPUT.PUT_LINE('=== Comparison (S1 time only, S2 excluded) ===');
            DBMS_OUTPUT.PUT_LINE('BULK  : ' || ROUND(v_bulk_total   * 1000) || ' ms');
            DBMS_OUTPUT.PUT_LINE('SINGLE: ' || ROUND(v_single_total * 1000) || ' ms');
            IF v_bulk_total > 0 THEN
                DBMS_OUTPUT.PUT_LINE('SINGLE / BULK ratio: '
                    || ROUND(v_single_total / v_bulk_total, 2) || 'x');
            END IF;
        END IF;

        DBMS_OUTPUT.PUT_LINE('=== bewijs_milestone_6_S1 END | elapsed: '
            || ROUND(PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_total_start) * 1000)
            || ' ms ===');
    END bewijs_milestone_6_S1;

END PKG_S1_festivals;
/