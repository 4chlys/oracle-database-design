-- ===========================================================================
-- bewijs_milestone_code.sql — Milestone 4
-- Each empty procedure does ALTER TABLE (identity reset), which invalidates
-- the package that ran it. We isolate each empty call in its own block and
-- recompile the affected package before continuing. Fills do no DDL, so they
-- all run in one final block.
-- ===========================================================================

-- Phase 1a: empty S1 children (TICKET, PERMIT) -> invalidates PKG_S1
BEGIN
    PKG_S1_festivals.empty_s1_children;
END;
/
ALTER PACKAGE PKG_S1_festivals COMPILE BODY;
/

-- Phase 1b: empty S2 (PERFORMANCE, STAGE, FESTIVAL, ARTIST, GENRE) -> invalidates PKG_S2
BEGIN
    PKG_S2_festivals.empty_tables_S2;
END;
/
ALTER PACKAGE PKG_S2_festivals COMPILE BODY;
/

-- Phase 1c: empty S1 base (TICKETPLATFORM, VISITOR, COMPANY, CITY) -> invalidates PKG_S1
BEGIN
    PKG_S1_festivals.empty_s1_base;
END;
/
ALTER PACKAGE PKG_S1_festivals COMPILE BODY;
/

-- Phase 2: fills (no DDL, so one block is fine)
BEGIN
    PKG_S1_festivals.fill_s1_base;        -- COMPANY, CITY, VISITOR, TICKETPLATFORM
    PKG_S2_festivals.bewijs_M4_S2;        -- FESTIVAL, GENRE, ARTIST, STAGE, PERFORMANCE
    PKG_S1_festivals.fill_s1_children;    -- PERMIT, TICKET
END;
/
