-- S1 CONSTRAINT VIOLATION PROOFS - Music Festival Database
-- Student: Romeo Weyns
-- Each INSERT below intentionally violates one constraint.
-- Expected result: Oracle raises ORA-02290 (check constraint)
-- or ORA-00001 (unique constraint).



-- 1. Company_FoundingYear_Upper_chk  →  Company_Founding_Year < 2026
-- Violation: founding year is in the future

INSERT INTO Company (Company_Name, Company_Founding_Year)
VALUES ('Future Corp', 2030);
-- Expected error: ORA-02290: check constraint (Company_FoundingYear_Upper_chk) violated



-- 2. Company_FoundingYear_Lower_chk  →  Company_Founding_Year >= 1800
-- Violation: founding year is before allowed lower bound

INSERT INTO Company (Company_Name, Company_Founding_Year)
VALUES ('Ancient Corp', 1750);
-- Expected error: ORA-02290: check constraint (Company_FoundingYear_Lower_chk) violated



-- 3. Company_Name_UQ  →  UNIQUE (Company_Name)
-- Violation: company name already exists in the database

INSERT INTO Company (Company_Name, Company_Founding_Year)
VALUES ('Tomorrowland NV', 2010);
-- Expected error: ORA-00001: unique constraint (Company_Name_UQ) violated



-- 4. Visitor_Birthdate_Upper_chk  →  Visitor_Birthdate < DATE '2026-03-10'
-- Violation: birthdate is in the future

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Future', 'Person', DATE '2027-06-01', 'future.person@test.com',
        'Teststreet', '1',
        (SELECT City_ID FROM City WHERE Zipcode = '2000' AND Country = 'Belgium'),
        'Male');
-- Expected error: ORA-02290: check constraint (Visitor_Birthdate_Upper_chk) violated



-- 5. Visitor_Birthdate_Lower_chk  →  Visitor_Birthdate >= DATE '1900-01-01'
-- Violation: birthdate is before 1900

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Old', 'Person', DATE '1850-01-01', 'old.person@test.com',
        'Teststreet', '2',
        (SELECT City_ID FROM City WHERE Zipcode = '2000' AND Country = 'Belgium'),
        'Female');
-- Expected error: ORA-02290: check constraint (Visitor_Birthdate_Lower_chk) violated



-- 6. Visitor_Email_UQ  →  UNIQUE (Visitor_Email)
-- Violation: email already exists in the database

INSERT INTO Visitor (Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate, Visitor_Email,
                     Visitor_Street_Name, Visitor_Street_Number, City_ID, Visitor_Gender)
VALUES ('Duplicate', 'Email', TO_DATE('01-01-1990', 'DD-MM-YYYY'), 'lena.maes@gmail.com',
        'Teststreet', '3',
        (SELECT City_ID FROM City WHERE Zipcode = '2000' AND Country = 'Belgium'),
        'Female');
-- Expected error: ORA-00001: unique constraint (Visitor_Email_UQ) violated



