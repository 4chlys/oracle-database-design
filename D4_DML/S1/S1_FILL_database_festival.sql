DELETE
FROM Ticket;
DELETE
FROM Permit;
DELETE
FROM Festival;
DELETE
FROM TicketPlatform;
DELETE
FROM Visitor;
DELETE
FROM City;
DELETE
FROM Company;

COMMIT;

-- 1. COMPANY
INSERT INTO Company (Company_Name, Company_Founding_Year)
VALUES ('Tomorrowland NV', 2005);
INSERT INTO Company (Company_Name, Company_Founding_Year)
VALUES ('Rock Werchter Productions', 1975);
INSERT INTO Company (Company_Name, Company_Founding_Year)
VALUES ('Pukkelpop VZW', 1985);
INSERT INTO Company (Company_Name, Company_Founding_Year)
VALUES ('Live Nation Belgium', 1996);
INSERT INTO Company (Company_Name, Company_Founding_Year)
VALUES ('AEG Presents Europe', 2000);
INSERT INTO Company (Company_Name, Company_Founding_Year)
VALUES ('Sziget Cultural Management', 1993);
INSERT INTO Company (Company_Name, Company_Founding_Year)
VALUES ('Roskilde Festival Society', 1971);
INSERT INTO Company (Company_Name, Company_Founding_Year)
VALUES ('Glastonbury Festivals Ltd', 1970);
INSERT INTO Company (Company_Name, Company_Founding_Year)
VALUES ('Primavera Sound SL', 2001);
INSERT INTO Company (Company_Name, Company_Founding_Year)
VALUES ('Melt! Festival GmbH', 1997);

-- 2. CITY
INSERT INTO City (Zipcode, City, Country)
VALUES ('2000', 'Antwerp', 'Belgium');
INSERT INTO City (Zipcode, City, Country)
VALUES ('2850', 'Boom', 'Belgium');
INSERT INTO City (Zipcode, City, Country)
VALUES ('3118', 'Werchter', 'Belgium');
INSERT INTO City (Zipcode, City, Country)
VALUES ('3500', 'Hasselt', 'Belgium');
INSERT INTO City (Zipcode, City, Country)
VALUES ('1000', 'Brussels', 'Belgium');
INSERT INTO City (Zipcode, City, Country)
VALUES ('1117BP', 'Budapest', 'Hungary');
INSERT INTO City (Zipcode, City, Country)
VALUES ('4000', 'Roskilde', 'Denmark');
INSERT INTO City (Zipcode, City, Country)
VALUES ('BA44AF', 'Glastonbury', 'United Kingdom');
INSERT INTO City (Zipcode, City, Country)
VALUES ('08003', 'Barcelona', 'Spain');
INSERT INTO City (Zipcode, City, Country)
VALUES ('06773', 'Ferropolis', 'Germany');
INSERT INTO City (Zipcode, City, Country)
VALUES ('10115', 'Berlin', 'Germany');
INSERT INTO City (Zipcode, City, Country)
VALUES ('73150', 'Alpe d''Huez', 'France');

