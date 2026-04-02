CREATE OR REPLACE PACKAGE PKG_S2_festival AS


    -- PUBLIC: Empty all S2 tables
    -- (Performance, Stage, Genre, Artist, Festival
    PROCEDURE empty_tables_S2;

    -- PUBLIC: Fill all S2 tables with sample data
    -- (Festival, Genre, Artist, Stage, Performance)
    PROCEDURE bewijs_M4_S2;

    -- PUBLIC lookup:
    FUNCTION lookup_festival_id(p_festival_name IN VARCHAR2) RETURN NUMBER;

END PKG_S2_festival;
/