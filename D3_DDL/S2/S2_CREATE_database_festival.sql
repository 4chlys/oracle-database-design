-- Simple drops (rerunnable: first run may show ORA-00942 if table does not yet exist)
DROP TABLE Performance CASCADE CONSTRAINTS PURGE;
DROP TABLE Stage CASCADE CONSTRAINTS PURGE;
DROP TABLE Artist CASCADE CONSTRAINTS PURGE;
DROP TABLE Genre CASCADE CONSTRAINTS PURGE;
DROP TABLE Festival CASCADE CONSTRAINTS PURGE;

-- Shared Table - required for S2 foreign keys
CREATE TABLE Festival (
    Festival_ID             NUMBER GENERATED ALWAYS AS IDENTITY,
    Festival_Name           VARCHAR2(50 CHAR) NOT NULL,
    Company_ID              NUMBER,
    Festival_StartDate      DATE,
    Festival_EndDate        DATE,
    Festival_Location       VARCHAR2(50 CHAR) NOT NULL,
    City_ID                 NUMBER NOT NULL,
    Festival_Opening_Hour   DATE,
    Festival_Closing_Hour   DATE,
    Festival_Capacity       NUMBER(9),
    CONSTRAINT Festival_PK PRIMARY KEY (Festival_ID),
    CONSTRAINT Festival_Dates_chk CHECK (Festival_EndDate > Festival_StartDate),
    CONSTRAINT Festival_Hours_chk CHECK (Festival_Closing_Hour > Festival_Opening_Hour),
    CONSTRAINT Festival_Cap_chk CHECK (Festival_Capacity > 0)
);

-- S2 Tables
CREATE TABLE Genre (
    Genre_ID               NUMBER GENERATED ALWAYS AS IDENTITY,
    Genre_Name             VARCHAR2(20 CHAR) NOT NULL,
    Genre_Origin_Year      NUMBER(4),
    Genre_Origin_Location  VARCHAR2(100 CHAR),
    Genre_BPM              NUMBER(3),
    CONSTRAINT Genre_PK PRIMARY KEY (Genre_ID),
    CONSTRAINT Genre_BPM_chk CHECK (Genre_BPM >= 0)
);

CREATE TABLE Artist (
    Artist_ID                NUMBER GENERATED ALWAYS AS IDENTITY,
    Artist_Name              VARCHAR2(50 CHAR) NOT NULL,
    Artist_Birthday          DATE NOT NULL,
    Artist_Price             NUMBER(12),
    Artist_Price_Currency    CHAR(3),
    Artist_Land_Of_Birth     VARCHAR2(50 CHAR),
    CONSTRAINT Artist_PK PRIMARY KEY (Artist_ID),
    CONSTRAINT Artist_Price_chk CHECK (Artist_Price >= 0), 
    CONSTRAINT Artist_Land_chk CHECK (LENGTH(TRIM(Artist_Land_Of_Birth)) >= 4),
    CONSTRAINT Artist_Currency_chk CHECK (REGEXP_LIKE(Artist_Price_Currency, '^[A-Z]{3}$'))
);

CREATE TABLE Stage (
    Stage_ID                  NUMBER GENERATED ALWAYS AS IDENTITY,
    Stage_Name                VARCHAR2(20 CHAR) NOT NULL,
    Festival_ID               NUMBER NOT NULL,
    Stage_Style_Description   VARCHAR2(100 CHAR),
    Stage_Standing_Capacity   NUMBER(10),
    Stage_Toilet_Count        NUMBER(5),
    Stage_Description         VARCHAR2(100 CHAR),
    Stage_Roofed_Status       NUMBER(1),
    CONSTRAINT Stage_PK PRIMARY KEY (Stage_ID),
    CONSTRAINT Stage_Capac_chk CHECK (Stage_Standing_Capacity >= 0),
    CONSTRAINT Stage_Toilet_chk CHECK (Stage_Toilet_Count >= 0),
    CONSTRAINT Stage_Roofed_chk CHECK (Stage_Roofed_Status IN (0,1)),
    CONSTRAINT Stage_Festival_Name_UQ UNIQUE (Festival_ID, Stage_Name),
    CONSTRAINT Stage_Festival_FK FOREIGN KEY (Festival_ID) REFERENCES Festival (Festival_ID)
);

CREATE TABLE Performance (
    Performance_ID            NUMBER GENERATED ALWAYS AS IDENTITY,
    Performance_Start_Time    DATE,
    Artist_ID                 NUMBER NOT NULL,
    Performance_End_Time      DATE,
    Performance_Description   VARCHAR2(100 CHAR),
    Genre_ID                  NUMBER NOT NULL,
    Stage_ID                  NUMBER NOT NULL,
    CONSTRAINT Performance_PK PRIMARY KEY (Performance_ID),
    CONSTRAINT Performance_Times_chk CHECK (Performance_End_Time > Performance_Start_Time),
    CONSTRAINT Performance_Stage_FK FOREIGN KEY (Stage_ID) REFERENCES Stage (Stage_ID),
    CONSTRAINT Performance_Artist_FK FOREIGN KEY (Artist_ID) REFERENCES Artist (Artist_ID),
    CONSTRAINT Performance_Genre_FK FOREIGN KEY (Genre_ID) REFERENCES Genre (Genre_ID)
);
