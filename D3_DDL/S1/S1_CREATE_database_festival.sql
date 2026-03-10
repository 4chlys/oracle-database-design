-- Simple drops (rerunnable: first run may show ORA-00942 if table does not yet exist)
DROP TABLE Ticket CASCADE CONSTRAINTS PURGE;
DROP TABLE Permit CASCADE CONSTRAINTS PURGE;
DROP TABLE Festival CASCADE CONSTRAINTS PURGE;
DROP TABLE TicketPlatform CASCADE CONSTRAINTS PURGE;
DROP TABLE Visitor CASCADE CONSTRAINTS PURGE;
DROP TABLE City CASCADE CONSTRAINTS PURGE;
DROP TABLE Company CASCADE CONSTRAINTS PURGE;

-- S1 Tables
CREATE TABLE Company
(
    Company_ID            NUMBER GENERATED ALWAYS AS IDENTITY,
    Company_Name          VARCHAR2(50 CHAR) NOT NULL,
    Company_Founding_Year NUMBER(4),
    CONSTRAINT Company_PK PRIMARY KEY (Company_ID),
    CONSTRAINT Company_Name_UQ UNIQUE (Company_Name),
    CONSTRAINT Company_FoundingYear_Upper_chk CHECK (Company_Founding_Year < EXTRACT(YEAR FROM SYSDATE)),
    CONSTRAINT Company_FoundingYear_Lower_chk CHECK (Company_Founding_Year >= 1800)
);

CREATE TABLE City
(
    City_ID NUMBER GENERATED ALWAYS AS IDENTITY,
    Zipcode VARCHAR2(10 CHAR),
    City    VARCHAR2(50 CHAR),
    Country VARCHAR2(50 CHAR),
    CONSTRAINT City_PK PRIMARY KEY (City_ID),
    CONSTRAINT City_Zipcode_UQ UNIQUE (Zipcode, Country)
);

CREATE TABLE Visitor
(
    Visitor_ID            NUMBER GENERATED ALWAYS AS IDENTITY,
    Visitor_Firstname     VARCHAR2(50 CHAR),
    Visitor_Lastname      VARCHAR2(50 CHAR),
    Visitor_Birthdate     DATE,
    Visitor_Email         VARCHAR2(100 CHAR),
    Visitor_Street_Name   VARCHAR2(50 CHAR),
    Visitor_Street_Number VARCHAR2(10 CHAR),
    Visitor_City_Name     VARCHAR2(50 CHAR),
    City_ID               NUMBER,
    Visitor_Gender        VARCHAR2(10 CHAR),
    CONSTRAINT Visitor_PK PRIMARY KEY (Visitor_ID),
    CONSTRAINT Visitor_Email_UQ UNIQUE (Visitor_Email),
    CONSTRAINT Visitor_City_FK FOREIGN KEY (City_ID) REFERENCES City (City_ID),
    CONSTRAINT Visitor_Birthdate_Upper_chk CHECK (Visitor_Birthdate < SYSDATE),
    CONSTRAINT Visitor_Birthdate_Lower_chk CHECK (Visitor_Birthdate >= DATE '1900-01-01'),
    CONSTRAINT Visitor_Email_chk CHECK (REGEXP_LIKE(Visitor_Email, '^[^@]+@[^@]+\.[^@]+$')),
    CONSTRAINT Visitor_Gender_chk CHECK (Visitor_Gender IN ('Male', 'Female', 'Other', 'Prefer not to say'))
);

CREATE TABLE TicketPlatform
(
    TicketPlatform_ID   NUMBER GENERATED ALWAYS AS IDENTITY,
    TicketPlatform_Name VARCHAR2(100 CHAR),
    TicketPlatform_URL  VARCHAR2(500 CHAR),
    CONSTRAINT TicketPlatform_PK PRIMARY KEY (TicketPlatform_ID),
    CONSTRAINT TicketPlatform_Name_UQ UNIQUE (TicketPlatform_Name),
    CONSTRAINT TicketPlatform_URL_UQ UNIQUE (TicketPlatform_URL)
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
    CONSTRAINT Permit_ApplyRecept_chk CHECK (Permit_Application_Date < Permit_Reception_Date),
    CONSTRAINT Permit_ApplicationDate_chk CHECK (Permit_Application_Date <= SYSDATE)
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
    CONSTRAINT Ticket_Barcode_UQ UNIQUE (Ticket_Barcode),
    CONSTRAINT Ticket_VisitFestPlatform_UQ UNIQUE (Visitor_ID, Festival_ID, Ticket_Date),
    CONSTRAINT Ticket_Visitor_FK FOREIGN KEY (Visitor_ID) REFERENCES Visitor (Visitor_ID),
    CONSTRAINT Ticket_TicketPlatform_FK FOREIGN KEY (TicketPlatform_ID) REFERENCES TicketPlatform (TicketPlatform_ID),
    CONSTRAINT Ticket_Price_chk CHECK (Ticket_Price > 0),
    CONSTRAINT Ticket_Barcode_chk CHECK (LENGTH(Ticket_Barcode) BETWEEN 8 AND 14),
    CONSTRAINT Ticket_Currency_chk CHECK (REGEXP_LIKE(Ticket_Currency, '^[A-Z]{3}$')),
    CONSTRAINT Ticket_PurchaseDate_chk CHECK (Ticket_Purchase_Date <= SYSDATE),
    CONSTRAINT Ticket_Date_chk CHECK (Ticket_Purchase_Date <= Ticket_Date)
);

-- Shared Table (Festival)
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
    CONSTRAINT Festival_Company_Festival_FK FOREIGN KEY (Company_ID) REFERENCES Company (Company_ID),
    CONSTRAINT Festival_City_FK FOREIGN KEY (City_ID) REFERENCES City (City_ID),
    CONSTRAINT Festival_Dates_chk CHECK (Festival_EndDate > Festival_StartDate),
    CONSTRAINT Festival_Hours_chk CHECK (Festival_Closing_Hour > Festival_Opening_Hour),
    CONSTRAINT Festival_Cap_chk CHECK (Festival_Capacity > 0),
    CONSTRAINT Festival_StartDate_chk CHECK (Festival_StartDate >= SYSDATE)
);

-- Add Festival foreign keys after Festival table creation (circular dependency, must stay as ALTER)
ALTER TABLE Permit
    ADD CONSTRAINT Festival_Permit_FK
        FOREIGN KEY (Festival_ID) REFERENCES Festival (Festival_ID);

ALTER TABLE Ticket
    ADD CONSTRAINT Ticket_Festival_FK
        FOREIGN KEY (Festival_ID) REFERENCES Festival (Festival_ID);

select *
from Company;