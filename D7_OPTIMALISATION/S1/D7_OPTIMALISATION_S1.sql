-- =========================================================
-- MILESTONE 7 – OPTIMALISATIES : S1
-- Student  : Romeo Weyns
-- D-tabel  : TICKET
-- Techniek : RANGE-INTERVAL partitionering op TICKET_PURCHASE_DATE
-- =========================================================


-- =========================================================
-- STAP 1 : VOORBEREIDING
-- =========================================================

-- 1A. Controleer huidig aantal rijen in de D-tabel (TICKET)
--     Doel: minimum 400.000 rijen vereist
SELECT COUNT(*) AS ticket_count FROM Ticket;


-- 1B. Bereken statistieken op TICKET voor een accurate explain plan
BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(USER, 'TICKET');
    DBMS_STATS.GATHER_TABLE_STATS(USER, 'VISITOR');
    DBMS_STATS.GATHER_TABLE_STATS(USER, 'TICKETPLATFORM');
    DBMS_STATS.GATHER_TABLE_STATS(USER, 'PERMIT');
    DBMS_STATS.GATHER_TABLE_STATS(USER, 'COMPANY');
END;
/


-- 1C. Controleer de grootte van de TICKET-tabel
--     (vereist SELECT op DBA_SEGMENTS; vraag DBA-rechten indien nodig)
SELECT segment_name,
       segment_type,
       SUM(bytes / 1024 / 1024) AS MB,
       (SELECT COUNT(*) FROM Ticket) AS table_count
FROM dba_segments
WHERE segment_name = 'TICKET'
GROUP BY segment_name, segment_type;


-- 1D. AGGREGATIEQUERY (domeinspecifiek, beperkt bereik)
-- -------------------------------------------------------
-- Bedrijfsvraag : Wat is de omzetanalyse per festival en tickettype
--                 voor tickets AANGEKOCHT in het kalenderjaar 2025?
-- Groepering    : Festival + Ticket_Type
-- Bereik (WHERE): Ticket_Purchase_Date tussen 01-01-2025 en 31-12-2025
--                 => slechts een fractie van de volledige tabel wordt bevraagd
-- -------------------------------------------------------
SELECT f.Festival_Name                       AS Festival,
       t.Ticket_Type                         AS Tickettype,
       COUNT(t.Ticket_ID)                    AS Aantal_Tickets,
       ROUND(AVG(t.Ticket_Price), 2)         AS Gemiddelde_Prijs_EUR,
       SUM(t.Ticket_Price)                   AS Totale_Omzet_EUR,
       MIN(t.Ticket_Price)                   AS Laagste_Prijs,
       MAX(t.Ticket_Price)                   AS Hoogste_Prijs
FROM   Ticket t
           JOIN Festival f ON f.Festival_ID = t.Festival_ID
WHERE  t.Ticket_Purchase_Date
           BETWEEN DATE '2025-01-01' AND DATE '2025-12-31'
GROUP BY f.Festival_Name, t.Ticket_Type
ORDER BY Totale_Omzet_EUR DESC;


-- =========================================================
-- STAP 2 : EXPLAIN PLAN – VÓÓR PARTITIONERING
-- =========================================================
-- Verwacht resultaat: TABLE ACCESS FULL op TICKET
-- (geen partitionering => volledige tabel gescand)

EXPLAIN PLAN SET STATEMENT_ID = 'M7_S1_VOOR' FOR
SELECT f.Festival_Name                       AS Festival,
       t.Ticket_Type                         AS Tickettype,
       COUNT(t.Ticket_ID)                    AS Aantal_Tickets,
       ROUND(AVG(t.Ticket_Price), 2)         AS Gemiddelde_Prijs_EUR,
       SUM(t.Ticket_Price)                   AS Totale_Omzet_EUR,
       MIN(t.Ticket_Price)                   AS Laagste_Prijs,
       MAX(t.Ticket_Price)                   AS Hoogste_Prijs
FROM   Ticket t
           JOIN Festival f ON f.Festival_ID = t.Festival_ID
WHERE  t.Ticket_Purchase_Date
           BETWEEN DATE '2025-01-01' AND DATE '2025-12-31'
