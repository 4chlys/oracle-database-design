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

-- =============================================================
-- MILESTONE 6 – SMALL run, SINGLE insert (~49 000 S1 rows)
--   cities = GREATEST(CEIL(3000 / 20), 50) = 150
-- =============================================================
BEGIN
    -- === EMPTY ===
    PKG_S1_festivals.empty_s1_children;
    PKG_S2_festivals.empty_tables_S2;
    PKG_S1_festivals.empty_s1_base;

    -- === FILL with M6 SINGLE data ===
    --   1) S1 base (CITY, COMPANY, TICKETPLATFORM, VISITOR)
    --   2) S2 W-X-Y-Z – needs COMPANY, CITY to exist
    --   3) S1 children (TICKET, PERMIT) – needs FESTIVAL to exist
    PKG_S1_festivals.bewijs_milestone_6_S1_base_single(
            p_cities    => 150,
            p_companies => 3000,
            p_platforms => 3000,
            p_visitors  => 3000);

    PKG_S2_festivals.bewijs_milestone_6_S2(
            p_genres    => 30,
            p_festivals => 30,
            p_stages    => 30,
            p_perfs     => 60,
            p_mode      => 'SINGLE');

    PKG_S1_festivals.bewijs_milestone_6_S1_children_single(
            p_tickets          => 40000,
            p_permits_per_fest => 5);
END;
/

-- =============================================================
-- MILESTONE 6 – SMALL run, BULK insert (~49 000 S1 rows)
--   Same parameters as SINGLE above – compare [LOG] timings.
-- =============================================================
BEGIN
    -- === EMPTY ===
    PKG_S1_festivals.empty_s1_children;
    PKG_S2_festivals.empty_tables_S2;
    PKG_S1_festivals.empty_s1_base;

    -- === FILL with M6 BULK data ===
    PKG_S1_festivals.bewijs_milestone_6_S1_base_bulk(
            p_cities    => 150,
            p_companies => 3000,
            p_platforms => 3000,
            p_visitors  => 3000);

    PKG_S2_festivals.bewijs_milestone_6_S2(
            p_genres    => 30,
            p_festivals => 30,
            p_stages    => 30,
            p_perfs     => 60,
            p_mode      => 'BULK');

    PKG_S1_festivals.bewijs_milestone_6_S1_children_bulk(
            p_tickets          => 40000,
            p_permits_per_fest => 5);
END;
/

-- =============================================================
-- MILESTONE 6 – LARGE run, BENCHMARK insert (~490 000 S1 rows)
-- [LOG] generateRandomTickets | params: p_amount=400000 | rows added: 400000 | gen: 6441 ms | insert: 12388 ms | total: 18829 ms
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
            p_festivals => 300,
            p_stages => 30, -- per festival -> 900 stages
            p_perfs => 60); -- per stage    -> 54000 performances

    PKG_S1_festivals.bewijs_milestone_5_S1_children(
            p_tickets => 400000,
            p_permits_per_fest => 5);

    -- === STAP 4: showcase every random helper via DBMS_OUTPUT ===
    PKG_SAMEN_festivals.bewijs_Random_M5;
END;
/

-- =============================================================
-- MILESTONE 6 – LARGE run, SINGLE insert (~490 000 S1 rows)
--   At this scale the cost of row-by-row INSERT is most visible.
-- [LOG] generateRandomTickets_single | params: p_amount=400000 | rows added: 400000 | gen: 0 ms | insert: 57733 ms | total: 57733 ms
-- =============================================================
BEGIN
    -- === EMPTY ===
    PKG_S1_festivals.empty_s1_children;
    PKG_S2_festivals.empty_tables_S2;
    PKG_S1_festivals.empty_s1_base;

    -- === FILL with M6 SINGLE data ===
    PKG_S1_festivals.bewijs_milestone_6_S1_base_single(
            p_cities    => 150,
            p_companies => 3000,
            p_platforms => 3000,
            p_visitors  => 3000);

    PKG_S2_festivals.bewijs_milestone_6_S2(
            p_genres    => 30,
            p_festivals => 30,
            p_stages    => 30,
            p_perfs     => 60,
            p_mode      => 'SINGLE');

    PKG_S1_festivals.bewijs_milestone_6_S1_children_single(
            p_tickets          => 400000,
            p_permits_per_fest => 5);
END;
/

-- =============================================================
-- MILESTONE 6 – LARGE run, BULK insert (~490 000 S1 rows)
--   Same parameters as SINGLE above – compare [LOG] timings.
-- [LOG] generateRandomTickets_bulk | params: p_amount=400000 | rows added: 400000 | gen: 5975 ms | insert: 11359 ms | total: 17534 ms
-- =============================================================
BEGIN
    -- === EMPTY ===
    PKG_S1_festivals.empty_s1_children;
    PKG_S2_festivals.empty_tables_S2;
    PKG_S1_festivals.empty_s1_base;

    -- === FILL with M6 BULK data ===
    PKG_S1_festivals.bewijs_milestone_6_S1_base_bulk(
            p_cities    => 150,
            p_companies => 3000,
            p_platforms => 3000,
            p_visitors  => 3000);

    PKG_S2_festivals.bewijs_milestone_6_S2(
            p_genres    => 30,
            p_festivals => 30,
            p_stages    => 30,
            p_perfs     => 60,
            p_mode      => 'BULK');

    PKG_S1_festivals.bewijs_milestone_6_S1_children_bulk(
            p_tickets          => 400000,
            p_permits_per_fest => 5);
END;
/

-- =============================================================
-- MILESTONE 6 – S2 proof, SMALL run (30, 30, 30, 60, 'BOTH')
--   bewijs_milestone_6_S2 empties + refills the S2 tables with M4
--   data internally between the BULK and SINGLE runs.  S1 base
--   (COMPANY, CITY) must already be populated with the M4 baseline
--   because bewijs_M4_S2 looks up companies by hardcoded name.
--   Expected: minimum 54.000 rijen per method.
-- =============================================================
BEGIN
    PKG_S1_festivals.empty_s1_children;
    PKG_S2_festivals.empty_tables_S2;
    PKG_S1_festivals.empty_s1_base;
    PKG_S1_festivals.fill_s1_base;
    COMMIT;

    PKG_S2_festivals.bewijs_milestone_6_S2(
            p_genres    => 30,
            p_festivals => 30,
            p_stages    => 30,
            p_perfs     => 60,
            p_mode      => 'BOTH');
END;
/

-- =============================================================
-- MILESTONE 6 – S2 proof, LARGE run (30, 30, 30, 600, 'BOTH')
--   Same prerequisites as the small run.  Expected: minimum
--   540.000 rijen per method.
-- =============================================================
BEGIN
    PKG_S1_festivals.empty_s1_children;
    PKG_S2_festivals.empty_tables_S2;
    PKG_S1_festivals.empty_s1_base;
    PKG_S1_festivals.fill_s1_base;
    COMMIT;
    PKG_S2_festivals.bewijs_milestone_6_S2(
            p_genres    => 30,
            p_festivals => 30,
            p_stages    => 30,
            p_perfs     => 600,
            p_mode      => 'BOTH');
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