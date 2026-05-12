CREATE OR REPLACE PACKAGE BODY PKG_S1_festivals AS
    -- =========================================================
    -- Private collection types – shared by all M5 generators.
    -- Declared here once so procedures need no local TYPE stmts.
    -- =========================================================
    TYPE t_id_tab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    TYPE t_date_tab IS TABLE OF DATE INDEX BY PLS_INTEGER;
    TYPE t_num10_2 IS TABLE OF NUMBER(10, 2) INDEX BY PLS_INTEGER;
    TYPE t_str500 IS TABLE OF VARCHAR2(500) INDEX BY PLS_INTEGER;
    TYPE t_str100 IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
    TYPE t_str50 IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
    TYPE t_str14 IS TABLE OF VARCHAR2(14) INDEX BY PLS_INTEGER;
    TYPE t_str10 IS TABLE OF VARCHAR2(10) INDEX BY PLS_INTEGER;
    TYPE t_char3 IS TABLE OF VARCHAR2(3) INDEX BY PLS_INTEGER;

    -- Bulk-insert exception lives in PKG_SAMEN_festivals.bulk_errors
    -- (shared with S2 to avoid duplicating the PRAGMA EXCEPTION_INIT).

    -- Private: realistic email domain selector (used by visitor generators)
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

    -- ---------------------------------------------------------

    -- PUBLIC LOOKUP (also used internally by this package)
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

-- =============================================================
-- bewijs_M4_S1: thin wrapper. Assumes S1 base+children are empty
-- and that S2 fill happens between fill_s1_base and fill_s1_children.
-- The SAMEN script orchestrates the full sequence.
-- =============================================================
    PROCEDURE bewijs_M4_S1 IS
    BEGIN
        fill_s1_base;
        fill_s1_children;
    END bewijs_M4_S1;

