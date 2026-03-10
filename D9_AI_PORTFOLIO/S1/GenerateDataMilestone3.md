# Input

```
Generate a CSV file with 50 records for every table in this database. 
Each CSV must respect all table constraints and cover all relevant cardinality combinations. 
The dataset should contain realistic, domain‑appropriate information about music festivals, mixing historical 
and future events. Although the target audience is located in Antwerp (Belgium), 
the data itself should be international and represent a broad spectrum of cases. 
Finally, this requirement must be strictly respected: 
“Let op: in de insert statements gebruik je GEEN HARDCODED ID’s; alle ID’s worden opgezocht via een subselect op 
attributen waartoe de gebruiker toegang heeft.”
```

## Attached

```SQL
    -- S1
CREATE TABLE Company
(
    Company_ID            NUMBER GENERATED ALWAYS AS IDENTITY,
    Company_Name          VARCHAR2(50 CHAR) NOT NULL,
    Company_Founding_Year NUMBER(4),
    CONSTRAINT Company_PK PRIMARY KEY (Company_ID)
);

CREATE TABLE City
(
    City_ID NUMBER GENERATED ALWAYS AS IDENTITY,
    Zipcode VARCHAR2(10 CHAR),
    City    VARCHAR2(50 CHAR),
    Country VARCHAR2(50 CHAR),
    CONSTRAINT City_PK PRIMARY KEY (City_ID)
);

CREATE TABLE Visitor
(
    Visitor_ID        NUMBER GENERATED ALWAYS AS IDENTITY,
    Visitor_Firstname VARCHAR2(50 CHAR),
    Visitor_Lastname  VARCHAR2(50 CHAR),
    Visitor_Birthdate DATE,
    Visitor_Email     VARCHAR2(100 CHAR),
    Visitor_Street_Name   VARCHAR2(50 CHAR),
    Visitor_Street_Number VARCHAR2(10 CHAR),
    City_ID           NUMBER,
    Visitor_Gender    VARCHAR2(10 CHAR),
    CONSTRAINT Visitor_PK PRIMARY KEY (Visitor_ID),
    CONSTRAINT Visitor_City_FK FOREIGN KEY (City_ID) REFERENCES City (City_ID)
);

CREATE TABLE TicketPlatform
(
    TicketPlatform_ID   NUMBER GENERATED ALWAYS AS IDENTITY,
    TicketPlatform_Name VARCHAR2(100 CHAR),
    TicketPlatform_URL  VARCHAR2(500 CHAR),
    CONSTRAINT TicketPlatform_PK PRIMARY KEY (TicketPlatform_ID)
);

CREATE TABLE Permit
(
    Permit_ID               NUMBER GENERATED ALWAYS AS IDENTITY,
    Permit_Category         VARCHAR2(50 CHAR),
    Permit_Description      VARCHAR2(100 CHAR),
    Permit_Reception_Date   DATE,
    Permit_Expiration_Date  DATE,
    Permit_Application_Date DATE,
    Festival_ID             NUMBER,
    CONSTRAINT Permit_PK PRIMARY KEY (Permit_ID),
    CONSTRAINT Permit_ReceptExpire_chk CHECK (Permit_Reception_Date < Permit_Expiration_Date),
    CONSTRAINT Permit_ApplyRecept_chk CHECK (Permit_Application_Date < Permit_Reception_Date)
);

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
    CONSTRAINT Ticket_PK PRIMARY KEY (Ticket_ID),
    CONSTRAINT Ticket_Price_chk CHECK (Ticket_Price > 0),
    CONSTRAINT Ticket_Barcode_chk CHECK (LENGTH(Ticket_Barcode) BETWEEN 8 AND 14),
    CONSTRAINT Ticket_Currency_chk CHECK (REGEXP_LIKE(Ticket_Currency, '^[A-Z]{3}$')),
    CONSTRAINT Ticket_VisitFestPlatform_UQ UNIQUE (Visitor_ID, Festival_ID, TicketPlatform_ID),
    CONSTRAINT Ticket_Visitor_FK FOREIGN KEY (Visitor_ID) REFERENCES Visitor (Visitor_ID),
    CONSTRAINT Ticket_TicketPlatform_FK FOREIGN KEY (TicketPlatform_ID) REFERENCES TicketPlatform (TicketPlatform_ID)
);

-- Shared
CREATE TABLE Festival
(
    Festival_ID           NUMBER GENERATED ALWAYS AS IDENTITY,
    Festival_Name         VARCHAR2(200 CHAR) NOT NULL,
    Company_ID            NUMBER,
    Festival_StartDate    DATE,
    Festival_EndDate      DATE,
    Festival_Location     VARCHAR2(200 CHAR),
    City_ID               NUMBER,
    Festival_Opening_Hour DATE,
    Festival_Closing_Hour DATE,
    Festival_Capacity     NUMBER(7),
    CONSTRAINT Festival_PK PRIMARY KEY (Festival_ID),
    CONSTRAINT Festival_Dates_chk CHECK (Festival_EndDate > Festival_StartDate),
    CONSTRAINT Festival_Hours_chk CHECK (Festival_Closing_Hour > Festival_Opening_Hour),
    CONSTRAINT Festival_Cap_chk CHECK (Festival_Capacity > 0),
    CONSTRAINT Festival_Company_Festival_FK FOREIGN KEY (Company_ID) REFERENCES Company (Company_ID),
    CONSTRAINT Festival_City_FK FOREIGN KEY (City_ID) REFERENCES City (City_ID)
);

ALTER TABLE Permit
    ADD CONSTRAINT Festival_Permit_FK
        FOREIGN KEY (Festival_ID) REFERENCES Festival (Festival_ID);

ALTER TABLE Ticket
    ADD CONSTRAINT Ticket_Festival_FK
        FOREIGN KEY (Festival_ID) REFERENCES Festival (Festival_ID);

-- S2
CREATE TABLE Genre
(
    Genre_ID              NUMBER GENERATED ALWAYS AS IDENTITY,
    Genre_Name            VARCHAR2(20 CHAR) NOT NULL,
    Genre_Origin_Year     NUMBER(4),
    Genre_Origin_Location VARCHAR2(100 CHAR),
    Genre_BPM             NUMBER(3),
    CONSTRAINT Genre_PK PRIMARY KEY (Genre_ID),
    CONSTRAINT Genre_BPM_chk CHECK (Genre_BPM >= 0)
);

CREATE TABLE Artist
(
    Artist_ID             NUMBER GENERATED ALWAYS AS IDENTITY,
    Artist_Name           VARCHAR2(50 CHAR) NOT NULL,
    Artist_Birthday       DATE              NOT NULL,
    Artist_Price          NUMBER(12),
    Artist_Price_Currency CHAR(3),
    Artist_Land_Of_Birth  VARCHAR2(50 CHAR),
    CONSTRAINT Artist_PK PRIMARY KEY (Artist_ID),
    CONSTRAINT Artist_Price_chk CHECK (Artist_Price >= 0),
    CONSTRAINT Artist_Land_chk CHECK (LENGTH(TRIM(Artist_Land_Of_Birth)) >= 4),
    CONSTRAINT Artist_Currency_chk CHECK (REGEXP_LIKE(Artist_Price_Currency, '^[A-Z]{3}$'))
);

CREATE TABLE Stage
(
    Stage_ID                NUMBER GENERATED ALWAYS AS IDENTITY,
    Stage_Name              VARCHAR2(20 CHAR) NOT NULL,
    Festival_ID             NUMBER            NOT NULL,
    Stage_Style_Description VARCHAR2(100 CHAR),
    Stage_Standing_Capacity NUMBER(10),
    Stage_Toilet_Count      NUMBER(5),
    Stage_Description       VARCHAR2(100 CHAR),
    Stage_Roofed_Status     NUMBER(1),
    CONSTRAINT Stage_PK PRIMARY KEY (Stage_ID),
    CONSTRAINT Stage_Capac_chk CHECK (Stage_Standing_Capacity >= 0),
    CONSTRAINT Stage_Toilet_chk CHECK (Stage_Toilet_Count >= 0),
    CONSTRAINT Stage_Roofed_chk CHECK (Stage_Roofed_Status IN (0, 1)),
    CONSTRAINT Stage_Festival_Name_UQ UNIQUE (Festival_ID, Stage_Name),
    CONSTRAINT Stage_Festival_FK FOREIGN KEY (Festival_ID) REFERENCES Festival (Festival_ID)
);

CREATE TABLE Performance
(
    Performance_ID          NUMBER GENERATED ALWAYS AS IDENTITY,
    Performance_Start_Time  DATE,
    Artist_ID               NUMBER NOT NULL,
    Performance_End_Time    DATE,
    Performance_Description VARCHAR2(100 CHAR),
    Genre_ID                NUMBER NOT NULL,
    Stage_ID                NUMBER NOT NULL,
    CONSTRAINT Performance_PK PRIMARY KEY (Performance_ID),
    CONSTRAINT Performance_Times_chk CHECK (Performance_End_Time > Performance_Start_Time),
    CONSTRAINT Performance_Stage_FK FOREIGN KEY (Stage_ID) REFERENCES Stage (Stage_ID),
    CONSTRAINT Performance_Artist_FK FOREIGN KEY (Artist_ID) REFERENCES Artist (Artist_ID),
    CONSTRAINT Performance_Genre_FK FOREIGN KEY (Genre_ID) REFERENCES Genre (Genre_ID)
);
```

