-- =====================================================================
-- S2 - Milestone 7 - Refill the database with similar data
-- Run order: 07 (then re-run 01_stats and 03_explain)
-- =====================================================================
-- Assignment step: "Vul de database opnieuw met gelijkaardige data
-- (zelfde aantallen)" - to demonstrate that the materialized view stays
-- in sync via REFRESH FAST ON COMMIT, and that the optimised plan still
-- uses MAT_VIEW REWRITE ACCESS after data has changed.
--
-- After running this script, re-run in order:
--   1. S2_OPT_01_stats.sql   - re-gather statistics
--   2. S2_OPT_03_explain.sql - confirm the plan still uses the MV
-- =====================================================================
BEGIN
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'PERFORMANCE');
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'STAGE');
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'FESTIVAL');
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'ARTIST');
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'GENRE');
END;
BEGIN
    PKG_S2_festivals.generateRandomPerformances(10);
    COMMIT;
END;
/

-- MV-log backlog should be drained by REFRESH FAST ON COMMIT
SELECT COUNT(*) AS mlog_pending FROM mlog$_performance;

-- MV should report FRESH with a recent last_refresh_date
SELECT mview_name, refresh_method, refresh_mode, staleness, last_refresh_date
FROM   user_mviews
WHERE  mview_name = 'MV_S2_FESTIVAL_PROGRAMMING';

-- MV aggregate should match the new Performance row count
SELECT (SELECT SUM(Performance_Count) FROM MV_S2_Festival_Programming) AS mv_total,
       (SELECT COUNT(*)               FROM Performance)                AS table_total
FROM   dual;
