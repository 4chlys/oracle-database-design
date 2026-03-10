-- S1 QUERIES - Music Festival Database
-- Student: Romeo Weyns
-- S1 tables (ABCD): Visitor (A), TicketPlatform (C), Ticket (D), Permit, Company, City
-- S1 shared table: Festival (B/X)
-- Shared table: Festival


-- ============================================================
-- STAP 3 – COUNT QUERY (alle S1 tabellen)
-- Prefixes:
--   S1-A   : Visitor
--   S1-B/X : Festival   (shared, S1 responsible)
--   S1-C   : TicketPlatform
--   S1-D   : Ticket
--   S1_    : Company
--   S1_    : City
--   S1_    : Permit
-- ============================================================

SELECT 'S1-A   : Visitor' AS table_name, (SELECT COUNT(*) FROM Visitor) AS table_count
FROM dual
UNION ALL
SELECT 'S1-B/X : Festival' AS table_name, (SELECT COUNT(*) FROM Festival) AS table_count
FROM dual
UNION ALL
SELECT 'S1-C   : TicketPlatform' AS table_name, (SELECT COUNT(*) FROM TicketPlatform) AS table_count
FROM dual
UNION ALL
SELECT 'S1-D   : Ticket' AS table_name, (SELECT COUNT(*) FROM Ticket) AS table_count
FROM dual
UNION ALL
SELECT 'S1_    : Company' AS table_name, (SELECT COUNT(*) FROM Company) AS table_count
FROM dual
UNION ALL
SELECT 'S1_    : City' AS table_name, (SELECT COUNT(*) FROM City) AS table_count
FROM dual
UNION ALL
SELECT 'S1_    : Permit' AS table_name, (SELECT COUNT(*) FROM Permit) AS table_count
FROM dual;


-- ============================================================
-- S1 – Query 1: Veel-op-veel relatie
--   Visitor (A) <--> Festival (B/X) via Ticket (D) + TicketPlatform (C)
--   Toont: welke bezoekers een ticket hebben voor welk festival,
--          via welk platform gekocht, met prijs en status.
-- ============================================================

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


-- ============================================================
-- S1 – Query 2: 2 niveaus diep (Company -> Festival -> Permit)
--   + City gekoppeld aan Festival
--   Toont: welke vergunningen elk festival heeft, inclusief
--          het organisatiebedrijf en de locatiestad.
--   Company en City zijn de niet eerder getoonde tabellen.
-- ============================================================

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


-- ============================================================
-- S1 – Query 3: Overzicht bezoeker + totaaluitgaven + stad
--   Toont: per bezoeker het totaal aantal tickets, het totaal
--          bedrag uitgegeven (in EUR), en hun woonstad.
--   Tabellen: Visitor (A), Ticket (D), City, Festival (B/X)
-- ============================================================

-- S1 Query 3 (A, D, City, B/X): Totaaluitgaven per bezoeker met woonstad en aantal bezochte festivals
SELECT v.Visitor_Firstname           AS Voornaam,
       v.Visitor_Lastname            AS Achternaam,
       v.Visitor_Email               AS Email,
       v.Visitor_Birthdate           AS Geboortedatum,
       ci.City                       AS Woonstad,
       ci.Country                    AS Land,
       COUNT(t.Ticket_ID)            AS Aantal_Tickets,
       COUNT(DISTINCT f.Festival_ID) AS Aantal_Festivals,
       ROUND(SUM(t.Ticket_Price), 2) AS Totaal_Uitgegeven,
       t.Ticket_Currency             AS Munt,
       MIN(f.Festival_StartDate)     AS Vroegste_Festival,
       MAX(f.Festival_StartDate)     AS Laatste_Festival
FROM Visitor v
         JOIN City ci ON ci.City_ID = v.City_ID
         JOIN Ticket t ON t.Visitor_ID = v.Visitor_ID
         JOIN Festival f ON f.Festival_ID = t.Festival_ID
GROUP BY v.Visitor_ID,
         v.Visitor_Firstname,
         v.Visitor_Lastname,
         v.Visitor_Email,
         v.Visitor_Birthdate,
         ci.City,
         ci.Country,
         t.Ticket_Currency
ORDER BY Totaal_Uitgegeven DESC;


-- ============================================================
-- S1 – Query 4: Festivalplatformen en ticketverkoop per festival
--   Toont: welke ticketplatformen gebruikt worden per festival,
--          hoeveel tickets er via elk platform verkocht zijn,
--          en wat de gemiddelde en totale ticketprijs is.
--   Tabellen: TicketPlatform (C), Ticket (D), Festival (B/X),
--             Company
-- ============================================================

-- S1 Query 4 (C, D, B/X, Company): Ticketverkoop per platform per festival met gemiddelde prijs
SELECT f.Festival_Name                                            AS Festival,
       f.Festival_StartDate                                       AS Startdatum,
       f.Festival_Location                                        AS Locatie,
       c.Company_Name                                             AS Organisator,
       tp.TicketPlatform_Name                                     AS Platform,
       tp.TicketPlatform_URL                                      AS Platform_URL,
       COUNT(t.Ticket_ID)                                         AS Aantal_Tickets_Verkocht,
       ROUND(AVG(t.Ticket_Price), 2)                              AS Gemiddelde_Prijs,
       ROUND(SUM(t.Ticket_Price), 2)                              AS Totale_Omzet,
       t.Ticket_Currency                                          AS Munt,
       SUM(CASE WHEN t.Ticket_Status = 'Used' THEN 1 ELSE 0 END)  AS Gebruikt,
       SUM(CASE WHEN t.Ticket_Status = 'Valid' THEN 1 ELSE 0 END) AS Geldig
FROM TicketPlatform tp
         JOIN Ticket t ON t.TicketPlatform_ID = tp.TicketPlatform_ID
         JOIN Festival f ON f.Festival_ID = t.Festival_ID
         JOIN Company c ON c.Company_ID = f.Company_ID
GROUP BY f.Festival_ID,
         f.Festival_Name,
         f.Festival_StartDate,
         f.Festival_Location,
         c.Company_Name,
         tp.TicketPlatform_Name,
         tp.TicketPlatform_URL,
         t.Ticket_Currency
ORDER BY f.Festival_StartDate, Totale_Omzet DESC;