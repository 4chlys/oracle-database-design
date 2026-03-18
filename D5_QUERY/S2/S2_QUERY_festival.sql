-- S2 QUERIES - Music Festival Database
-- Student: Jonas Friedhoff
-- S2 tables (WXYZ): Genre, Artist (W), Stage (Y), Performance (Z)
-- Shared table: Festival (X)

-- Count query: row counts for all tables

SELECT 'S2_  : Genre'          AS "Table", COUNT(*) AS "Count" FROM Genre
UNION ALL
SELECT 'S2-W  : Artist',         COUNT(*) FROM Artist
UNION ALL
SELECT 'S2_X   : Festival',       COUNT(*) FROM Festival
UNION ALL
SELECT 'S2-Y  : Stage',          COUNT(*) FROM Stage
UNION ALL
SELECT 'S2-Z  : Performance',    COUNT(*) FROM Performance;


-- Query 1 (WXYZ): 2-level deep relationship
-- Festival → Stage → Performance → Artist + Genre
-- Shows the full lineup per festival: which artist performs
-- on which stage, in which genre, and at what time.
-- All user-data columns from S2 tables are included (no IDs).
-- Tables joined: Festival (X), Stage (Y), Performance (Z),
--                Artist (), Genre – 5 tables

SELECT
    f.Festival_Name,
    TO_CHAR(f.Festival_StartDate, 'DD-MM-YYYY')              AS Festival_Start,
    TO_CHAR(f.Festival_EndDate,   'DD-MM-YYYY')              AS Festival_End,
    f.Festival_Location,
    TO_CHAR(f.Festival_Opening_Hour, 'HH24:MI')              AS Opening_Hour,
    TO_CHAR(f.Festival_Closing_Hour, 'HH24:MI')              AS Closing_Hour,
    f.Festival_Capacity,
    s.Stage_Name,
    s.Stage_Style_Description,
    s.Stage_Standing_Capacity,
    s.Stage_Toilet_Count,
    s.Stage_Description,
    CASE s.Stage_Roofed_Status WHEN 1 THEN 'Yes' ELSE 'No' END AS Stage_Roofed,
    a.Artist_Name,
    TO_CHAR(a.Artist_Birthday, 'DD-MM-YYYY')                 AS Artist_Birthday,
    a.Artist_Price,
    a.Artist_Price_Currency,
    a.Artist_Land_Of_Birth,
    g.Genre_Name,
    g.Genre_Origin_Year,
    g.Genre_Origin_Location,
    g.Genre_BPM,
    TO_CHAR(p.Performance_Start_Time, 'DD-MM-YYYY HH24:MI')  AS Performance_Start,
    TO_CHAR(p.Performance_End_Time,   'DD-MM-YYYY HH24:MI')  AS Performance_End,
    p.Performance_Description
FROM Festival    f
JOIN Stage       s ON s.Festival_ID  = f.Festival_ID
JOIN Performance p ON p.Stage_ID     = s.Stage_ID
JOIN Artist      a ON a.Artist_ID    = p.Artist_ID
JOIN Genre       g ON g.Genre_ID     = p.Genre_ID
ORDER BY f.Festival_Name, s.Stage_Name, p.Performance_Start_Time;



-- Query 2 (WXYZ): Many-to-many relationship (Artist ↔ Festival)
-- An artist can perform at many festivals, and a festival
-- hosts many artists. The link runs through Performance + Stage.
-- Tables joined: Artist (W), Performance (Z), Genre,
--                Stage (Y), Festival (X) – 5 tables

SELECT
    a.Artist_Name,
    TO_CHAR(a.Artist_Birthday, 'DD-MM-YYYY')                 AS Artist_Birthday,
    a.Artist_Price || ' ' || a.Artist_Price_Currency          AS Artist_Fee,
    a.Artist_Land_Of_Birth,
    f.Festival_Name,
    f.Festival_Location,
    TO_CHAR(f.Festival_StartDate, 'DD-MM-YYYY')              AS Festival_Start,
    s.Stage_Name,
    g.Genre_Name,
    g.Genre_BPM,
    TO_CHAR(p.Performance_Start_Time, 'DD-MM-YYYY HH24:MI')  AS Performance_Start,
    TO_CHAR(p.Performance_End_Time,   'DD-MM-YYYY HH24:MI')  AS Performance_End,
    p.Performance_Description
FROM Artist      a
JOIN Performance p ON p.Artist_ID   = a.Artist_ID
JOIN Genre       g ON g.Genre_ID    = p.Genre_ID
JOIN Stage       s ON s.Stage_ID    = p.Stage_ID
JOIN Festival    f ON f.Festival_ID = s.Festival_ID
ORDER BY a.Artist_Name, f.Festival_Name, p.Performance_Start_Time;