GROUP BY f.Festival_Name, t.Ticket_Type
ORDER BY Totale_Omzet_EUR DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(NULL, 'M7_S1_VOOR', 'ALL'));


-- =========================================================
-- STAP 3 : PARTITIONERING + HEROPBOUW + BEWIJS
-- =========================================================

-- 3A. Verwijder de bestaande TICKET-tabel
--     (CASCADE CONSTRAINTS verwijdert ook externe FK-verwijzingen)
DROP TABLE Ticket CASCADE CONSTRAINTS PURGE;


-- 3B. Herstel TICKET als RANGE-INTERVAL gepartitioneerde tabel
-- ---------------------------------------------------------------
-- Partitioneringssleutel : TICKET_PURCHASE_DATE (DATE)
-- Strategie              : RANGE met INTERVAL van 1 jaar
-- Initiële partities     : voor 2021 t/m 2026 (op basis van gegenereerde data)
-- Automatisch            : elke aankoopdatum >= 2027 krijgt automatisch een
--                          nieuwe jaarlijkse partitie via het INTERVAL-mechanisme
-- ---------------------------------------------------------------
CREATE TABLE Ticket
(
    Ticket_ID            NUMBER GENERATED ALWAYS AS IDENTITY,
    Ticket_Price         NUMBER(10, 2),
    Ticket_Currency      CHAR(3),
    Ticket_Date          DATE,
    Ticket_Purchase_Date DATE,
    Ticket_Description   VARCHAR2(100 CHAR),
    Ticket_Barcode       VARCHAR2(14 CHAR),
    Ticket_Type          VARCHAR2(50 CHAR),
    Ticket_Status        VARCHAR2(50 CHAR),
    Ticket_QR_Code       VARCHAR2(500 CHAR),
    TicketPlatform_ID    NUMBER,
    Visitor_ID           NUMBER,
    Festival_ID          NUMBER,
    CONSTRAINT Ticket_PK                  PRIMARY KEY (Ticket_ID),
    CONSTRAINT Ticket_Barcode_UQ          UNIQUE (Ticket_Barcode),
    CONSTRAINT Ticket_VisitFestPlatform_UQ UNIQUE (Visitor_ID, Festival_ID, Ticket_Date),
    CONSTRAINT Ticket_Visitor_FK          FOREIGN KEY (Visitor_ID)
        REFERENCES Visitor (Visitor_ID),
    CONSTRAINT Ticket_TicketPlatform_FK   FOREIGN KEY (TicketPlatform_ID)
        REFERENCES TicketPlatform (TicketPlatform_ID),
    CONSTRAINT Ticket_Price_chk           CHECK (Ticket_Price > 0),
    CONSTRAINT Ticket_Barcode_chk         CHECK (LENGTH(Ticket_Barcode) BETWEEN 8 AND 14),
    CONSTRAINT Ticket_Date_chk            CHECK (Ticket_Purchase_Date <= Ticket_Date)
)
    PARTITION BY RANGE (Ticket_Purchase_Date)
    INTERVAL (NUMTOYMINTERVAL(1, 'YEAR'))
(
    PARTITION ticket_p_pre2021 VALUES LESS THAN (DATE '2021-01-01'),
    PARTITION ticket_p_2021    VALUES LESS THAN (DATE '2022-01-01'),
    PARTITION ticket_p_2022    VALUES LESS THAN (DATE '2023-01-01'),
    PARTITION ticket_p_2023    VALUES LESS THAN (DATE '2024-01-01'),
    PARTITION ticket_p_2024    VALUES LESS THAN (DATE '2025-01-01'),
    PARTITION ticket_p_2025    VALUES LESS THAN (DATE '2026-01-01'),
    PARTITION ticket_p_2026    VALUES LESS THAN (DATE '2027-01-01')
);


-- 3C. Herstel de Festival-FK (verwijderd door DROP ... CASCADE CONSTRAINTS)
ALTER TABLE Ticket
    ADD CONSTRAINT Ticket_Festival_FK
        FOREIGN KEY (Festival_ID) REFERENCES Festival (Festival_ID);


