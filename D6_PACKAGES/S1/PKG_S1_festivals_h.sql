CREATE OR REPLACE PACKAGE PKG_S1_festivals AS
    -- PUBLIC: Empty all S1 tables
    -- (Performance, Stage, Genre, Artist, Festival
    PROCEDURE empty_tables_S1;

    -- PUBLIC: Fill all S1 tables with sample data
    -- (Festival, Genre, Artist, Stage, Performance)
    PROCEDURE bewijs_M4_S1;

    -- PUBLIC lookup:
    FUNCTION lookup_company_id(p_company_name IN VARCHAR2) RETURN NUMBER;

    FUNCTION lookup_city_id(p_zipcode IN VARCHAR2, p_country IN VARCHAR2) RETURN NUMBER;

END PKG_S1_festivals;
/