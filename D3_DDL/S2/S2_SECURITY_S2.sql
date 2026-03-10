-- S2 SECURITY - Music Festival Database
-- Student: Jonas Friedhoff
-- Creates a dedicated user with appropriate privileges
-- for the S2 portion of the schema.
-- Run as: ADMIN / main schema owner

-- Drop user if it already exists (rerunnable)
-- Note: first run may raise ORA-01918 if user does not yet exist
BEGIN
    EXECUTE IMMEDIATE 'DROP USER festival_s2_user CASCADE';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- Create user
CREATE USER festival_s2_user IDENTIFIED BY "REDACTED";

-- Allow the user to connect
GRANT CREATE SESSION TO festival_s2_user;

-- S2-owned tables: full DML rights
GRANT SELECT, INSERT, UPDATE, DELETE ON Genre       TO festival_s2_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON Artist      TO festival_s2_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON Stage       TO festival_s2_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON Performance TO festival_s2_user;


-- Shared table (Festival): read-only
-- S2 needs Festival_ID for foreign keys in Stage,
-- but should not be able to modify festivals.

GRANT SELECT ON Festival TO festival_s2_user;

-- S1-owned tables: NO access granted
-- (Company, City, Visitor, TicketPlatform, Permit, Ticket
--  remain invisible to festival_s2_user)