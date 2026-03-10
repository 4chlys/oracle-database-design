DELETE
FROM Performance;
DELETE
FROM Stage;
DELETE
FROM Artist;
DELETE
FROM Genre;

COMMIT;

-- --------------------------------------------------------
-- 1. GENRE
-- --------------------------------------------------------
INSERT INTO Genre (Genre_Name, Genre_Origin_Year, Genre_Origin_Location, Genre_BPM) VALUES ('Electronic',    1970, 'Chicago, USA',          128);
INSERT INTO Genre (Genre_Name, Genre_Origin_Year, Genre_Origin_Location, Genre_BPM) VALUES ('Rock',          1955, 'Memphis, USA',           120);
INSERT INTO Genre (Genre_Name, Genre_Origin_Year, Genre_Origin_Location, Genre_BPM) VALUES ('Pop',           1960, 'New York, USA',           110);
INSERT INTO Genre (Genre_Name, Genre_Origin_Year, Genre_Origin_Location, Genre_BPM) VALUES ('Hip-Hop',       1973, 'Bronx, New York, USA',    90);
INSERT INTO Genre (Genre_Name, Genre_Origin_Year, Genre_Origin_Location, Genre_BPM) VALUES ('Techno',        1985, 'Detroit, USA',            140);
INSERT INTO Genre (Genre_Name, Genre_Origin_Year, Genre_Origin_Location, Genre_BPM) VALUES ('House',         1983, 'Chicago, USA',            125);
INSERT INTO Genre (Genre_Name, Genre_Origin_Year, Genre_Origin_Location, Genre_BPM) VALUES ('Drum and Bass', 1991, 'London, UK',              170);
INSERT INTO Genre (Genre_Name, Genre_Origin_Year, Genre_Origin_Location, Genre_BPM) VALUES ('Trance',        1990, 'Frankfurt, Germany',      138);
INSERT INTO Genre (Genre_Name, Genre_Origin_Year, Genre_Origin_Location, Genre_BPM) VALUES ('Indie Rock',    1980, 'New York, USA',           115);
INSERT INTO Genre (Genre_Name, Genre_Origin_Year, Genre_Origin_Location, Genre_BPM) VALUES ('Reggae',        1960, 'Kingston, Jamaica',       80);

-- --------------------------------------------------------
-- 2. ARTIST
-- --------------------------------------------------------
INSERT INTO Artist (Artist_Name, Artist_Birthday, Artist_Price, Artist_Price_Currency, Artist_Land_Of_Birth)
VALUES ('Martin Garrix',      TO_DATE('14-05-1996','DD-MM-YYYY'), 500000,  'EUR', 'Netherlands');
INSERT INTO Artist (Artist_Name, Artist_Birthday, Artist_Price, Artist_Price_Currency, Artist_Land_Of_Birth)
VALUES ('Kendrick Lamar',     TO_DATE('17-06-1987','DD-MM-YYYY'), 1200000, 'USD', 'United States');
INSERT INTO Artist (Artist_Name, Artist_Birthday, Artist_Price, Artist_Price_Currency, Artist_Land_Of_Birth)
VALUES ('Billie Eilish',      TO_DATE('18-12-2001','DD-MM-YYYY'), 900000,  'USD', 'United States');
INSERT INTO Artist (Artist_Name, Artist_Birthday, Artist_Price, Artist_Price_Currency, Artist_Land_Of_Birth)
VALUES ('Stromae',            TO_DATE('12-03-1985','DD-MM-YYYY'), 400000,  'EUR', 'Belgium');
INSERT INTO Artist (Artist_Name, Artist_Birthday, Artist_Price, Artist_Price_Currency, Artist_Land_Of_Birth)
VALUES ('David Guetta',       TO_DATE('07-11-1967','DD-MM-YYYY'), 600000,  'EUR', 'France');
INSERT INTO Artist (Artist_Name, Artist_Birthday, Artist_Price, Artist_Price_Currency, Artist_Land_Of_Birth)
VALUES ('Rammstein',          TO_DATE('01-01-1994','DD-MM-YYYY'), 800000,  'EUR', 'Germany');
INSERT INTO Artist (Artist_Name, Artist_Birthday, Artist_Price, Artist_Price_Currency, Artist_Land_Of_Birth)
VALUES ('Arctic Monkeys',     TO_DATE('01-06-2002','DD-MM-YYYY'), 750000,  'GBP', 'United Kingdom');
INSERT INTO Artist (Artist_Name, Artist_Birthday, Artist_Price, Artist_Price_Currency, Artist_Land_Of_Birth)
VALUES ('Bad Bunny',          TO_DATE('10-03-1994','DD-MM-YYYY'), 1500000, 'USD', 'Puerto Rico');
INSERT INTO Artist (Artist_Name, Artist_Birthday, Artist_Price, Artist_Price_Currency, Artist_Land_Of_Birth)
VALUES ('Charlotte de Witte', TO_DATE('15-10-1992','DD-MM-YYYY'), 80000,   'EUR', 'Belgium');
INSERT INTO Artist (Artist_Name, Artist_Birthday, Artist_Price, Artist_Price_Currency, Artist_Land_Of_Birth)
VALUES ('Bicep',              TO_DATE('01-01-2009','DD-MM-YYYY'), 120000,  'GBP', 'United Kingdom');

