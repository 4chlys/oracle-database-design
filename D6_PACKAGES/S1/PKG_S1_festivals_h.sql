CREATE OR REPLACE PACKAGE PKG_S1_festivals AS
    -- PUBLIC EMPTY (split into phases because of cross-schema FK:
    --   FESTIVAL (S2) -> COMPANY (S1)  and  TICKET/PERMIT (S1) -> FESTIVAL (S2))
    PROCEDURE empty_s1_children;          -- TICKET, PERMIT (must run before empty_tables_S2)
    PROCEDURE empty_s1_base;              -- TICKETPLATFORM, VISITOR, COMPANY, CITY (must run after empty_tables_S2)
    PROCEDURE empty_tables_S1;            -- convenience wrapper (only safe when S2 already empty)

    -- PUBLIC FILL (split into phases because COMPANY must exist before FESTIVAL,
    --   and FESTIVAL must exist before TICKET/PERMIT)
    PROCEDURE fill_s1_base;               -- COMPANY, CITY, VISITOR, TICKETPLATFORM
    PROCEDURE fill_s1_children;           -- PERMIT, TICKET (requires FESTIVAL to exist)
    PROCEDURE bewijs_M4_S1;               -- fill_s1_base + fill_s1_children (no empty; SAMEN handles ordering)

    -- PUBLIC LOOKUPS (used by other packages)
    FUNCTION lookup_company_id(p_company_name IN COMPANY.COMPANY_NAME%type) RETURN COMPANY.COMPANY_ID%type;
    FUNCTION lookup_city_id(p_zipcode IN CITY.ZIPCODE%type,
                            p_country IN CITY.COUNTRY%type) RETURN CITY.CITY_ID%type;

END PKG_S1_festivals;
/