-- =============================================================
-- M5 – RANDOM GENERATORS  (Stap 2)
--
-- Pattern used throughout:
--   • BULK COLLECT  – reads all parent IDs in one SQL→PL/SQL round-trip
--   • Value arrays  – built in a FOR loop (pure PL/SQL, no SQL)
--   • FORALL + SAVE EXCEPTIONS – sends all INSERTs in one batch;
--     individual constraint violations (ORA-00001) are silently
--     skipped via PKG_SAMEN_festivals.bulk_errors; every other error is re-raised.
-- =============================================================

    -- ---------------------------------------------------------
    -- generateRandomCities
    --   Unique zipcode: 'Z' + zero-padded (existing count + i),
    --   so repeated calls never collide with each other or with M4.
    -- ---------------------------------------------------------
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
                v_zips(i) := 'Z' || LPAD(TO_CHAR(v_offset + i), 8, '0');
                v_names(i) := PKG_SAMEN_festivals.give_random_location
                    || '_' || LPAD(TO_CHAR(v_offset + i), 5, '0');
                v_cntrs(i) := PKG_SAMEN_festivals.give_random_country;
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

    -- ---------------------------------------------------------
    -- generateRandomCompanies
    --   Unique name: 'RndCo_' + zero-padded counter offset.
    --   Companies serve as festival owners for S2's random festivals.
    -- ---------------------------------------------------------
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
                v_names(i) := 'RndCo_' || LPAD(TO_CHAR(v_offset + i), 6, '0');
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

    -- ---------------------------------------------------------
    -- generateRandomTicketplatforms
    --   Unique name AND url, both counter-based.
    -- ---------------------------------------------------------
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
                v_names(i) := PKG_SAMEN_festivals.give_random_platform_name
                    || '_' || LPAD(TO_CHAR(v_offset + i), 5, '0');
                v_urls(i) := 'https://platform' || LPAD(TO_CHAR(v_offset + i), 8, '0') || '.com';
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

    -- ---------------------------------------------------------
    -- generateRandomVisitors
    --   BULK COLLECT city IDs → pure-PL/SQL value generation →
    --   FORALL INSERT.
    --   Email uniqueness: LOWER(firstname) || (offset+i) || '@rnd.com'
    -- ---------------------------------------------------------
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
        v_ci       PLS_INTEGER;
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
                v_ci := PKG_SAMEN_festivals.give_random_number(1, v_city_ids.COUNT);
                v_fname := PKG_SAMEN_festivals.give_random_first_name;
                v_lname := PKG_SAMEN_festivals.give_random_last_name;
                v_fnames(i) := v_fname;
                v_lnames(i) := v_lname;
                v_births(i) := PKG_SAMEN_festivals.give_random_date(DATE '1960-01-01', DATE '2005-12-31');
                v_emails(i) := LOWER(v_fname) || '.' || LOWER(v_lname)
                            || (v_offset + i) || '@' || random_email_domain;
                v_streets(i) := PKG_SAMEN_festivals.give_random_street;
                v_snums(i) := TO_CHAR(PKG_SAMEN_festivals.give_random_number(1, 999));
                v_cids(i) := v_city_ids(v_ci);
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

    -- ---------------------------------------------------------
    -- generateRandomTickets  (core Stap-2 junction)
    --
    -- Visitor (1)--(*) Ticket (*)--(1) Festival
    --   FESTIVAL is owned by S2; we read it via cross-schema SELECT.
    --
    -- All three parent pools are BULK COLLECTed once.
    -- Twelve value arrays are built in PL/SQL, then one FORALL
    -- sends all INSERTs to the SQL engine in a single batch.
    --
    -- Date constraints honoured:
    --   TICKET_DATE        in [FESTIVAL_STARTDATE, FESTIVAL_ENDDATE]
    --   TICKET_PURCHASE_DATE <= TICKET_DATE
    --   TICKET_PURCHASE_DATE <= DATE '2026-03-10'  (DDL CHECK)
    --
    -- Uniqueness constraints:
    --   TICKET_BARCODE unique: 'R' + 12-digit (existing count + i)
    --   (VISITOR_ID, FESTIVAL_ID, TICKET_DATE): violations skipped
    -- ---------------------------------------------------------
    PROCEDURE generateRandomTickets(p_amount IN NUMBER) IS
        -- parent pools (pure SQL scans – no DBMS_RANDOM in SQL, zero context switches)
        v_fest_ids     t_id_tab;
        v_fest_names   t_str100;
        v_fest_starts  t_date_tab;
        v_fest_ends    t_date_tab;
        v_all_vis      t_id_tab;
        v_plat_pool    t_id_tab;
        -- stick-breaking budgets and per-festival visitor shuffle map
        v_fest_budgets t_id_tab;
        v_vis_shuffle  t_id_tab;
        -- FORALL INSERT arrays
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
        v_k            PLS_INTEGER;
        v_idx          PLS_INTEGER := 0;
        v_vi           PLS_INTEGER;
        v_pi           PLS_INTEGER;
        v_j            PLS_INTEGER;
        v_val_i        PLS_INTEGER;
        v_val_j        PLS_INTEGER;
        v_tkt_date     DATE;
        v_max_purch    DATE;
        v_barcode      VARCHAR2(14);
        v_rows         PLS_INTEGER;
        v_tmp_n        NUMBER;
        v_tmp_d        DATE;
        v_tmp_s        VARCHAR2(100);
    BEGIN
        SELECT FESTIVAL_ID,
               FESTIVAL_NAME,
               FESTIVAL_STARTDATE,
               FESTIVAL_ENDDATE
            BULK COLLECT
        INTO v_fest_ids, v_fest_names, v_fest_starts, v_fest_ends
        FROM FESTIVAL;

        SELECT VISITOR_ID BULK COLLECT INTO v_all_vis FROM VISITOR;
        SELECT TICKETPLATFORM_ID BULK COLLECT INTO v_plat_pool FROM TICKETPLATFORM;

        IF v_fest_ids.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomTickets: no festivals – run S2 generators first');
            RETURN;
        END IF;
        IF v_all_vis.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomTickets: no visitors – run generateRandomVisitors first');
            RETURN;
        END IF;
        IF v_plat_pool.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomTickets: no ticketplatforms – run generateRandomTicketplatforms first');
            RETURN;
        END IF;

        SELECT COUNT(*) INTO v_offset FROM TICKET;

        v_vis_count := v_all_vis.COUNT;
        v_fest_count := v_fest_ids.COUNT;

        -- Full Fisher-Yates shuffle of festival order in PL/SQL so stick-breaking
        -- doesn't systematically favour the first festival loaded from the table.
        FOR k IN REVERSE 2..v_fest_count
            LOOP
                v_j := PKG_SAMEN_festivals.give_random_number(1, k);
                v_tmp_n := v_fest_ids(k); v_fest_ids(k) := v_fest_ids(v_j); v_fest_ids(v_j) := v_tmp_n;
                v_tmp_s := v_fest_names(k); v_fest_names(k) := v_fest_names(v_j); v_fest_names(v_j) := v_tmp_s;
                v_tmp_d := v_fest_starts(k); v_fest_starts(k) := v_fest_starts(v_j); v_fest_starts(v_j) := v_tmp_d;
                v_tmp_d := v_fest_ends(k); v_fest_ends(k) := v_fest_ends(v_j); v_fest_ends(v_j) := v_tmp_d;
            END LOOP;

        -- Stick-breaking: each festival claims a random slice of the remaining budget, so ticket counts range from 0 to p_amount across festivals.
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

        -- For each festival: sparse partial Fisher-Yates over [0, V-1] picks
        -- v_k unique visitors. The map is reset per festival so the same visitor
        -- can appear across multiple festivals but never twice in one.
        FOR f IN 1..v_fest_count
            LOOP
                v_k := LEAST(v_fest_budgets(f), v_vis_count);
                v_vis_shuffle.DELETE;

                FOR s IN 1..v_k
                    LOOP
                        v_j := PKG_SAMEN_festivals.give_random_number(s - 1, v_vis_count - 1);
                        v_val_i := CASE WHEN v_vis_shuffle.EXISTS(s - 1) THEN v_vis_shuffle(s - 1) ELSE s - 1 END;
                        v_val_j := CASE WHEN v_vis_shuffle.EXISTS(v_j) THEN v_vis_shuffle(v_j) ELSE v_j END;
                        v_vis_shuffle(s - 1) := v_val_j;
                        IF v_j != s - 1 THEN v_vis_shuffle(v_j) := v_val_i; END IF;

                        v_vi := v_val_j + 1;
                        v_pi := PKG_SAMEN_festivals.give_random_number(1, v_plat_pool.COUNT);
                        v_idx := v_idx + 1;

                        v_tkt_date := PKG_SAMEN_festivals.give_random_date(v_fest_starts(f), v_fest_ends(f));
                        v_max_purch := LEAST(v_tkt_date, DATE '2026-03-10');
                        v_barcode := 'R' || LPAD(TO_CHAR(v_offset + v_idx), 12, '0');

                        v_types(v_idx) := PKG_SAMEN_festivals.give_random_ticket_type;
                        v_prices(v_idx) := PKG_SAMEN_festivals.give_random_number(50, 500);
                        v_currencies(v_idx) := PKG_SAMEN_festivals.give_random_currency;
                        v_tkt_dates(v_idx) := v_tkt_date;
                        v_purch_dates(v_idx) := PKG_SAMEN_festivals.give_random_date(
                                GREATEST(v_max_purch - 365, DATE '2020-01-01'), v_max_purch);
                        v_descs(v_idx) := v_types(v_idx) || ' ticket for ' || v_fest_names(f);
                        v_barcodes(v_idx) := v_barcode;
                        v_statuses(v_idx) := PKG_SAMEN_festivals.give_random_ticket_status;
                        v_qr_codes(v_idx) := 'https://qr.rnd.be/' || v_barcode;
                        v_ins_plats(v_idx) := v_plat_pool(v_pi);
                        v_ins_vis(v_idx) := v_all_vis(v_vi);
                        v_ins_fests(v_idx) := v_fest_ids(f);
                    END LOOP;
            END LOOP;
        v_gen_done := SYSTIMESTAMP;

        BEGIN
            FORALL i IN 1..v_idx SAVE EXCEPTIONS
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

    -- ---------------------------------------------------------
    -- generateRandomPermits
    --   Inserts p_per_festival permits for every existing festival.
    --   Festival IDs are BULK COLLECTed once.  All permit rows are
    --   built into flat arrays then sent in a single FORALL INSERT.
    --
    --   Date ordering guaranteed:
    --     application_date < reception_date < expiration_date
    --     application_date <= DATE '2026-03-10'  (DDL CHECK)
    -- ---------------------------------------------------------
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
        v_idx         PLS_INTEGER := 1;
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

        -- Build flat arrays across all festivals
        FOR fi IN 1..v_fest_ids.COUNT
            LOOP
                v_max_app := LEAST(v_fest_starts(fi) - 1, DATE '2026-03-10');
                v_min_app := GREATEST(v_max_app - 365, DATE '2020-01-01');
                IF v_min_app > v_max_app THEN v_min_app := v_max_app; END IF;

                FOR j IN 1..p_per_festival
                    LOOP
                        v_app_date := PKG_SAMEN_festivals.give_random_date(v_min_app, v_max_app);
                        v_rec_date := PKG_SAMEN_festivals.give_random_date(v_app_date + 1, v_app_date + 60);
                        v_cats(v_idx) := PKG_SAMEN_festivals.give_random_permit_category;
                        v_descs(v_idx) := v_cats(v_idx) || ' permit for '
                            || v_fest_names(fi);
                        v_app_dates(v_idx) := v_app_date;
                        v_rec_dates(v_idx) := v_rec_date;
                        v_exp_dates(v_idx) := PKG_SAMEN_festivals.give_random_date(v_rec_date + 1, v_rec_date + 180);
                        v_fids(v_idx) := v_fest_ids(fi);
                        v_idx := v_idx + 1;
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
    -- bewijs_milestone_5_S1_base
    --   Phase 1: generates all S1 rows that have NO dependency on
    --   S2 festivals.  Must run BEFORE bewijs_milestone_5_S2 so
    --   that S2 can pick random companies as festival owners.
    --   Mirrors M4's fill_s1_base.
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
    -- bewijs_milestone_5_S1_children
    --   Phase 2: generates TICKET and PERMIT rows that require
    --   festivals to already exist in S2.  Must run AFTER
    --   bewijs_milestone_5_S2.  Mirrors M4's fill_s1_children.
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

    -- ---------------------------------------------------------
    -- bewijs_milestone_5_S1
    --   Convenience wrapper that calls base then children.
    --   Only safe when S2 festivals already exist (same contract
    --   as bewijs_M4_S1).  The SAMEN script is the correct entry
    --   point for a full cross-schema M5 demonstration.
    -- ---------------------------------------------------------
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
-- Row-by-row INSERT; DUP_VAL_ON_INDEX is silently skipped.
-- gen_secs is 0 because generation and insertion are interleaved.
-- =============================================================

    -- ---------------------------------------------------------
    -- generateRandomCities_single
    -- ---------------------------------------------------------
    PROCEDURE generateRandomCities_single(p_amount IN NUMBER) IS
        v_start  TIMESTAMP   := SYSTIMESTAMP;
        v_end    TIMESTAMP;
        v_offset NUMBER;
        v_rows   PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(*) INTO v_offset FROM CITY;
        FOR i IN 1 .. p_amount LOOP
            BEGIN
                INSERT INTO CITY (ZIPCODE, CITY, COUNTRY)
                VALUES ('Z' || LPAD(TO_CHAR(v_offset + i), 8, '0'),
                        PKG_SAMEN_festivals.give_random_location
                            || '_' || LPAD(TO_CHAR(v_offset + i), 5, '0'),
                        PKG_SAMEN_festivals.give_random_country);
                v_rows := v_rows + 1;
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN NULL;
            END;
        END LOOP;
        v_end := SYSTIMESTAMP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomCities_single', 'p_amount=' || p_amount,
                                v_rows, 0,
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start));
    END generateRandomCities_single;

    -- ---------------------------------------------------------
    -- generateRandomCompanies_single
    -- ---------------------------------------------------------
    PROCEDURE generateRandomCompanies_single(p_amount IN NUMBER) IS
        v_start  TIMESTAMP   := SYSTIMESTAMP;
        v_end    TIMESTAMP;
        v_offset NUMBER;
        v_rows   PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(*) INTO v_offset FROM COMPANY;
        FOR i IN 1 .. p_amount LOOP
            BEGIN
                INSERT INTO COMPANY (COMPANY_NAME, COMPANY_FOUNDING_YEAR)
                VALUES ('RndCo_' || LPAD(TO_CHAR(v_offset + i), 6, '0'),
                        PKG_SAMEN_festivals.give_random_number(1800, 2025));
                v_rows := v_rows + 1;
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN NULL;
            END;
        END LOOP;
        v_end := SYSTIMESTAMP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomCompanies_single', 'p_amount=' || p_amount,
                                v_rows, 0,
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start));
    END generateRandomCompanies_single;

    -- ---------------------------------------------------------
    -- generateRandomTicketplatforms_single
    -- ---------------------------------------------------------
    PROCEDURE generateRandomTicketplatforms_single(p_amount IN NUMBER) IS
        v_start  TIMESTAMP   := SYSTIMESTAMP;
        v_end    TIMESTAMP;
        v_offset NUMBER;
        v_rows   PLS_INTEGER := 0;
    BEGIN
        SELECT COUNT(*) INTO v_offset FROM TICKETPLATFORM;
        FOR i IN 1 .. p_amount LOOP
            BEGIN
                INSERT INTO TICKETPLATFORM (TICKETPLATFORM_NAME, TICKETPLATFORM_URL)
                VALUES (PKG_SAMEN_festivals.give_random_platform_name
                            || '_' || LPAD(TO_CHAR(v_offset + i), 5, '0'),
                        'https://platform' || LPAD(TO_CHAR(v_offset + i), 8, '0') || '.com');
                v_rows := v_rows + 1;
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN NULL;
            END;
        END LOOP;
        v_end := SYSTIMESTAMP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomTicketplatforms_single', 'p_amount=' || p_amount,
                                v_rows, 0,
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start));
    END generateRandomTicketplatforms_single;

    -- ---------------------------------------------------------
    -- generateRandomVisitors_single
    --   City pool BULK COLLECTed once (read-only).
    --   Email: firstname.lastname<counter>@<realistic-domain>
    -- ---------------------------------------------------------
    PROCEDURE generateRandomVisitors_single(p_amount IN NUMBER) IS
        v_city_ids t_id_tab;
        v_start    TIMESTAMP   := SYSTIMESTAMP;
        v_end      TIMESTAMP;
        v_offset   NUMBER;
        v_rows     PLS_INTEGER := 0;
        v_ci       PLS_INTEGER;
        v_fname    VARCHAR2(50);
        v_lname    VARCHAR2(50);
    BEGIN
        SELECT CITY_ID BULK COLLECT INTO v_city_ids FROM CITY;
        IF v_city_ids.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomVisitors_single: no cities – run generateRandomCities first');
            RETURN;
        END IF;
        SELECT COUNT(*) INTO v_offset FROM VISITOR;

        FOR i IN 1 .. p_amount LOOP
            v_ci    := PKG_SAMEN_festivals.give_random_number(1, v_city_ids.COUNT);
            v_fname := PKG_SAMEN_festivals.give_random_first_name;
            v_lname := PKG_SAMEN_festivals.give_random_last_name;
            BEGIN
                INSERT INTO VISITOR (VISITOR_FIRSTNAME, VISITOR_LASTNAME, VISITOR_BIRTHDATE,
                                     VISITOR_EMAIL, VISITOR_STREET_NAME, VISITOR_STREET_NUMBER,
                                     CITY_ID, VISITOR_GENDER)
                VALUES (v_fname,
                        v_lname,
                        PKG_SAMEN_festivals.give_random_date(DATE '1960-01-01', DATE '2005-12-31'),
                        LOWER(v_fname) || '.' || LOWER(v_lname)
                            || (v_offset + i) || '@' || random_email_domain,
                        PKG_SAMEN_festivals.give_random_street,
                        TO_CHAR(PKG_SAMEN_festivals.give_random_number(1, 999)),
                        v_city_ids(v_ci),
                        PKG_SAMEN_festivals.give_random_gender);
                v_rows := v_rows + 1;
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN NULL;
            END;
        END LOOP;
        v_end := SYSTIMESTAMP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomVisitors_single', 'p_amount=' || p_amount,
                                v_rows, 0,
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start));
    END generateRandomVisitors_single;

    -- ---------------------------------------------------------
    -- generateRandomTickets_single
    --   Parent pools BULK COLLECTed once; each ticket inserted
    --   individually; duplicates silently skipped.
    --   Barcodes use 'S' prefix to distinguish from bulk runs.
    -- ---------------------------------------------------------
    PROCEDURE generateRandomTickets_single(p_amount IN NUMBER) IS
        v_fest_ids    t_id_tab;
        v_fest_names  t_str100;
        v_fest_starts t_date_tab;
        v_fest_ends   t_date_tab;
        v_all_vis     t_id_tab;
        v_plat_pool   t_id_tab;
        v_start       TIMESTAMP   := SYSTIMESTAMP;
        v_end         TIMESTAMP;
        v_offset      NUMBER;
        v_rows        PLS_INTEGER := 0;
        v_fi          PLS_INTEGER;
        v_vi          PLS_INTEGER;
        v_pi          PLS_INTEGER;
        v_tkt_date    DATE;
        v_max_purch   DATE;
        v_barcode     VARCHAR2(14);
        v_type        VARCHAR2(50);
    BEGIN
        SELECT FESTIVAL_ID, FESTIVAL_NAME, FESTIVAL_STARTDATE, FESTIVAL_ENDDATE
            BULK COLLECT INTO v_fest_ids, v_fest_names, v_fest_starts, v_fest_ends
        FROM FESTIVAL;
        SELECT VISITOR_ID        BULK COLLECT INTO v_all_vis   FROM VISITOR;
        SELECT TICKETPLATFORM_ID BULK COLLECT INTO v_plat_pool FROM TICKETPLATFORM;

        IF v_fest_ids.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomTickets_single: no festivals');  RETURN;
        END IF;
        IF v_all_vis.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomTickets_single: no visitors');   RETURN;
        END IF;
        IF v_plat_pool.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomTickets_single: no platforms');  RETURN;
        END IF;

        SELECT COUNT(*) INTO v_offset FROM TICKET;

        FOR i IN 1 .. p_amount LOOP
            v_fi        := PKG_SAMEN_festivals.give_random_number(1, v_fest_ids.COUNT);
            v_vi        := PKG_SAMEN_festivals.give_random_number(1, v_all_vis.COUNT);
            v_pi        := PKG_SAMEN_festivals.give_random_number(1, v_plat_pool.COUNT);
            v_tkt_date  := PKG_SAMEN_festivals.give_random_date(v_fest_starts(v_fi), v_fest_ends(v_fi));
            v_max_purch := LEAST(v_tkt_date, DATE '2026-03-10');
            v_barcode   := 'S' || LPAD(TO_CHAR(v_offset + i), 12, '0');
            v_type      := PKG_SAMEN_festivals.give_random_ticket_type;
            BEGIN
                INSERT INTO TICKET (TICKET_PRICE, TICKET_CURRENCY, TICKET_DATE,
                                    TICKET_PURCHASE_DATE, TICKET_DESCRIPTION,
                                    TICKET_BARCODE, TICKET_TYPE, TICKET_STATUS,
                                    TICKET_QR_CODE, TICKETPLATFORM_ID, VISITOR_ID, FESTIVAL_ID)
                VALUES (PKG_SAMEN_festivals.give_random_number(50, 500),
                        PKG_SAMEN_festivals.give_random_currency,
                        v_tkt_date,
                        PKG_SAMEN_festivals.give_random_date(
                            GREATEST(v_max_purch - 365, DATE '2020-01-01'), v_max_purch),
                        v_type || ' ticket for ' || v_fest_names(v_fi),
                        v_barcode,
                        v_type,
                        PKG_SAMEN_festivals.give_random_ticket_status,
                        'https://qr.rnd.be/' || v_barcode,
                        v_plat_pool(v_pi),
                        v_all_vis(v_vi),
                        v_fest_ids(v_fi));
                v_rows := v_rows + 1;
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN NULL;
            END;
        END LOOP;
        v_end := SYSTIMESTAMP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomTickets_single', 'p_amount=' || p_amount,
                                v_rows, 0,
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start));
    END generateRandomTickets_single;

    -- ---------------------------------------------------------
    -- generateRandomPermits_single
    --   Iterates over every festival (FESTIVAL_NAME included in
    --   BULK COLLECT) and inserts p_per_festival permits one
    --   at a time, referencing the real festival name.
    -- ---------------------------------------------------------
    PROCEDURE generateRandomPermits_single(p_per_festival IN NUMBER) IS
        v_fest_ids    t_id_tab;
        v_fest_names  t_str100;
        v_fest_starts t_date_tab;
        v_start       TIMESTAMP   := SYSTIMESTAMP;
        v_end         TIMESTAMP;
        v_rows        PLS_INTEGER := 0;
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
            DBMS_OUTPUT.PUT_LINE('generateRandomPermits_single: no festivals');  RETURN;
        END IF;

        FOR fi IN 1 .. v_fest_ids.COUNT LOOP
            v_max_app := LEAST(v_fest_starts(fi) - 1, DATE '2026-03-10');
            v_min_app := GREATEST(v_max_app - 365, DATE '2020-01-01');
            IF v_min_app > v_max_app THEN v_min_app := v_max_app; END IF;

            FOR j IN 1 .. p_per_festival LOOP
                v_app_date := PKG_SAMEN_festivals.give_random_date(v_min_app, v_max_app);
                v_rec_date := PKG_SAMEN_festivals.give_random_date(v_app_date + 1, v_app_date + 60);
                v_cat      := PKG_SAMEN_festivals.give_random_permit_category;
                BEGIN
                    INSERT INTO PERMIT (PERMIT_CATEGORY, PERMIT_DESCRIPTION,
                                        PERMIT_RECEPTION_DATE, PERMIT_EXPIRATION_DATE,
                                        PERMIT_APPLICATION_DATE, FESTIVAL_ID)
                    VALUES (v_cat,
                            v_cat || ' permit for ' || v_fest_names(fi),
                            v_rec_date,
                            PKG_SAMEN_festivals.give_random_date(v_rec_date + 1, v_rec_date + 180),
                            v_app_date,
                            v_fest_ids(fi));
                    v_rows := v_rows + 1;
                EXCEPTION
                    WHEN DUP_VAL_ON_INDEX THEN NULL;
                END;
            END LOOP;
        END LOOP;
        v_end := SYSTIMESTAMP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomPermits_single', 'p_per_festival=' || p_per_festival,
                                v_rows, 0,
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start),
                                PKG_SAMEN_festivals.timestamp_diff(v_end, v_start));
    END generateRandomPermits_single;

