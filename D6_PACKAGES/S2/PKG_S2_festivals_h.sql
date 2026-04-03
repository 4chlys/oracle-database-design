CREATE OR REPLACE PACKAGE PKG_S2_festivals AS


    -- PUBLIC: Empty all S2 tables
    -- (Performance, Stage, Genre, Artist, Festival
    PROCEDURE empty_tables_S2;

    -- PUBLIC: Fill all S2 tables with sample data
    -- (Festival, Genre, Artist, Stage, Performance)
    PROCEDURE bewijs_M4_S2;

    -- PUBLIC lookup:
    FUNCTION lookup_festival_id(p_festival_name IN FESTIVAL.FESTIVAL_NAME%type) RETURN FESTIVAL.FESTIVAL_ID%type;

END PKG_S2_festivals;
/