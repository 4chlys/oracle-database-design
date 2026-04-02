--PROJECT 6 deel 1
-- ter info wijzigen van user in IntelliJ :
-- klik in databankvanster op Praktijk
-- Ga naar het Datasource scherm
-- Zorg dat de User 'Praktijk' is

--Voer voor je deze praktijkopgave maakt,
--het create en insert script van de Vakantieparken databank opnieuw uit.

--Vraag 1
-- Zoek in de dictionary tabellen op welke indexen er momenteel
-- op de tabellen uit de Vakantieparken database staan.
--  werk je op de cloud:
SELECT owner, INDEX_NAME, TABLE_NAME, TABLESPACE_NAME, UNIQUENESS
FROM dba_indexes
WHERE TABLE_OWNER='PRAKTIJK'; 
--Welke van deze indexen werden automatisch door Oracle aangemaakt?
--allemaal

--Wat merk je aan de naamgeving van deze indexen?
--Kregen dezelfde naam als de PK constraint

--Vraag 2
--Je plaatste voor de tabel TYPE_HUIZEN een primaire sleutel
-- op de attributen parkcode en typenr.
--Er staat dus een unieke index op deze combinatie van attributen.

--a.
--Kijk na in welke volgorde de attributen in de index staan.

SELECT *
FROM ALL_CONS_COLUMNS
WHERE TABLE_NAME = 'TYPE_HUIZEN'
  AND CONSTRAINT_NAME LIKE 'PK%';
select * from TYPE_HUIZEN;
--kijk naar position --> parkcode heeft position 1,
--typenr--> position 2

--b.
--Is die volgorde volgens jou ok?  Leg uit waarom!
--Plaats het attribuut met de grootste verscheidenheid aan
-- waarden vooraan.
--In dit geval is dat TYPENR => dus beter volgorde wisselen.

--Vraag 3
--a.
--Ga na welke indexen op de tabel TYPE_HUIS_PRIJZEN staan.

SELECT *
FROM dba_indexes   -- of all_indexes
WHERE UPPER(TABLE_NAME) = 'TYPE_HUIS_PRIJZEN';

--b.
--Zet de  PK constraint van bovenstaande tabel
-- tijdelijk buiten werking.
ALTER TABLE type_huis_prijzen
DISABLE CONSTRAINT pk_typehprijzen ;
--c.
--Ga opnieuw na welke indexen op de tabel TYPE_HUIS_PRIJZEN staan.
-- verdwenen

--d.
--zet de PK constaint opnieuw in werking en doe een controle op de index.
ALTER TABLE type_huis_prijzen
ENABLE CONSTRAINT pk_typehprijzen ;
-- is er terug 
--e.
--Verwijder de index die automatisch op bovenstaande
-- PK werd gecreerd.
--Wat merk je?
DROP INDEX pk_typehprijzen;

--Je kan een index die automatisch door een PK (of UNIQUE) constraint wordt aangemaakt,
-- niet verwijderen met DROP INDEX.
-- Je kan de index alleen verwijderen door de constraint te verwijderen.

--Vraag 4
--a.
--voer onderstaande instructie uit:
--drop table klanten1;
CREATE TABLE klanten1
AS SELECT *
   FROM klanten;
ALTER TABLE klanten1
    MODIFY klnr CONSTRAINT pk_klanten1 PRIMARY KEY;

--Deze tabel komt in je default tablespace DATA te staan.
--Controleer de status van de index op de PK van Klanten1.
SELECT index_name,tablespace_name,status
FROM dba_indexes
WHERE lower(table_name)='klanten1';
--valid
--b.
--Disable tijdelijk de index en herbekijk de status.
ALTER INDEX pk_klanten1 unusable;

SELECT tablespace_name,index_name,status
FROM dba_indexes
WHERE index_name='PK_KLANTEN1';
--unusable

--c.
--Plaats de status terug op VALID uitgaande van de oude index (dus niet droppen en opnieuw aanmaken)
--Indexen die UNUSABLE  zijn geworden hoeven daarvoor niet verwijderd te worden en opnieuw gecreëerd.
--Ze moeten gewoon opnieuw opgebouwd worden.
--	Hoe ga je te werk?

ALTER INDEX PK_KLANTEN1 REBUILD;

