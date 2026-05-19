-- =====================================================================
-- S2 - Milestone 7 - NEGATIVE consequences of the materialized view
-- Run order: 06
-- =====================================================================
-- We show three downsides:
--   1. STORAGE OVERHEAD - the MV and the four MV logs occupy disk space
--      on top of the original tables.
--   2. DML SLOWDOWN  - because the MV is REFRESH FAST ON COMMIT, every
--      transaction that touches a base table also has to maintain the
--      MV log and run an incremental refresh. INSERTs into Performance
--      become noticeably slower.
--   3. STALENESS - if we switch the MV to ON DEMAND, a SELECT through
--      the MV returns out-of-date data until DBMS_MVIEW.REFRESH is run.
-- =====================================================================
SELECT mview_name, refresh_method, refresh_mode, rewrite_enabled, compile_state, staleness
FROM   user_mviews
WHERE  mview_name = 'MV_S2_FESTIVAL_PROGRAMMING';
-- ---------------------------------------------------------------------
-- 1) STORAGE OVERHEAD
--    MV segment + 4 MV-log segments
-- ---------------------------------------------------------------------
SELECT s.segment_name, s.segment_type, ROUND(s.bytes/1024/1024, 3) AS MB
FROM   user_segments s
WHERE  s.segment_name = 'MV_S2_FESTIVAL_PROGRAMMING'
UNION ALL
SELECT m.log_table, 'MV LOG', ROUND(s.bytes/1024/1024, 3)
FROM   user_mview_logs m
JOIN   user_segments  s ON s.segment_name = m.log_table
WHERE  m.master IN ('PERFORMANCE','STAGE','FESTIVAL','ARTIST');


-- ---------------------------------------------------------------------
-- 2) DML SLOWDOWN under REFRESH FAST ON COMMIT
--
--    A/B comparison: same 1000-row insert + commit, run twice.
--      (a) WITH the MV active   -> COMMIT also runs an incremental refresh
--      (b) WITHOUT the MV       -> COMMIT does plain INSERT bookkeeping
-- ---------------------------------------------------------------------

-- (a) WITH MV
DECLARE
    t_start TIMESTAMP;
    t_end   TIMESTAMP;
BEGIN
    t_start := SYSTIMESTAMP;

    INSERT INTO Performance
        (Performance_Start_Time, Artist_ID, Performance_End_Time,
         Performance_Description, Genre_ID, Stage_ID)
    SELECT  SYSDATE + LEVEL/1440,
            (SELECT MIN(Artist_ID) FROM Artist),
            SYSDATE + LEVEL/1440 + 1/24,
            'M7 negative-consequence load test',
            (SELECT MIN(Genre_ID)  FROM Genre),
            (SELECT MIN(Stage_ID)  FROM Stage)
    FROM    dual
    CONNECT BY LEVEL <= 1000;

    COMMIT;

    t_end := SYSTIMESTAMP;
    DBMS_OUTPUT.PUT_LINE('Insert + commit duration WITH MV: ' ||
                         TO_CHAR(EXTRACT(SECOND FROM (t_end - t_start)), 'FM9990.000') ||
                         ' seconds');
END;
/

DELETE FROM Performance
WHERE  Performance_Description = 'M7 negative-consequence load test';
COMMIT;

-- Drop the MV so the same insert runs without the ON COMMIT refresh
DROP MATERIALIZED VIEW MV_S2_Festival_Programming;

-- (b) WITHOUT MV
DECLARE
    t_start TIMESTAMP;
    t_end   TIMESTAMP;
BEGIN
    t_start := SYSTIMESTAMP;

    INSERT INTO Performance
        (Performance_Start_Time, Artist_ID, Performance_End_Time,
         Performance_Description, Genre_ID, Stage_ID)
    SELECT  SYSDATE + LEVEL/1440,
            (SELECT MIN(Artist_ID) FROM Artist),
            SYSDATE + LEVEL/1440 + 1/24,
            'M7 negative-consequence load test',
            (SELECT MIN(Genre_ID)  FROM Genre),
            (SELECT MIN(Stage_ID)  FROM Stage)
    FROM    dual
    CONNECT BY LEVEL <= 1000;

    COMMIT;

    t_end := SYSTIMESTAMP;
    DBMS_OUTPUT.PUT_LINE('Insert + commit duration WITHOUT MV: ' ||
                         TO_CHAR(EXTRACT(SECOND FROM (t_end - t_start)), 'FM9990.000') ||
                         ' seconds');
END;
/

DELETE FROM Performance
WHERE  Performance_Description = 'M7 negative-consequence load test';
COMMIT;

-- Recreate the MV before the staleness demo below (same DDL as S2_OPT_mv.sql)
CREATE MATERIALIZED VIEW MV_S2_Festival_Programming
    BUILD IMMEDIATE
    REFRESH FAST ON COMMIT
    ENABLE QUERY REWRITE
