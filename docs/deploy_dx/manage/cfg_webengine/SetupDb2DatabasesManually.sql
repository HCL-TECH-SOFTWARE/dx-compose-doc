/****************************************************************************************************
 * ★★★★★ IMPORTANT WARNING ★★★★★
 * PLEASE REVIEW AND UPDATE ALL USERS, ROLES, AND PATHS ACCORDING TO YOUR ENVIRONMENT.
 * This sample script is provided as a template. BEFORE EXECUTION, ensure that you modify the
 * user names, role definitions, and file paths to match your specific requirements and
 * security policies.
 ****************************************************************************************************/

-- NOTE: create a database name WPSDB & user. And update below query with your database connect user (<replace-with-user>) and password (<replace-with-user-password>)
-- NOTE: make sure replace the <replace-with-user> and <replace-with-user-password> with your database connect user and password
CONNECT TO WPSDB USER <replace-with-user> USING <replace-with-user-password>;
CREATE SCHEMA release AUTHORIZATION <replace-with-user>;
COMMIT;

GRANT CONNECT, CREATETAB ON DATABASE TO GROUP WP_BASE_CONFIG_USERS;
GRANT EXECUTE ON PACKAGE NULLID.SYSSH200 TO GROUP WP_BASE_CONFIG_USERS;
GRANT ALTERIN, CREATEIN, DROPIN ON SCHEMA release TO GROUP WP_BASE_CONFIG_USERS;
GRANT USE OF TABLESPACE USERSPACE1 TO GROUP WP_BASE_CONFIG_USERS;
GRANT USAGE ON WORKLOAD SYSDEFAULTUSERWORKLOAD TO GROUP WP_BASE_CONFIG_USERS;

CONNECT RESET;

CONNECT TO WPSDB USER <replace-with-user> USING <replace-with-user-password>;
CREATE SCHEMA community AUTHORIZATION <replace-with-user>;
COMMIT;

GRANT CONNECT, CREATETAB ON DATABASE TO GROUP WP_BASE_CONFIG_USERS;
GRANT EXECUTE ON PACKAGE NULLID.SYSSH200 TO GROUP WP_BASE_CONFIG_USERS;
GRANT ALTERIN, CREATEIN, DROPIN ON SCHEMA community TO GROUP WP_BASE_CONFIG_USERS;
GRANT USE OF TABLESPACE USERSPACE1 TO GROUP WP_BASE_CONFIG_USERS;
GRANT USAGE ON WORKLOAD SYSDEFAULTUSERWORKLOAD TO GROUP WP_BASE_CONFIG_USERS;

CONNECT RESET;

CONNECT TO WPSDB USER <replace-with-user> USING <replace-with-user-password>;
CREATE SCHEMA customization AUTHORIZATION <replace-with-user>;
COMMIT;

GRANT CONNECT, CREATETAB ON DATABASE TO GROUP WP_BASE_CONFIG_USERS;
GRANT EXECUTE ON PACKAGE NULLID.SYSSH200 TO GROUP WP_BASE_CONFIG_USERS;
GRANT ALTERIN, CREATEIN, DROPIN ON SCHEMA customization TO GROUP WP_BASE_CONFIG_USERS;
GRANT USE OF TABLESPACE USERSPACE1 TO GROUP WP_BASE_CONFIG_USERS;
GRANT USAGE ON WORKLOAD SYSDEFAULTUSERWORKLOAD TO GROUP WP_BASE_CONFIG_USERS;

CONNECT RESET;

CONNECT TO WPSDB USER <replace-with-user> USING <replace-with-user-password>;
CREATE SCHEMA jcr AUTHORIZATION <replace-with-user>;
COMMIT;

GRANT CONNECT, CREATETAB ON DATABASE TO GROUP WP_JCR_CONFIG_USERS;
GRANT EXECUTE ON PACKAGE NULLID.SYSSH200 TO GROUP WP_JCR_CONFIG_USERS;
GRANT ALTERIN, CREATEIN, DROPIN ON SCHEMA jcr TO GROUP WP_JCR_CONFIG_USERS;
GRANT USE OF TABLESPACE USERSPACE1 TO GROUP WP_JCR_CONFIG_USERS;
GRANT USAGE ON WORKLOAD SYSDEFAULTUSERWORKLOAD TO GROUP WP_JCR_CONFIG_USERS;


GRANT USE OF TABLESPACE ICMLFQ32 TO GROUP WP_JCR_CONFIG_USERS;
GRANT USE OF TABLESPACE ICMLNF32 TO GROUP WP_JCR_CONFIG_USERS;
GRANT USE OF TABLESPACE ICMVFQ04 TO GROUP WP_JCR_CONFIG_USERS;
GRANT USE OF TABLESPACE ICMSFQ04 TO GROUP WP_JCR_CONFIG_USERS;
GRANT USE OF TABLESPACE CMBINV04 TO GROUP WP_JCR_CONFIG_USERS;
GRANT USE OF TABLESPACE ICMLSUSRTSPACE4 TO GROUP WP_JCR_CONFIG_USERS;

CONNECT RESET;

CONNECT TO WPSDB USER <replace-with-user> USING <replace-with-user-password>;
CREATE SCHEMA feedback AUTHORIZATION <replace-with-user>;
COMMIT;

GRANT CONNECT, CREATETAB ON DATABASE TO GROUP WP_PZN_CONFIG_USERS;
GRANT EXECUTE ON PACKAGE NULLID.SYSSH200 TO GROUP WP_PZN_CONFIG_USERS;
GRANT ALTERIN, CREATEIN, DROPIN ON SCHEMA feedback TO GROUP WP_PZN_CONFIG_USERS;
GRANT USE OF TABLESPACE USERSPACE1 TO GROUP WP_PZN_CONFIG_USERS;
GRANT USAGE ON WORKLOAD SYSDEFAULTUSERWORKLOAD TO GROUP WP_PZN_CONFIG_USERS;

CONNECT RESET;

CONNECT TO WPSDB USER <replace-with-user> USING <replace-with-user-password>;
CREATE SCHEMA likeminds AUTHORIZATION <replace-with-user>;
COMMIT;

GRANT CONNECT, CREATETAB ON DATABASE TO GROUP WP_PZN_CONFIG_USERS;
GRANT EXECUTE ON PACKAGE NULLID.SYSSH200 TO GROUP WP_PZN_CONFIG_USERS;
GRANT ALTERIN, CREATEIN, DROPIN ON SCHEMA likeminds TO GROUP WP_PZN_CONFIG_USERS;
GRANT USE OF TABLESPACE USERSPACE1 TO GROUP WP_PZN_CONFIG_USERS;
GRANT USAGE ON WORKLOAD SYSDEFAULTUSERWORKLOAD TO GROUP WP_PZN_CONFIG_USERS;

CONNECT RESET;