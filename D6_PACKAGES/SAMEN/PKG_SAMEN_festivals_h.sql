CREATE OR REPLACE PACKAGE PKG_SAMEN_festivals AS
    -- =========================================================
    -- MILESTONE 5 – SAMEN package (festivals domain)
    -- Contains shared random helpers + proof procedure
    -- =========================================================

    -- -------------------------------------------------------
    -- Shared bulk-INSERT plumbing (used by S1 and S2 generators)
    -- -------------------------------------------------------
    -- ORA-24381 is raised when FORALL ... SAVE EXCEPTIONS skips at
    -- least one row.  Mapping it to a named exception lets every
    -- generator catch the partial-failure case without duplicating
    -- the PRAGMA in every package body.
    bulk_errors EXCEPTION;
    PRAGMA EXCEPTION_INIT(bulk_errors, -24381);

    -- Chunk size used by the parent-child generators when flushing
    -- accumulated PL/SQL arrays back to the SQL engine.  Bounds PGA
    -- usage on the 50k-row inserts.
    C_BULK_CHUNK CONSTANT PLS_INTEGER := 1000000;

    -- -------------------------------------------------------
    -- Shared logging helpers (used by S1 and S2 generators)
    -- -------------------------------------------------------
    -- Standard end-of-procedure log line:
    --   gen   = time spent collecting random data into PL/SQL arrays
    --   ins   = time spent inside the FORALL bulk insert
    --   total = overall procedure duration
    PROCEDURE log(p_proc       IN VARCHAR2,
                  p_param      IN VARCHAR2,
                  p_rows       IN NUMBER,
                  p_gen_secs   IN NUMBER,
                  p_ins_secs   IN NUMBER,
                  p_total_secs IN NUMBER);

    -- Summarises rows that SAVE EXCEPTIONS skipped: one line per
    -- distinct error code, with the count of skipped rows.
    PROCEDURE log_bulk_errors(p_proc IN VARCHAR2);

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
    FUNCTION give_random_location RETURN VARCHAR2;
    FUNCTION give_random_country RETURN VARCHAR2;
    FUNCTION give_random_artist_prefix RETURN VARCHAR2;
    FUNCTION give_random_stage_suffix RETURN VARCHAR2;
    FUNCTION give_random_festival_suffix RETURN VARCHAR2;
    FUNCTION give_random_ticket_type RETURN VARCHAR2;
    FUNCTION give_random_ticket_status RETURN VARCHAR2;
    FUNCTION give_random_currency RETURN VARCHAR2;
    FUNCTION give_random_gender RETURN VARCHAR2;
    FUNCTION give_random_street RETURN VARCHAR2;
    FUNCTION give_random_first_name RETURN VARCHAR2;
    FUNCTION give_random_last_name RETURN VARCHAR2;
    FUNCTION give_random_permit_category RETURN VARCHAR2;
    FUNCTION give_random_platform_name RETURN VARCHAR2;
    FUNCTION give_random_description RETURN VARCHAR2;

    -- 4) Random combo: domain list item + zero-padded counter
    --    e.g. give_random_combo('BassDrop', 42) --> 'BassDrop_0042'
    FUNCTION give_random_combo(p_base IN VARCHAR2, p_counter IN NUMBER)
        RETURN VARCHAR2;

    -- 4b) Same as give_random_combo but with a SYS_GUID suffix so the
    --     result is guaranteed unique even when the same (base, counter)
    --     pair would otherwise collide across runs or with existing rows.
    --     Used by S2 generators that must satisfy UNIQUE constraints
    --     on Festival_Name and Stage_Name.
    FUNCTION give_unique_combo(p_base IN VARCHAR2, p_counter IN NUMBER)
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
