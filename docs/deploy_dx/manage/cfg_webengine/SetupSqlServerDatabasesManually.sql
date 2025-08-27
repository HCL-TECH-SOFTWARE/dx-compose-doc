--------------------------------------------------------------
-- WPREL DATABASE creation
--------------------------------------------------------------
CREATE DATABASE WPREL 
ON PRIMARY
(
    NAME = RELDB_DATA,
    FILENAME = '<replace-with-path>\WPREL_Data.mdf',
    SIZE = 10MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 5MB
)
LOG ON
(
    NAME = DB_LOG,
    FILENAME = '<replace-with-path>\WPREL_Log.ldf',
    SIZE = 5MB,
    MAXSIZE = 250MB,
    FILEGROWTH = 5MB
)
COLLATE SQL_Latin1_General_CP1_CS_AS;

ALTER DATABASE WPREL SET READ_COMMITTED_SNAPSHOT ON;

--------------------------------------------------------------
-- WPCOMM DATABASE creation
--------------------------------------------------------------
CREATE DATABASE WPCOMM 
ON PRIMARY
(
    NAME = RELDB_DATA,
    FILENAME = '<replace-with-path>\WPCOMM_Data.mdf',
    SIZE = 10MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 5MB
)
LOG ON
(
    NAME = DB_LOG,
    FILENAME = '<replace-with-path>\WPCOMM_Log.ldf',
    SIZE = 5MB,
    MAXSIZE = 250MB,
    FILEGROWTH = 5MB
)
COLLATE SQL_Latin1_General_CP1_CS_AS;

ALTER DATABASE WPCOMM SET READ_COMMITTED_SNAPSHOT ON;

--------------------------------------------------------------
-- WPCUST DATABASE creation
--------------------------------------------------------------
CREATE DATABASE WPCUST 
ON PRIMARY
(
    NAME = RELDB_DATA,
    FILENAME = '<replace-with-path>\WPCUST_Data.mdf',
    SIZE = 10MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 5MB
)
LOG ON
(
    NAME = DB_LOG,
    FILENAME = '<replace-with-path>\WPCUST_Log.ldf',
    SIZE = 5MB,
    MAXSIZE = 250MB,
    FILEGROWTH = 5MB
)
COLLATE SQL_Latin1_General_CP1_CS_AS;

ALTER DATABASE WPCUST SET READ_COMMITTED_SNAPSHOT ON;

--------------------------------------------------------------
-- WPJCR DATABASE creation
--------------------------------------------------------------
CREATE DATABASE WPJCR 
ON PRIMARY
(
    NAME = RELDB_DATA,
    FILENAME = '<replace-with-path>\WPJCR_Data.mdf',
    SIZE = 10MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 5MB
)
LOG ON
(
    NAME = DB_LOG,
    FILENAME = '<replace-with-path>\WPJCR_Log.ldf',
    SIZE = 100MB,
    MAXSIZE = 30000MB,
    FILEGROWTH = 100MB
)
COLLATE SQL_Latin1_General_CP1_CS_AS;

ALTER DATABASE WPJCR SET READ_COMMITTED_SNAPSHOT ON;

--------------------------------------------------------------
-- WPFDBK DATABASE creation
--------------------------------------------------------------
CREATE DATABASE WPFDBK 
ON PRIMARY
(
    NAME = RELDB_DATA,
    FILENAME = '<replace-with-path>\WPFDBK_Data.mdf',
    SIZE = 10MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 5MB
)
LOG ON
(
    NAME = DB_LOG,
    FILENAME = '<replace-with-path>\WPFDBK_Log.ldf',
    SIZE = 5MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 5MB
)
COLLATE SQL_Latin1_General_CP1_CS_AS;

