CREATE OR REPLACE PACKAGE PKG_SAMEN_festivals AS

    -- =========================================================
    -- MILESTONE 5 – SAMEN package (festivals domain)
    -- Contains shared random helpers + proof procedure
    -- =========================================================

    -- -------------------------------------------------------
    -- STAP 1: Random helper functions
    -- -------------------------------------------------------

    -- 1) Random integer within a range
    FUNCTION give_random_number(p_min IN NUMBER, p_max IN NUMBER)
        RETURN NUMBER;

    -- 2) Random date between two dates
    FUNCTION give_random_date(p_start IN DATE, p_end IN DATE)
        RETURN DATE;

    -- 3) Random item from a domain-specific list (genres)
    FUNCTION give_random_genre RETURN VARCHAR2;

    -- Additional domain lists (used by S1 and S2 random generators)
    FUNCTION give_random_location        RETURN VARCHAR2;
    FUNCTION give_random_country         RETURN VARCHAR2;
    FUNCTION give_random_artist_prefix   RETURN VARCHAR2;
    FUNCTION give_random_stage_suffix    RETURN VARCHAR2;
    FUNCTION give_random_festival_suffix RETURN VARCHAR2;
    FUNCTION give_random_ticket_type     RETURN VARCHAR2;
    FUNCTION give_random_ticket_status   RETURN VARCHAR2;
    FUNCTION give_random_currency        RETURN VARCHAR2;
    FUNCTION give_random_gender          RETURN VARCHAR2;
    FUNCTION give_random_street          RETURN VARCHAR2;
    FUNCTION give_random_first_name      RETURN VARCHAR2;
    FUNCTION give_random_last_name       RETURN VARCHAR2;
    FUNCTION give_random_permit_category RETURN VARCHAR2;
    FUNCTION give_random_platform_name   RETURN VARCHAR2;

    -- 4) Random combo: domain list item + zero-padded counter
    --    e.g. give_random_combo('BassDrop', 42) --> 'BassDrop_0042'
    FUNCTION give_random_combo(p_base IN VARCHAR2, p_counter IN NUMBER)
        RETURN VARCHAR2;

    -- Precision timer helper (provided by assignment)
    FUNCTION timestamp_diff(a TIMESTAMP, b TIMESTAMP)
        RETURN NUMBER;

    -- -------------------------------------------------------
    -- STAP 4: Proof – demonstrates all random functions via
    --         DBMS_OUTPUT and logs timing with timestamp_diff
    -- -------------------------------------------------------
    PROCEDURE bewijs_Random_M5;

END PKG_SAMEN_festivals;
/
