SELECT 'S1-A   : Visitor' AS "Table", COUNT(*) AS "Count"
FROM Visitor
UNION ALL
SELECT 'S1-C   : TicketPlatform', COUNT(*)
FROM TicketPlatform
UNION ALL
SELECT 'S1-D   : Ticket', COUNT(*)
FROM Ticket
UNION ALL
SELECT 'S1_   : Company', COUNT(*)
FROM Company
UNION ALL
SELECT 'S1_   : City', COUNT(*)
FROM City
UNION ALL
SELECT 'S1_   : Permit', COUNT(*)
FROM Permit
UNION ALL
SELECT 'S2-W  : Artist', COUNT(*)
FROM Artist
UNION ALL
SELECT 'S2-X   : Festival', COUNT(*)
FROM Festival
UNION ALL
SELECT 'S2-Y  : Stage', COUNT(*)
FROM Stage
UNION ALL
SELECT 'S2-Z  : Performance', COUNT(*)
FROM Performance
UNION ALL
SELECT 'S2_  : Genre' AS "Table", COUNT(*) AS "Count"
FROM Genre
ORDER BY 1
;