--------------------------------------------------------------
-- WPLM DATABASE creation
--------------------------------------------------------------
CREATE DATABASE WPLM 
ON PRIMARY
(
    NAME = RELDB_DATA,
    FILENAME = '<replace-with-path>\WPLM_Data.mdf',
    SIZE = 10MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 5MB
)
LOG ON
(
    NAME = DB_LOG,
    FILENAME = '<replace-with-path>\WPLM_Log.ldf',
    SIZE = 5MB,
    MAXSIZE = 50MB,
    FILEGROWTH = 5MB
)
COLLATE SQL_Latin1_General_CP1_CI_AS;

--------------------------------------------------------------
-- SETUP for schema RELEASE
--------------------------------------------------------------
USE [WPREL];

CREATE SCHEMA RELEASE;

-- Create the configuration user
USE [WPREL];
EXEC sp_addlogin '<replace-with-user>', '<replace-with-user-password>', 'WPREL';
-- Add a role to the user for XA transactions
USE [master];
EXEC sp_addrolemember N'SqlJDBCXAUser', N'<replace-with-user>';

-- Add the configuration user to the database
USE [WPREL];
EXEC sp_grantdbaccess '<replace-with-user>';

-- Add the runtime user to the database -- skipped if same as config user
--USE [WPREL];
--EXEC sp_grantdbaccess '<replace-with-runtime-user>';

-- Create the configuration role
USE [WPREL];
CREATE ROLE [WP_BASE_CONFIG_USERS];
GRANT CREATE TABLE TO [WP_BASE_CONFIG_USERS];
GRANT ALTER, SELECT, INSERT, UPDATE, DELETE, REFERENCES ON SCHEMA::[RELEASE] TO [WP_BASE_CONFIG_USERS];
EXEC sp_addrolemember N'WP_BASE_CONFIG_USERS', N'<replace-with-user>';

-- Create the runtime role
CREATE ROLE [WP_BASE_RUNTIME_USERS];
EXEC sp_addrolemember N'WP_BASE_RUNTIME_USERS', N'<replace-with-user>';

--------------------------------------------------------------
-- SETUP for schema COMMUNITY
--------------------------------------------------------------
USE [WPCOMM];

CREATE SCHEMA COMMUNITY;

-- Add the configuration user to the database
USE [WPCOMM];
EXEC sp_grantdbaccess '<replace-with-user>';

-- Add the runtime user to the database -- skipped if same as config user
--USE [WPCOMM];
--EXEC sp_grantdbaccess '<replace-with-runtime-user>';

-- Create the configuration role
USE [WPCOMM];
CREATE ROLE [WP_BASE_CONFIG_USERS];
GRANT CREATE TABLE TO [WP_BASE_CONFIG_USERS];
GRANT ALTER, SELECT, INSERT, UPDATE, DELETE, REFERENCES ON SCHEMA::[COMMUNITY] TO [WP_BASE_CONFIG_USERS];
EXEC sp_addrolemember N'WP_BASE_CONFIG_USERS', N'<replace-with-user>';

-- Create the runtime role
CREATE ROLE [WP_BASE_RUNTIME_USERS];
EXEC sp_addrolemember N'WP_BASE_RUNTIME_USERS', N'<replace-with-user>';

--------------------------------------------------------------
-- SETUP for schema CUSTOMIZATION
--------------------------------------------------------------
USE [WPCUST];

CREATE SCHEMA CUSTOMIZATION;

-- Add the configuration user to the database
USE [WPCUST];
EXEC sp_grantdbaccess '<replace-with-user>';

-- Add the runtime user to the database -- skipped same as config user
--USE [WPCUST];
--EXEC sp_grantdbaccess '<replace-with-runtime-user>';

-- Create the configuration role
USE [WPCUST];
CREATE ROLE [WP_BASE_CONFIG_USERS];
GRANT CREATE TABLE TO [WP_BASE_CONFIG_USERS];
GRANT ALTER, SELECT, INSERT, UPDATE, DELETE, REFERENCES ON SCHEMA::[CUSTOMIZATION] TO [WP_BASE_CONFIG_USERS];
EXEC sp_addrolemember N'WP_BASE_CONFIG_USERS', N'<replace-with-user>';