# Output

```
Now let me generate all the CSV files with realistic, constraint-respecting data:
Everything works perfectly. Let me present all the files:
Here's everything you need — 11 CSV files (50 rows each
All constraints respected: Permit_Application_Date < Reception_Date < Expiration_Date, Festival_EndDate > StartDate, Closing_Hour > Opening_Hour, Ticket_Price > 0, barcode lengths 8–14, ISO currency codes, etc.
Broad temporal spectrum: past events (2023–2024), ongoing/recent (2025), and future (2026)
International data spanning Belgium, Netherlands, UK, Germany, Spain, USA, Japan, Brazil, India, Iceland and more, with Belgian/Antwerp visitors well represented as the target audience
```

## Attached

- [Artist.csv](Artist.csv)
- [City.csv](City.csv)
- [Company.csv](Company.csv)
- [Festival.csv](Festival.csv)
- [Genre.csv](Genre.csv)
- [Performance.csv](Performance.csv)
- [Permit.csv](Permit.csv)
- [Stage.csv](Stage.csv)
- [Ticket.csv](Ticket.csv)
- [TicketPlatform.csv](TicketPlatform.csv)
- [Visitor.csv](Visitor.csv)

# Input

```
Generate a CSV file with 10 records for every table in this database. 
Each CSV must respect all table constraints and cover all relevant cardinality combinations. 
The dataset should contain realistic, domain‑appropriate information about music festivals, mixing historical 
and future events. Although the target audience is located in Antwerp (Belgium), 
the data itself should be international and represent a broad spectrum of cases. 
Finally, this requirement must be strictly respected: 
“Let op: in de insert statements gebruik je GEEN HARDCODED ID’s; alle ID’s worden opgezocht via een subselect op 
attributen waartoe de gebruiker toegang heeft.”
```

