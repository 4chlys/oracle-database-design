CREATE OR REPLACE PACKAGE PKG_S2_festivals AS
    -- PUBLIC: Empty all S2 tables
    -- (Performance, Stage, Genre, Artist, Festival
    PROCEDURE empty_tables_S2;

    -- PUBLIC: Fill all S2 tables with sample data
    -- (Festival, Genre, Artist, Stage, Performance)
    PROCEDURE bewijs_M4_S2;

    -- PUBLIC lookup:
    FUNCTION lookup_festival_id(p_festival_name IN FESTIVAL.FESTIVAL_NAME%type) RETURN FESTIVAL.FESTIVAL_ID%type;

    -- M5: Random generators (Stap 2 + 3)
    PROCEDURE generateRandomArtists(p_amount IN NUMBER);
    PROCEDURE generateRandomFestivals(p_amount IN NUMBER);
    PROCEDURE generateRandomStages(p_per_festival IN NUMBER);
    PROCEDURE generateRandomPerformances(p_per_stage IN NUMBER);
    PROCEDURE bewijs_M5_S2(p_festivals IN NUMBER,
                                    p_genres    IN NUMBER,
                                    p_stages    IN NUMBER,
                                    p_perfs     IN NUMBER);

END PKG_S2_festivals;
/