-- Create the runtime role
CREATE ROLE [WP_BASE_RUNTIME_USERS];
EXEC sp_addrolemember N'WP_BASE_RUNTIME_USERS', N'<replace-with-user>';

--------------------------------------------------------------
-- SETUP for schema JCR
--------------------------------------------------------------
USE [WPJCR];

CREATE SCHEMA JCR;

-- Add the configuration user to the database
USE [WPJCR];
EXEC sp_grantdbaccess '<replace-with-user>';

-- Add the runtime user to the database -- skipped if same as config user
--USE [WPJCR];
--EXEC sp_grantdbaccess '<replace-with-runtime-user>';

-- Create the configuration role
USE [WPJCR];
CREATE ROLE [WP_JCR_CONFIG_USERS];
GRANT CREATE TABLE TO [WP_JCR_CONFIG_USERS];
GRANT CREATE VIEW TO [WP_JCR_CONFIG_USERS];
GRANT ALTER, SELECT, INSERT, UPDATE, DELETE, REFERENCES ON SCHEMA::[JCR] TO [WP_JCR_CONFIG_USERS];
EXEC sp_addrolemember N'WP_JCR_CONFIG_USERS', N'<replace-with-user>';

-- Create the runtime role
CREATE ROLE [WP_JCR_RUNTIME_USERS];
EXEC sp_addrolemember N'WP_JCR_RUNTIME_USERS', N'<replace-with-user>';

--------------------------------------------------------------
-- SETUP for schema FEEDBACK
--------------------------------------------------------------
USE [WPFDBK];

CREATE SCHEMA FEEDBACK;

-- Add the configuration user to the database
USE [WPFDBK];
EXEC sp_grantdbaccess '<replace-with-user>';

-- Add the runtime user to the database -- skipped if same as config user
--USE [WPFDBK];
--EXEC sp_grantdbaccess '<replace-with-runtime-user>';

-- Create the configuration role
USE [WPFDBK];
CREATE ROLE [WP_PZN_CONFIG_USERS];
GRANT CREATE TABLE TO [WP_PZN_CONFIG_USERS];
GRANT ALTER, SELECT, INSERT, UPDATE, DELETE, REFERENCES ON SCHEMA::[FEEDBACK] TO [WP_PZN_CONFIG_USERS];
EXEC sp_addrolemember N'WP_PZN_CONFIG_USERS', N'<replace-with-user>';

-- Create the runtime role
CREATE ROLE [WP_PZN_RUNTIME_USERS];
EXEC sp_addrolemember N'WP_PZN_RUNTIME_USERS', N'<replace-with-user>';

--------------------------------------------------------------
-- SETUP for schema LIKEMINDS
--------------------------------------------------------------
USE [WPLM];

CREATE SCHEMA LIKEMINDS;

-- Add the configuration user to the database
USE [WPLM];
EXEC sp_grantdbaccess '<replace-with-user>';

-- Add the runtime user to the database -- skipped if same as config user
--USE [WPLM];
--EXEC sp_grantdbaccess '<replace-with-runtime-user>';

-- Create the configuration role
USE [WPLM];
CREATE ROLE [WP_PZN_CONFIG_USERS];
GRANT CREATE TABLE TO [WP_PZN_CONFIG_USERS];
GRANT CREATE PROCEDURE TO [WP_PZN_CONFIG_USERS];
GRANT ALTER, SELECT, INSERT, UPDATE, DELETE, REFERENCES ON SCHEMA::[LIKEMINDS] TO [WP_PZN_CONFIG_USERS];
EXEC sp_addrolemember N'WP_PZN_CONFIG_USERS', N'<replace-with-user>';

-- Create the runtime role
CREATE ROLE [WP_PZN_RUNTIME_USERS];
EXEC sp_addrolemember N'WP_PZN_RUNTIME_USERS', N'<replace-with-user>';