## Attached
```SQL
    -- S1
    CREATE TABLE Company
    (
        Company_ID            NUMBER GENERATED ALWAYS AS IDENTITY,
        Company_Name          VARCHAR2(50 CHAR) NOT NULL,
        Company_Founding_Year NUMBER(4),
        CONSTRAINT Company_PK PRIMARY KEY (Company_ID)
    );
    
    CREATE TABLE City
    (
        City_ID NUMBER GENERATED ALWAYS AS IDENTITY,
        Zipcode VARCHAR2(10 CHAR),
        City    VARCHAR2(50 CHAR),
        Country VARCHAR2(50 CHAR),
        CONSTRAINT City_PK PRIMARY KEY (City_ID)
    );
    
    CREATE TABLE Visitor
    (
        Visitor_ID        NUMBER GENERATED ALWAYS AS IDENTITY,
        Visitor_Firstname VARCHAR2(50 CHAR),
        Visitor_Lastname  VARCHAR2(50 CHAR),
        Visitor_Birthdate DATE,
        Visitor_Email     VARCHAR2(100 CHAR),
        Visitor_Street_Name   VARCHAR2(50 CHAR),
        Visitor_Street_Number VARCHAR2(10 CHAR),
        City_ID           NUMBER,
        Visitor_Gender    VARCHAR2(10 CHAR),
        CONSTRAINT Visitor_PK PRIMARY KEY (Visitor_ID),
        CONSTRAINT Visitor_City_FK FOREIGN KEY (City_ID) REFERENCES City (City_ID)
    );
    
    CREATE TABLE TicketPlatform
    (
        TicketPlatform_ID   NUMBER GENERATED ALWAYS AS IDENTITY,
        TicketPlatform_Name VARCHAR2(100 CHAR),
        TicketPlatform_URL  VARCHAR2(500 CHAR),
        CONSTRAINT TicketPlatform_PK PRIMARY KEY (TicketPlatform_ID)
    );
    
    CREATE TABLE Permit
    (
        Permit_ID               NUMBER GENERATED ALWAYS AS IDENTITY,
        Permit_Category         VARCHAR2(50 CHAR),
        Permit_Description      VARCHAR2(100 CHAR),
        Permit_Reception_Date   DATE,
        Permit_Expiration_Date  DATE,
        Permit_Application_Date DATE,
        Festival_ID             NUMBER,
        CONSTRAINT Permit_PK PRIMARY KEY (Permit_ID),
        CONSTRAINT Permit_ReceptExpire_chk CHECK (Permit_Reception_Date < Permit_Expiration_Date),
        CONSTRAINT Permit_ApplyRecept_chk CHECK (Permit_Application_Date < Permit_Reception_Date)
    );
    
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
        CONSTRAINT Ticket_PK PRIMARY KEY (Ticket_ID),
        CONSTRAINT Ticket_Price_chk CHECK (Ticket_Price > 0),
        CONSTRAINT Ticket_Barcode_chk CHECK (LENGTH(Ticket_Barcode) BETWEEN 8 AND 14),
        CONSTRAINT Ticket_Currency_chk CHECK (REGEXP_LIKE(Ticket_Currency, '^[A-Z]{3}$')),
        CONSTRAINT Ticket_VisitFestPlatform_UQ UNIQUE (Visitor_ID, Festival_ID, TicketPlatform_ID),
        CONSTRAINT Ticket_Visitor_FK FOREIGN KEY (Visitor_ID) REFERENCES Visitor (Visitor_ID),
        CONSTRAINT Ticket_TicketPlatform_FK FOREIGN KEY (TicketPlatform_ID) REFERENCES TicketPlatform (TicketPlatform_ID)
    );
    
    -- Shared
    CREATE TABLE Festival
    (
        Festival_ID           NUMBER GENERATED ALWAYS AS IDENTITY,
        Festival_Name         VARCHAR2(200 CHAR) NOT NULL,
        Company_ID            NUMBER,
        Festival_StartDate    DATE,
        Festival_EndDate      DATE,
        Festival_Location     VARCHAR2(200 CHAR),
        City_ID               NUMBER,
        Festival_Opening_Hour DATE,
        Festival_Closing_Hour DATE,
        Festival_Capacity     NUMBER(7),
        CONSTRAINT Festival_PK PRIMARY KEY (Festival_ID),
        CONSTRAINT Festival_Dates_chk CHECK (Festival_EndDate > Festival_StartDate),
        CONSTRAINT Festival_Hours_chk CHECK (Festival_Closing_Hour > Festival_Opening_Hour),
        CONSTRAINT Festival_Cap_chk CHECK (Festival_Capacity > 0),
        CONSTRAINT Festival_Company_Festival_FK FOREIGN KEY (Company_ID) REFERENCES Company (Company_ID),
        CONSTRAINT Festival_City_FK FOREIGN KEY (City_ID) REFERENCES City (City_ID)
    );
    
    ALTER TABLE Permit
        ADD CONSTRAINT Festival_Permit_FK
            FOREIGN KEY (Festival_ID) REFERENCES Festival (Festival_ID);
    
    ALTER TABLE Ticket
        ADD CONSTRAINT Ticket_Festival_FK
            FOREIGN KEY (Festival_ID) REFERENCES Festival (Festival_ID);
    
    -- S2
    CREATE TABLE Genre
    (
        Genre_ID              NUMBER GENERATED ALWAYS AS IDENTITY,
        Genre_Name            VARCHAR2(20 CHAR) NOT NULL,
        Genre_Origin_Year     NUMBER(4),
        Genre_Origin_Location VARCHAR2(100 CHAR),
        Genre_BPM             NUMBER(3),
        CONSTRAINT Genre_PK PRIMARY KEY (Genre_ID),
        CONSTRAINT Genre_BPM_chk CHECK (Genre_BPM >= 0)
    );
    
    CREATE TABLE Artist
    (
        Artist_ID             NUMBER GENERATED ALWAYS AS IDENTITY,
        Artist_Name           VARCHAR2(50 CHAR) NOT NULL,
        Artist_Birthday       DATE              NOT NULL,
        Artist_Price          NUMBER(12),
        Artist_Price_Currency CHAR(3),
        Artist_Land_Of_Birth  VARCHAR2(50 CHAR),
        CONSTRAINT Artist_PK PRIMARY KEY (Artist_ID),
        CONSTRAINT Artist_Price_chk CHECK (Artist_Price >= 0),
        CONSTRAINT Artist_Land_chk CHECK (LENGTH(TRIM(Artist_Land_Of_Birth)) >= 4),
        CONSTRAINT Artist_Currency_chk CHECK (REGEXP_LIKE(Artist_Price_Currency, '^[A-Z]{3}$'))
    );
    
    CREATE TABLE Stage
    (
        Stage_ID                NUMBER GENERATED ALWAYS AS IDENTITY,
        Stage_Name              VARCHAR2(20 CHAR) NOT NULL,
        Festival_ID             NUMBER            NOT NULL,
        Stage_Style_Description VARCHAR2(100 CHAR),
        Stage_Standing_Capacity NUMBER(10),
        Stage_Toilet_Count      NUMBER(5),
        Stage_Description       VARCHAR2(100 CHAR),
        Stage_Roofed_Status     NUMBER(1),
        CONSTRAINT Stage_PK PRIMARY KEY (Stage_ID),
        CONSTRAINT Stage_Capac_chk CHECK (Stage_Standing_Capacity >= 0),
        CONSTRAINT Stage_Toilet_chk CHECK (Stage_Toilet_Count >= 0),
        CONSTRAINT Stage_Roofed_chk CHECK (Stage_Roofed_Status IN (0, 1)),
        CONSTRAINT Stage_Festival_Name_UQ UNIQUE (Festival_ID, Stage_Name),
        CONSTRAINT Stage_Festival_FK FOREIGN KEY (Festival_ID) REFERENCES Festival (Festival_ID)
    );
    
    CREATE TABLE Performance
    (
        Performance_ID          NUMBER GENERATED ALWAYS AS IDENTITY,
        Performance_Start_Time  DATE,
        Artist_ID               NUMBER NOT NULL,
        Performance_End_Time    DATE,
        Performance_Description VARCHAR2(100 CHAR),
        Genre_ID                NUMBER NOT NULL,
        Stage_ID                NUMBER NOT NULL,
        CONSTRAINT Performance_PK PRIMARY KEY (Performance_ID),
        CONSTRAINT Performance_Times_chk CHECK (Performance_End_Time > Performance_Start_Time),
        CONSTRAINT Performance_Stage_FK FOREIGN KEY (Stage_ID) REFERENCES Stage (Stage_ID),
        CONSTRAINT Performance_Artist_FK FOREIGN KEY (Artist_ID) REFERENCES Artist (Artist_ID),
        CONSTRAINT Performance_Genre_FK FOREIGN KEY (Genre_ID) REFERENCES Genre (Genre_ID)
    );
```