-- =============================================================
-- M6 – BULK GENERATORS WITH CHUNKING
-- Arrays capped at C_BULK_CHUNK; outer WHILE loop refills and
-- flushes until p_amount rows are inserted.  Prevents PGA
-- exhaustion at 400 000+ rows.  Gen time and insert time are
-- accumulated separately across chunks.
-- =============================================================

    -- ---------------------------------------------------------
    -- generateRandomCities_bulk
    -- ---------------------------------------------------------
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
                v_zips(i)  := 'Z' || LPAD(TO_CHAR(v_offset + v_done + i), 8, '0');
                v_names(i) := PKG_SAMEN_festivals.give_random_location
                           || '_' || LPAD(TO_CHAR(v_offset + v_done + i), 5, '0');
                v_cntrs(i) := PKG_SAMEN_festivals.give_random_country;
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

    -- ---------------------------------------------------------
    -- generateRandomCompanies_bulk
    -- ---------------------------------------------------------
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
        WHILE v_done < p_amount LOOP
            v_chunk := LEAST(p_amount - v_done, PKG_SAMEN_festivals.C_BULK_CHUNK);
            v_t0 := SYSTIMESTAMP;
            FOR i IN 1 .. v_chunk LOOP
                v_names(i) := 'RndCo_' || LPAD(TO_CHAR(v_offset + v_done + i), 6, '0');
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

    -- ---------------------------------------------------------
    -- generateRandomTicketplatforms_bulk
    -- ---------------------------------------------------------
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
        WHILE v_done < p_amount LOOP
            v_chunk := LEAST(p_amount - v_done, PKG_SAMEN_festivals.C_BULK_CHUNK);
            v_t0 := SYSTIMESTAMP;
            FOR i IN 1 .. v_chunk LOOP
                v_names(i) := PKG_SAMEN_festivals.give_random_platform_name
                           || '_' || LPAD(TO_CHAR(v_offset + v_done + i), 5, '0');
                v_urls(i)  := 'https://platform' || LPAD(TO_CHAR(v_offset + v_done + i), 8, '0') || '.com';
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

    -- ---------------------------------------------------------
    -- generateRandomVisitors_bulk
    --   City pool loaded once; rows produced in chunks.
    --   Email: firstname.lastname<counter>@<realistic-domain>
    -- ---------------------------------------------------------
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
        v_ci         PLS_INTEGER;
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
                v_ci         := PKG_SAMEN_festivals.give_random_number(1, v_city_ids.COUNT);
                v_fname      := PKG_SAMEN_festivals.give_random_first_name;
                v_lname      := PKG_SAMEN_festivals.give_random_last_name;
                v_fnames(i)  := v_fname;
                v_lnames(i)  := v_lname;
                v_births(i)  := PKG_SAMEN_festivals.give_random_date(DATE '1960-01-01', DATE '2005-12-31');
                v_emails(i)  := LOWER(v_fname) || '.' || LOWER(v_lname)
                             || (v_offset + v_done + i) || '@' || random_email_domain;
                v_streets(i) := PKG_SAMEN_festivals.give_random_street;
                v_snums(i)   := TO_CHAR(PKG_SAMEN_festivals.give_random_number(1, 999));
                v_cids(i)    := v_city_ids(v_ci);
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

    -- ---------------------------------------------------------
    -- generateRandomTickets_bulk
    --   Twelve INSERT arrays capped at C_BULK_CHUNK; freed
    --   between chunks so PGA stays bounded at 400 000+ rows.
    --   Barcodes use 'B' prefix (M5='R', single='S').
    -- ---------------------------------------------------------
    PROCEDURE generateRandomTickets_bulk(p_amount IN NUMBER) IS
        v_fest_ids    t_id_tab;
        v_fest_names  t_str100;
        v_fest_starts t_date_tab;
        v_fest_ends   t_date_tab;
        v_all_vis     t_id_tab;
        v_plat_pool   t_id_tab;
        v_start       TIMESTAMP   := SYSTIMESTAMP;
        v_gen_acc     NUMBER      := 0;
        v_ins_acc     NUMBER      := 0;
        v_t0          TIMESTAMP;
        v_t1          TIMESTAMP;
        v_offset      NUMBER;
        v_prices      t_num10_2;
        v_currencies  t_char3;
        v_tkt_dates   t_date_tab;
        v_purch_dates t_date_tab;
        v_descs       t_str100;
        v_barcodes    t_str14;
        v_types       t_str50;
        v_statuses    t_str50;
        v_qr_codes    t_str500;
        v_ins_plats   t_id_tab;
        v_ins_vis     t_id_tab;
        v_ins_fests   t_id_tab;
        v_chunk       PLS_INTEGER;
        v_done        PLS_INTEGER := 0;
        v_total_rows  PLS_INTEGER := 0;
        v_fi          PLS_INTEGER;
        v_vi          PLS_INTEGER;
        v_pi          PLS_INTEGER;
        v_tkt_date    DATE;
        v_max_purch   DATE;
        v_barcode     VARCHAR2(14);
        v_type        VARCHAR2(50);
        v_fest_count  PLS_INTEGER;
        v_vis_count   PLS_INTEGER;
        v_plat_count  PLS_INTEGER;
    BEGIN
        SELECT FESTIVAL_ID, FESTIVAL_NAME, FESTIVAL_STARTDATE, FESTIVAL_ENDDATE
            BULK COLLECT INTO v_fest_ids, v_fest_names, v_fest_starts, v_fest_ends
        FROM FESTIVAL;
        SELECT VISITOR_ID        BULK COLLECT INTO v_all_vis   FROM VISITOR;
        SELECT TICKETPLATFORM_ID BULK COLLECT INTO v_plat_pool FROM TICKETPLATFORM;

        IF v_fest_ids.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomTickets_bulk: no festivals');  RETURN;
        END IF;
        IF v_all_vis.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomTickets_bulk: no visitors');   RETURN;
        END IF;
        IF v_plat_pool.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('generateRandomTickets_bulk: no platforms');  RETURN;
        END IF;

        v_fest_count := v_fest_ids.COUNT;
        v_vis_count  := v_all_vis.COUNT;
        v_plat_count := v_plat_pool.COUNT;
        SELECT COUNT(*) INTO v_offset FROM TICKET;

        WHILE v_done < p_amount LOOP
            v_chunk := LEAST(p_amount - v_done, PKG_SAMEN_festivals.C_BULK_CHUNK);
            v_t0 := SYSTIMESTAMP;

            FOR i IN 1 .. v_chunk LOOP
                v_fi        := PKG_SAMEN_festivals.give_random_number(1, v_fest_count);
                v_vi        := PKG_SAMEN_festivals.give_random_number(1, v_vis_count);
                v_pi        := PKG_SAMEN_festivals.give_random_number(1, v_plat_count);
                v_tkt_date  := PKG_SAMEN_festivals.give_random_date(v_fest_starts(v_fi), v_fest_ends(v_fi));
                v_max_purch := LEAST(v_tkt_date, DATE '2026-03-10');
                v_barcode   := 'B' || LPAD(TO_CHAR(v_offset + v_done + i), 12, '0');
                v_type      := PKG_SAMEN_festivals.give_random_ticket_type;

                v_prices(i)      := PKG_SAMEN_festivals.give_random_number(50, 500);
                v_currencies(i)  := PKG_SAMEN_festivals.give_random_currency;
                v_tkt_dates(i)   := v_tkt_date;
                v_purch_dates(i) := PKG_SAMEN_festivals.give_random_date(
                                        GREATEST(v_max_purch - 365, DATE '2020-01-01'), v_max_purch);
                v_descs(i)       := v_type || ' ticket for ' || v_fest_names(v_fi);
                v_barcodes(i)    := v_barcode;
                v_types(i)       := v_type;
                v_statuses(i)    := PKG_SAMEN_festivals.give_random_ticket_status;
                v_qr_codes(i)    := 'https://qr.rnd.be/' || v_barcode;
                v_ins_plats(i)   := v_plat_pool(v_pi);
                v_ins_vis(i)     := v_all_vis(v_vi);
                v_ins_fests(i)   := v_fest_ids(v_fi);
            END LOOP;

            v_t1      := SYSTIMESTAMP;
            v_gen_acc := v_gen_acc + PKG_SAMEN_festivals.timestamp_diff(v_t1, v_t0);

            BEGIN
                FORALL i IN 1 .. v_chunk SAVE EXCEPTIONS
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

            v_done := v_done + v_chunk;
            v_prices.DELETE;      v_currencies.DELETE;  v_tkt_dates.DELETE;
            v_purch_dates.DELETE; v_descs.DELETE;       v_barcodes.DELETE;
            v_types.DELETE;       v_statuses.DELETE;    v_qr_codes.DELETE;
            v_ins_plats.DELETE;   v_ins_vis.DELETE;     v_ins_fests.DELETE;
        END LOOP;
        COMMIT;
        PKG_SAMEN_festivals.log('generateRandomTickets_bulk', 'p_amount=' || p_amount,
                                v_total_rows, v_gen_acc, v_ins_acc,
                                PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_start));
    END generateRandomTickets_bulk;

    -- ---------------------------------------------------------
    -- generateRandomPermits_bulk
    --   FESTIVAL_NAME loaded alongside FESTIVAL_ID so the
    --   description references the real festival name.
    --   Rows accumulate in a buffer; flushed per C_BULK_CHUNK.
    -- ---------------------------------------------------------
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
            v_max_app := LEAST(v_fest_starts(fi) - 1, DATE '2026-03-10');
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
-- Mirror the M5 base/children split so SAMEN can orchestrate:
--   bewijs_milestone_6_S1_base_*   → bewijs_M6_S2 → bewijs_milestone_6_S1_children_*
-- S2 must run between base and children due to cross-schema FKs:
--   FESTIVAL (S2) -> COMPANY/CITY (S1)   base must precede S2
--   TICKET/PERMIT (S1) -> FESTIVAL (S2)  children must follow S2
-- =============================================================

    PROCEDURE bewijs_milestone_6_S1_base_single(p_cities    IN NUMBER,
                                                p_companies IN NUMBER,
                                                p_platforms IN NUMBER,
                                                p_visitors  IN NUMBER) IS
        v_start TIMESTAMP := SYSTIMESTAMP;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== bewijs_milestone_6_S1_base_single START ===');
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
-- Each run: reset to M4 baseline → S1 base → S2 → S1 children
-- S2 time excluded from S1 timing so the comparison is fair.
-- Per-table gen/insert timings appear in individual [LOG] lines.
-- =============================================================

    PROCEDURE bewijs_milestone_6_S1(p_visitors         IN NUMBER,
                                    p_companies        IN NUMBER,
                                    p_platforms        IN NUMBER,
                                    p_tickets          IN NUMBER,
                                    p_permits_per_fest IN NUMBER,
                                    p_genres           IN NUMBER,
                                    p_festivals        IN NUMBER,
                                    p_stages           IN NUMBER,
                                    p_perfs            IN NUMBER,
                                    p_mode             IN VARCHAR2) IS
        v_mode           VARCHAR2(10) := UPPER(TRIM(p_mode));
        v_total_start    TIMESTAMP   := SYSTIMESTAMP;
        v_base_start     TIMESTAMP;
        v_s2_start       TIMESTAMP;
        v_children_start TIMESTAMP;
        v_single_total   NUMBER      := 0;
        v_bulk_total     NUMBER      := 0;
        v_aux_cities     PLS_INTEGER := GREATEST(CEIL(p_visitors / 20), 50);
    BEGIN
        IF v_mode NOT IN ('BOTH', 'BULK', 'SINGLE') THEN
            RAISE_APPLICATION_ERROR(-20020,
                'bewijs_milestone_6_S1: invalid mode "' || p_mode
                || '". Use BOTH, BULK, or SINGLE.');
        END IF;

        DBMS_OUTPUT.PUT_LINE('========================================');
        DBMS_OUTPUT.PUT_LINE('bewijs_milestone_6_S1  mode=' || v_mode);
        DBMS_OUTPUT.PUT_LINE('  visitors='         || p_visitors
                          || '  companies='        || p_companies
                          || '  platforms='        || p_platforms
                          || '  tickets='          || p_tickets
                          || '  permits_per_fest=' || p_permits_per_fest);
        DBMS_OUTPUT.PUT_LINE('  genres='    || p_genres
                          || '  festivals=' || p_festivals
                          || '  stages='    || p_stages
                          || '  perfs='     || p_perfs);
        DBMS_OUTPUT.PUT_LINE('========================================');

        -- ======================================================
        -- SINGLE-INSERT run
        -- ======================================================
        IF v_mode IN ('BOTH', 'SINGLE') THEN
            DBMS_OUTPUT.PUT_LINE('--- [SINGLE] resetting to M4 baseline ---');
            empty_s1_children;
            PKG_S2_festivals.empty_tables_S2;
            empty_s1_base;
            fill_s1_base;
            PKG_S2_festivals.bewijs_M4_S2;
            fill_s1_children;

            -- S1 base (timed)
            v_base_start := SYSTIMESTAMP;
            bewijs_milestone_6_S1_base_single(v_aux_cities, p_companies, p_platforms, p_visitors);

            -- S2 hierarchy (not timed – identical cost for both methods)
            -- TODO: replace with PKG_S2_festivals.bewijs_M6_S2 once available
            v_s2_start := SYSTIMESTAMP;
            DBMS_OUTPUT.PUT_LINE('--- [SINGLE] S2 hierarchy ---');
            PKG_S2_festivals.bewijs_M5_S2(p_genres, p_festivals, p_stages, p_perfs);

            -- S1 children (timed)
            v_children_start := SYSTIMESTAMP;
            bewijs_milestone_6_S1_children_single(p_tickets, p_permits_per_fest);

            -- S1-only time: base + children; S2 excluded
            v_single_total := PKG_SAMEN_festivals.timestamp_diff(v_s2_start,       v_base_start)
                           + PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_children_start);
            DBMS_OUTPUT.PUT_LINE('--- [SINGLE] S1 total (S2 excluded): '
                || ROUND(v_single_total * 1000) || ' ms ---');
        END IF;

        -- ======================================================
        -- BULK-INSERT run
        -- ======================================================
        IF v_mode IN ('BOTH', 'BULK') THEN
            DBMS_OUTPUT.PUT_LINE('--- [BULK] resetting to M4 baseline ---');
            empty_s1_children;
            PKG_S2_festivals.empty_tables_S2;
            empty_s1_base;
            fill_s1_base;
            PKG_S2_festivals.bewijs_M4_S2;
            fill_s1_children;

            -- S1 base (timed)
            v_base_start := SYSTIMESTAMP;
            bewijs_milestone_6_S1_base_bulk(v_aux_cities, p_companies, p_platforms, p_visitors);

            -- S2 hierarchy (not timed – identical cost for both methods)
            -- TODO: replace with PKG_S2_festivals.bewijs_M6_S2 once available
            v_s2_start := SYSTIMESTAMP;
            DBMS_OUTPUT.PUT_LINE('--- [BULK] S2 hierarchy ---');
            PKG_S2_festivals.bewijs_M5_S2(p_genres, p_festivals, p_stages, p_perfs);

            -- S1 children (timed)
            v_children_start := SYSTIMESTAMP;
            bewijs_milestone_6_S1_children_bulk(p_tickets, p_permits_per_fest);

            -- S1-only time: base + children; S2 excluded
            v_bulk_total := PKG_SAMEN_festivals.timestamp_diff(v_s2_start,       v_base_start)
                         + PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_children_start);
            DBMS_OUTPUT.PUT_LINE('--- [BULK] S1 total (S2 excluded): '
                || ROUND(v_bulk_total * 1000) || ' ms ---');
        END IF;

        -- ======================================================
        -- Comparison summary (only when both ran)
        -- ======================================================
        IF v_mode = 'BOTH' THEN
            DBMS_OUTPUT.PUT_LINE('========================================');
            DBMS_OUTPUT.PUT_LINE('SINGLE vs BULK comparison (S1 time only)');
            DBMS_OUTPUT.PUT_LINE('  SINGLE: ' || ROUND(v_single_total * 1000) || ' ms');
            DBMS_OUTPUT.PUT_LINE('  BULK  : ' || ROUND(v_bulk_total   * 1000) || ' ms');
            IF v_bulk_total > 0 THEN
                DBMS_OUTPUT.PUT_LINE('  Speedup: '
                    || ROUND(v_single_total / v_bulk_total, 2) || 'x  (bulk vs single)');
            END IF;
            DBMS_OUTPUT.PUT_LINE('========================================');
        END IF;

        DBMS_OUTPUT.PUT_LINE('bewijs_milestone_6_S1 END  elapsed: '
            || ROUND(PKG_SAMEN_festivals.timestamp_diff(SYSTIMESTAMP, v_total_start) * 1000)
            || ' ms');
    END bewijs_milestone_6_S1;

END PKG_S1_festivals;
/