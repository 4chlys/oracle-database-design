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
        v_ticketplatform_id := lookup_ticketplatform_id(p_ticketplatform_name);;
        v_visitor_id := lookup_visitor_id(p_visitor_firstname, p_visitor_lastname);
        v_festival_id := lookup_festival_id(p_festival_name);

        SELECT FESTIVAL_STARTDATE, FESTIVAL_ENDDATE
        INTO v_festival_start, v_festival_end
        FROM FESTIVAL
        WHERE FESTIVAL_ID = v_festival_id;;

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

END PKG_S1_festivals;
/