-- --------------------------------------------------------
-- 3. STAGE  (Festival_ID via Festival_Name)
-- --------------------------------------------------------
INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Description, Stage_Roofed_Status)
VALUES ('Mainstage',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'),
        'Grand pyramid structure with full LED canopy', 80000, 200,
        'The iconic main stage with world-class production', 0);

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Description, Stage_Roofed_Status)
VALUES ('Freedom Stage',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'),
        'Underground bunker-style enclosed venue', 15000, 80,
        'Dark and deep electronic music venue', 1);

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Description, Stage_Roofed_Status)
VALUES ('Main Stage',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Rock Werchter 2024'),
        'Open air classic rock stage with massive screens', 65000, 180,
        'The legendary open air rock stage', 0);

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Description, Stage_Roofed_Status)
VALUES ('Club Stage',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Rock Werchter 2024'),
        'Covered intimate club venue', 8000, 40,
        'Intimate covered stage for emerging artists', 1);

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Description, Stage_Roofed_Status)
VALUES ('Chateau Stage',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Pukkelpop 2024'),
        'Open air stage near the castle pond', 40000, 120,
        'Flagship stage overlooking the castle', 0);

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Description, Stage_Roofed_Status)
VALUES ('Boiler Room',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Pukkelpop 2024'),
        'Concrete underground club stage', 3000, 20,
        'Exclusive underground electronic stage', 1);

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Description, Stage_Roofed_Status)
VALUES ('Main Stage',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Sziget Festival 2024'),
        'Grand island stage with LED towers', 70000, 250,
        'The heart of Sziget on the island', 0);

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Description, Stage_Roofed_Status)
VALUES ('A38 Stage',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Sziget Festival 2024'),
        'Covered secondary stage named after the famous ship bar', 12000, 60,
        'Popular covered stage for alternative acts', 1);

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Description, Stage_Roofed_Status)
VALUES ('Orange Stage',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Roskilde Festival 2024'),
        'Iconic orange tent main stage', 75000, 200,
        'The legendary main stage of Roskilde', 0);

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Description, Stage_Roofed_Status)
VALUES ('Arena Stage',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Roskilde Festival 2024'),
        'Covered arena for mid-size acts', 15000, 70,
        'Covered arena stage at Roskilde', 1);

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Description, Stage_Roofed_Status)
VALUES ('Pyramid Stage',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Glastonbury 2025'),
        'The world-famous pyramid-shaped headline stage', 100000, 300,
        'The most iconic festival stage in the world', 0);

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Description, Stage_Roofed_Status)
VALUES ('Other Stage',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Glastonbury 2025'),
        'Second largest stage at Glastonbury', 50000, 150,
        'Alternative headline stage at Glastonbury', 0);

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Description, Stage_Roofed_Status)
VALUES ('ATP Stage',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Primavera Sound 2025'),
        'Covered indoor arena stage', 12000, 60,
        'Air-conditioned indoor arena stage', 1);

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Description, Stage_Roofed_Status)
VALUES ('Heineken Stage',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Primavera Sound 2025'),
        'Large open air stage overlooking the sea', 40000, 110,
        'Main outdoor stage with sea views', 0);

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Description, Stage_Roofed_Status)
VALUES ('Ferropolis Stage',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Melt! Festival 2025'),
        'Open air stage surrounded by industrial cranes', 20000, 80,
        'Unique stage set among giant mining excavators', 0);

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Description, Stage_Roofed_Status)
VALUES ('Sleepless Floor',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Melt! Festival 2025'),
        'Open air techno floor running all night', 8000, 30,
        'The legendary all-night Melt techno floor', 0);

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Description, Stage_Roofed_Status)
VALUES ('Alpe Stage',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Winter 2025'),
        'Alpine outdoor stage with mountain backdrop', 25000, 90,
        'Main stage set against the French Alps', 0);

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Description, Stage_Roofed_Status)
VALUES ('Ice Club',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Winter 2025'),
        'Indoor heated club stage in a ski chalet', 4000, 20,
        'Intimate indoor club stage for the winter edition', 1);

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Description, Stage_Roofed_Status)
VALUES ('Main Stage',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Lollapalooza Berlin 2025'),
        'Grand open air stage in the Olympic stadium grounds', 60000, 200,
        'The main headline stage of Lollapalooza Berlin', 0);

