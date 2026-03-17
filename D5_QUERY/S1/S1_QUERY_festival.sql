-- S1 QUERIES - Music Festival Database
-- Student: Romeo Weyns
-- S1 tables (ABCD): Visitor (A), TicketPlatform (C), Ticket (D), Permit, Company, City
-- S1 shared table: Festival (B/X)
-- Shared table: Festival


-- STAP 3 – COUNT QUERY (alle S1 tabellen)
-- Prefixes:
--   S1-A   : Visitor
--   S1-B/X : Festival   (shared, S1 responsible)
--   S1-C   : TicketPlatform
--   S1-D   : Ticket
--   S1_    : Company
--   S1_    : City
--   S1_    : Permit

SELECT 'S1-A   : Visitor' AS table_name, COUNT(*) AS table_count
FROM Visitor
UNION ALL
SELECT 'S1-B/X : Festival' AS table_name, COUNT(*) AS table_count
FROM Festival
UNION ALL
SELECT 'S1-C   : TicketPlatform' AS table_name, COUNT(*) AS table_count
FROM TicketPlatform
UNION ALL
SELECT 'S1-D   : Ticket' AS table_name, COUNT(*) AS table_count
FROM Ticket
UNION ALL
SELECT 'S1_    : Company' AS table_name, COUNT(*) AS table_count
FROM Company
UNION ALL
SELECT 'S1_    : City' AS table_name, COUNT(*) AS table_count
FROM City
UNION ALL
SELECT 'S1_    : Permit' AS table_name, COUNT(*) AS table_count
FROM Permit
;


-- S1 – Query 1: Veel-op-veel relatie
--   Visitor (A) <--> Festival (B/X) via Ticket (D) + TicketPlatform (C)
--   Toont: welke bezoekers een ticket hebben voor welk festival,
--          via welk platform gekocht, met prijs en status.

-- S1 Query 1 (A, B/X, C, D): Bezoekers en hun tickets per festival (veel-op-veel via Ticket)
SELECT v.Visitor_Firstname    AS Voornaam,
       v.Visitor_Lastname     AS Achternaam,
       v.Visitor_Email        AS Email,
       v.Visitor_Gender       AS Geslacht,
       f.Festival_Name        AS Festival,
       f.Festival_StartDate   AS Startdatum,
       f.Festival_EndDate     AS Einddatum,
       f.Festival_Location    AS Locatie,
       t.Ticket_Date          AS Ticket_Dag,
       t.Ticket_Type          AS Ticket_Type,
       t.Ticket_Price         AS Prijs,
       t.Ticket_Currency      AS Munt,
       t.Ticket_Status        AS Status,
       tp.TicketPlatform_Name AS Platform,
       tp.TicketPlatform_URL  AS Platform_URL
FROM Visitor v
         JOIN Ticket t ON t.Visitor_ID = v.Visitor_ID
         JOIN Festival f ON f.Festival_ID = t.Festival_ID
         JOIN TicketPlatform tp ON tp.TicketPlatform_ID = t.TicketPlatform_ID
ORDER BY v.Visitor_Lastname, v.Visitor_Firstname, f.Festival_StartDate;


-- S1 – Query 2: 2 niveaus diep (Company -> Festival -> Permit)
--   + City gekoppeld aan Festival
--   Toont: welke vergunningen elk festival heeft, inclusief
--          het organisatiebedrijf en de locatiestad.
--   Company en City zijn de niet eerder getoonde tabellen.

-- S1 Query 2 (Company, City, Festival B/X, Permit): Bedrijven, festivals en hun vergunningen (2 niveaus diep: Company -> Festival -> Permit)
SELECT c.Company_Name            AS Bedrijf,
       c.Company_Founding_Year   AS Oprichtingsjaar,
       f.Festival_Name           AS Festival,
       f.Festival_StartDate      AS Startdatum,
       f.Festival_EndDate        AS Einddatum,
       f.Festival_Location       AS Locatie,
       ci.City                   AS Stad,
       ci.Country                AS Land,
       ci.Zipcode                AS Postcode,
       f.Festival_Capacity       AS Capaciteit,
       p.Permit_Category         AS Vergunning_Categorie,
       p.Permit_Description      AS Vergunning_Omschrijving,
       p.Permit_Application_Date AS Aanvraagdatum,
       p.Permit_Reception_Date   AS Ontvangstdatum,
       p.Permit_Expiration_Date  AS Vervaldatum
FROM Company c
         JOIN Festival f ON f.Company_ID = c.Company_ID
         JOIN Permit p ON p.Festival_ID = f.Festival_ID
         JOIN City ci ON ci.City_ID = f.City_ID
ORDER BY c.Company_Name, f.Festival_StartDate, p.Permit_Category;