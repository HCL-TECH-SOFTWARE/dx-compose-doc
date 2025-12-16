/****************************************************************************************************
 * ★★★★★ IMPORTANT WARNING ★★★★★
 * PLEASE REVIEW AND UPDATE ALL USERS, ROLES, AND PATHS ACCORDING TO YOUR ENVIRONMENT.
 * This sample script is provided as a template. BEFORE EXECUTION, ensure that you modify the
 * user names, role definitions, and file paths to match your specific requirements and
 * security policies.
 * Note make sure replace the <replace-with-user> and <replace-with-user-password> with your database connect user and password. Similar for runtime user also.
 * If GO keyword is not recognized, try removing it.
 ****************************************************************************************************/

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
GO
ALTER DATABASE WPREL SET READ_COMMITTED_SNAPSHOT ON;
GO

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
GO

ALTER DATABASE WPCOMM SET READ_COMMITTED_SNAPSHOT ON;
GO

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
GO

ALTER DATABASE WPCUST SET READ_COMMITTED_SNAPSHOT ON;
GO

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
GO

ALTER DATABASE WPJCR SET READ_COMMITTED_SNAPSHOT ON;
GO

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
GO

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
GO

--------------------------------------------------------------
-- SETUP for schema RELEASE
--------------------------------------------------------------
USE [WPREL];
GO

CREATE SCHEMA RELEASE;
GO

-- Create the configuration user
USE [WPREL];
GO
EXEC sp_addlogin '<replace-with-user>', '<replace-with-user-password>', 'WPREL';
GO
-- Add a role to the user for XA transactions
USE [master];
GO
EXEC sp_addrolemember N'SqlJDBCXAUser', N'<replace-with-user>';
GO

-- Add the configuration user to the database
USE [WPREL];
GO
EXEC sp_grantdbaccess '<replace-with-user>';
GO

-- Add the runtime user to the database -- skipped if same as config user
--USE [WPREL];
-- GO
--EXEC sp_grantdbaccess '<replace-with-runtime-user>';
-- GO

-- Create the configuration role
USE [WPREL];
GO
CREATE ROLE [WP_BASE_CONFIG_USERS];
GO
GRANT CREATE TABLE TO [WP_BASE_CONFIG_USERS];
GO
GRANT ALTER, SELECT, INSERT, UPDATE, DELETE, REFERENCES ON SCHEMA::[RELEASE] TO [WP_BASE_CONFIG_USERS];
GO
EXEC sp_addrolemember N'WP_BASE_CONFIG_USERS', N'<replace-with-user>';
GO

-- Create the runtime role
CREATE ROLE [WP_BASE_RUNTIME_USERS];
GO
EXEC sp_addrolemember N'WP_BASE_RUNTIME_USERS', N'<replace-with-user>';
GO

--------------------------------------------------------------
-- SETUP for schema COMMUNITY
--------------------------------------------------------------
USE [WPCOMM];
GO

CREATE SCHEMA COMMUNITY;
GO

-- Add the configuration user to the database
USE [WPCOMM];
GO
EXEC sp_grantdbaccess '<replace-with-user>';
GO

-- Add the runtime user to the database -- skipped if same as config user
--USE [WPCOMM];
-- GO
--EXEC sp_grantdbaccess '<replace-with-runtime-user>';
-- GO

-- Create the configuration role
USE [WPCOMM];
GO
CREATE ROLE [WP_BASE_CONFIG_USERS];
GO
GRANT CREATE TABLE TO [WP_BASE_CONFIG_USERS];
GO
GRANT ALTER, SELECT, INSERT, UPDATE, DELETE, REFERENCES ON SCHEMA::[COMMUNITY] TO [WP_BASE_CONFIG_USERS];
GO
EXEC sp_addrolemember N'WP_BASE_CONFIG_USERS', N'<replace-with-user>';
GO

-- Create the runtime role
CREATE ROLE [WP_BASE_RUNTIME_USERS];
GO
EXEC sp_addrolemember N'WP_BASE_RUNTIME_USERS', N'<replace-with-user>';
GO

--------------------------------------------------------------
-- SETUP for schema CUSTOMIZATION
--------------------------------------------------------------
USE [WPCUST];
GO

CREATE SCHEMA CUSTOMIZATION;
GO

-- Add the configuration user to the database
USE [WPCUST];
GO
EXEC sp_grantdbaccess '<replace-with-user>';
GO

-- Add the runtime user to the database -- skipped same as config user
--USE [WPCUST];
-- GO
--EXEC sp_grantdbaccess '<replace-with-runtime-user>';
-- GO

