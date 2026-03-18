-- =====================================================================
-- SQL*Plus script dropcase.sql: verwijdert de casustabellen
-- (met constraints) maar laat het schema bestaan; handig als de
-- tabellen per ongeluk in eenverkeerd schema zijn gecreeerd.
-- Leerboek Oracle SQL, Lex de Haan
-- derde editie, Academic Service 2004
-- =====================================================================

drop table medewerkers    cascade constraints;
drop table afdelingen     cascade constraints;
drop table schalen        cascade constraints;
drop table cursussen      cascade constraints;
drop table uitvoeringen   cascade constraints;
drop table inschrijvingen cascade constraints;
drop table historie       cascade constraints;
