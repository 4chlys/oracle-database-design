
Milestone 3: Creatie Databank en Security
---

    Identity columns
---
- Mandatory
    **
- - A: Vi
- sitor: Visitor_ID**
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
![count_result.png](screenshots%2Fcount_result.png)

Queries
--- 
    S1 @query 1: VISITOR (A) - FESTIVAL (B/X) via Ticket (D) + TicketPlatform (C)
![S1_query1_visitor_festival_ticket_1.png](screenshots/S1_query1_visitor_festival_ticket_1.png)
![S1_query1_visitor_festival_ticket_2.png](screenshots/S1_query1_visitor_festival_ticket_2.png)

    S1 @query 2: COMPANY - FESTIVAL - PERMIT
![S1_query2_company_festival_permit_1.png](screenshots/S1_query2_company_festival_permit_1.png)
![S1_query2_company_festival_permit_2.png](screenshots/S1_query2_company_festival_permit_2.png)

    S2 @query 1: FESTIVAL (B/X) – STAGE (Y) – PERFORMANCE (Z) – ARTIST (W) – GENRE
![S2_query1_festival_stage_performance.png](screenshots%2FS2_query1_festival_stage_performance.png)

    S2 @query 2: ARTIST (W) – PERFORMANCE (Z) – GENRE – STAGE (Y) – FESTIVAL (B/X)
![S2_query2_artist_performance_genre.png](screenshots%2FS2_query2_artist_performance_genre.png)

Bewijs Domeinen - constraints M2
--- 

    S1
- Company: founding year must be between 1800 and 2025, Company_Name_UQ  →  UNIQUE (Company_Name)

![S1_bewijs_company_constraints.png](screenshots/S1_bewijs_company_constraints.png)

- Visitor: birthdate must be between 1900-01-01 and 2026-03-10, Visitor_Email_UQ  →  UNIQUE (Visitor_Email)

![S1_bewijs_visitor_constraints.png](screenshots/S1_bewijs_visitor_constraints.png)

- Permit: application_date < reception_date < expiration_date

![S1_bewijs_permit_constraints.png](screenshots/S1_bewijs_permit_constraints.png)

- Ticket: price > 0, barcode length between 8 and 14, purchase_date <= ticket_date, UNIQUE (Visitor_ID, Festival_ID, Ticket_Date)

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
SELECT * FROM USER_SYS_PRIVS;
```
![S1_user_sys_privs.png](screenshots/S1_user_sys_privs.png)

- User tab privs S1
```sql
SELECT * FROM USER_TAB_PRIVS;
```
![S1_user_tab_privs.png](screenshots/S1_user_tab_privs.png)

- User col privs S1
```sql
SELECT * FROM USER_COL_PRIVS;
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