-- 3. VISITOR
INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Lena', 'Maes', TO_DATE('15-03-1995', 'DD-MM-YYYY'), 'lena.maes@gmail.com',
        'Meir', '42',
        (SELECT City_ID FROM City WHERE Zipcode = '2000' AND Country = 'Belgium'),
        'Female');

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Jonas', 'De Wolf', TO_DATE('22-07-1990', 'DD-MM-YYYY'), 'jonas.dewolf@hotmail.com',
        'Nationalestraat', '17',
        (SELECT City_ID FROM City WHERE Zipcode = '2000' AND Country = 'Belgium'),
        'Male');

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Sophie', 'Janssen', TO_DATE('08-11-1998', 'DD-MM-YYYY'), 'sophie.janssen@outlook.com',
        'Groenplaats', '5',
        (SELECT City_ID FROM City WHERE Zipcode = '2000' AND Country = 'Belgium'),
        'Female');

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Pieter', 'Claes', TO_DATE('30-04-1985', 'DD-MM-YYYY'), 'pieter.claes@yahoo.com',
        'Kammenstraat', '88',
        (SELECT City_ID FROM City WHERE Zipcode = '2000' AND Country = 'Belgium'),
        'Male');

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Nathalie', 'Hermans', TO_DATE('12-02-2000', 'DD-MM-YYYY'), 'nathalie.hermans@gmail.com',
        'Lange Nieuwstraat', '33',
        (SELECT City_ID FROM City WHERE Zipcode = '2000' AND Country = 'Belgium'),
        'Female');

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Adrien', 'Dupont', TO_DATE('19-09-1993', 'DD-MM-YYYY'), 'adrien.dupont@gmail.com',
        'Rue Royale', '12',
        (SELECT City_ID FROM City WHERE Zipcode = '1000' AND Country = 'Belgium'),
        'Male');

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Zara', 'Ahmed', TO_DATE('03-01-1997', 'DD-MM-YYYY'), 'zara.ahmed@gmail.com',
        'Leopoldstraat', '7',
        (SELECT City_ID FROM City WHERE Zipcode = '2000' AND Country = 'Belgium'),
        'Female');

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Markus', 'Bauer', TO_DATE('27-08-1988', 'DD-MM-YYYY'), 'markus.bauer@web.de',
        'Hauptstrasse', '55',
        (SELECT City_ID FROM City WHERE Zipcode = '10115' AND Country = 'Germany'),
        'Male');

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Elena', 'Kovacs', TO_DATE('14-12-2001', 'DD-MM-YYYY'), 'elena.kovacs@gmail.com',
        'Váci utca', '23',
        (SELECT City_ID FROM City WHERE Zipcode = '1117BP' AND Country = 'Hungary'),
        'Female');

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Chloe', 'Martin', TO_DATE('05-06-1996', 'DD-MM-YYYY'), 'chloe.martin@gmail.com',
        'Brederodestraat', '9',
        (SELECT City_ID FROM City WHERE Zipcode = '2000' AND Country = 'Belgium'),
        'Female');

-- 4. TICKETPLATFORM
INSERT INTO TicketPlatform (TicketPlatform_Name, TicketPlatform_URL)
VALUES ('Ticketmaster Belgium', 'https://www.ticketmaster.be');
INSERT INTO TicketPlatform (TicketPlatform_Name, TicketPlatform_URL)
VALUES ('See Tickets', 'https://www.seetickets.com');
INSERT INTO TicketPlatform (TicketPlatform_Name, TicketPlatform_URL)
VALUES ('Paylogic', 'https://www.paylogic.com');
INSERT INTO TicketPlatform (TicketPlatform_Name, TicketPlatform_URL)
VALUES ('Eventbrite', 'https://www.eventbrite.be');
INSERT INTO TicketPlatform (TicketPlatform_Name, TicketPlatform_URL)
VALUES ('Tele Ticket Service', 'https://www.teleticketservice.com');
INSERT INTO TicketPlatform (TicketPlatform_Name, TicketPlatform_URL)
VALUES ('Dice FM', 'https://dice.fm');
INSERT INTO TicketPlatform (TicketPlatform_Name, TicketPlatform_URL)
VALUES ('Fever Up', 'https://feverup.com');
INSERT INTO TicketPlatform (TicketPlatform_Name, TicketPlatform_URL)
VALUES ('TicketSwap', 'https://www.ticketswap.com');
INSERT INTO TicketPlatform (TicketPlatform_Name, TicketPlatform_URL)
VALUES ('Resident Advisor', 'https://ra.co');
INSERT INTO TicketPlatform (TicketPlatform_Name, TicketPlatform_URL)
VALUES ('StubHub International', 'https://www.stubhub.com');

-- 5. FESTIVAL  (shared table – S1 is responsible)
--    Company_ID via Company_Name; City_ID via Zipcode+Country
INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
VALUES ('Tomorrowland Summer 2024',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Tomorrowland NV'),
        TO_DATE('19-07-2024', 'DD-MM-YYYY'), TO_DATE('21-07-2024', 'DD-MM-YYYY'),
        'De Schorre',
        (SELECT City_ID FROM City WHERE Zipcode = '2850' AND Country = 'Belgium'),
        TO_DATE('10:00', 'HH24:MI'), TO_DATE('10:00', 'HH24:MI') + INTERVAL '17' HOUR,
        200000);

INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
VALUES ('Rock Werchter 2024',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Rock Werchter Productions'),
        TO_DATE('04-07-2024', 'DD-MM-YYYY'), TO_DATE('07-07-2024', 'DD-MM-YYYY'),
        'Festivalpark Werchter',
        (SELECT City_ID FROM City WHERE Zipcode = '3118' AND Country = 'Belgium'),
        TO_DATE('11:00', 'HH24:MI'), TO_DATE('11:00', 'HH24:MI') + INTERVAL '15' HOUR,
        90000);

INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
VALUES ('Pukkelpop 2024',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Pukkelpop VZW'),
        TO_DATE('15-08-2024', 'DD-MM-YYYY'), TO_DATE('18-08-2024', 'DD-MM-YYYY'),
        'Hasselt Kiewit',
        (SELECT City_ID FROM City WHERE Zipcode = '3500' AND Country = 'Belgium'),
        TO_DATE('12:00', 'HH24:MI'), TO_DATE('12:00', 'HH24:MI') + INTERVAL '13' HOUR,
        65000);

INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
VALUES ('Sziget Festival 2024',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Sziget Cultural Management'),
        TO_DATE('07-08-2024', 'DD-MM-YYYY'), TO_DATE('12-08-2024', 'DD-MM-YYYY'),
        'Óbudai-sziget',
        (SELECT City_ID FROM City WHERE Zipcode = '1117BP' AND Country = 'Hungary'),
        TO_DATE('10:00', 'HH24:MI'), TO_DATE('10:00', 'HH24:MI') + INTERVAL '18' HOUR,
        100000);

INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
VALUES ('Roskilde Festival 2024',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Roskilde Festival Society'),
        TO_DATE('29-06-2024', 'DD-MM-YYYY'), TO_DATE('06-07-2024', 'DD-MM-YYYY'),
        'Roskilde Dyrskueplads',
        (SELECT City_ID FROM City WHERE Zipcode = '4000' AND Country = 'Denmark'),
        TO_DATE('09:00', 'HH24:MI'), TO_DATE('09:00', 'HH24:MI') + INTERVAL '18' HOUR,
        130000);

INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
VALUES ('Glastonbury 2025',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Glastonbury Festivals Ltd'),
        TO_DATE('25-06-2025', 'DD-MM-YYYY'), TO_DATE('29-06-2025', 'DD-MM-YYYY'),
        'Worthy Farm Pilton',
        (SELECT City_ID FROM City WHERE Zipcode = 'BA44AF' AND Country = 'United Kingdom'),
        TO_DATE('08:00', 'HH24:MI'), TO_DATE('08:00', 'HH24:MI') + INTERVAL '21' HOUR,
        210000);

INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
VALUES ('Primavera Sound 2025',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Primavera Sound SL'),
        TO_DATE('29-05-2025', 'DD-MM-YYYY'), TO_DATE('01-06-2025', 'DD-MM-YYYY'),
        'Parc del Fòrum',
        (SELECT City_ID FROM City WHERE Zipcode = '08003' AND Country = 'Spain'),
        TO_DATE('16:00', 'HH24:MI'), TO_DATE('16:00', 'HH24:MI') + INTERVAL '12' HOUR,
        60000);

INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
VALUES ('Melt! Festival 2025',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Melt! Festival GmbH'),
        TO_DATE('18-07-2025', 'DD-MM-YYYY'), TO_DATE('20-07-2025', 'DD-MM-YYYY'),
        'Ferropolis Industrial Park',
        (SELECT City_ID FROM City WHERE Zipcode = '06773' AND Country = 'Germany'),
        TO_DATE('14:00', 'HH24:MI'), TO_DATE('14:00', 'HH24:MI') + INTERVAL '16' HOUR,
        25000);

INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
VALUES ('Tomorrowland Winter 2025',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Tomorrowland NV'),
        TO_DATE('08-03-2025', 'DD-MM-YYYY'), TO_DATE('15-03-2025', 'DD-MM-YYYY'),
        'Alpe d''Huez Ski Resort',
        (SELECT City_ID FROM City WHERE Zipcode = '73150' AND Country = 'France'),
        TO_DATE('10:00', 'HH24:MI'), TO_DATE('10:00', 'HH24:MI') + INTERVAL '16' HOUR,
        30000);

INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour, Festival_Capacity)
VALUES ('Lollapalooza Berlin 2025',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Live Nation Belgium'),
        TO_DATE('07-09-2025', 'DD-MM-YYYY'), TO_DATE('08-09-2025', 'DD-MM-YYYY'),
        'Olympiagelände Berlin',
        (SELECT City_ID FROM City WHERE Zipcode = '10115' AND Country = 'Germany'),
        TO_DATE('11:00', 'HH24:MI'), TO_DATE('11:00', 'HH24:MI') + INTERVAL '14' HOUR,
        85000);

-- 6. PERMIT  (Festival_ID via Festival_Name)

-- Tomorrowland Summer 2024
INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Noise', 'Noise exemption permit for outdoor amplified music',
        TO_DATE('01-01-2024', 'DD-MM-YYYY'), TO_DATE('15-02-2024', 'DD-MM-YYYY'), TO_DATE('22-07-2024', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Alcohol', 'Beer and spirits vendor license Tomorrowland',
        TO_DATE('05-02-2024', 'DD-MM-YYYY'), TO_DATE('20-03-2024', 'DD-MM-YYYY'), TO_DATE('22-07-2024', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Traffic', 'Road closure permit A12 motorway approach',
        TO_DATE('10-03-2024', 'DD-MM-YYYY'), TO_DATE('01-05-2024', 'DD-MM-YYYY'), TO_DATE('22-07-2024', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'));

-- Rock Werchter 2024
INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Environmental', 'Environmental impact clearance for large outdoor event',
        TO_DATE('10-01-2024', 'DD-MM-YYYY'), TO_DATE('20-02-2024', 'DD-MM-YYYY'), TO_DATE('08-07-2024', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Rock Werchter 2024'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Public Safety', 'Emergency services coordination permit Rock Werchter',
        TO_DATE('01-02-2024', 'DD-MM-YYYY'), TO_DATE('15-03-2024', 'DD-MM-YYYY'), TO_DATE('08-07-2024', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Rock Werchter 2024'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Noise', 'Extended late-night noise exemption Rock Werchter',
        TO_DATE('15-02-2024', 'DD-MM-YYYY'), TO_DATE('01-04-2024', 'DD-MM-YYYY'), TO_DATE('08-07-2024', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Rock Werchter 2024'));

-- Pukkelpop 2024
INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Public Safety', 'Crowd management and emergency exit permit',
        TO_DATE('05-02-2024', 'DD-MM-YYYY'), TO_DATE('01-03-2024', 'DD-MM-YYYY'), TO_DATE('19-08-2024', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Pukkelpop 2024'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Alcohol', 'Alcohol sales license Pukkelpop',
        TO_DATE('10-03-2024', 'DD-MM-YYYY'), TO_DATE('20-04-2024', 'DD-MM-YYYY'), TO_DATE('19-08-2024', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Pukkelpop 2024'));

-- Sziget Festival 2024
INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Alcohol', 'License for on-site alcohol sales and distribution',
        TO_DATE('01-03-2024', 'DD-MM-YYYY'), TO_DATE('15-04-2024', 'DD-MM-YYYY'), TO_DATE('15-08-2024', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Sziget Festival 2024'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Health', 'First aid and medical tent permit Sziget',
        TO_DATE('01-04-2024', 'DD-MM-YYYY'), TO_DATE('01-05-2024', 'DD-MM-YYYY'), TO_DATE('13-08-2024', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Sziget Festival 2024'));

-- Roskilde Festival 2024
INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Fire Safety', 'Pyrotechnics and open flame usage permit',
        TO_DATE('10-02-2024', 'DD-MM-YYYY'), TO_DATE('05-03-2024', 'DD-MM-YYYY'), TO_DATE('10-07-2024', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Roskilde Festival 2024'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Construction', 'Temporary structure permit Roskilde camping',
        TO_DATE('01-01-2024', 'DD-MM-YYYY'), TO_DATE('01-02-2024', 'DD-MM-YYYY'), TO_DATE('07-07-2024', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Roskilde Festival 2024'));

-- Glastonbury 2025
INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Construction', 'Temporary stage and infrastructure construction permit',
        TO_DATE('01-11-2024', 'DD-MM-YYYY'), TO_DATE('15-12-2024', 'DD-MM-YYYY'), TO_DATE('03-07-2025', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Glastonbury 2025'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Noise', 'Glastonbury 2025 late-night noise exemption',
        TO_DATE('15-12-2024', 'DD-MM-YYYY'), TO_DATE('01-02-2025', 'DD-MM-YYYY'), TO_DATE('30-06-2025', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Glastonbury 2025'));

-- Primavera Sound 2025
INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Health', 'Medical services and first aid station permit',
        TO_DATE('01-12-2024', 'DD-MM-YYYY'), TO_DATE('20-01-2025', 'DD-MM-YYYY'), TO_DATE('05-06-2025', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Primavera Sound 2025'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Noise', 'Late-night amplified music permit Primavera',
        TO_DATE('15-12-2024', 'DD-MM-YYYY'), TO_DATE('01-02-2025', 'DD-MM-YYYY'), TO_DATE('02-06-2025', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Primavera Sound 2025'));

-- Melt! Festival 2025
INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Traffic', 'Road closure and traffic management permit',
        TO_DATE('15-01-2025', 'DD-MM-YYYY'), TO_DATE('01-03-2025', 'DD-MM-YYYY'), TO_DATE('25-07-2025', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Melt! Festival 2025'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Traffic', 'Melt Festival site access road permit',
        TO_DATE('01-03-2025', 'DD-MM-YYYY'), TO_DATE('15-04-2025', 'DD-MM-YYYY'), TO_DATE('21-07-2025', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Melt! Festival 2025'));

-- Tomorrowland Winter 2025
INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Noise', 'Night noise exemption permit for alpine event',
        TO_DATE('01-10-2024', 'DD-MM-YYYY'), TO_DATE('01-11-2024', 'DD-MM-YYYY'), TO_DATE('16-03-2025', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Winter 2025'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Public Safety', 'Mountain rescue coordination permit',
        TO_DATE('15-10-2024', 'DD-MM-YYYY'), TO_DATE('15-11-2024', 'DD-MM-YYYY'), TO_DATE('16-03-2025', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Winter 2025'));

-- Lollapalooza Berlin 2025
INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Security', 'Private security and perimeter control permit',
        TO_DATE('01-03-2025', 'DD-MM-YYYY'), TO_DATE('15-04-2025', 'DD-MM-YYYY'), TO_DATE('10-09-2025', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Lollapalooza Berlin 2025'));

INSERT INTO Permit (Permit_Category, Permit_Description, Permit_Application_Date, Permit_Reception_Date,
                    Permit_Expiration_Date, Festival_ID)
VALUES ('Fire Safety', 'Lollapalooza Berlin pyrotechnics permit',
        TO_DATE('01-04-2025', 'DD-MM-YYYY'), TO_DATE('01-06-2025', 'DD-MM-YYYY'), TO_DATE('09-09-2025', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Lollapalooza Berlin 2025'));

-- 7. TICKET
--    Visitor_ID via email; Festival_ID via name; TicketPlatform_ID via name
--    Unique constraint: (Visitor_ID, Festival_ID, Ticket_Date)
--    → one ticket per visitor per festival day

-- Lena: Tomorrowland + Pukkelpop + Lollapalooza
INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (320.00, 'EUR', TO_DATE('19-07-2024', 'DD-MM-YYYY'), TO_DATE('10-01-2024', 'DD-MM-YYYY'),
        'Full weekend pass Tomorrowland', 'TML20240001AA', 'Weekend', 'Used',
        'https://qr.tomorrowland.com/TML20240001AA',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Ticketmaster Belgium'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'lena.maes@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (195.00, 'EUR', TO_DATE('15-08-2024', 'DD-MM-YYYY'), TO_DATE('03-05-2024', 'DD-MM-YYYY'),
        'Pukkelpop combi ticket – Lena', 'PKP20240001AA', 'Combi', 'Used',
        'https://qr.pukkelpop.be/PKP20240001AA',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Paylogic'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'lena.maes@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Pukkelpop 2024'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (99.00, 'EUR', TO_DATE('07-09-2025', 'DD-MM-YYYY'), TO_DATE('25-05-2025', 'DD-MM-YYYY'),
        'Lollapalooza Berlin 2-day pass – Lena', 'LLP20250001AA', 'Weekend', 'Valid',
        'https://qr.lollaberlin.de/LLP20250001AA',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Ticketmaster Belgium'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'lena.maes@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Lollapalooza Berlin 2025'));

-- Jonas: Rock Werchter + Tomorrowland
INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (89.50, 'EUR', TO_DATE('04-07-2024', 'DD-MM-YYYY'), TO_DATE('15-03-2024', 'DD-MM-YYYY'),
        'Single day Friday Rock Werchter', 'RWF20240001BB', 'Day', 'Used',
        'https://qr.rockwerchter.be/RWF20240001BB',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'See Tickets'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'jonas.dewolf@hotmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Rock Werchter 2024'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (320.00, 'EUR', TO_DATE('19-07-2024', 'DD-MM-YYYY'), TO_DATE('20-02-2024', 'DD-MM-YYYY'),
        'Tomorrowland weekend ticket – Jonas', 'TML20240001BB', 'Weekend', 'Used',
        'https://qr.tomorrowland.com/TML20240001BB',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Paylogic'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'jonas.dewolf@hotmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'));

-- Sophie: Pukkelpop + Glastonbury
INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (195.00, 'EUR', TO_DATE('15-08-2024', 'DD-MM-YYYY'), TO_DATE('01-04-2024', 'DD-MM-YYYY'),
        '4-day combi ticket Pukkelpop', 'PKP20240001CC', 'Combi', 'Used',
        'https://qr.pukkelpop.be/PKP20240001CC',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Paylogic'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'sophie.janssen@outlook.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Pukkelpop 2024'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (375.00, 'GBP', TO_DATE('25-06-2025', 'DD-MM-YYYY'), TO_DATE('01-11-2024', 'DD-MM-YYYY'),
        'Glastonbury full festival ticket – Sophie', 'GLA20250001CC', 'Full Festival', 'Valid',
        'https://qr.glastonbury.co.uk/GLA20250001CC',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Dice FM'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'sophie.janssen@outlook.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Glastonbury 2025'));

-- Pieter: Sziget + Roskilde
INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (290.00, 'EUR', TO_DATE('07-08-2024', 'DD-MM-YYYY'), TO_DATE('20-02-2024', 'DD-MM-YYYY'),
        '7-day full island ticket Sziget', 'SZI20240001DD', 'Full Festival', 'Used',
        'https://qr.szigetfestival.com/SZI20240001DD',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Eventbrite'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'pieter.claes@yahoo.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Sziget Festival 2024'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (145.00, 'EUR', TO_DATE('29-06-2024', 'DD-MM-YYYY'), TO_DATE('10-02-2024', 'DD-MM-YYYY'),
        'Roskilde weekend ticket – Pieter', 'RSK20240001DD', 'Weekend', 'Used',
        'https://qr.roskilde.dk/RSK20240001DD',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Tele Ticket Service'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'pieter.claes@yahoo.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Roskilde Festival 2024'));

-- Nathalie: Roskilde + Primavera
INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (145.00, 'EUR', TO_DATE('29-06-2024', 'DD-MM-YYYY'), TO_DATE('05-01-2024', 'DD-MM-YYYY'),
        'Weekend ticket Roskilde', 'RSK20240001EE', 'Weekend', 'Used',
        'https://qr.roskilde.dk/RSK20240001EE',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Tele Ticket Service'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'nathalie.hermans@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Roskilde Festival 2024'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (185.00, 'EUR', TO_DATE('29-05-2025', 'DD-MM-YYYY'), TO_DATE('05-01-2025', 'DD-MM-YYYY'),
        'Primavera Sound 3-day pass – Nathalie', 'PRM20250001EE', 'Combi', 'Valid',
        'https://qr.primaverasound.com/PRM20250001EE',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Fever Up'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'nathalie.hermans@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Primavera Sound 2025'));

-- Adrien: Glastonbury + Sziget
INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (375.00, 'GBP', TO_DATE('25-06-2025', 'DD-MM-YYYY'), TO_DATE('15-10-2024', 'DD-MM-YYYY'),
        'Full Glastonbury ticket – Adrien', 'GLA20250001FF', 'Full Festival', 'Valid',
        'https://qr.glastonbury.co.uk/GLA20250001FF',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Dice FM'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'adrien.dupont@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Glastonbury 2025'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (290.00, 'EUR', TO_DATE('07-08-2024', 'DD-MM-YYYY'), TO_DATE('01-03-2024', 'DD-MM-YYYY'),
        'Sziget full festival ticket – Adrien', 'SZI20240001FF', 'Full Festival', 'Used',
        'https://qr.szigetfestival.com/SZI20240001FF',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Eventbrite'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'adrien.dupont@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Sziget Festival 2024'));

-- Zara: Primavera + Lollapalooza
INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (185.00, 'EUR', TO_DATE('29-05-2025', 'DD-MM-YYYY'), TO_DATE('01-12-2024', 'DD-MM-YYYY'),
        '3-day Primavera Sound pass – Zara', 'PRM20250001GG', 'Combi', 'Valid',
        'https://qr.primaverasound.com/PRM20250001GG',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Fever Up'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'zara.ahmed@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Primavera Sound 2025'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (99.00, 'EUR', TO_DATE('07-09-2025', 'DD-MM-YYYY'), TO_DATE('10-05-2025', 'DD-MM-YYYY'),
        'Lollapalooza Berlin weekend – Zara', 'LLP20250001GG', 'Weekend', 'Valid',
        'https://qr.lollaberlin.de/LLP20250001GG',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'StubHub International'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'zara.ahmed@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Lollapalooza Berlin 2025'));

-- Markus: Melt + Tomorrowland Winter
INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (98.00, 'EUR', TO_DATE('18-07-2025', 'DD-MM-YYYY'), TO_DATE('10-02-2025', 'DD-MM-YYYY'),
        'Weekend ticket Melt Festival – Markus', 'MLT20250001HH', 'Weekend', 'Valid',
        'https://qr.meltfestival.de/MLT20250001HH',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'TicketSwap'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'markus.bauer@web.de'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Melt! Festival 2025'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (220.00, 'EUR', TO_DATE('08-03-2025', 'DD-MM-YYYY'), TO_DATE('15-10-2024', 'DD-MM-YYYY'),
        'Tomorrowland Winter full package – Markus', 'TMW20250001HH', 'Full Festival', 'Used',
        'https://qr.tomorrowland.com/TMW20250001HH',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Resident Advisor'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'markus.bauer@web.de'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Winter 2025'));

-- Elena: Tomorrowland Winter + Melt
INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (220.00, 'EUR', TO_DATE('08-03-2025', 'DD-MM-YYYY'), TO_DATE('01-09-2024', 'DD-MM-YYYY'),
        'Full week Tomorrowland Winter – Elena', 'TMW20250001II', 'Full Festival', 'Used',
        'https://qr.tomorrowland.com/TMW20250001II',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Resident Advisor'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'elena.kovacs@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Winter 2025'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (98.00, 'EUR', TO_DATE('18-07-2025', 'DD-MM-YYYY'), TO_DATE('01-03-2025', 'DD-MM-YYYY'),
        'Melt Festival weekend ticket – Elena', 'MLT20250001II', 'Weekend', 'Valid',
        'https://qr.meltfestival.de/MLT20250001II',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'TicketSwap'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'elena.kovacs@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Melt! Festival 2025'));

-- Chloe: Lollapalooza + Rock Werchter
INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (99.00, 'EUR', TO_DATE('07-09-2025', 'DD-MM-YYYY'), TO_DATE('20-04-2025', 'DD-MM-YYYY'),
        '2-day Lollapalooza Berlin pass – Chloe', 'LLP20250001JJ', 'Weekend', 'Valid',
        'https://qr.lollaberlin.de/LLP20250001JJ',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'StubHub International'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'chloe.martin@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Lollapalooza Berlin 2025'));

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (89.50, 'EUR', TO_DATE('05-07-2024', 'DD-MM-YYYY'), TO_DATE('20-04-2024', 'DD-MM-YYYY'),
        'Rock Werchter Saturday day ticket – Chloe', 'RWF20240001JJ', 'Day', 'Used',
        'https://qr.rockwerchter.be/RWF20240001JJ',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'See Tickets'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'chloe.martin@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Rock Werchter 2024'));

COMMIT;