--In welke tabelspace staat de index?  --> nog steeds DATA
-- De index blijft in de oude tablespace staan.
--Wat is de status van de index? --> VALID

SELECT index_name,tablespace_name,status
FROM dba_indexes
WHERE table_name='KLANTEN1';

--vraag 5 PARTITIONERING

--DOEL: Maak een kopie van de tabel reservaties, nl reservaties2
--Maar zorg ervoor dat de tabel een INTERVAL partitioning
-- op jaarbasis heeft voor de kolom boekingsdatum.
--a.
--Gebruik ‘Go to DDL’ om de CREATE TABLE statement van de tabel
-- reservaties te vinden
--B)
--Check eerst welke jaren er reeds in de database zitten
SELECT DISTINCT to_CHAR(boekingsdatum, 'YYYY') years
FROM reservaties
ORDER bY 1;

--c)
create table RESERVATIES2
(
    RESNR         NUMBER(4) not null,
    BUNR          NUMBER(2) not null
        constraint FK_RES_BUR2
            references REISBURS
                on delete cascade,
    KLNR          VARCHAR2(5)
        constraint FK_RES_KLANT2
            references KLANTEN,
    PARKCODE      VARCHAR2(2)
        constraint PARKCODE3_HFDL2
            check (parkcode = upper(parkcode)),
    TYPENR        VARCHAR2(5)
        constraint TYP_HFDL_12
            check (typenr = upper(typenr)),
    HNR           NUMBER(3),
    BOEKINGSDATUM DATE,
    BEGINDAT      DATE,
    EINDDAT       DATE,
    KODE          NUMBER(1)
        constraint CC_RESV_KODE2
            check (kode IN (1, 2)),
    STATUS        VARCHAR2(8)
        constraint CC_RES_STATUS2
            check (status in ('OPEN', 'BETAALD', 'GESLOTEN')),
    PROMOCODE     VARCHAR2(9)
        constraint FK_RES_PROMO2
            references PROMOTIES,
    constraint PK_RESERV2
        primary key (RESNR, BUNR),
    constraint FK_RES_VAKANTIEHUIS2
        foreign key (PARKCODE, TYPENR, HNR) references VAKANTIEHUIZEN
            on delete cascade,
    constraint INTEGR_DATUMS2
        check (einddat >= begindat)
)
    PARTITION BY RANGE (BOEKINGSDATUM)
    INTERVAL(NUMTOYMINTERVAL(1, 'YEAR'))
( PARTITION p0 VALUES LESS THAN (TO_DATE('1-1-2018', 'DD-MM-YYYY'))
    , PARTITION p1 VALUES LESS THAN (TO_DATE('1-1-2019', 'DD-MM-YYYY'))
    , PARTITION p2 VALUES LESS THAN (TO_DATE('1-1-2020', 'DD-MM-YYYY')) );

-- D) kopieer de data van reservaties naar RESERVATIES2

INSERT INTO RESERVATIES2
(SELECT * from reservaties);

--e)	Check de partities van de tabel met volgende query
SELECT *
FROM DBA_TAB_PARTITIONS
WHERE lower(TABLE_OWNER)='praktijk';

--f)
--check in welke partities de rijen van reservaties2 staan door enkele rijen te querien van 2019
SELECT * from reservaties2
WHERE boekingsdatum BETWEEN TO_DATE('1-1-2019', 'DD-MM-YYYY') AND TO_DATE('31-12-2019', 'DD-MM-YYYY');

INSERT INTO RESERVATIES2 VALUES (25,1,'34560','MD',
                                 '32', 133,
                                 sysdate,
                                 sysdate+20,
                                 sysdate+30,
                                 2, 'BETAALD', NULL);

--g)	Check opnieuw de partities van de tabel reservaties2, wat merk je op?
select * from dba_tab_partitions where upper(table_name) = 'RESERVATIES2';
--of gebruik all_tab_partitions indien je niet user praktijk bent (of in cloud werkt)
select * from all_tab_partitions where table_name = 'RESERVATIES2';
--of onderstaande query
SELECT *
FROM DBA_TAB_PARTITIONS
WHERE lower(TABLE_OWNER)='praktijk';

--bemerk:
drop TABLE reservaties2;
--partities staan er nog!

--opkuisen:
purge recyclebin;