-- Create the configuration role
USE [WPCUST];
GO
CREATE ROLE [WP_BASE_CONFIG_USERS];
GO
GRANT CREATE TABLE TO [WP_BASE_CONFIG_USERS];
GO
GRANT ALTER, SELECT, INSERT, UPDATE, DELETE, REFERENCES ON SCHEMA::[CUSTOMIZATION] TO [WP_BASE_CONFIG_USERS];
GO
EXEC sp_addrolemember N'WP_BASE_CONFIG_USERS', N'<replace-with-user>';
GO

-- Create the runtime role
CREATE ROLE [WP_BASE_RUNTIME_USERS];
GO
EXEC sp_addrolemember N'WP_BASE_RUNTIME_USERS', N'<replace-with-user>';
GO

--------------------------------------------------------------
-- SETUP for schema JCR
--------------------------------------------------------------
USE [WPJCR];
GO

CREATE SCHEMA JCR;
GO

-- Add the configuration user to the database
USE [WPJCR];
GO
EXEC sp_grantdbaccess '<replace-with-user>';
GO

-- Add the runtime user to the database -- skipped if same as config user
--USE [WPJCR];
-- GO
--EXEC sp_grantdbaccess '<replace-with-runtime-user>';
-- GO

-- Create the configuration role
USE [WPJCR];
GO
CREATE ROLE [WP_JCR_CONFIG_USERS];
GO
GRANT CREATE TABLE TO [WP_JCR_CONFIG_USERS];
GO
GRANT CREATE VIEW TO [WP_JCR_CONFIG_USERS];
GO
GRANT ALTER, SELECT, INSERT, UPDATE, DELETE, REFERENCES ON SCHEMA::[JCR] TO [WP_JCR_CONFIG_USERS];
GO
EXEC sp_addrolemember N'WP_JCR_CONFIG_USERS', N'<replace-with-user>';
GO

-- Create the runtime role
CREATE ROLE [WP_JCR_RUNTIME_USERS];
GO
EXEC sp_addrolemember N'WP_JCR_RUNTIME_USERS', N'<replace-with-user>';
GO

--------------------------------------------------------------
-- SETUP for schema FEEDBACK
--------------------------------------------------------------
USE [WPFDBK];
GO

CREATE SCHEMA FEEDBACK;
GO

-- Add the configuration user to the database
USE [WPFDBK];
GO
EXEC sp_grantdbaccess '<replace-with-user>';
GO

-- Add the runtime user to the database -- skipped if same as config user
--USE [WPFDBK];
-- GO
--EXEC sp_grantdbaccess '<replace-with-runtime-user>';
-- GO

-- Create the configuration role
USE [WPFDBK];
GO
CREATE ROLE [WP_PZN_CONFIG_USERS];
GO
GRANT CREATE TABLE TO [WP_PZN_CONFIG_USERS];
GO
GRANT ALTER, SELECT, INSERT, UPDATE, DELETE, REFERENCES ON SCHEMA::[FEEDBACK] TO [WP_PZN_CONFIG_USERS];
GO
EXEC sp_addrolemember N'WP_PZN_CONFIG_USERS', N'<replace-with-user>';
GO

-- Create the runtime role
CREATE ROLE [WP_PZN_RUNTIME_USERS];
GO
EXEC sp_addrolemember N'WP_PZN_RUNTIME_USERS', N'<replace-with-user>';
GO

--------------------------------------------------------------
-- SETUP for schema LIKEMINDS
--------------------------------------------------------------
USE [WPLM];
GO

CREATE SCHEMA LIKEMINDS;
GO

-- Add the configuration user to the database
USE [WPLM];
GO
EXEC sp_grantdbaccess '<replace-with-user>';
GO

-- Add the runtime user to the database -- skipped if same as config user
--USE [WPLM];
-- GO
--EXEC sp_grantdbaccess '<replace-with-runtime-user>';
-- GO

-- Create the configuration role
USE [WPLM];
GO
CREATE ROLE [WP_PZN_CONFIG_USERS];
GO
GRANT CREATE TABLE TO [WP_PZN_CONFIG_USERS];
GO
GRANT CREATE PROCEDURE TO [WP_PZN_CONFIG_USERS];
GO
GRANT ALTER, SELECT, INSERT, UPDATE, DELETE, REFERENCES ON SCHEMA::[LIKEMINDS] TO [WP_PZN_CONFIG_USERS];
GO
EXEC sp_addrolemember N'WP_PZN_CONFIG_USERS', N'<replace-with-user>';
GO

-- Create the runtime role
CREATE ROLE [WP_PZN_RUNTIME_USERS];
GO
EXEC sp_addrolemember N'WP_PZN_RUNTIME_USERS', N'<replace-with-user>';
GO
