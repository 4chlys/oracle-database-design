CREATE OR REPLACE PACKAGE PKG_S2_festivals AS
    -- =====================================================================
    -- M4 – Empty + fill (initial demo data)
    -- =====================================================================
    -- PUBLIC: Empty all S2 tables
    -- (Performance, Stage, Festival, Artist, Genre)
    PROCEDURE empty_tables_S2;

    -- PUBLIC: Fill all S2 tables with M4 sample data
    PROCEDURE bewijs_M4_S2;

    -- =====================================================================
    -- Lookups (used by other packages and by single-row add procedures)
    -- =====================================================================
    FUNCTION lookup_festival_id(p_festival_name IN FESTIVAL.FESTIVAL_NAME%type) RETURN FESTIVAL.FESTIVAL_ID%type;

    -- =====================================================================
    -- M5 – BULK random generators (FORALL bulk DML)
    -- Already use BULK in M5; remain unchanged for M6 comparison.
    -- =====================================================================
    PROCEDURE generateRandomGenres(p_amount IN NUMBER);
    PROCEDURE generateRandomArtists(p_amount IN NUMBER);
    PROCEDURE generateRandomFestivals(p_amount IN NUMBER);
    PROCEDURE generateRandomStages(p_per_festival IN NUMBER);
    PROCEDURE generateRandomPerformances(p_per_stage IN NUMBER);

    -- Parameters follow the W-X-Y-Z order from the assignment:
    --   p_genres    = W count (Genre rows, Artist = p_genres*10)
    --   p_festivals = X count (Festival rows)
    --   p_stages    = Y per X (Stage rows per Festival)
    --   p_perfs     = Z per Y (Performance rows per Stage)
    PROCEDURE bewijs_M5_S2(p_genres    IN NUMBER,
                           p_festivals IN NUMBER,
                           p_stages    IN NUMBER,
                           p_perfs     IN NUMBER);

    -- =====================================================================
    -- M6 – SINGLE-row insert generators (for performance comparison)
    -- Naming note: M5 was implemented in BULK, so for M6 we add the
    -- SINGLE counterparts with postfix _single (mirror of the assignment's
    -- _bulk postfix that applies to students who started from single inserts).
    -- =====================================================================
    PROCEDURE generateRandomGenres_single(p_amount IN NUMBER);
    PROCEDURE generateRandomArtists_single(p_amount IN NUMBER);
    PROCEDURE generateRandomFestivals_single(p_amount IN NUMBER);
    PROCEDURE generateRandomStages_single(p_per_festival IN NUMBER);
    PROCEDURE generateRandomPerformances_single(p_per_stage IN NUMBER);

    -- =====================================================================
    -- M6 – Proof procedure: runs SINGLE and/or BULK and logs timing
    --   p_mode = 'BOTH'   : both generation methods are run
    --   p_mode = 'BULK'   : only the bulk methods are run
    --   p_mode = 'SINGLE' : only the single-insert methods are run
    -- Before each method run, the S2 tables are emptied and refilled with
    -- M4 data so both runs start from the same baseline.
    -- =====================================================================
    PROCEDURE bewijs_milestone_6_S2(p_genres    IN NUMBER,
                                    p_festivals IN NUMBER,
                                    p_stages    IN NUMBER,
                                    p_perfs     IN NUMBER,
                                    p_mode      IN VARCHAR2 DEFAULT 'BOTH');

END PKG_S2_festivals;
/
