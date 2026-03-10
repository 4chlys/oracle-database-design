-- ============================================================
-- S2 QUERIES - Music Festival Database
-- Student: Jonas Friedhoff
-- Tables owned by S2: Genre, Artist, Stage, Performance
-- Shared table: Festival
-- ============================================================

-- --------------------------------------------------------
-- Count query: number of rows per S2 table
-- --------------------------------------------------------
SELECT 'S2-A Genre'       AS TableName, COUNT(*) AS RowCount FROM Genre
UNION ALL
SELECT 'S2-B Artist'      AS TableName, COUNT(*) AS RowCount FROM Artist
UNION ALL
SELECT 'S2-C Stage'       AS TableName, COUNT(*) AS RowCount FROM Stage
UNION ALL
SELECT 'S2-D Performance' AS TableName, COUNT(*) AS RowCount FROM Performance;


-- --------------------------------------------------------
-- Query 1: 2-level deep relationship
-- Festival → Stage → Performance → Artist + Genre
-- Shows the full lineup per festival: which artist performed
-- on which stage, in which genre, and at what time.
-- Tables joined: Festival, Stage, Performance, Artist, Genre (5 tables)
-- --------------------------------------------------------
SELECT
    f.Festival_Name,
    s.Stage_Name,
    a.Artist_Name,
    g.Genre_Name,
    TO_CHAR(p.Performance_Start_Time, 'DD-MM-YYYY HH24:MI') AS Start_Time,
    TO_CHAR(p.Performance_End_Time,   'DD-MM-YYYY HH24:MI') AS End_Time,
    p.Performance_Description
FROM Festival f
JOIN Stage       s ON s.Festival_ID  = f.Festival_ID
JOIN Performance p ON p.Stage_ID     = s.Stage_ID
JOIN Artist      a ON a.Artist_ID    = p.Artist_ID
JOIN Genre       g ON g.Genre_ID     = p.Genre_ID
ORDER BY f.Festival_Name, s.Stage_Name, p.Performance_Start_Time;



-- Query 2: Artists and every festival they performed at
-- Shows the many-to-many relationship:
-- Artist ←→ Performance ←→ Stage ←→ Festival
-- Tables joined: Artist, Performance, Stage, Festival, Genre (5 tables)

SELECT
    a.Artist_Name,
    a.Artist_Land_Of_Birth,
    f.Festival_Name,
    s.Stage_Name,
    g.Genre_Name,
    COUNT(p.Performance_ID) AS Performance_Count
FROM Artist      a
JOIN Performance p ON p.Artist_ID   = a.Artist_ID
JOIN Stage       s ON s.Stage_ID    = p.Stage_ID
JOIN Festival    f ON f.Festival_ID = s.Festival_ID
JOIN Genre       g ON g.Genre_ID    = p.Genre_ID
GROUP BY a.Artist_Name, a.Artist_Land_Of_Birth,
         f.Festival_Name, s.Stage_Name, g.Genre_Name
ORDER BY a.Artist_Name, f.Festival_Name;



-- Query 3: Stage overview per festival with performance stats
-- Shows capacity planning: how many performances per stage,
-- first and last slot, and whether the stage is roofed.
-- Tables joined: Festival, Stage, Performance, Artist (4 tables)

SELECT
    f.Festival_Name,
    s.Stage_Name,
    s.Stage_Standing_Capacity,
    CASE s.Stage_Roofed_Status WHEN 1 THEN 'Yes' ELSE 'No' END AS Roofed,
    COUNT(p.Performance_ID)                                    AS Performance_Count,
    MAX(a.Artist_Name)  KEEP (DENSE_RANK FIRST ORDER BY p.Performance_Start_Time)
                                                               AS First_Artist,
    MAX(a.Artist_Name)  KEEP (DENSE_RANK LAST  ORDER BY p.Performance_End_Time)
                                                               AS Last_Artist
FROM Festival    f
JOIN Stage       s ON s.Festival_ID = f.Festival_ID
LEFT JOIN Performance p ON p.Stage_ID  = s.Stage_ID
LEFT JOIN Artist      a ON a.Artist_ID = p.Artist_ID
GROUP BY f.Festival_Name, s.Stage_Name,
         s.Stage_Standing_Capacity, s.Stage_Roofed_Status
ORDER BY f.Festival_Name, Performance_Count DESC;
