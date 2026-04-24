CREATE OR REPLACE PACKAGE PKG_S1_festivals AS
    -- PUBLIC EMPTY (split into phases because of cross-schema FK:
    --   FESTIVAL (S2) -> COMPANY (S1)  and  TICKET/PERMIT (S1) -> FESTIVAL (S2))
    PROCEDURE empty_s1_children; -- TICKET, PERMIT (must run before empty_tables_S2)
    PROCEDURE empty_s1_base; -- TICKETPLATFORM, VISITOR, COMPANY, CITY (must run after empty_tables_S2)
    PROCEDURE empty_tables_S1; -- convenience wrapper (only safe when S2 already empty)

    -- PUBLIC FILL (split into phases because COMPANY must exist before FESTIVAL,
    --   and FESTIVAL must exist before TICKET/PERMIT)
    PROCEDURE fill_s1_base; -- COMPANY, CITY, VISITOR, TICKETPLATFORM
    PROCEDURE fill_s1_children; -- PERMIT, TICKET (requires FESTIVAL to exist)
    PROCEDURE bewijs_M4_S1; -- fill_s1_base + fill_s1_children (no empty; SAMEN handles ordering)

    -- PUBLIC LOOKUPS (used by other packages)
    FUNCTION lookup_company_id(p_company_name IN COMPANY.COMPANY_NAME%type) RETURN COMPANY.COMPANY_ID%type;
    FUNCTION lookup_city_id(p_zipcode IN CITY.ZIPCODE%type,
                            p_country IN CITY.COUNTRY%type) RETURN CITY.CITY_ID%type;

    -- M5: Random generators (Stap 2)
    PROCEDURE generateRandomCities(p_amount IN NUMBER);
    PROCEDURE generateRandomCompanies(p_amount IN NUMBER);
    PROCEDURE generateRandomTicketplatforms(p_amount IN NUMBER);
    PROCEDURE generateRandomVisitors(p_amount IN NUMBER);
    PROCEDURE generateRandomTickets(p_amount IN NUMBER);
    PROCEDURE generateRandomPermits(p_per_festival IN NUMBER);
    -- Phase split mirrors M4 fill_s1_base / fill_s1_children:
    --   bewijs_milestone_5_S1_base     must run BEFORE bewijs_milestone_5_S2 (S2 needs companies)
    --   bewijs_milestone_5_S1_children must run AFTER  bewijs_milestone_5_S2 (tickets/permits need festivals)
    --   bewijs_milestone_5_S1          convenience wrapper – only safe when S2 festivals already exist
    --   SAMEN script orchestrates: S1_base → S2 → S1_children
    PROCEDURE bewijs_milestone_5_S1_base(p_cities IN NUMBER,
                                         p_companies IN NUMBER,
                                         p_platforms IN NUMBER,
                                         p_visitors IN NUMBER);

    PROCEDURE bewijs_milestone_5_S1_children(p_tickets IN NUMBER,
                                             p_permits_per_fest IN NUMBER);

    PROCEDURE bewijs_milestone_5_S1(p_cities IN NUMBER,
                                    p_companies IN NUMBER,
                                    p_platforms IN NUMBER,
                                    p_visitors IN NUMBER,
                                    p_tickets IN NUMBER,
                                    p_permits_per_fest IN NUMBER);

END PKG_S1_festivals;
/