-- 7. Ticket_Price_chk  →  Ticket_Price > 0
-- Violation: ticket price is zero (not strictly positive)

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (0.00, 'EUR', TO_DATE('18-07-2025', 'DD-MM-YYYY'), TO_DATE('01-01-2025', 'DD-MM-YYYY'),
        'Free ticket test', 'TESTBAR00001A', 'Day', 'Valid',
        'https://qr.test.com/TESTBAR00001A',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Ticketmaster BE'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'lena.maes@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'));
-- Expected error: ORA-02290: check constraint (Ticket_Price_chk) violated



-- 8. Ticket_Barcode_chk  →  LENGTH(Ticket_Barcode) BETWEEN 8 AND 14
-- Violation: barcode is only 5 characters (below minimum of 8)

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (50.00, 'EUR', TO_DATE('18-07-2025', 'DD-MM-YYYY'), TO_DATE('01-01-2025', 'DD-MM-YYYY'),
        'Short barcode test', 'SHORT', 'Day', 'Valid',
        'https://qr.test.com/SHORT',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Ticketmaster BE'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'lena.maes@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'));
-- Expected error: ORA-02290: check constraint (Ticket_Barcode_chk) violated



-- 9. Ticket_Date_chk  →  Ticket_Purchase_Date <= Ticket_Date
-- Violation: purchase date is AFTER the ticket (event) date

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (75.00, 'EUR',
        TO_DATE('01-01-2025', 'DD-MM-YYYY'),   -- event date BEFORE purchase date
        TO_DATE('15-01-2025', 'DD-MM-YYYY'),   -- purchase date AFTER event date
        'Date order violation test', 'DATETEST0001A', 'Day', 'Valid',
        'https://qr.test.com/DATETEST0001A',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Ticketmaster BE'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'lena.maes@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'));
-- Expected error: ORA-02290: check constraint (Ticket_Date_chk) violated



-- 10. Ticket_PurchaseDate_chk  →  Ticket_Purchase_Date <= DATE '2026-03-10'
-- Violation: purchase date is in the future beyond the allowed cutoff

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (75.00, 'EUR',
        TO_DATE('01-01-2027', 'DD-MM-YYYY'),
        TO_DATE('01-06-2026', 'DD-MM-YYYY'),   -- purchase date beyond allowed cutoff
        'Future purchase date test', 'FUTPURCH0001A', 'Day', 'Valid',
        'https://qr.test.com/FUTPURCH0001A',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Ticketmaster BE'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'lena.maes@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'));
-- Expected error: ORA-02290: check constraint (Ticket_PurchaseDate_chk) violated



-- 11. Ticket_VisitFestPlatform_UQ  →  UNIQUE (Visitor_ID, Festival_ID, Ticket_Date)
-- Violation: same visitor already has a ticket for the same festival on the same date
-- (lena.maes@gmail.com already has a ticket for Tomorrowland Summer 2024 on 19-07-2024)

INSERT INTO Ticket (Ticket_Price, Ticket_Currency, Ticket_Date, Ticket_Purchase_Date,
                    Ticket_Description, Ticket_Barcode, Ticket_Type, Ticket_Status,
                    Ticket_QR_Code, TicketPlatform_ID, Visitor_ID, Festival_ID)
VALUES (89.00, 'EUR',
        TO_DATE('19-07-2024', 'DD-MM-YYYY'),   -- same date as existing ticket for this visitor+festival
        TO_DATE('01-01-2024', 'DD-MM-YYYY'),
        'Duplicate day ticket test', 'DUPDAY000001A', 'Day', 'Valid',
        'https://qr.test.com/DUPDAY000001A',
        (SELECT TicketPlatform_ID FROM TicketPlatform WHERE TicketPlatform_Name = 'Ticketmaster BE'),
        (SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = 'lena.maes@gmail.com'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'));
-- Expected error: ORA-00001: unique constraint (Ticket_VisitFestPlatform_UQ) violated



-- 12. Permit_ReceptExpire_chk  →  Permit_Reception_Date < Permit_Expiration_Date
-- Violation: expiration date is before reception date

INSERT INTO Permit (Permit_Category, Permit_Description,
                    Permit_Reception_Date, Permit_Expiration_Date, Permit_Application_Date,
                    Festival_ID)
VALUES ('Safety', 'Test permit - expire before reception',
        TO_DATE('01-06-2024', 'DD-MM-YYYY'),   -- reception
        TO_DATE('01-01-2024', 'DD-MM-YYYY'),   -- expiration BEFORE reception
        TO_DATE('01-12-2023', 'DD-MM-YYYY'),
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'));
-- Expected error: ORA-02290: check constraint (Permit_ReceptExpire_chk) violated



-- 13. Permit_ApplyRecept_chk  →  Permit_Application_Date < Permit_Reception_Date
-- Violation: application date is after reception date

INSERT INTO Permit (Permit_Category, Permit_Description,
                    Permit_Reception_Date, Permit_Expiration_Date, Permit_Application_Date,
                    Festival_ID)
VALUES ('Noise', 'Test permit - apply after reception',
        TO_DATE('01-06-2024', 'DD-MM-YYYY'),   -- reception
        TO_DATE('01-12-2024', 'DD-MM-YYYY'),
        TO_DATE('15-07-2024', 'DD-MM-YYYY'),   -- application AFTER reception
        (SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024'));
-- Expected error: ORA-02290: check constraint (Permit_ApplyRecept_chk) violated



-- 14. Festival_Dates_chk  →  Festival_EndDate > Festival_StartDate
-- Violation: end date is before start date

INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour,
                      Festival_Capacity)
VALUES ('Bad Date Festival',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Tomorrowland NV'),
        TO_DATE('10-08-2025', 'DD-MM-YYYY'),   -- start date
        TO_DATE('01-08-2025', 'DD-MM-YYYY'),   -- end date BEFORE start date
        'Test Location',
        (SELECT City_ID FROM City WHERE Zipcode = '2850' AND Country = 'Belgium'),
        TO_DATE('2025-01-01 10:00', 'YYYY-MM-DD HH24:MI'),
        TO_DATE('2025-01-01 23:00', 'YYYY-MM-DD HH24:MI'),
        50000);
-- Expected error: ORA-02290: check constraint (Festival_Dates_chk) violated



-- 15. Festival_Cap_chk  →  Festival_Capacity > 0
-- Violation: capacity is zero (not strictly positive)

INSERT INTO Festival (Festival_Name, Company_ID, Festival_StartDate, Festival_EndDate,
                      Festival_Location, City_ID, Festival_Opening_Hour, Festival_Closing_Hour,
                      Festival_Capacity)
VALUES ('Zero Capacity Festival',
        (SELECT Company_ID FROM Company WHERE Company_Name = 'Tomorrowland NV'),
        TO_DATE('01-08-2025', 'DD-MM-YYYY'),
        TO_DATE('05-08-2025', 'DD-MM-YYYY'),
        'Test Location',
        (SELECT City_ID FROM City WHERE Zipcode = '2850' AND Country = 'Belgium'),
        TO_DATE('2025-01-01 10:00', 'YYYY-MM-DD HH24:MI'),
        TO_DATE('2025-01-01 23:00', 'YYYY-MM-DD HH24:MI'),
        0);
-- Expected error: ORA-02290: check constraint (Festival_Cap_chk) violated