# Output

```
Now I'll generate all the CSV files with realistic festival data, and then a SQL insert script using subselects (no hardcoded IDs).
Here's a summary of everything generated — 11 CSV files (10 rows each)
Key design decisions:

No hardcoded IDs anywhere in the SQL script. Every FK is resolved with a subselect on a natural key, e.g.:

(SELECT Festival_ID FROM Festival WHERE Festival_Name = 'Tomorrowland Summer 2024')
(SELECT Stage_ID FROM Stage WHERE Stage_Name = 'Mainstage' AND Festival_ID = (SELECT ...))
(SELECT Visitor_ID FROM Visitor WHERE Visitor_Email = '...')


All constraints respected:

Ticket_Barcode lengths are 14 chars ✓
Ticket_Currency / Artist_Price_Currency match ^[A-Z]{3}$ ✓
Permit date chain: Application < Reception < Expiration ✓
Festival_Opening_Hour < Festival_Closing_Hour — closing hours use + 1 (next day) where needed ✓
Ticket_VisitFestPlatform_UQ — each visitor/festival/platform combination is unique ✓
Stage_Festival_Name_UQ — stage names are unique per festival ✓


Data variety: mix of past (2024) and future (2025) events, 8 countries, 3 currencies (EUR/GBP/USD), covered and open-air stages, all ticket types and statuses.
```

## Attached

- [Artist.csv](Artist.csv)
- [City.csv](City.csv)
- [Company.csv](Company.csv)
- [Festival.csv](Festival.csv)
- [Genre.csv](Genre.csv)
- [Performance.csv](Performance.csv)
- [Permit.csv](Permit.csv)
- [Stage.csv](Stage.csv)
- [Ticket.csv](Ticket.csv)
- [TicketPlatform.csv](TicketPlatform.csv)
- [Visitor.csv](Visitor.csv)
