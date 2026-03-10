DELETE
FROM Performance;
DELETE
FROM Stage;
DELETE
FROM Permit;
DELETE
FROM Ticket;
DELETE
FROM Festival;
DELETE
FROM Artist;
DELETE
FROM Genre;
DELETE
FROM TicketPlatform;
DELETE
FROM Visitor;
DELETE
FROM City;
DELETE
FROM Company;

COMMIT;-- 1. COMPANY
-- --------------------------------------------------------
INSERT INTO Company (Company_Name, Company_Founding_Year) VALUES ('Tomorrowland NV', 2005);
INSERT INTO Company (Company_Name, Company_Founding_Year) VALUES ('Rock Werchter Productions', 1975);
INSERT INTO Company (Company_Name, Company_Founding_Year) VALUES ('Pukkelpop VZW', 1985);
INSERT INTO Company (Company_Name, Company_Founding_Year) VALUES ('Live Nation Belgium', 1996);
INSERT INTO Company (Company_Name, Company_Founding_Year) VALUES ('AEG Presents Europe', 2000);
INSERT INTO Company (Company_Name, Company_Founding_Year) VALUES ('Sziget Cultural Management', 1993);
INSERT INTO Company (Company_Name, Company_Founding_Year) VALUES ('Roskilde Festival Society', 1971);
INSERT INTO Company (Company_Name, Company_Founding_Year) VALUES ('Glastonbury Festivals Ltd', 1970);
INSERT INTO Company (Company_Name, Company_Founding_Year) VALUES ('Primavera Sound SL', 2001);
INSERT INTO Company (Company_Name, Company_Founding_Year) VALUES ('Melt! Festival GmbH', 1997);

-- --------------------------------------------------------
-- 2. CITY  (Zipcode is used in all subselects – guarantees 1 row)
-- --------------------------------------------------------
INSERT INTO City (Zipcode, City, Country) VALUES ('2000',   'Antwerp',     'Belgium');
INSERT INTO City (Zipcode, City, Country) VALUES ('2850',   'Boom',        'Belgium');
INSERT INTO City (Zipcode, City, Country) VALUES ('3500',   'Hasselt',     'Belgium');
INSERT INTO City (Zipcode, City, Country) VALUES ('1000',   'Brussels',    'Belgium');
INSERT INTO City (Zipcode, City, Country) VALUES ('1117BP', 'Budapest',    'Hungary');
INSERT INTO City (Zipcode, City, Country) VALUES ('4000',   'Roskilde',    'Denmark');
INSERT INTO City (Zipcode, City, Country) VALUES ('BA44AF', 'Glastonbury', 'United Kingdom');
INSERT INTO City (Zipcode, City, Country) VALUES ('08003',  'Barcelona',   'Spain');
INSERT INTO City (Zipcode, City, Country) VALUES ('06773',  'Ferropolis',  'Germany');
INSERT INTO City (Zipcode, City, Country) VALUES ('10115',  'Berlin',      'Germany');