-- 3D. Hergenereer alle data (minimum 400.000 tickets)
--     bewijs_milestone_6_S1 reset alles (TRUNCATE), vult S1-base,
--     genereert festivals via S2, en vult daarna tickets + permits.
--     Gebruik mode 'BULK' voor maximale insteegprestaties.
BEGIN
    DBMS_OUTPUT.ENABLE(NULL);
    PKG_S1_festivals.bewijs_milestone_6_S1(
            p_visitors         => 20000,
            p_companies        => 500,
            p_platforms        => 30,
            p_tickets          => 400000,
            p_permits_per_fest => 5,
            p_festivals        => 300,
            p_mode             => 'BULK'
    );
    COMMIT;
END;
/


-- 3E. Controleer opnieuw het aantal rijen na hergeneratie
SELECT COUNT(*) AS ticket_count FROM Ticket;


-- 3F. Herbereken statistieken op de gepartitioneerde tabel
BEGIN
    DBMS_STATS.GATHER_TABLE_STATS(USER, 'TICKET');
END;
/


-- 3G. Controleer de nieuwe tabelgrootte (inclusief alle partities samen)
SELECT segment_name,
       segment_type,
       SUM(bytes / 1024 / 1024) AS MB,
       (SELECT COUNT(*) FROM Ticket) AS table_count
FROM dba_segments
WHERE segment_name = 'TICKET'
GROUP BY segment_name, segment_type;

-- Alternatief zonder DBA-rechten:
SELECT SUM(bytes / 1024 / 1024) AS MB
FROM user_segments
WHERE segment_name = 'TICKET';


-- 3H. EXPLAIN PLAN – NÁ PARTITIONERING (met NOPARALLEL hint)
-- ---------------------------------------------------------------
-- Verwacht resultaat: PARTITION RANGE ITERATOR
--   => Oracle bevraagt ENKEL partitie ticket_p_2025
--   => Geen volledige tabelscan meer
-- NOPARALLEL-hint: forceert seriële uitvoering zodat het explain plan
--                  duidelijk toont welke INDIVIDUELE partitie bevraagd wordt
-- ---------------------------------------------------------------
EXPLAIN PLAN SET STATEMENT_ID = 'M7_S1_NA' FOR
SELECT /*+ NOPARALLEL(t) */
    f.Festival_Name                       AS Festival,
    t.Ticket_Type                         AS Tickettype,
    COUNT(t.Ticket_ID)                    AS Aantal_Tickets,
    ROUND(AVG(t.Ticket_Price), 2)         AS Gemiddelde_Prijs_EUR,
    SUM(t.Ticket_Price)                   AS Totale_Omzet_EUR,
    MIN(t.Ticket_Price)                   AS Laagste_Prijs,
    MAX(t.Ticket_Price)                   AS Hoogste_Prijs
FROM   Ticket t
           JOIN Festival f ON f.Festival_ID = t.Festival_ID
WHERE  t.Ticket_Purchase_Date
           BETWEEN DATE '2025-01-01' AND DATE '2025-12-31'
GROUP BY f.Festival_Name, t.Ticket_Type
ORDER BY Totale_Omzet_EUR DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY(NULL, 'M7_S1_NA', 'ALL'));

-- 3I. Grootte per partitie (bewijs dat alleen de nodige partities worden gebruikt)
-- ---------------------------------------------------------------
-- user_tab_partitions: statistieken per partitie (na GATHER_TABLE_STATS)
-- ---------------------------------------------------------------
SELECT partition_name,
       partition_position                              AS pos,
       num_rows,
       blocks,
       ROUND(blocks * 8 / 1024, 2)                   AS approx_MB
FROM   all_tab_partitions
WHERE  table_name = 'TICKET'
ORDER BY partition_position;

-- Fysieke segmentgrootte per partitie (vereist DBA_SEGMENTS)
SELECT segment_name,
       partition_name,
       ROUND(bytes / 1024 / 1024, 2)                 AS MB
FROM   dba_segments
WHERE  segment_name = 'TICKET'
ORDER BY partition_name;

-- Alternatief zonder DBA-rechten:
SELECT segment_name,
       partition_name,
       ROUND(bytes / 1024 / 1024, 2)                 AS MB
FROM   user_segments
WHERE  segment_name = 'TICKET'
ORDER BY partition_name;