INSERT INTO Stage (Stage_Name, Festival_ID, Stage_Style_Description, Stage_Standing_Capacity, Stage_Toilet_Count, Stage_Description, Stage_Roofed_Status)
VALUES ('Perry Stage',
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Lollapalooza Berlin 2025'),
        'Second stage named after Lolla founder Perry Farrell', 25000, 80,
        'Second headline stage at Lollapalooza Berlin', 0);

-- --------------------------------------------------------
-- 4. PERFORMANCE  (Stage_ID via Stage_Name+Festival_Name; Artist_ID via name; Genre_ID via name)
-- --------------------------------------------------------

-- Tomorrowland Summer 2024 – Mainstage
INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('19-07-2024 22:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Martin Garrix'),
        TO_DATE('20-07-2024 00:00','DD-MM-YYYY HH24:MI'),
        'Martin Garrix closing set Mainstage',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Electronic'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Mainstage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024')));

INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('20-07-2024 20:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'David Guetta'),
        TO_DATE('20-07-2024 22:00','DD-MM-YYYY HH24:MI'),
        'David Guetta pre-closing set Mainstage',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'House'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Mainstage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024')));

-- Tomorrowland Summer 2024 – Freedom Stage
INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('20-07-2024 02:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Charlotte de Witte'),
        TO_DATE('20-07-2024 05:00','DD-MM-YYYY HH24:MI'),
        'Charlotte de Witte deep techno set',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Techno'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Freedom Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024')));

INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('21-07-2024 00:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Bicep'),
        TO_DATE('21-07-2024 02:00','DD-MM-YYYY HH24:MI'),
        'Bicep live AV on Freedom Stage',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Electronic'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Freedom Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024')));

-- Rock Werchter 2024 – Main Stage
INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('04-07-2024 21:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Arctic Monkeys'),
        TO_DATE('04-07-2024 23:00','DD-MM-YYYY HH24:MI'),
        'Arctic Monkeys headliner set',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Indie Rock'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Main Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Rock Werchter 2024')));

INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('05-07-2024 20:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Kendrick Lamar'),
        TO_DATE('05-07-2024 22:30','DD-MM-YYYY HH24:MI'),
        'Kendrick Lamar Saturday headline',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Hip-Hop'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Main Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Rock Werchter 2024')));

-- Rock Werchter 2024 – Club Stage
INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('05-07-2024 23:30','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'David Guetta'),
        TO_DATE('06-07-2024 01:30','DD-MM-YYYY HH24:MI'),
        'David Guetta electronic crossover set',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'House'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Club Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Rock Werchter 2024')));

INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('06-07-2024 02:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Charlotte de Witte'),
        TO_DATE('06-07-2024 05:00','DD-MM-YYYY HH24:MI'),
        'Charlotte de Witte closing Club Stage',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Techno'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Club Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Rock Werchter 2024')));

-- Pukkelpop 2024 – Chateau Stage
INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('15-08-2024 20:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Stromae'),
        TO_DATE('15-08-2024 22:00','DD-MM-YYYY HH24:MI'),
        'Stromae Belgian icon live performance',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Pop'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Chateau Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Pukkelpop 2024')));

INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('16-08-2024 21:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Billie Eilish'),
        TO_DATE('16-08-2024 23:00','DD-MM-YYYY HH24:MI'),
        'Billie Eilish headline Chateau Stage',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Pop'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Chateau Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Pukkelpop 2024')));

-- Pukkelpop 2024 – Boiler Room
INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('16-08-2024 01:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Bicep'),
        TO_DATE('16-08-2024 03:00','DD-MM-YYYY HH24:MI'),
        'Bicep live electronic AV show',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'House'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Boiler Room'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Pukkelpop 2024')));

INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('17-08-2024 02:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Martin Garrix'),
        TO_DATE('17-08-2024 04:00','DD-MM-YYYY HH24:MI'),
        'Martin Garrix secret Boiler Room set',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Electronic'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Boiler Room'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Pukkelpop 2024')));

-- Sziget Festival 2024 – Main Stage
INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('09-08-2024 21:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Bad Bunny'),
        TO_DATE('09-08-2024 23:00','DD-MM-YYYY HH24:MI'),
        'Bad Bunny Friday headline Sziget',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Hip-Hop'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Main Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Sziget Festival 2024')));

INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('10-08-2024 21:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Kendrick Lamar'),
        TO_DATE('10-08-2024 23:30','DD-MM-YYYY HH24:MI'),
        'Kendrick Lamar Saturday headline Sziget',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Hip-Hop'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Main Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Sziget Festival 2024')));

-- Sziget Festival 2024 – A38 Stage
INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('08-08-2024 22:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Charlotte de Witte'),
        TO_DATE('09-08-2024 01:00','DD-MM-YYYY HH24:MI'),
        'Charlotte de Witte techno night A38',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Techno'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'A38 Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Sziget Festival 2024')));

INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('11-08-2024 23:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Bicep'),
        TO_DATE('12-08-2024 01:30','DD-MM-YYYY HH24:MI'),
        'Bicep closing night A38 Stage',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'House'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'A38 Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Sziget Festival 2024')));

-- Roskilde Festival 2024 – Orange Stage
INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('30-06-2024 21:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Billie Eilish'),
        TO_DATE('30-06-2024 23:00','DD-MM-YYYY HH24:MI'),
        'Billie Eilish headline Orange Stage',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Pop'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Orange Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Roskilde Festival 2024')));

INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('04-07-2024 20:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Rammstein'),
        TO_DATE('04-07-2024 22:30','DD-MM-YYYY HH24:MI'),
        'Rammstein industrial metal headline',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Rock'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Orange Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Roskilde Festival 2024')));

-- Roskilde Festival 2024 – Arena Stage
INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('01-07-2024 22:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Martin Garrix'),
        TO_DATE('02-07-2024 00:00','DD-MM-YYYY HH24:MI'),
        'Martin Garrix Arena Stage Roskilde',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Electronic'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Arena Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Roskilde Festival 2024')));

INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('03-07-2024 23:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Bad Bunny'),
        TO_DATE('04-07-2024 01:00','DD-MM-YYYY HH24:MI'),
        'Bad Bunny reggaeton night Arena Stage',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Hip-Hop'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Arena Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Roskilde Festival 2024')));

-- Glastonbury 2025 – Pyramid Stage
INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('26-06-2025 22:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Billie Eilish'),
        TO_DATE('27-06-2025 00:00','DD-MM-YYYY HH24:MI'),
        'Billie Eilish Pyramid Stage headline',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Pop'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Pyramid Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Glastonbury 2025')));

INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('28-06-2025 21:30','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Arctic Monkeys'),
        TO_DATE('28-06-2025 23:30','DD-MM-YYYY HH24:MI'),
        'Arctic Monkeys closing Pyramid Stage',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Indie Rock'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Pyramid Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Glastonbury 2025')));

-- Glastonbury 2025 – Other Stage
INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('27-06-2025 19:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Stromae'),
        TO_DATE('27-06-2025 21:00','DD-MM-YYYY HH24:MI'),
        'Stromae Friday evening Other Stage',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Pop'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Other Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Glastonbury 2025')));

INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('29-06-2025 20:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Kendrick Lamar'),
        TO_DATE('29-06-2025 22:30','DD-MM-YYYY HH24:MI'),
        'Kendrick Lamar closing Other Stage',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Hip-Hop'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Other Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Glastonbury 2025')));

-- Primavera Sound 2025 – ATP Stage
INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('30-05-2025 23:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Bad Bunny'),
        TO_DATE('31-05-2025 01:00','DD-MM-YYYY HH24:MI'),
        'Bad Bunny Latin trap headline Primavera',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Hip-Hop'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'ATP Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Primavera Sound 2025')));

INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('31-05-2025 21:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Arctic Monkeys'),
        TO_DATE('31-05-2025 23:00','DD-MM-YYYY HH24:MI'),
        'Arctic Monkeys Saturday headline Primavera',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Indie Rock'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'ATP Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Primavera Sound 2025')));

