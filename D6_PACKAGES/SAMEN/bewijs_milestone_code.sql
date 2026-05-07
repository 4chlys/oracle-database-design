-- =============================================================
-- MILESTONE 5 – full cross-schema demonstration
--
-- Mapping
--   S1 (N-N junction)
--     A = VISITOR          (3000)
--     C = TICKETPLATFORM   (3000)
--     D = TICKET           (40000)   -- junction A x C x S2.FESTIVAL
--     aux: COMPANY, CITY, PERMIT
--   S2 (parent-child 2 levels deep)
--     W = ARTIST           (sibling FK on Z)
--     X = FESTIVAL         (30)
--     Y = STAGE            (900     = 30 X * 30 per X)
--     Z = PERFORMANCE      (54000   = 900 Y * 60 per Y)
--     aux: GENRE
--
-- Order constraints (cross-schema FKs):
--   FESTIVAL (S2) -> COMPANY, CITY (S1)        -> S1 base must run first
--   TICKET, PERMIT (S1) -> FESTIVAL (S2)       -> S1 children must run last
-- =============================================================
BEGIN
    -- === EMPTY (children first to satisfy cross-schema FKs) ===
    PKG_S1_festivals.empty_s1_children; -- TICKET, PERMIT
    PKG_S2_festivals.empty_tables_S2; -- PERFORMANCE, STAGE, FESTIVAL, ARTIST, GENRE
    PKG_S1_festivals.empty_s1_base;
    -- TICKETPLATFORM, VISITOR, COMPANY, CITY

    -- === FILL with M5 RANDOM data, interleaved ===
    --   1) S1 base       (CITY, COMPANY, TICKETPLATFORM, VISITOR)
    --   2) S2 W-X-Y-Z    (GENRE, ARTIST, FESTIVAL, STAGE, PERFORMANCE)
    --   3) S1 children   (TICKET, PERMIT) – needs FESTIVAL to exist
    PKG_S1_festivals.bewijs_milestone_5_S1_base(
            p_cities => 3000,
            p_companies => 3000,
            p_platforms => 3000,
            p_visitors => 3000);

    PKG_S2_festivals.bewijs_M5_S2(
            p_genres => 30,
            p_festivals => 30,
            p_stages => 30, -- per festival -> 900 stages
            p_perfs => 60); -- per stage    -> 54000 performances

    PKG_S1_festivals.bewijs_milestone_5_S1_children(
            p_tickets => 40000,
            p_permits_per_fest => 5);

    -- === STAP 4: showcase every random helper via DBMS_OUTPUT ===
    PKG_SAMEN_festivals.bewijs_Random_M5;
END;
/
SELECT 'S1-A   : Visitor' AS "Table", COUNT(*) AS "Count"
FROM Visitor
UNION ALL
SELECT 'S1-C   : TicketPlatform', COUNT(*)
FROM TicketPlatform
UNION ALL
SELECT 'S1-D   : Ticket', COUNT(*)
FROM Ticket
UNION ALL
SELECT 'S1_    : Company', COUNT(*)
FROM Company
UNION ALL
SELECT 'S1_    : City', COUNT(*)
FROM City
UNION ALL
SELECT 'S1_    : Permit', COUNT(*)
FROM Permit
UNION ALL
SELECT 'S2-W   : Artist', COUNT(*)
FROM Artist
UNION ALL
SELECT 'S2-X   : Festival', COUNT(*)
FROM Festival
UNION ALL
SELECT 'S2-Y   : Stage', COUNT(*)
FROM Stage
UNION ALL
SELECT 'S2-Z   : Performance', COUNT(*)
FROM Performance
UNION ALL
SELECT 'S2_    : Genre' AS "Table", COUNT(*) AS "Count"
FROM Genre
ORDER BY 1
;

-- -------------------------------------------------------------
-- Random sample - data variety checks (no repeating values allowed)
-- -------------------------------------------------------------
SELECT VISITOR_FIRSTNAME || ' ' || VISITOR_LASTNAME AS "Visitor",
       VISITOR_EMAIL,
       VISITOR_GENDER,
       VISITOR_BIRTHDATE
FROM VISITOR
ORDER BY DBMS_RANDOM.VALUE()
    FETCH FIRST 10 ROWS ONLY;

SELECT TICKET_BARCODE,
       TICKET_TYPE,
       TICKET_STATUS,
       TICKET_PRICE,
       TICKET_CURRENCY,
       TICKET_DATE
FROM TICKET
ORDER BY DBMS_RANDOM.VALUE()
    FETCH FIRST 10 ROWS ONLY;

SELECT TICKETPLATFORM_NAME,
       TICKETPLATFORM_URL
FROM TICKETPLATFORM
ORDER BY DBMS_RANDOM.VALUE()
    FETCH FIRST 10 ROWS ONLY;

SELECT PERMIT_CATEGORY,
       PERMIT_DESCRIPTION,
       PERMIT_APPLICATION_DATE,
       PERMIT_RECEPTION_DATE,
       PERMIT_EXPIRATION_DATE
FROM PERMIT
ORDER BY DBMS_RANDOM.VALUE()
    FETCH FIRST 10 ROWS ONLY;

SELECT ARTIST_NAME,
       ARTIST_BIRTHDAY,
       ARTIST_LAND_OF_BIRTH,
       ARTIST_PRICE
FROM ARTIST
ORDER BY DBMS_RANDOM.VALUE()
    FETCH FIRST 10 ROWS ONLY;

SELECT FESTIVAL_NAME,
       FESTIVAL_LOCATION,
       FESTIVAL_CAPACITY,
       FESTIVAL_OPENING_HOUR,
       FESTIVAL_CLOSING_HOUR,
       FESTIVAL_STARTDATE,
       FESTIVAL_ENDDATE
FROM FESTIVAL
ORDER BY DBMS_RANDOM.VALUE()
    FETCH FIRST 10 ROWS ONLY;

SELECT PERFORMANCE_DESCRIPTION,
       PERFORMANCE_START_TIME,
       PERFORMANCE_END_TIME
FROM PERFORMANCE
ORDER BY DBMS_RANDOM.VALUE()
    FETCH FIRST 10 ROWS ONLY;

SELECT STAGE_NAME,
       STAGE_DESCRIPTION,
       STAGE_ROOFED_STATUS,
       STAGE_STANDING_CAPACITY,
       STAGE_STYLE_DESCRIPTION,
       STAGE_TOILET_COUNT
FROM STAGE
ORDER BY DBMS_RANDOM.VALUE()
    FETCH FIRST 10 ROWS ONLY;

SELECT FESTIVAL_ID, COUNT(TICKET_ID)
FROM Ticket
GROUP BY FESTIVAL_ID;

