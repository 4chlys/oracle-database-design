BEGIN
    -- === EMPTY (interleaved because of cross-schema FKs) ===
    PKG_S1_festivals.empty_s1_children;   -- TICKET, PERMIT (children of S2.FESTIVAL)
    PKG_S2_festivals.empty_tables_S2;     -- PERFORMANCE, STAGE, FESTIVAL, ARTIST, GENRE
    PKG_S1_festivals.empty_s1_base;       -- TICKETPLATFORM, VISITOR, COMPANY, CITY
-- --
-- --     -- === FILL (interleaved: COMPANY before FESTIVAL, FESTIVAL before TICKET/PERMIT) ===
    PKG_S1_festivals.fill_s1_base;        -- COMPANY, CITY, VISITOR, TICKETPLATFORM
    PKG_S2_festivals.bewijs_M4_S2;        -- FESTIVAL, GENRE, ARTIST, STAGE, PERFORMANCE
    PKG_S1_festivals.fill_s1_children;    -- PERMIT, TICKET

    PKG_S2_festivals.bewijs_M5_S2(30,30,30,10);
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