-- Primavera Sound 2025 – Heineken Stage
INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('29-05-2025 22:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'David Guetta'),
        TO_DATE('30-05-2025 00:00','DD-MM-YYYY HH24:MI'),
        'David Guetta opening night Heineken Stage',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'House'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Heineken Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Primavera Sound 2025')));

INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('01-06-2025 20:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Stromae'),
        TO_DATE('01-06-2025 22:00','DD-MM-YYYY HH24:MI'),
        'Stromae closing night Heineken Stage',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Pop'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Heineken Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Primavera Sound 2025')));

-- Melt! Festival 2025 – Ferropolis Stage
INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('18-07-2025 22:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Rammstein'),
        TO_DATE('19-07-2025 00:30','DD-MM-YYYY HH24:MI'),
        'Rammstein opening night Ferropolis Stage',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Rock'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Ferropolis Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Melt! Festival 2025')));

INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('19-07-2025 21:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Bicep'),
        TO_DATE('19-07-2025 23:00','DD-MM-YYYY HH24:MI'),
        'Bicep live set Ferropolis Stage',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Electronic'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Ferropolis Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Melt! Festival 2025')));

-- Melt! Festival 2025 – Sleepless Floor
INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('19-07-2025 02:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Charlotte de Witte'),
        TO_DATE('19-07-2025 06:00','DD-MM-YYYY HH24:MI'),
        'Charlotte de Witte all-night Sleepless Floor',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Techno'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Sleepless Floor'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Melt! Festival 2025')));

INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('20-07-2025 01:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Martin Garrix'),
        TO_DATE('20-07-2025 03:00','DD-MM-YYYY HH24:MI'),
        'Martin Garrix closing Sleepless Floor',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Electronic'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Sleepless Floor'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Melt! Festival 2025')));

-- Tomorrowland Winter 2025 – Alpe Stage
INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('08-03-2025 18:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'David Guetta'),
        TO_DATE('08-03-2025 20:00','DD-MM-YYYY HH24:MI'),
        'David Guetta opening Alpe Stage',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'House'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Alpe Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Winter 2025')));

INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('14-03-2025 20:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Martin Garrix'),
        TO_DATE('14-03-2025 22:00','DD-MM-YYYY HH24:MI'),
        'Martin Garrix closing Alpe Stage',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Electronic'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Alpe Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Winter 2025')));

-- Tomorrowland Winter 2025 – Ice Club
INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('10-03-2025 23:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Charlotte de Witte'),
        TO_DATE('11-03-2025 03:00','DD-MM-YYYY HH24:MI'),
        'Charlotte de Witte intimate Ice Club set',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Techno'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Ice Club'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Winter 2025')));

INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('13-03-2025 01:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Bicep'),
        TO_DATE('13-03-2025 03:30','DD-MM-YYYY HH24:MI'),
        'Bicep live AV Ice Club',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'House'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Ice Club'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Winter 2025')));

-- Lollapalooza Berlin 2025 – Main Stage
INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('07-09-2025 20:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Rammstein'),
        TO_DATE('07-09-2025 22:30','DD-MM-YYYY HH24:MI'),
        'Rammstein Friday headline Lollapalooza',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Rock'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Main Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Lollapalooza Berlin 2025')));

INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('08-09-2025 20:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Kendrick Lamar'),
        TO_DATE('08-09-2025 22:30','DD-MM-YYYY HH24:MI'),
        'Kendrick Lamar Saturday headline Lollapalooza',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Hip-Hop'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Main Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Lollapalooza Berlin 2025')));

-- Lollapalooza Berlin 2025 – Perry Stage
INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('07-09-2025 22:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'Bad Bunny'),
        TO_DATE('08-09-2025 00:00','DD-MM-YYYY HH24:MI'),
        'Bad Bunny Friday night Perry Stage',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'Hip-Hop'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Perry Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Lollapalooza Berlin 2025')));

INSERT INTO Performance (Performance_Start_Time, Artist_ID, Performance_End_Time, Performance_Description, Genre_ID, Stage_ID)
VALUES (TO_DATE('08-09-2025 22:00','DD-MM-YYYY HH24:MI'),
        (SELECT Artist_ID FROM Artist WHERE Artist_Name = 'David Guetta'),
        TO_DATE('09-09-2025 00:00','DD-MM-YYYY HH24:MI'),
        'David Guetta closing Perry Stage',
        (SELECT Genre_ID FROM Genre WHERE Genre_Name = 'House'),
        (SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Perry Stage'
                                      AND Festival_ID = (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Lollapalooza Berlin 2025')));

COMMIT;
