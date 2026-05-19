-- =====================================================================
-- S2 - Milestone 7 - Explain plan (BEFORE / AFTER)
-- Run order: 03 (BEFORE plan) and again after 05 (AFTER plan)
-- =====================================================================
-- Run this script TWICE for the report:
--   (1) BEFORE creating the MV  -> baseline plan: 4-table join + HASH GROUP BY
--   (2) AFTER  creating the MV  -> rewritten plan: MAT_VIEW REWRITE ACCESS
-- Make sure statistics are fresh (see S2_OPT_stats.sql) before each run.
-- =====================================================================

-- Required for the AFTER step so Oracle is allowed to rewrite the query.
ALTER SESSION SET query_rewrite_enabled  = TRUE;
ALTER SESSION SET query_rewrite_integrity = 'ENFORCED';

-- ---------------------------------------------------------------------
-- Capture the plan for the original user query (UNCHANGED before/after).
-- Oracle's query rewrite must recognise the MV automatically.
-- ---------------------------------------------------------------------
EXPLAIN PLAN FOR
SELECT
    f.Festival_ID,
    f.Festival_Name,
    COUNT(*)                                                            AS Performance_Count,
    SUM((p.Performance_End_Time - p.Performance_Start_Time) * 24 * 60)  AS Total_Minutes,
    SUM(a.Artist_Price)                                                 AS Total_Artist_Spend
FROM Performance p
JOIN Stage    s ON s.Stage_ID    = p.Stage_ID
JOIN Festival f ON f.Festival_ID = s.Festival_ID
JOIN Artist   a ON a.Artist_ID   = p.Artist_ID
GROUP BY f.Festival_ID, f.Festival_Name;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(format => 'ALL'));