-- =====================================================================
-- S2 - Milestone 7 - Statistics + size check
-- Run order: 1 (also re-run after S2_OPT_refill.sql)
-- =====================================================================
-- Run BEFORE capturing the "before" explain plan, and AGAIN after the
-- database has been refilled. Fresh statistics let the Cost-Based
-- Optimizer choose a fair plan in each run.
-- =====================================================================

-- 1) Gather table statistics (assignment tip: DBMS_STATS.GATHER_TABLE_STATS(<username>,<tabelname>))
BEGIN
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'PERFORMANCE');
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'STAGE');
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'FESTIVAL');
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'ARTIST');
    DBMS_STATS.GATHER_TABLE_STATS('PROJECT', 'GENRE');
END;
/

-- 2) Size of the source table (assignment template) - target >= 60 MB
select segment_name, segment_type, sum(bytes/1024/1024) MB,
       (select COUNT(*) FROM Performance) as table_count
from dba_segments
where segment_name='PERFORMANCE'
group by segment_name, segment_type;

-- 3) Row counts per table
SELECT 'PERFORMANCE' AS tab, COUNT(*) AS n FROM Performance UNION ALL
SELECT 'STAGE',              COUNT(*)      FROM Stage       UNION ALL
SELECT 'FESTIVAL',           COUNT(*)      FROM Festival    UNION ALL
SELECT 'ARTIST',             COUNT(*)      FROM Artist      UNION ALL
SELECT 'GENRE',              COUNT(*)      FROM Genre;