-- --------------------------------------------------------
-- 3. VISITOR  (City_ID via Zipcode + Country – guaranteed unique)
-- --------------------------------------------------------
INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Lena', 'Maes', TO_DATE('15-03-1995','DD-MM-YYYY'), 'lena.maes@gmail.com',
        'Meir', '42',
        (SELECT City_ID FROM City WHERE Zipcode = '2000' AND Country = 'Belgium'),
        'Female');

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Jonas', 'De Wolf', TO_DATE('22-07-1990','DD-MM-YYYY'), 'jonas.dewolf@hotmail.com',
        'Nationalestraat', '17',
        (SELECT City_ID FROM City WHERE Zipcode = '2000' AND Country = 'Belgium'),
        'Male');

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Sophie', 'Janssen', TO_DATE('08-11-1998','DD-MM-YYYY'), 'sophie.janssen@outlook.com',
        'Groenplaats', '5',
        (SELECT City_ID FROM City WHERE Zipcode = '2000' AND Country = 'Belgium'),
        'Female');

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Pieter', 'Claes', TO_DATE('30-04-1985','DD-MM-YYYY'), 'pieter.claes@yahoo.com',
        'Kammenstraat', '88',
        (SELECT City_ID FROM City WHERE Zipcode = '2000' AND Country = 'Belgium'),
        'Male');

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Nathalie', 'Hermans', TO_DATE('12-02-2000','DD-MM-YYYY'), 'nathalie.hermans@gmail.com',
        'Lange Nieuwstraat', '33',
        (SELECT City_ID FROM City WHERE Zipcode = '2000' AND Country = 'Belgium'),
        'Female');

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Adrien', 'Dupont', TO_DATE('19-09-1993','DD-MM-YYYY'), 'adrien.dupont@gmail.com',
        'Rue Royale', '12',
        (SELECT City_ID FROM City WHERE Zipcode = '1000' AND Country = 'Belgium'),
        'Male');

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Zara', 'Ahmed', TO_DATE('03-01-1997','DD-MM-YYYY'), 'zara.ahmed@gmail.com',
        'Leopoldstraat', '7',
        (SELECT City_ID FROM City WHERE Zipcode = '2000' AND Country = 'Belgium'),
        'Female');

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Markus', 'Bauer', TO_DATE('27-08-1988','DD-MM-YYYY'), 'markus.bauer@web.de',
        'Hauptstrasse', '55',
        (SELECT City_ID FROM City WHERE Zipcode = '10115' AND Country = 'Germany'),
        'Male');

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Elena', 'Kovacs', TO_DATE('14-12-2001','DD-MM-YYYY'), 'elena.kovacs@gmail.com',
        'Váci utca', '23',
        (SELECT City_ID FROM City WHERE Zipcode = '1117BP' AND Country = 'Hungary'),
        'Female');

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Chloe', 'Martin', TO_DATE('05-06-1996','DD-MM-YYYY'), 'chloe.martin@gmail.com',
        'Brederodestraat', '9',
        (SELECT City_ID FROM City WHERE Zipcode = '2000' AND Country = 'Belgium'),
        'Female');

-- --------------------------------------------------------
-- 4. TICKETPLATFORM
-- --------------------------------------------------------
INSERT INTO TicketPlatform (TicketPlatform_Name, TicketPlatform_URL) VALUES ('Ticketmaster Belgium', 'https://www.ticketmaster.be');
INSERT INTO TicketPlatform (TicketPlatform_Name, TicketPlatform_URL) VALUES ('See Tickets',          'https://www.seetickets.com');
INSERT INTO TicketPlatform (TicketPlatform_Name, TicketPlatform_URL) VALUES ('Paylogic',             'https://www.paylogic.com');
INSERT INTO TicketPlatform (TicketPlatform_Name, TicketPlatform_URL) VALUES ('Eventbrite',           'https://www.eventbrite.be');
INSERT INTO TicketPlatform (TicketPlatform_Name, TicketPlatform_URL) VALUES ('Tele Ticket Service',  'https://www.teleticketservice.com');
INSERT INTO TicketPlatform (TicketPlatform_Name, TicketPlatform_URL) VALUES ('Dice FM',              'https://dice.fm');
INSERT INTO TicketPlatform (TicketPlatform_Name, TicketPlatform_URL) VALUES ('Fever Up',             'https://feverup.com');
INSERT INTO TicketPlatform (TicketPlatform_Name, TicketPlatform_URL) VALUES ('TicketSwap',           'https://www.ticketswap.com');
INSERT INTO TicketPlatform (TicketPlatform_Name, TicketPlatform_URL) VALUES ('Resident Advisor',     'https://ra.co');
INSERT INTO TicketPlatform (TicketPlatform_Name, TicketPlatform_URL) VALUES ('StubHub International','https://www.stubhub.com');

-- --------------------------------------------------------
-- 5. FESTIVAL  (Company_ID via Company_Name; City_ID via Zipcode+Country)
-- --------------------------------------------------------
INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
VALUES ('Tomorrowland Summer 2024',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Tomorrowland NV'),
        TO_DATE('19-07-2024','DD-MM-YYYY'), TO_DATE('21-07-2024','DD-MM-YYYY'),
        'De Schorre',
        (SELECT City_ID FROM City WHERE Zipcode = '2850' AND Country = 'Belgium'),
        TO_DATE('10:00','HH24:MI'), TO_DATE('10:00','HH24:MI') + INTERVAL '17' HOUR,
        200000);

INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
VALUES ('Rock Werchter 2024',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Rock Werchter Productions'),
        TO_DATE('04-07-2024','DD-MM-YYYY'), TO_DATE('07-07-2024','DD-MM-YYYY'),
        'Festivalpark Werchter',
        (SELECT City_ID FROM City WHERE Zipcode = '3500' AND Country = 'Belgium'),
        TO_DATE('11:00','HH24:MI'), TO_DATE('11:00','HH24:MI') + INTERVAL '15' HOUR,
        90000);

INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
VALUES ('Pukkelpop 2024',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Pukkelpop VZW'),
        TO_DATE('15-08-2024','DD-MM-YYYY'), TO_DATE('18-08-2024','DD-MM-YYYY'),
        'Hasselt Kiewit',
        (SELECT City_ID FROM City WHERE Zipcode = '3500' AND Country = 'Belgium'),
        TO_DATE('12:00','HH24:MI'), TO_DATE('12:00','HH24:MI') + INTERVAL '13' HOUR,
        65000);

INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
VALUES ('Sziget Festival 2024',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Sziget Cultural Management'),
        TO_DATE('07-08-2024','DD-MM-YYYY'), TO_DATE('12-08-2024','DD-MM-YYYY'),
        'Óbudai-sziget',
        (SELECT City_ID FROM City WHERE Zipcode = '1117BP' AND Country = 'Hungary'),
        TO_DATE('10:00','HH24:MI'), TO_DATE('10:00','HH24:MI') + INTERVAL '18' HOUR,
        100000);

INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
VALUES ('Roskilde Festival 2024',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Roskilde Festival Society'),
        TO_DATE('29-06-2024','DD-MM-YYYY'), TO_DATE('06-07-2024','DD-MM-YYYY'),
        'Roskilde Dyrskueplads',
        (SELECT City_ID FROM City WHERE Zipcode = '4000' AND Country = 'Denmark'),
        TO_DATE('09:00','HH24:MI'), TO_DATE('09:00','HH24:MI') + INTERVAL '18' HOUR,
        130000);

INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
VALUES ('Glastonbury 2025',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Glastonbury Festivals Ltd'),
        TO_DATE('25-06-2025','DD-MM-YYYY'), TO_DATE('29-06-2025','DD-MM-YYYY'),
        'Worthy Farm Pilton',
        (SELECT City_ID FROM City WHERE Zipcode = 'BA44AF' AND Country = 'United Kingdom'),
        TO_DATE('08:00','HH24:MI'), TO_DATE('08:00','HH24:MI') + INTERVAL '21' HOUR,
        210000);

INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
VALUES ('Primavera Sound 2025',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Primavera Sound SL'),
        TO_DATE('29-05-2025','DD-MM-YYYY'), TO_DATE('01-06-2025','DD-MM-YYYY'),
        'Parc del Fòrum',
        (SELECT City_ID FROM City WHERE Zipcode = '08003' AND Country = 'Spain'),
        TO_DATE('14:00','HH24:MI'), TO_DATE('14:00','HH24:MI') + INTERVAL '14' HOUR,
        75000);

INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
VALUES ('Melt! Festival 2025',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Melt! Festival GmbH'),
        TO_DATE('18-07-2025','DD-MM-YYYY'), TO_DATE('20-07-2025','DD-MM-YYYY'),
        'Ferropolis Industriepark',
        (SELECT City_ID FROM City WHERE Zipcode = '06773' AND Country = 'Germany'),
        TO_DATE('13:00','HH24:MI'), TO_DATE('13:00','HH24:MI') + INTERVAL '16' HOUR,
        25000);

INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
VALUES ('Tomorrowland Winter 2025',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Tomorrowland NV'),
        TO_DATE('08-03-2025','DD-MM-YYYY'), TO_DATE('15-03-2025','DD-MM-YYYY'),
        'Alpe d''Huez',
        (SELECT City_ID FROM City WHERE Zipcode = '1000' AND Country = 'Belgium'),
        TO_DATE('10:00','HH24:MI'), TO_DATE('10:00','HH24:MI') + INTERVAL '16' HOUR,
        30000);

INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
VALUES ('Lollapalooza Berlin 2025',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'AEG Presents Europe'),
        TO_DATE('07-09-2025','DD-MM-YYYY'), TO_DATE('08-09-2025','DD-MM-YYYY'),
        'Olympiastadion Berlin',
        (SELECT City_ID FROM City WHERE Zipcode = '10115' AND Country = 'Germany'),
        TO_DATE('11:00','HH24:MI'), TO_DATE('11:00','HH24:MI') + INTERVAL '12' HOUR,
        85000);

-- --------------------------------------------------------
-- 6. PERMIT  (Festival_ID via Festival_Name – unique)
-- --------------------------------------------------------
INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Noise', 'Noise exemption permit for outdoor amplified music',
        TO_DATE('01-01-2024','DD-MM-YYYY'), TO_DATE('15-02-2024','DD-MM-YYYY'), TO_DATE('22-07-2024','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Alcohol', 'Beer and spirits vendor license Tomorrowland',
        TO_DATE('05-02-2024','DD-MM-YYYY'), TO_DATE('20-03-2024','DD-MM-YYYY'), TO_DATE('22-07-2024','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Traffic', 'Road closure permit A12 motorway approach',
        TO_DATE('10-03-2024','DD-MM-YYYY'), TO_DATE('01-05-2024','DD-MM-YYYY'), TO_DATE('22-07-2024','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Environmental', 'Environmental impact clearance for large outdoor event',
        TO_DATE('10-01-2024','DD-MM-YYYY'), TO_DATE('20-02-2024','DD-MM-YYYY'), TO_DATE('08-07-2024','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Rock Werchter 2024'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Public Safety', 'Emergency services coordination permit Rock Werchter',
        TO_DATE('01-02-2024','DD-MM-YYYY'), TO_DATE('15-03-2024','DD-MM-YYYY'), TO_DATE('08-07-2024','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Rock Werchter 2024'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Noise', 'Extended late-night noise exemption Rock Werchter',
        TO_DATE('15-02-2024','DD-MM-YYYY'), TO_DATE('01-04-2024','DD-MM-YYYY'), TO_DATE('08-07-2024','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Rock Werchter 2024'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Public Safety', 'Crowd management and emergency exit permit',
        TO_DATE('05-02-2024','DD-MM-YYYY'), TO_DATE('01-03-2024','DD-MM-YYYY'), TO_DATE('19-08-2024','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Pukkelpop 2024'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Alcohol', 'Alcohol sales license Pukkelpop',
        TO_DATE('10-03-2024','DD-MM-YYYY'), TO_DATE('20-04-2024','DD-MM-YYYY'), TO_DATE('19-08-2024','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Pukkelpop 2024'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Alcohol', 'License for on-site alcohol sales and distribution',
        TO_DATE('01-03-2024','DD-MM-YYYY'), TO_DATE('15-04-2024','DD-MM-YYYY'), TO_DATE('15-08-2024','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Sziget Festival 2024'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Health', 'First aid and medical tent permit Sziget',
        TO_DATE('01-04-2024','DD-MM-YYYY'), TO_DATE('01-05-2024','DD-MM-YYYY'), TO_DATE('13-08-2024','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Sziget Festival 2024'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Fire Safety', 'Pyrotechnics and open flame usage permit',
        TO_DATE('10-02-2024','DD-MM-YYYY'), TO_DATE('05-03-2024','DD-MM-YYYY'), TO_DATE('10-07-2024','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Roskilde Festival 2024'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Construction', 'Temporary structure permit Roskilde camping',
        TO_DATE('01-01-2024','DD-MM-YYYY'), TO_DATE('01-02-2024','DD-MM-YYYY'), TO_DATE('07-07-2024','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Roskilde Festival 2024'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Construction', 'Temporary stage and infrastructure construction permit',
        TO_DATE('01-11-2024','DD-MM-YYYY'), TO_DATE('15-12-2024','DD-MM-YYYY'), TO_DATE('03-07-2025','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Glastonbury 2025'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Noise', 'Glastonbury 2025 late-night noise exemption',
        TO_DATE('15-12-2024','DD-MM-YYYY'), TO_DATE('01-02-2025','DD-MM-YYYY'), TO_DATE('30-06-2025','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Glastonbury 2025'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Health', 'Medical services and first aid station permit',
        TO_DATE('01-12-2024','DD-MM-YYYY'), TO_DATE('20-01-2025','DD-MM-YYYY'), TO_DATE('05-06-2025','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Primavera Sound 2025'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Noise', 'Late-night amplified music permit Primavera',
        TO_DATE('15-12-2024','DD-MM-YYYY'), TO_DATE('01-02-2025','DD-MM-YYYY'), TO_DATE('02-06-2025','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Primavera Sound 2025'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Traffic', 'Road closure and traffic management permit',
        TO_DATE('15-01-2025','DD-MM-YYYY'), TO_DATE('01-03-2025','DD-MM-YYYY'), TO_DATE('25-07-2025','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Melt! Festival 2025'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Traffic', 'Melt Festival site access road permit',
        TO_DATE('01-03-2025','DD-MM-YYYY'), TO_DATE('15-04-2025','DD-MM-YYYY'), TO_DATE('21-07-2025','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Melt! Festival 2025'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Noise', 'Night noise exemption permit for alpine event',
        TO_DATE('01-10-2024','DD-MM-YYYY'), TO_DATE('01-11-2024','DD-MM-YYYY'), TO_DATE('16-03-2025','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Winter 2025'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Public Safety', 'Mountain rescue coordination permit',
        TO_DATE('15-10-2024','DD-MM-YYYY'), TO_DATE('15-11-2024','DD-MM-YYYY'), TO_DATE('16-03-2025','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Winter 2025'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Security', 'Private security and perimeter control permit',
        TO_DATE('01-03-2025','DD-MM-YYYY'), TO_DATE('15-04-2025','DD-MM-YYYY'), TO_DATE('10-09-2025','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Lollapalooza Berlin 2025'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date, Permit_Expiration_Date, Festival_ID)
VALUES ('Fire Safety', 'Lollapalooza Berlin pyrotechnics permit',
        TO_DATE('01-04-2025','DD-MM-YYYY'), TO_DATE('01-06-2025','DD-MM-YYYY'), TO_DATE('09-09-2025','DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Lollapalooza Berlin 2025'));

-- --------------------------------------------------------
-- 7. GENRE
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
-- 8. ARTIST
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
-- 9. STAGE  (Festival_ID via Festival_Name)
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
-- 10. TICKET  (Visitor_ID via email; Festival_ID via name; TicketPlatform_ID via name)
-- --------------------------------------------------------

-- Lena: Tomorrowland + Pukkelpop + Lollapalooza
INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (320.00, 'EUR', TO_DATE('19-07-2024','DD-MM-YYYY'), TO_DATE('10-01-2024','DD-MM-YYYY'),
        'Full weekend pass Tomorrowland', 'TML20240001AA', 'Weekend', 'Used', 'https://qr.tomorrowland.com/TML20240001AA',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Ticketmaster Belgium'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'lena.maes@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (195.00, 'EUR', TO_DATE('15-08-2024','DD-MM-YYYY'), TO_DATE('03-05-2024','DD-MM-YYYY'),
        'Pukkelpop combi – Lena', 'PKP20240001AA', 'Combi', 'Used', 'https://qr.pukkelpop.be/PKP20240001AA',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Paylogic'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'lena.maes@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Pukkelpop 2024'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (99.00, 'EUR', TO_DATE('07-09-2025','DD-MM-YYYY'), TO_DATE('25-05-2025','DD-MM-YYYY'),
        'Lollapalooza Berlin – Lena', 'LLP20250001AA', 'Weekend', 'Valid', 'https://qr.lollaberlin.de/LLP20250001AA',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Ticketmaster Belgium'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'lena.maes@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Lollapalooza Berlin 2025'));

-- Jonas: Rock Werchter + Tomorrowland
INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (89.50, 'EUR', TO_DATE('04-07-2024','DD-MM-YYYY'), TO_DATE('15-03-2024','DD-MM-YYYY'),
        'Single day Friday Rock Werchter', 'RWF20240001BB', 'Day', 'Used', 'https://qr.rockwerchter.be/RWF20240001BB',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'See Tickets'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'jonas.dewolf@hotmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Rock Werchter 2024'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (320.00, 'EUR', TO_DATE('19-07-2024','DD-MM-YYYY'), TO_DATE('20-02-2024','DD-MM-YYYY'),
        'Tomorrowland weekend – Jonas', 'TML20240001BB', 'Weekend', 'Used', 'https://qr.tomorrowland.com/TML20240001BB',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Paylogic'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'jonas.dewolf@hotmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'));

-- Sophie: Pukkelpop + Glastonbury
INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (195.00, 'EUR', TO_DATE('15-08-2024','DD-MM-YYYY'), TO_DATE('01-04-2024','DD-MM-YYYY'),
        '4-day combi ticket Pukkelpop', 'PKP20240001CC', 'Combi', 'Used', 'https://qr.pukkelpop.be/PKP20240001CC',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Paylogic'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'sophie.janssen@outlook.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Pukkelpop 2024'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (375.00, 'GBP', TO_DATE('25-06-2025','DD-MM-YYYY'), TO_DATE('01-11-2024','DD-MM-YYYY'),
        'Glastonbury full – Sophie', 'GLA20250001CC', 'Full Festival', 'Valid', 'https://qr.glastonbury.co.uk/GLA20250001CC',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Dice FM'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'sophie.janssen@outlook.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Glastonbury 2025'));

-- Pieter: Sziget + Roskilde
INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (290.00, 'EUR', TO_DATE('07-08-2024','DD-MM-YYYY'), TO_DATE('20-02-2024','DD-MM-YYYY'),
        '7-day full island ticket Sziget', 'SZI20240001DD', 'Full Festival', 'Used', 'https://qr.szigetfestival.com/SZI20240001DD',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Eventbrite'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'pieter.claes@yahoo.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Sziget Festival 2024'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (145.00, 'EUR', TO_DATE('29-06-2024','DD-MM-YYYY'), TO_DATE('10-02-2024','DD-MM-YYYY'),
        'Roskilde weekend – Pieter', 'RSK20240001DD', 'Weekend', 'Used', 'https://qr.roskilde.dk/RSK20240001DD',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Tele Ticket Service'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'pieter.claes@yahoo.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Roskilde Festival 2024'));

-- Nathalie: Roskilde + Primavera
INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (145.00, 'EUR', TO_DATE('29-06-2024','DD-MM-YYYY'), TO_DATE('05-01-2024','DD-MM-YYYY'),
        'Weekend ticket Roskilde', 'RSK20240001EE', 'Weekend', 'Used', 'https://qr.roskilde.dk/RSK20240001EE',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Tele Ticket Service'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'nathalie.hermans@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Roskilde Festival 2024'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (185.00, 'EUR', TO_DATE('29-05-2025','DD-MM-YYYY'), TO_DATE('05-01-2025','DD-MM-YYYY'),
        'Primavera Sound – Nathalie', 'PRM20250001EE', 'Combi', 'Valid', 'https://qr.primaverasound.com/PRM20250001EE',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Fever Up'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'nathalie.hermans@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Primavera Sound 2025'));

-- Adrien: Glastonbury + Sziget
INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (375.00, 'GBP', TO_DATE('25-06-2025','DD-MM-YYYY'), TO_DATE('15-10-2024','DD-MM-YYYY'),
        'Full Glastonbury ticket', 'GLA20250001FF', 'Full Festival', 'Valid', 'https://qr.glastonbury.co.uk/GLA20250001FF',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Dice FM'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'adrien.dupont@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Glastonbury 2025'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (290.00, 'EUR', TO_DATE('07-08-2024','DD-MM-YYYY'), TO_DATE('01-03-2024','DD-MM-YYYY'),
        'Sziget full – Adrien', 'SZI20240001FF', 'Full Festival', 'Used', 'https://qr.szigetfestival.com/SZI20240001FF',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Eventbrite'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'adrien.dupont@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Sziget Festival 2024'));

-- Zara: Primavera + Lollapalooza
INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (185.00, 'EUR', TO_DATE('29-05-2025','DD-MM-YYYY'), TO_DATE('01-12-2024','DD-MM-YYYY'),
        '3-day Primavera Sound pass', 'PRM20250001GG', 'Combi', 'Valid', 'https://qr.primaverasound.com/PRM20250001GG',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Fever Up'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'zara.ahmed@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Primavera Sound 2025'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (99.00, 'EUR', TO_DATE('07-09-2025','DD-MM-YYYY'), TO_DATE('10-05-2025','DD-MM-YYYY'),
        'Lollapalooza Berlin – Zara', 'LLP20250001GG', 'Weekend', 'Valid', 'https://qr.lollaberlin.de/LLP20250001GG',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'StubHub International'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'zara.ahmed@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Lollapalooza Berlin 2025'));

-- Markus: Melt + Tomorrowland Winter
INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (98.00, 'EUR', TO_DATE('18-07-2025','DD-MM-YYYY'), TO_DATE('10-02-2025','DD-MM-YYYY'),
        'Weekend ticket Melt Festival', 'MLT20250001HH', 'Weekend', 'Valid', 'https://qr.meltfestival.de/MLT20250001HH',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'TicketSwap'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'markus.bauer@web.de'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Melt! Festival 2025'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (220.00, 'EUR', TO_DATE('08-03-2025','DD-MM-YYYY'), TO_DATE('15-10-2024','DD-MM-YYYY'),
        'Tomorrowland Winter – Markus', 'TMW20250001HH', 'Full Festival', 'Used', 'https://qr.tomorrowland.com/TMW20250001HH',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Resident Advisor'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'markus.bauer@web.de'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Winter 2025'));

-- Elena: Tomorrowland Winter + Melt
INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (220.00, 'EUR', TO_DATE('08-03-2025','DD-MM-YYYY'), TO_DATE('01-09-2024','DD-MM-YYYY'),
        'Full week Tomorrowland Winter', 'TMW20250001II', 'Full Festival', 'Used', 'https://qr.tomorrowland.com/TMW20250001II',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Resident Advisor'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'elena.kovacs@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Winter 2025'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (98.00, 'EUR', TO_DATE('18-07-2025','DD-MM-YYYY'), TO_DATE('01-03-2025','DD-MM-YYYY'),
        'Melt Festival – Elena', 'MLT20250001II', 'Weekend', 'Valid', 'https://qr.meltfestival.de/MLT20250001II',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'TicketSwap'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'elena.kovacs@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Melt! Festival 2025'));

-- Chloe: Lollapalooza + Rock Werchter
INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (99.00, 'EUR', TO_DATE('07-09-2025','DD-MM-YYYY'), TO_DATE('20-04-2025','DD-MM-YYYY'),
        '2-day Lollapalooza Berlin pass', 'LLP20250001JJ', 'Weekend', 'Valid', 'https://qr.lollaberlin.de/LLP20250001JJ',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'StubHub International'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'chloe.martin@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Lollapalooza Berlin 2025'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date, Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status, Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (89.50, 'EUR', TO_DATE('05-07-2024','DD-MM-YYYY'), TO_DATE('20-04-2024','DD-MM-YYYY'),
        'Rock Werchter day – Chloe', 'RWF20240001JJ', 'Day', 'Used', 'https://qr.rockwerchter.be/RWF20240001JJ',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'See Tickets'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'chloe.martin@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Rock Werchter 2024'));

-- --------------------------------------------------------
-- 11. PERFORMANCE  (Stage_ID via Stage_Name+Festival_Name; Artist_ID via name; Genre_ID via name)
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