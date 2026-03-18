-- S2 CONSTRAINT VIOLATION PROOFS - Music Festival Database
-- Student: Jonas Friedhoff
-- Each INSERT below intentionally violates one constraint.
-- Expected result: Oracle raises ORA-02290 (check constraint)
-- or ORA-00001 (unique constraint).



-- 1. Genre_BPM_chk  →  Genre_BPM >= 0
-- Violation: negative BPM value

INSERT INTO Genre (Genre_Name, Genre_Origin_Year, Genre_Origin_Location, Genre_BPM)
VALUES ('TestGenre', 1990, 'USA', -5);
-- Expected error: ORA-02290: check constraint (Genre_BPM_chk) violated

-- 2. Genre_Origin_Year_chk  →  Genre_Origin_Year < 2026
-- Violation: origin year in the future

INSERT INTO Genre (Genre_Name, Genre_Origin_Year, Genre_Origin_Location, Genre_BPM)
VALUES ('FutureGenre', 2030, 'Mars', 120);
-- Expected error: ORA-02290: check constraint (Genre_Origin_Year_chk) violated



-- 3. Artist_Price_chk  →  Artist_Price >= 0
-- Violation: negative booking fee

INSERT INTO Artist (Artist_Name, Artist_Birthday, Artist_Price, Artist_Price_Currency, Artist_Land_Of_Birth)
VALUES ('Test Artist', TO_DATE('01-01-1990', 'DD-MM-YYYY'), -500, 'EUR', 'Belgium');
-- Expected error: ORA-02290: check constraint (Artist_Price_chk) violated

-- 4. Artist_Land_chk  →  LENGTH(TRIM(Artist_Land_Of_Birth)) >= 4
-- Violation: country abbreviation too short ("US" = 2 chars)

INSERT INTO Artist (Artist_Name, Artist_Birthday, Artist_Price, Artist_Price_Currency, Artist_Land_Of_Birth)
VALUES ('Test Artist 2', TO_DATE('01-01-1990', 'DD-MM-YYYY'), 1000, 'USD', 'US');
-- Expected error: ORA-02290: check constraint (Artist_Land_chk) violated

-- 5. Artist_Currency_chk  →  REGEXP_LIKE(Artist_Price_Currency, '^[A-Z]{3}$')
-- Violation: currency code contains digits

INSERT INTO Artist (Artist_Name, Artist_Birthday, Artist_Price, Artist_Price_Currency, Artist_Land_Of_Birth)
VALUES ('Test Artist 3', TO_DATE('01-01-1990', 'DD-MM-YYYY'), 1000, '123', 'Belgium');
-- Expected error: ORA-02290: check constraint (Artist_Currency_chk) violated

-- 6. Artist_Birthday_chk  →  Artist_Birthday < DATE '2026-03-10'
-- Violation: birthday in the future

INSERT INTO Artist (Artist_Name, Artist_Birthday, Artist_Price, Artist_Price_Currency, Artist_Land_Of_Birth)
VALUES ('Future Artist', DATE '2027-01-01', 1000, 'EUR', 'Belgium');
-- Expected error: ORA-02290: check constraint (Artist_Birthday_chk) violated




-- 7. Stage_Capac_chk  →  Stage_Standing_Capacity >= 0
-- Violation: negative capacity

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Roofed_Status)
VALUES ('TestStage',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'),
        -100, 10, 0);
-- Expected error: ORA-02290: check constraint (Stage_Capac_chk) violated



-- 8. Stage_Toilet_chk  →  Stage_Toilet_Count >= 0
-- Violation: negative toilet count

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Roofed_Status)
VALUES ('TestStage2',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'),
        5000, -3, 0);
-- Expected error: ORA-02290: check constraint (Stage_Toilet_chk) violated



-- 9. Stage_Roofed_chk  →  Stage_Roofed_Status IN (0, 1)
-- Violation: value outside allowed boolean domain

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Roofed_Status)
VALUES ('TestStage3',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'),
        5000, 10, 5);
-- Expected error: ORA-02290: check constraint (Stage_Roofed_chk) violated



-- 10. Stage_Festival_Name_UQ  →  UNIQUE (Festival_ID, Stage_Name)
-- Violation: duplicate stage name within the same festival
-- 'Mainstage' already exists for Tomorrowland Summer 2024

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Roofed_Status)
VALUES ('Mainstage',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'),
        10000, 50, 0);
-- Expected error: ORA-00001: unique constraint (Stage_Festival_Name_UQ) violated



-- 11. Performance_Times_chk  →  Performance_End_Time > Performance_Start_Time
-- Violation: end time before start time

INSERT INTO Performance (Performance_Start_Time, Performance_End_Time,
                         Performance_Description, Artist_ID, Genre_ID, Stage_ID)
VALUES (
    TO_DATE('20-07-2024 22:00', 'DD-MM-YYYY HH24:MI'),
    TO_DATE('20-07-2024 20:00', 'DD-MM-YYYY HH24:MI'),   -- end BEFORE start
    'Invalid performance',
    (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Martin Garrix'),
    (SELECT Genre_ID  FROM Genre  WHERE Genre_Name  = 'Electronic'),
    (SELECT Stage_ID  FROM Stage  WHERE Stage_Name  = 'Mainstage'
       AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'))
);
-- Expected error: ORA-02290: check constraint (Performance_Times_chk) violated
INSERT INTO Performance (Performance_Start_Time, Performance_End_Time,
                         Performance_Description, Artist_ID, Genre_ID, Stage_ID)
VALUES (
           TO_DATE('20-07-2024 22:00', 'DD-MM-YYYY HH24:MI'),
           TO_DATE('20-07-2024 23:00', 'DD-MM-YYYY HH24:MI'),   -- end BEFORE start
           'Invalid performance',
           (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Martin Garrix'),
           (SELECT Genre_ID  FROM Genre  WHERE Genre_Name  = 'Electronic'),
           NULL);