AS
SELECT
    f.Festival_ID,
    f.Festival_Name,
    COUNT(*)                                                            AS Performance_Count,
    SUM((p.Performance_End_Time - p.Performance_Start_Time) * 24 * 60)  AS Total_Minutes,
    COUNT((p.Performance_End_Time - p.Performance_Start_Time) * 24 * 60) AS Cnt_Minutes,
    SUM(a.Artist_Price)                                                 AS Total_Artist_Spend,
    COUNT(a.Artist_Price)                                               AS Cnt_Artist_Price
FROM Performance p
JOIN Stage    s ON s.Stage_ID    = p.Stage_ID
JOIN Festival f ON f.Festival_ID = s.Festival_ID
JOIN Artist   a ON a.Artist_ID   = p.Artist_ID
GROUP BY f.Festival_ID, f.Festival_Name;

SELECT mview_name, refresh_method, refresh_mode, rewrite_enabled, compile_state, staleness
FROM   user_mviews WHERE mview_name = 'MV_S2_FESTIVAL_PROGRAMMING';



-- ---------------------------------------------------------------------
-- 3) STALENESS demo - switch the MV to ON DEMAND and prove that a SELECT
--    through the MV returns the OLD aggregate value until we refresh
--    manually.
--
--    We track ONE specific festival (the lowest existing Festival_ID)
--    end-to-end:
--      A) BEFORE the probe insert      -> Performance_Count = X
--      B) AFTER  the probe insert      -> Performance_Count = X  (stale!)
--      C) AFTER  manual REFRESH        -> Performance_Count = X+1
-- ---------------------------------------------------------------------
ALTER MATERIALIZED VIEW MV_S2_Festival_Programming REFRESH FAST ON DEMAND;

-- (A) BEFORE the probe insert - lock in the festival we will track
SELECT Festival_ID, Performance_Count, Total_Minutes
FROM   MV_S2_Festival_Programming
WHERE  Festival_ID = (SELECT MIN(Festival_ID) FROM Festival);

-- Probe insert: add ONE performance attached to that same festival's first stage
INSERT INTO Performance
    (Performance_Start_Time, Artist_ID, Performance_End_Time,
     Performance_Description, Genre_ID, Stage_ID)
SELECT  SYSDATE,
        (SELECT MIN(Artist_ID) FROM Artist),
        SYSDATE + 1/24,
        'M7 staleness probe',
        (SELECT MIN(Genre_ID)  FROM Genre),
        (SELECT MIN(Stage_ID)  FROM Stage WHERE Festival_ID = (SELECT MIN(Festival_ID) FROM Festival))
FROM    dual;
COMMIT;

-- MV is now stale (ON DEMAND does not refresh on commit)
SELECT mview_name, staleness, last_refresh_date
FROM   user_mviews
WHERE  mview_name = 'MV_S2_FESTIVAL_PROGRAMMING';

-- (B) AFTER probe + commit, BEFORE refresh - same query, still OLD value
SELECT Festival_ID, Performance_Count, Total_Minutes
FROM   MV_S2_Festival_Programming
WHERE  Festival_ID = (SELECT MIN(Festival_ID) FROM Festival);

-- Manual fast refresh
BEGIN
    DBMS_MVIEW.REFRESH('MV_S2_FESTIVAL_PROGRAMMING', method => 'F');
END;
/
SELECT mview_name, staleness, last_refresh_date
FROM   user_mviews
WHERE  mview_name = 'MV_S2_FESTIVAL_PROGRAMMING';

-- (C) AFTER refresh - Performance_Count has increased by 1
SELECT Festival_ID, Performance_Count, Total_Minutes
FROM   MV_S2_Festival_Programming
WHERE  Festival_ID = (SELECT MIN(Festival_ID) FROM Festival);

-- ---------------------------------------------------------------------
-- Cleanup: remove the probe row, refresh again, then restore ON COMMIT.
-- Refreshing FIRST is required: ON COMMIT cannot be re-enabled while
-- there are pending entries in the MV log (ORA-32337).
-- ---------------------------------------------------------------------
DELETE FROM Performance
WHERE  Performance_Description = 'M7 staleness probe';
COMMIT;

BEGIN
    DBMS_MVIEW.REFRESH('MV_S2_FESTIVAL_PROGRAMMING', method => 'F');
END;
/

ALTER MATERIALIZED VIEW MV_S2_Festival_Programming REFRESH FAST ON COMMIT;

-- Final state check
SELECT mview_name, refresh_method, refresh_mode, rewrite_enabled, compile_state, staleness
FROM   user_mviews
WHERE  mview_name = 'MV_S2_FESTIVAL_PROGRAMMING';


SELECT COUNT(*) FROM Performance
WHERE  Performance_Description IN ('M7 negative-consequence load test','M7 staleness probe');