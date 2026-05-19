-- =====================================================================
-- S2 - Milestone 7 - Materialized View Logs
-- Run order: 04
-- =====================================================================
-- Required for REFRESH FAST ON COMMIT.
-- Each base table referenced by the MV needs a log that captures:
--   * ROWID                  (mandatory for join MVs)
--   * INCLUDING NEW VALUES   (mandatory for aggregate MVs)
--   * Every column used by the MV in its filter, group-by and aggregates
-- =====================================================================

DROP MATERIALIZED VIEW LOG ON Performance;
DROP MATERIALIZED VIEW LOG ON Stage;
DROP MATERIALIZED VIEW LOG ON Festival;
DROP MATERIALIZED VIEW LOG ON Artist;

CREATE MATERIALIZED VIEW LOG ON Performance
    WITH ROWID, SEQUENCE
    (Performance_Start_Time, Performance_End_Time, Stage_ID, Artist_ID)
    INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON Stage
    WITH ROWID, SEQUENCE
    (Stage_ID, Festival_ID)
    INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON Festival
    WITH ROWID, SEQUENCE
    (Festival_ID, Festival_Name)
    INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON Artist
    WITH ROWID, SEQUENCE
    (Artist_ID, Artist_Price)
    INCLUDING NEW VALUES;