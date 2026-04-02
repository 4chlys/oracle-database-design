select *
from KLANTEN;
-- Vraag 1
savepoint vraag1begin;
insert into KLANTEN (KLNR, ACHTERNAAM, VOORNAAM)
VALUES (55555, upper('Friedhoff'), upper('Jonas'));
savepoint klant;
INSERT INTO reservaties(resnr, bunr, klnr, parkcode, typenr, hnr, boekingsdatum, begindat, einddat, kode, promocode,
                        status)
VALUES (21, 1, '55555', 'WB', 'FK', 225, sysdate,
        to_date('28-10-22', 'dd-mm-yy'),
        to_date('01-11-22', 'dd-mm-yy'), 1, null, 'OPEN');

INSERT INTO reservaties(resnr, bunr, klnr, parkcode, typenr, hnr,
                        boekingsdatum, begindat, einddat, kode,
                        promocode, status)
VALUES (22, 1, '55555', 'WB', 'FV10', 515, sysdate, to_date('23-12-22', 'dd-mm-yy'), to_date('27-12-22', 'dd-mm-yy'), 1,
        null, 'OPEN');
SAVEPOINT s1;

INSERT INTO betalingen
(betalingsnr, resnr, bunr, datumbetaling,
 bedrag, betalingswijze)
values ((select max(betalingsnr) + 1 from betalingen),
        '21',
        '1',
        sysdate,
        200,
        'B');

ROLLBACK TO SAVEPOINT s1;
ROLLBACK to SAVEPOINT klant;
ROLLBACK;
SELECT *
from reservaties;
SELECT *
from klanten;
SELECT *
from betalingen;

--Vraag2

select *
from RESERVATIES
where KLNR = (select KLNR from KLANTEN where VOORNAAM = upper('pieter') AND ACHTERNAAM = upper('stoot'));

select PARKCODE, TYPENR, abadKamer
from TYPE_HUIZEN
order by ABADKAMER desc fetch first 1 rows
with ties;

delete
from KLANTEN
where VOORNAAM = upper('pieter')
  AND ACHTERNAAM = upper('stoot');
ROLLBACK;

select parkcode, typenr, hnr
from vakantiehuizen
where typenr like 'FK%';

select *
from reservaties
where parkcode = 'WB';


DELETE
FROM vakantiehuizen
WHERE parkcode = 'WB'
  AND typenr = 'FK'
  AND hnr = 225;

ROLLBACK;

UPDATE type_huis_prijzen
SET prijs_weekend = prijs_Weekend * 1.1,
    prijs_midweek = prijs_midweek * 1.1
WHERE seizoencode = 1
  AND (parkcode, typenr) IN (SELECT parkcode, typenr
                             FROM type_huizen th
                                      JOIN parken p ON (p.code = th.parkcode)
                                      JOIN landen l ON (l.landcode = p.landcode)
                             WHERE UPPER(landnaam) = 'NEDERLAND');
rollback;

ALTER TABLE TYPE_HUIZEN drop constraint CC_TYPEH_APERS;

ALTER TABLE type_huizen
    ADD CONSTRAINT cc_typeh_apers CHECK (apers BETWEEN 4 AND 24);
--b
ALTER TABLE type_huizen
    ADD CONSTRAINT cc_typeh_apers CHECK (apers BETWEEN 4 AND 24) INITIALLY DISABLE;
--c
UPDATE type_huizen
SET apers = 4
WHERE apers < 4;
--d
ALTER TABLE type_huizen
    ENABLE NOVALIDATE CONSTRAINT cc_typeh_apers;
--e
SELECT *
                                 FROM user_constraints
                                 WHERE table_name = 'TYPE_HUIZEN';

SELECT constraint_name, status, validated
FROM user_constraints;
--f
INSERT INTO type_huizen(parkcode, typenr, apers)
VALUES ('WB', 'WX', 3);
--Waarom protesteert het DBMS?
--Nieuwe rijen en updates op bestaande rijen worden wel gevalideerd
SELECT owner, table_name
FROM all_tables;
SELECT table_name
FROM user_tables;

SELECT owner, table_name
FROM all_tables
WHERE LOWER(table_name) = 'type_huizen';

SELECT USER FROM dual;
SELECT owner, constraint_name, status, validated
FROM all_constraints
WHERE table_name = 'TYPE_HUIZEN';