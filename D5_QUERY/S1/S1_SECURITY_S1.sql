-- S1 SECURITY - Music Festival Database
-- Student: Romeo Weyns
-- Creates a role, a user, and a view for the S1 portion of the schema.

-- security_S1.sql  –  Milestone 3  |  Stap 5: Security S1
-- Uit te voeren vanuit de ADMIN user, tenzij anders aangegeven.
-- Gebruikersprefix: s1_visitor


-- DEEL 1: USER AANMAKEN  (als ADMIN)

-- Verwijder user indien al bestaat (heruitvoerbaar)
DROP USER s1_visitor CASCADE;

-- Maak de S1 user aan
CREATE USER s1_visitor IDENTIFIED BY "REDACTED";

-- Basisrecht om in te loggen
GRANT CREATE SESSION TO s1_visitor;


-- DEEL 2: RECHTEN OP TABEL A (Visitor)
--   Volledige DML + DDL op Visitor
--   Met doorgeeefrecht (WITH GRANT OPTION / WITH ADMIN OPTION)

GRANT SELECT, INSERT, UPDATE, DELETE ON PROJECT.Visitor TO s1_visitor WITH GRANT OPTION;
GRANT SELECT ON PROJECT.City TO s1_visitor; -- Nodig voor het DML gedeelte van S1 Scenario uitwerking.
GRANT ALTER ON PROJECT.Visitor TO s1_visitor;


-- DEEL 3: RECHTEN OP TUSSENENTITEIT D (Ticket)
--   Alleen UPDATE op de kolommen Ticket_Price en Ticket_Status
--   (equivalent van highscore / highscore_description in het voorbeeld)

GRANT UPDATE (Ticket_Price, Ticket_Status) ON PROJECT.Ticket TO s1_visitor;


-- DEEL 4: VIEW AANMAKEN  (als ADMIN, in schema PROJECT)
--   Top 3 bezoekers met het hoogste aantal aan tickets,
--   met gegevens uit alle 4 tabellen: Visitor (A), Festival (B/X),
--   TicketPlatform (C), Ticket (D)

GRANT CREATE ANY VIEW TO s1_visitor;
-- REVOKE CREATE ANY VIEW FROM s1_visitor;

GRANT SELECT ON PROJECT.Ticket TO s1_visitor;
GRANT SELECT ON PROJECT.TicketPlatform TO s1_visitor;
GRANT SELECT ON PROJECT.Festival TO s1_visitor;

-- Voer dit uit als s1_visitor:
DROP VIEW PROJECT.TOP3_VISITORS;

CREATE OR REPLACE VIEW TOP3_VISITORS AS
-- SELECT v.Visitor_Firstname    AS Voornaam,
--        v.Visitor_Lastname     AS Achternaam,
--        v.Visitor_Email        AS Email,
--        v.Visitor_Gender       AS Geslacht,
--        f.Festival_Name        AS Festival,
--        f.Festival_Location    AS Locatie,
--        f.Festival_StartDate   AS Festival_Startdatum,
--        t.Ticket_Type          AS Ticket_Type,
--        t.Ticket_Price         AS Ticket_Prijs,
--        t.Ticket_Currency      AS Munt,
--        t.Ticket_Status        AS Status,
--        tp.TicketPlatform_Name AS Platform,
--        tv.Ticket_Count        AS Aantal_Tickets
-- FROM PROJECT.Visitor v
--          JOIN (SELECT Visitor_ID, COUNT(*) AS Ticket_Count
--                FROM PROJECT.Ticket
--                GROUP BY Visitor_ID
--                ORDER BY Ticket_Count DESC
--                    FETCH FIRST 3 ROWS ONLY) tv ON tv.Visitor_ID = v.Visitor_ID
--          JOIN PROJECT.Ticket t ON t.Visitor_ID = v.Visitor_ID
--          JOIN PROJECT.Festival f ON f.Festival_ID = t.Festival_ID
--          JOIN PROJECT.TicketPlatform tp ON tp.TicketPlatform_ID = t.TicketPlatform_ID
-- ORDER BY tv.Ticket_Count DESC, v.Visitor_Lastname, v.Visitor_Firstname;

SELECT v.Visitor_Firstname AS "First Name",
       v.Visitor_Lastname  AS "Last Name",
       tv.Ticket_Count     AS "Amount of Tickets"
FROM PROJECT.Visitor v
JOIN (
    SELECT Visitor_ID, COUNT(*) AS Ticket_Count
    FROM PROJECT.Ticket
    GROUP BY Visitor_ID
    ORDER BY Ticket_Count DESC
    FETCH FIRST 3 ROWS ONLY
) tv ON v.Visitor_ID = tv.Visitor_ID
ORDER BY tv.Ticket_Count DESC;

-- Geef s1_visitor leesrecht op de view
-- GRANT SELECT ON PROJECT.TOP3_VISITORS TO s1_visitor;

-- DEEL 5: PUBLIC SYNONYM AANMAKEN  (als s1_visitor)

-- Als ADMIN: geef s1_visitor het recht om public synonyms aan te maken en te verwijderen
GRANT CREATE PUBLIC SYNONYM TO s1_visitor;
GRANT DROP PUBLIC SYNONYM TO s1_visitor;

-- Voer het volgende uit als s1_visitor:
DROP PUBLIC SYNONYM topvisitors;
CREATE PUBLIC SYNONYM topvisitors FOR PROJECT.TOP3_VISITORS;

-- Test (werkt voor elke gebruiker dankzij het public synonym):
SELECT *
FROM topvisitors;


-- DEEL 6: SCENARIO S1

-- ---- 6a: Laat de toegang tot tabel Visitor zien (SELECT) ----
-- Uit te voeren als s1_visitor:
SELECT Visitor_Firstname,
       Visitor_Lastname,
       Visitor_Email,
       Visitor_Birthdate,
       Visitor_Gender
FROM PROJECT.Visitor
ORDER BY Visitor_Lastname;


-- ---- 6b: DML voorbeeld – voeg een nieuwe bezoeker toe ----
-- Uit te voeren als s1_visitor:
INSERT INTO PROJECT.Visitor
(Visitor_Firstname, Visitor_Lastname, Visitor_Birthdate,
 Visitor_Email, Visitor_Street_Name, Visitor_Street_Number,
 City_ID, Visitor_Gender)
VALUES ('Thomas', 'Peeters', TO_DATE('11-07-1994', 'DD-MM-YYYY'),
        'thomas.peeters@gmail.com', 'Keizerstraat', '14',
        (SELECT City_ID FROM PROJECT.City WHERE Zipcode = '2000' AND Country = 'Belgium'),
        'Male');

-- Verwijder Thomas Peeters als s1_visitor indien deze reeds bestaat
DELETE
FROM PROJECT.Visitor
WHERE Visitor_Email = 'thomas.peeters@gmail.com';

-- ---- 6c: DDL voorbeeld – voeg een nieuw attribuut toe aan Visitor ----
-- Uit te voeren als s1_visitor:
ALTER TABLE PROJECT.Visitor
    ADD Visitor_Phone VARCHAR2(20 CHAR);


-- VERIFICATIE (als ADMIN): dictionary views voor screenshots

-- User sys privs van s1_visitor
SELECT *
FROM USER_SYS_PRIVS;

-- User tab privs van s1_visitor
SELECT *
FROM USER_TAB_PRIVS;

-- User col privs van s1_visitor (enkel Ticket kolommen)
SELECT *
FROM USER_COL_PRIVS;

-- Resultaat van het public synonym (als s1_visitor of andere user)
SELECT *
FROM topvisitors;