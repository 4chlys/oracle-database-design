Milestone 3: Creatie Databank en Security
---

    Identity columns

---

- Mandatory
-
    - A: Visitor: Visitor_ID
    - B/X: Festival: Festival_ID
    - C: TicketPlatform: TicketPlatform_ID
    - D: Ticket: Ticket_ID
    - W: Artist: Artist_ID
    - Y: Stage: Stage_ID
    - Z: Performance: Performance_ID
- other:
    - Company: Company_ID
    - City: City_ID
    - Permit: Permit_ID
    - Genre: Genre_ID

      Table Counts

---

     Tablecounts

```sql
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
```

![count_result.png](screenshots%2Fcount_result.png)

Queries
---

    S1 @query 1: VISITOR (A) - FESTIVAL (B/X) via Ticket (D) + TicketPlatform (C)

```sql
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
```

![S1_query1_visitor_festival_ticket_1.png](screenshots/S1_query1_visitor_festival_ticket_1.png)
![S1_query1_visitor_festival_ticket_2.png](screenshots/S1_query1_visitor_festival_ticket_2.png)

    S1 @query 2: COMPANY - FESTIVAL - PERMIT

```sql
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
```

![S1_query2_company_festival_permit_1.png](screenshots/S1_query2_company_festival_permit_1.png)
![S1_query2_company_festival_permit_2.png](screenshots/S1_query2_company_festival_permit_2.png)

    S2 @query 1: FESTIVAL (B/X) – STAGE (Y) – PERFORMANCE (Z) – ARTIST (W) – GENRE

```sql
SELECT f.Festival_Name,
       TO_CHAR(f.Festival_StartDate, 'DD-MM-YYYY')                AS Festival_Start,
       TO_CHAR(f.Festival_EndDate, 'DD-MM-YYYY')                  AS Festival_End,
       f.Festival_Location,
       TO_CHAR(f.Festival_Opening_Hour, 'HH24:MI')                AS Opening_Hour,
       TO_CHAR(f.Festival_Closing_Hour, 'HH24:MI')                AS Closing_Hour,
       f.Festival_Capacity,
       s.Stage_Name,
       s.Stage_Style_Description,
       s.Stage_Standing_Capacity,
       s.Stage_Toilet_Count,
       s.Stage_Description,
       CASE s.Stage_Roofed_Status WHEN 1 THEN 'Yes' ELSE 'No' END AS Stage_Roofed,
       a.Artist_Name,
       TO_CHAR(a.Artist_Birthday, 'DD-MM-YYYY')                   AS Artist_Birthday,
       a.Artist_Price,
       a.Artist_Price_Currency,
       a.Artist_Land_Of_Birth,
       g.Genre_Name,
       g.Genre_Origin_Year,
       g.Genre_Origin_Location,
       g.Genre_BPM,
       TO_CHAR(p.Performance_Start_Time, 'DD-MM-YYYY HH24:MI')    AS Performance_Start,
       TO_CHAR(p.Performance_End_Time, 'DD-MM-YYYY HH24:MI')      AS Performance_End,
       p.Performance_Description
FROM Festival f
         JOIN Stage s ON s.Festival_ID = f.Festival_ID
         JOIN Performance p ON p.Stage_ID = s.Stage_ID
         JOIN Artist a ON a.Artist_ID = p.Artist_ID
         JOIN Genre g ON g.Genre_ID = p.Genre_ID
ORDER BY f.Festival_Name, s.Stage_Name, p.Performance_Start_Time;
```

![S2_query1_festival_stage_performance.png](screenshots%2FS2_query1_festival_stage_performance.png)

    S2 @query 2: ARTIST (W) – PERFORMANCE (Z) – GENRE – STAGE (Y) – FESTIVAL (B/X)

```sql
SELECT a.Artist_Name,
       TO_CHAR(a.Artist_Birthday, 'DD-MM-YYYY')                AS Artist_Birthday,
       a.Artist_Price || ' ' || a.Artist_Price_Currency        AS Artist_Fee,
       a.Artist_Land_Of_Birth,
       f.Festival_Name,
       f.Festival_Location,
       TO_CHAR(f.Festival_StartDate, 'DD-MM-YYYY')             AS Festival_Start,
       s.Stage_Name,
       g.Genre_Name,
       g.Genre_BPM,
       TO_CHAR(p.Performance_Start_Time, 'DD-MM-YYYY HH24:MI') AS Performance_Start,
       TO_CHAR(p.Performance_End_Time, 'DD-MM-YYYY HH24:MI')   AS Performance_End,
       p.Performance_Description
FROM Artist a
         JOIN Performance p ON p.Artist_ID = a.Artist_ID
         JOIN Genre g ON g.Genre_ID = p.Genre_ID
         JOIN Stage s ON s.Stage_ID = p.Stage_ID
         JOIN Festival f ON f.Festival_ID = s.Festival_ID
ORDER BY a.Artist_Name, f.Festival_Name, p.Performance_Start_Time;
```

