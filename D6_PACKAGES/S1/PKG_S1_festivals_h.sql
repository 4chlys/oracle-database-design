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

    -- M6: Single-insert generators (row-by-row INSERT, for performance comparison)
    PROCEDURE generateRandomCities_single(p_amount IN NUMBER);
    PROCEDURE generateRandomCompanies_single(p_amount IN NUMBER);
    PROCEDURE generateRandomTicketplatforms_single(p_amount IN NUMBER);
    PROCEDURE generateRandomVisitors_single(p_amount IN NUMBER);
    PROCEDURE generateRandomTickets_single(p_amount IN NUMBER);
    PROCEDURE generateRandomPermits_single(p_per_festival IN NUMBER);

    -- M6: Bulk generators with chunking (arrays capped at C_BULK_CHUNK; memory-safe for 400k+)
    PROCEDURE generateRandomCities_bulk(p_amount IN NUMBER);
    PROCEDURE generateRandomCompanies_bulk(p_amount IN NUMBER);
    PROCEDURE generateRandomTicketplatforms_bulk(p_amount IN NUMBER);
    PROCEDURE generateRandomVisitors_bulk(p_amount IN NUMBER);
    PROCEDURE generateRandomTickets_bulk(p_amount IN NUMBER);
    PROCEDURE generateRandomPermits_bulk(p_per_festival IN NUMBER);

    -- M6: Phase wrappers (mirror M5's base/children split; respect S2 FK dependency)
    --   bewijs_milestone_6_S1_base_single     must run BEFORE bewijs_M6_S2 (S2 needs companies)
    --   bewijs_milestone_6_S1_base_bulk       must run BEFORE bewijs_M6_S2
    --   bewijs_milestone_6_S1_children_single must run AFTER  bewijs_M6_S2 (tickets/permits need festivals)
    --   bewijs_milestone_6_S1_children_bulk   must run AFTER  bewijs_M6_S2
    --   SAMEN script orchestrates: S1_base → S2 → S1_children  (same order as M5)
    PROCEDURE bewijs_milestone_6_S1_base_single(p_cities    IN NUMBER,
                                                p_companies IN NUMBER,
                                                p_platforms IN NUMBER,
                                                p_visitors  IN NUMBER);

    PROCEDURE bewijs_milestone_6_S1_base_bulk(p_cities    IN NUMBER,
                                              p_companies IN NUMBER,
                                              p_platforms IN NUMBER,
                                              p_visitors  IN NUMBER);

    PROCEDURE bewijs_milestone_6_S1_children_single(p_tickets          IN NUMBER,
                                                    p_permits_per_fest IN NUMBER);

    PROCEDURE bewijs_milestone_6_S1_children_bulk(p_tickets          IN NUMBER,
                                                  p_permits_per_fest IN NUMBER);

    -- M6: Proof procedure
    --   p_mode = 'BOTH' | 'BULK' | 'SINGLE'
    --   Each run: reset to M4 baseline → S1 base → S2 → S1 children
    --   S2 time excluded from S1 timing so the SINGLE vs BULK comparison is fair.
    --   Calls PKG_S2_festivals.generateRandomFestivals internally (only S2 festivals
    --   are needed as FK anchors for Ticket/Permit; genres/stages/performances excluded).
    PROCEDURE bewijs_milestone_6_S1(p_visitors         IN NUMBER,
                                    p_companies        IN NUMBER,
                                    p_platforms        IN NUMBER,
                                    p_tickets          IN NUMBER,
                                    p_permits_per_fest IN NUMBER,
                                    p_festivals        IN NUMBER,
                                    p_mode             IN VARCHAR2);

END PKG_S1_festivals;
/
