BEGIN
    -- === EMPTY (interleaved because of cross-schema FKs) ===
    PKG_S1_festivals.empty_s1_children; -- TICKET, PERMIT (children of S2.FESTIVAL)
    PKG_S2_festivals.empty_tables_S2; -- PERFORMANCE, STAGE, FESTIVAL, ARTIST, GENRE
    PKG_S1_festivals.empty_s1_base;
    -- TICKETPLATFORM, VISITOR, COMPANY, CITY

    -- === FILL (interleaved: COMPANY before FESTIVAL, FESTIVAL before TICKET/PERMIT) ===
    PKG_S1_festivals.fill_s1_base; -- COMPANY, CITY, VISITOR, TICKETPLATFORM
    PKG_S2_festivals.bewijs_M4_S2; -- FESTIVAL, GENRE, ARTIST, STAGE, PERFORMANCE
    PKG_S1_festivals.fill_s1_children; -- PERMIT, TICKET
END;
/
