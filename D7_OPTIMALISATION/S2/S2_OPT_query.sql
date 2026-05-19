-- =====================================================================
-- S2 - Milestone 7 - Optimisation Query
-- Student: Jonas Friedhoff
-- Domain : Festival programming dashboard (per-festival aggregate)
-- Run order: 2 (BEFORE timing) and 6 (AFTER timing)
-- =====================================================================
-- Source table D/Z : Performance (~559k rows)
-- Result set       : 1 row per Festival (~310 rows)  =>  ~1800x reduction
--
-- The query is written FAST-refresh compatible so that the materialized
-- view in S2_OPT_mv.sql can be defined directly from it:
--   * COUNT(*) is present
--   * Every SUM(expr) is paired with COUNT(expr)
--   * No COUNT(DISTINCT ...) - that would block FAST refresh
-- =====================================================================

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

ALTER SESSION SET query_rewrite_enabled = FALSE;

-- run this 3 times, note all three execution: ms numbers
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

-- THEN re-enable rewrite (important so the rest of the work uses the MV)
ALTER SESSION SET query_rewrite_enabled = TRUE;