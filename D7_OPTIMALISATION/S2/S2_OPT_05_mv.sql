-- =====================================================================
-- S2 - Milestone 7 - Materialized View
-- Run order: 05
-- =====================================================================
-- Strategy: REFRESH FAST ON COMMIT + ENABLE QUERY REWRITE
--   * FAST          -> uses MV logs, applies only deltas (cheap)
--   * ON COMMIT     -> view is ALWAYS up-to-date, refreshed inside the
--                      same transaction that modifies a base table
--   * QUERY REWRITE -> the original query is automatically rewritten
--                      by Oracle to read from the MV. The explain plan
--                      switches from a 4-table join + GROUP BY to a
--                      single MV_REWRITE ACCESS FULL.
--
-- Pre-requisites:
--   1. Materialized view logs exist  (run S2_OPT_mvlogs.sql first)
--   2. Statistics gathered            (run S2_OPT_stats.sql)
--   3. PROJECT has the privileges:
--        GRANT CREATE MATERIALIZED VIEW TO PROJECT;
--        GRANT QUERY REWRITE            TO PROJECT;
--        GRANT ON COMMIT REFRESH        TO PROJECT;
-- =====================================================================

DROP MATERIALIZED VIEW MV_S2_Festival_Programming;

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

-- Verify the MV ended up in the intended state
SELECT mview_name, refresh_method, refresh_mode, rewrite_enabled, compile_state, staleness
FROM   user_mviews
WHERE  mview_name = 'MV_S2_FESTIVAL_PROGRAMMING';
