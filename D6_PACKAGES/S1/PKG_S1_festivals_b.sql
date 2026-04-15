CREATE OR REPLACE PACKAGE BODY PKG_S1_festivals AS

    -- PUBLIC LOOKUP (also used internally by this package)
    FUNCTION lookup_company_id(p_company_name in VARCHAR2) RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT COMPANY_ID
        INTO v_id
        FROM COMPANY
        WHERE COMPANY_NAME = p_company_name;
        RETURN v_id;
    END;

    -- ---------------------------------------------------------

    FUNCTION
        lookup_city_id(p_zipcode IN VARCHAR2, p_country IN VARCHAR2)
        RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT City_ID
        INTO v_id
        FROM City
        WHERE Zipcode = p_zipcode
          AND Country = p_country;
        RETURN v_id;
    END lookup_city_id;

    -- PRIVATE LOOKUP FUNCTIONS
    FUNCTION lookup_visitor_id(p_visitor_firstname IN VARCHAR2, p_visitor_lastname IN VARCHAR2)
        RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT VISITOR_ID
        INTO v_id
        FROM VISITOR
        WHERE VISITOR_FIRSTNAME = p_visitor_firstname
          AND VISITOR_LASTNAME = p_visitor_lastname;
        RETURN v_id;
    END lookup_visitor_id;

    -- ---------------------------------------------------------

    FUNCTION
        lookup_ticket_id(p_ticketplatform_id IN NUMBER, p_visitor_id in NUMBER, p_festival_id in NUMBER)
        RETURN NUMBER IS
        v_id NUMBER;
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

    FUNCTION
        lookup_ticketplatform_id(p_ticketplatform_name IN VARCHAR2)
        RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT TICKETPLATFORM_ID
        INTO v_id
        FROM TICKETPLATFORM
        WHERE TICKETPLATFORM_NAME = p_ticketplatform_name;
        RETURN v_id;
    END lookup_ticketplatform_id;

    -- ---------------------------------------------------------

    FUNCTION
        lookup_permit_id(p_festival_id IN NUMBER, p_category IN VARCHAR2,
                         p_application_date IN PERMIT.PERMIT_APPLICATION_DATE%type)
        RETURN NUMBER IS
        v_id NUMBER;
    BEGIN
        SELECT PERMIT_ID
        INTO v_id
        FROM PERMIT
        WHERE (FESTIVAL_ID, PERMIT_CATEGORY, PERMIT_APPLICATION_DATE) = (p_festival_id, p_category, p_application_date);
        RETURN v_id;
    END lookup_permit_id;

    -- ---------------------------------------------------------------------------------------------------------------------
    -- PRIVATE ADD PROCEDURES

    PROCEDURE add_company(p_company_name IN VARCHAR2,
                          p_company_founding_year IN NUMBER) IS
    BEGIN
        INSERT INTO COMPANY (COMPANY_NAME, COMPANY_FOUNDING_YEAR)
        VALUES (p_company_name, p_company_founding_year);
    END add_company;

    -- ---------------------------------------------------------

    PROCEDURE add_city(p_zipcode IN VARCHAR2,
                       p_city IN VARCHAR2,
                       p_country IN VARCHAR2) IS
    BEGIN
        INSERT INTO CITY (ZIPCODE, CITY, COUNTRY)
        VALUES (p_city, p_zipcode, p_country);
    END add_city;

    -- ---------------------------------------------------------

    PROCEDURE add_visitor(p_firstname IN VARCHAR2, p_lastname IN VARCHAR2,
                          p_birthdate IN VISITOR.VISITOR_BIRTHDATE%type, p_email IN VARCHAR2, p_street_name IN VARCHAR2,
                          p_street_number IN VARCHAR2, p_zipcode IN VARCHAR2, p_country IN VARCHAR2,
                          p_gender IN VARCHAR2) IS
        v_city_id NUMBER;
    BEGIN
        v_city_id := lookup_city_id(p_zipcode, p_country);
        INSERT INTO VISITOR (VISITOR_FIRSTNAME, VISITOR_LASTNAME, VISITOR_BIRTHDATE, VISITOR_EMAIL, VISITOR_STREET_NAME,
                             VISITOR_STREET_NUMBER, CITY_ID, VISITOR_GENDER)
        VALUES (p_firstname, p_lastname, p_birthdate, p_email, p_street_name, p_street_number, v_city_id, p_gender);
    END add_visitor;

    -- ---------------------------------------------------------

    PROCEDURE add_ticketplatform(p_name IN VARCHAR2, p_url IN VARCHAR2) IS
    BEGIN
        INSERT INTO TICKETPLATFORM (TICKETPLATFORM_NAME, TICKETPLATFORM_URL)
        VALUES (p_name, p_url);
    END add_ticketplatform;

    -- ---------------------------------------------------------

    PROCEDURE add_permit(p_category IN VARCHAR2,
                         p_description IN VARCHAR2,
                         p_reception_date IN PERMIT.PERMIT_RECEPTION_DATE%type,
                         p_expiration_date IN PERMIT.PERMIT_EXPIRATION_DATE%type,
                         p_application_date IN PERMIT.PERMIT_APPLICATION_DATE%type,
                         p_festival_name IN VARCHAR2) IS
        v_festival_id NUMBER;
    BEGIN
        v_festival_id := lookup_festival_id(p_festival_name);

        INSERT INTO PERMIT (PERMIT_CATEGORY, PERMIT_DESCRIPTION, PERMIT_RECEPTION_DATE, PERMIT_EXPIRATION_DATE,
                            PERMIT_APPLICATION_DATE, FESTIVAL_ID)
        VALUES (p_category, p_description, p_reception_date, p_expiration_date, p_application_date, v_festival_id);
    END add_permit;

    -- ---------------------------------------------------------

    PROCEDURE add_ticket(p_price IN NUMBER,
                         p_currency IN NUMBER,
                         p_date IN TICKET.TICKET_DATE%type,
                         p_purchase_date IN TICKET.TICKET_PURCHASE_DATE%type,
                         p_description IN VARCHAR2,
                         p_barcode IN TICKET.TICKET_BARCODE%type,
                         p_type IN TICKET.TICKET_TYPE%type,
                         p_status IN TICKET.TICKET_STATUS%type,
                         p_qr_code IN TICKET.TICKET_QR_CODE%type,
                         p_ticketplatform_name IN VARCHAR2,
                         p_visitor_firstname IN VARCHAR2,
                         p_visitor_lastname IN VARCHAR2,
                         p_festival_name IN VARCHAR2) IS
        v_festival_start    DATE;
        v_festival_end      DATE;
        v_ticketplatform_id NUMBER;
        v_visitor_id        NUMBER;
        v_festival_id       NUMBER;
    BEGIN
        -- S2 date rule: performance start must fall within the parent Festival's dates
        v_ticketplatform_id := lookup_ticketplatform_id(p_ticketplatform_name);
        v_visitor_id := lookup_visitor_id(p_visitor_firstname, p_visitor_lastname);
        v_festival_id := lookup_festival_id(p_festival_name);

        SELECT FESTIVAL_STARTDATE, FESTIVAL_ENDDATE
        INTO v_festival_start, v_festival_end
        FROM FESTIVAL
        WHERE FESTIVAL_ID = v_festival_id;

        IF p_date NOT BETWEEN (v_festival_start AND v_festival_end) AND p_purchase_date > v_festival_end OR
           p_purchase_date > p_date THEN
            RAISE_APPLICATION_ERROR(-20001,
                                    'Ticket date ' || TO_CHAR(p_date, 'DD-MM-YYYY') ||
                                    ' must fall within festival dates (' ||
                                    TO_CHAR(v_festival_start, 'DD-MM-YYYY') || ' - ' ||
                                    TO_CHAR(v_festival_end, 'DD-MM-YYYY') || ') and after the purchase date (' ||
                                    TO_CHAR(p_purchase_date, 'DD-MM-YYYY') || ').';
        END IF;

        INSERT INTO TICKET (TICKET_PRICE, TICKET_CURRENCY, TICKET_DATE, TICKET_PURCHASE_DATE, TICKET_DESCRIPTION,
                            TICKET_BARCODE, TICKET_TYPE, TICKET_STATUS, TICKET_QR_CODE, TICKETPLATFORM_ID, VISITOR_ID,
                            FESTIVAL_ID)
        VALUES (p_price, p_currency, p_date, p_purchase_date, p_description, p_barcode, p_type, p_status, p_qr_code,
                v_ticketplatform_id, v_visitor_id, v_festival_id);
    END add_ticket;

-- ---------------------------------------------------------------------------------------------------------------------


-- ---------------------------------------------------------------------------------------------------------------------

-- PUBLIC: EMPTY TABLES

    PROCEDURE empty_tables_S1 IS
    BEGIN
        -- Delete in FK order: deepest children first
        -- Ticket references Festival, Ticketplatform, Visitor
        -- Permit references Festival
        -- Visitor references City
        -- Festival is referenced by Stage (S2 tables) but Festival is owned by S2
        -- In the SAMEN script we call S1 empty first, then S2 empty.
        DELETE FROM TICKET;
        DELETE FROM PERMIT;
        DELETE FROM TICKETPLATFORM;
        DELETE FROM VISITOR;
        DELETE FROM COMPANY;
        DELETE FROM CITY;

        -- Reset identity sequences
        EXECUTE IMMEDIATE 'ALTER TABLE TICKET MODIFY TICKET_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
        EXECUTE IMMEDIATE 'ALTER TABLE PERMIT MODIFY PERMIT_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
        EXECUTE IMMEDIATE 'ALTER TABLE TICKETPLATFORM MODIFY TICKETPLATFORM_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
        EXECUTE IMMEDIATE 'ALTER TABLE VISITOR MODIFY VISITOR_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
        EXECUTE IMMEDIATE 'ALTER TABLE COMPANY MODIFY COMPANY_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';
        EXECUTE IMMEDIATE 'ALTER TABLE CITY MODIFY CITY_ID GENERATED ALWAYS AS IDENTITY (START WITH 1)';

        COMMIT;
    END empty_tables_S1;

-- =============================================================
-- bewijs_M4_S1
-- Proof-of-concept procedure for Milestone 4 – Student 1
-- Empties all S1 tables and refills them via 
-- NOTE: FESTIVAL table is owned by S2; this procedure deliberately
--       does NOT touch it.  The tickets below reference festivals
--       that S2 must have inserted before bewijs_M4_S1 is called,
--       or the SAMEN script must call S2 fill first.
-- =============================================================

    PROCEDURE bewijs_M4_S1 IS
    BEGIN
        -- ----------------------------------------------------------------
        -- 1. EMPTY all S1 tables (resets identity sequences to 1)
        -- ----------------------------------------------------------------
        empty_tables_S1();
        -- ----------------------------------------------------------------
        -- 2. COMPANY  (10 rows)
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

        -- ----------------------------------------------------------------
        -- 6. PERMIT  (20 rows)
        --    Festival rows are assumed present (inserted by S2 fill).
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

    END bewijs_M4_S1;

END PKG_S1_festivals;
/