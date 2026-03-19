/****************************************************************************************************
 * ★★★★★ IMPORTANT WARNING ★★★★★
 * PLEASE REVIEW AND UPDATE ALL USERS, ROLES, AND PATHS ACCORDING TO YOUR ENVIRONMENT.
 * This sample script is provided as a template. BEFORE EXECUTION, ensure that you modify the
 * user names, role definitions, and passwords to match your specific requirements and
 * security policies.
 ****************************************************************************************************/
-- Note: Replace <replace-with-user> and <replace-with-user-password> with your database connect user and password

--------------------------------------------------------------
-- 1. INFRASTRUCTURE: TABLESPACE CREATION
-- Optimized for RDS: Uses Oracle Managed Files (OMF)
--------------------------------------------------------------
CREATE TABLESPACE ICMLFQ32 DATAFILE SIZE 300M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED;
CREATE TABLESPACE ICMLNF32 DATAFILE SIZE 25M  AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED;
CREATE TABLESPACE ICMVFQ04 DATAFILE SIZE 25M  AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED;
CREATE TABLESPACE ICMSFQ04 DATAFILE SIZE 150M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED;
CREATE TABLESPACE ICMLSNDX DATAFILE SIZE 10M  AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED;

--------------------------------------------------------------
-- 2. DOMAIN OWNERS: SCHEMA CREATION
--------------------------------------------------------------
CREATE USER release       IDENTIFIED BY <replace-with-user-password> DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP;
CREATE USER community     IDENTIFIED BY <replace-with-user-password> DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP;
CREATE USER customization IDENTIFIED BY <replace-with-user-password> DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP;
CREATE USER jcr           IDENTIFIED BY <replace-with-user-password> DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP;
CREATE USER feedback      IDENTIFIED BY <replace-with-user-password> DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP;
CREATE USER likeminds     IDENTIFIED BY <replace-with-user-password> DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP;

-- RESOURCE role allows owners to manage objects in their OWN schema
GRANT CREATE SESSION, RESOURCE, UNLIMITED TABLESPACE TO 
    release, community, customization, jcr, feedback, likeminds;

--------------------------------------------------------------
-- 3. SERVICE USER & ROLE DEFINITIONS (DX CORE ALIGNMENT)
--------------------------------------------------------------
-- The single login identity for the WebEngine application
CREATE USER <replace-with-user> IDENTIFIED BY <replace-with-user-password> DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP;
GRANT CREATE SESSION TO <replace-with-user>;

-- Define Legacy-Aligned Roles
CREATE ROLE WP_BASE_CONFIG_USERS NOT IDENTIFIED;
CREATE ROLE WP_BASE_RUNTIME_USERS NOT IDENTIFIED;
CREATE ROLE WP_JCR_CONFIG_USERS NOT IDENTIFIED;
CREATE ROLE WP_JCR_RUNTIME_USERS NOT IDENTIFIED;
CREATE ROLE WP_PZN_CONFIG_USERS NOT IDENTIFIED;
CREATE ROLE WP_PZN_RUNTIME_USERS NOT IDENTIFIED;

-- Assign all Roles to the service user
GRANT WP_BASE_CONFIG_USERS, WP_BASE_RUNTIME_USERS TO <replace-with-user>;
GRANT WP_JCR_CONFIG_USERS,  WP_JCR_RUNTIME_USERS  TO <replace-with-user>;
GRANT WP_PZN_CONFIG_USERS,  WP_PZN_RUNTIME_USERS  TO <replace-with-user>;

--------------------------------------------------------------
-- 4. PERMISSION ASSIGNMENT (MINIMIZED "ANY" PRIVILEGES)
--------------------------------------------------------------
-- Config Roles: Required for the Transfer tool to create objects across schemas
-- BASE CONFIG: Release/Community/Customization
GRANT CREATE ANY TABLE, ALTER ANY TABLE, DROP ANY TABLE TO WP_BASE_CONFIG_USERS;
GRANT CREATE ANY INDEX, DROP ANY INDEX TO WP_BASE_CONFIG_USERS;
GRANT CREATE ANY SEQUENCE, DROP ANY SEQUENCE, SELECT ANY SEQUENCE TO WP_BASE_CONFIG_USERS;
GRANT CREATE ANY TRIGGER, DROP ANY TRIGGER TO WP_BASE_CONFIG_USERS;

-- JCR CONFIG: Java Content Repository (Critical for DB Transfer)
GRANT CREATE ANY TABLE, ALTER ANY TABLE, DROP ANY TABLE TO WP_JCR_CONFIG_USERS;
GRANT CREATE ANY INDEX, DROP ANY INDEX TO WP_JCR_CONFIG_USERS;
GRANT CREATE ANY SEQUENCE, DROP ANY SEQUENCE TO WP_JCR_CONFIG_USERS;
GRANT CREATE ANY TRIGGER, DROP ANY TRIGGER TO WP_JCR_CONFIG_USERS;
GRANT CREATE ANY VIEW, DROP ANY VIEW TO WP_JCR_CONFIG_USERS;
GRANT CREATE ANY TYPE, DROP ANY TYPE, EXECUTE ANY TYPE TO WP_JCR_CONFIG_USERS;
GRANT SELECT ON DBA_IND_COLUMNS TO WP_JCR_CONFIG_USERS;
GRANT SELECT ON DBA_INDEXES TO WP_JCR_CONFIG_USERS;

-- PZN CONFIG: Feedback/Likeminds
GRANT CREATE ANY TABLE, ALTER ANY TABLE, DROP ANY TABLE TO WP_PZN_CONFIG_USERS;
GRANT CREATE ANY SEQUENCE, DROP ANY SEQUENCE, SELECT ANY SEQUENCE TO WP_PZN_CONFIG_USERS;

-- RUNTIME ROLES: Application Usage
GRANT SELECT ANY TABLE, INSERT ANY TABLE, UPDATE ANY TABLE, DELETE ANY TABLE TO WP_BASE_RUNTIME_USERS;
GRANT SELECT ANY SEQUENCE, DROP ANY SEQUENCE TO WP_BASE_RUNTIME_USERS;

-- XA Transaction visibility (Liberty requirement for all domains)
GRANT SELECT ON DBA_PENDING_TRANSACTIONS TO WP_BASE_RUNTIME_USERS;
GRANT SELECT ON DBA_PENDING_TRANSACTIONS TO WP_JCR_RUNTIME_USERS;
GRANT SELECT ON DBA_PENDING_TRANSACTIONS TO WP_PZN_RUNTIME_USERS;

--------------------------------------------------------------
-- 5. JCR SYSTEM GRANTS
--------------------------------------------------------------
GRANT CREATE VIEW, CREATE TYPE TO jcr;

--------------------------------------------------------------
-- 6. VERIFICATION: CHECK TABLESPACES (OPTIONAL/COMMENTED)
--------------------------------------------------------------
/*
SELECT tablespace_name, 
       bytes/1024/1024 as "Size (MB)", 
       autoextensible, 
       increment_by * (SELECT value FROM v$parameter WHERE name = 'db_block_size') / 1024 / 1024 as "Next (MB)"
FROM dba_data_files
WHERE tablespace_name IN ('ICMLFQ32', 'ICMLNF32', 'ICMVFQ04', 'ICMSFQ04', 'ICMLSNDX');
*/
-------------------------------------------------------------- 
