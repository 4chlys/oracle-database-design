-- S2 SECURITY - Music Festival Database
-- Student: Jonas Friedhoff
-- Creates a role, a user, and a view for the S2 portion of the schema.
-- Run as: ADMIN / PROJECT schema owner

-- Drop existing objects (makes script rerunnable)
-- First run may raise errors if objects do not yet exist.
DROP USER s2_stage CASCADE;
DROP ROLE festival_s2_role;
DROP VIEW v_stage_performance;

-- 1. Create a Role
--    Table Y (Stage)      : full DML + DDL
--    Table Z (Performance): SELECT, INSERT, DELETE
CREATE ROLE festival_s2_role;

-- Table Y (Stage)
GRANT SELECT, INSERT, UPDATE, DELETE ON Stage TO festival_s2_role;
GRANT ALTER                          ON Stage TO festival_s2_role;

-- Table Z (Performance)
GRANT SELECT, INSERT, DELETE ON Performance TO festival_s2_role;

-- 2. Create User with prefix S2 and assign the role

CREATE USER s2_stage IDENTIFIED BY "REDACTED";
GRANT CREATE SESSION TO s2_stage;
GRANT festival_s2_role TO s2_stage;

-- 3. Create a View (as admin) with data from 2 linked WXYZ
--    tables: Stage (Y) and Performance (Z).
--    Performance is the key-preserved table in this join.

CREATE OR REPLACE VIEW v_stage_performance AS
SELECT p.Performance_ID,
       p.Performance_Start_Time,
       p.Performance_End_Time,
       p.Performance_Description,
       p.Artist_ID,
       p.Genre_ID,
       p.Stage_ID,
       s.Stage_Name,
       s.Festival_ID,
       s.Stage_Style_Description,
       s.Stage_Standing_Capacity
FROM   Performance p
JOIN   Stage s ON p.Stage_ID = s.Stage_ID;

-- 4. Grant user S2 only read + insert rights on the view,
--    not directly on the underlying tables for this purpose.

GRANT SELECT, INSERT ON v_stage_performance TO s2_stage;

-- Additional SELECT grants so the user can resolve FK values
-- with subselects (no hardcoded IDs).
GRANT SELECT ON Artist   TO s2_stage;
GRANT SELECT ON Genre    TO s2_stage;
GRANT SELECT ON Festival TO s2_stage;

-- SCENARIO S2 (run as user s2_stage)
-- Insert into Performance (key-preserved table) via the view.
-- No hardcoded IDs: Artist_ID, Genre_ID, Stage_ID are resolved
-- with sub-selects.

INSERT INTO PROJECT.v_stage_performance
    (Performance_Start_Time, Performance_End_Time,
     Performance_Description, Artist_ID, Genre_ID, Stage_ID)
VALUES (
    TO_DATE('2026-07-20 22:00', 'YYYY-MM-DD HH24:MI'),
    TO_DATE('2026-07-20 23:30', 'YYYY-MM-DD HH24:MI'),
    'Closing set on the main stage',
    (SELECT Artist_ID FROM PROJECT.Artist   WHERE Artist_Name = 'Martin Garrix'),
    (SELECT Genre_ID  FROM PROJECT.Genre    WHERE Genre_Name  = 'Electronic'),
    (SELECT Stage_ID  FROM PROJECT.Stage    WHERE Stage_Name  = 'Mainstage'
       AND Festival_ID = (SELECT Festival_ID FROM PROJECT.Festival
                          WHERE Festival_Name = 'Tomorrowland Summer 2024'))
);