![S2_query2_artist_performance_genre.png](screenshots%2FS2_query2_artist_performance_genre.png)

Bewijs Domeinen - constraints M2
--- 

    S1

- Company: founding year must be between 1800 and 2025, Company_Name_UQ → UNIQUE (Company_Name)

![S1_bewijs_company_constraints.png](screenshots/S1_bewijs_company_constraints.png)

- Visitor: birthdate must be between 1900-01-01 and 2026-03-10, Visitor_Email_UQ → UNIQUE (Visitor_Email)

![S1_bewijs_visitor_constraints.png](screenshots/S1_bewijs_visitor_constraints.png)

- Permit: application_date < reception_date < expiration_date

![S1_bewijs_permit_constraints.png](screenshots/S1_bewijs_permit_constraints.png)

- Ticket: price > 0, barcode length between 8 and 14, purchase_date <= ticket_date, UNIQUE (Visitor_ID, Festival_ID,
  Ticket_Date)

![S1_bewijs_ticket_constraints_1.png](screenshots/S1_bewijs_ticket_constraints_1.png)
![S1_bewijs_ticket_constraints_2.png](screenshots/S1_bewijs_ticket_constraints_2.png)

- Festival: end_date > start_date, closing_hour > opening_hour, capacity > 0

![S1_bewijs_festival_constraints.png](screenshots/S1_bewijs_festival_constraints.png)

    S2

- Genre: BPM >= 0, origin year < 2026

![S2_bewijs_genre_constraints.png](screenshots%2FS2_bewijs_genre_constraints.png)

- Artist: price >= 0, currency is 3 uppercase letters (ISO 4217), land of birth >= 4 chars, birthday < 2026-03-10

![S2_bewijs_artist_constraints.png](screenshots%2FS2_bewijs_artist_constraints.png)

- Stage: standing capacity >= 0, toilet count >= 0, roofed status IN (0, 1), name unique per festival

![S2_bewijs_stage_constraints.png](screenshots%2FS2_bewijs_stage_constraints.png)

- Performance: end time > start time

![S2_bewijs_performance_times.png](screenshots%2FS2_bewijs_performance_times.png)


Security
---
IntelliJ Tree View

![tables_views.png](screenshots/tables_views.png)

    S1: user s1_visitor, role festival_s1_role, view v_visitor_ticket

- User sys privs S1

```sql
SELECT *
FROM USER_SYS_PRIVS;
```

![S1_user_sys_privs.png](screenshots/S1_user_sys_privs.png)

- User tab privs S1

```sql
SELECT *
FROM USER_TAB_PRIVS;
```

![S1_user_tab_privs.png](screenshots/S1_user_tab_privs.png)

- User col privs S1

```sql
SELECT *
FROM USER_COL_PRIVS;
```

![S1_user_col_privs.png](screenshots/S1_user_col_privs.png)

- View Topvisitors
  ![S1_view_topvisitors.png](screenshots/S1_view_topvisitors.png)

  S2: user s2_stage, role festival_s2_role, view v_stage_performance

- User tab privs S2

```sql
SELECT *
FROM USER_TAB_PRIVS
WHERE GRANTEE = (SELECT USER FROM dual);
```

![S2_user_tab_privs.png](screenshots%2FS2_user_tab_privs.png)

- User Role privs S2

```sql
SELECT *
FROM USER_ROLE_PRIVS;
```

![S2_user_role_privs.png](screenshots%2FS2_user_role_privs.png)

- Role Tab privs S2

```sql
SELECT *
FROM role_tab_privs
WHERE role = 'FESTIVAL_S2_ROLE'
ORDER BY TABLE_NAME;
```

![S2_Role_tab_privs.png](screenshots%2FS2_Role_tab_privs.png)

- view v_stage_performance
  ![S2_view_v_stage_performance.png](screenshots%2FS2_view_v_stage_performance.png)

- INSERT VIEW - key preserved table (Performance)
  ![S2_key_preserved_table.png](screenshots%2FS2_key_preserved_table.png)