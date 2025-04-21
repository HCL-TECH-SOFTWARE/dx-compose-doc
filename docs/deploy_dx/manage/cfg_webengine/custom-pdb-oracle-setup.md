---
id: oracle23ai_custom_setup
title: Oracle 23ai Custom Setup (Pre-User Creation)
---

# Oracle 23ai Custom Setup (Pre-User Creation)

By default, the Oracle 23ai Amazon Machine Image (AMI) is launched on shared tenancy infrastructure. If needed, it can be deployed with single tenancy by selecting a dedicated instance or host during EC2 provisioning.

Upon creation, the AMI only provisions a Container Database (CDB) without a Pluggable Database (PDB). Since the CDB enforces the "C##" prefix for common users and limits certain configuration options, it is recommended to create and work within a Pluggable Database (PDB) for standard user management and application compatibility.

Refer to the following steps and details for setting up the PDB prior to creating users:

1. Create the primary directory and set its ownership to `oracle:oinstall` with permissions set to 0750 (or as specified by your security guidelines) using the following commands:

    ```
    mkdir -p <replace-with-oracle-new-dir>
    mkdir -p `<oracle-db-home>/ORCL`
    ```


2. Log into SQLPlus on the Oracle AMI Instance as the database administrator (DBA) using the following commands. This establishes an SSH session, elevates privileges, and starts SQLPlus as the oracle user.

    ```
    ssh  <oracle-user>@<IP>
    sudo su
    su - oracle
    sqlplus / as sysdba
    ```

    !!!note
        Ensure you have the necessary privileges to perform DBA operations.

3. Create a PDB using the following SQL commands. The `FILE_NAME_CONVERT` clause ensures that files are redirected to the correct directories.

    ```
    CREATE PLUGGABLE DATABASE ORCL ADMIN USER <replace-with-user> IDENTIFIED BY <replace-with-user-password> 
    ROLES=(DBA) 
    FILE_NAME_CONVERT = ('<replace-with-oracle-existing-dir>', '<replace-with-oracle-new-dir>');
    ```

4. Open the PDB to make it immediately available.

    If your workflow requires the PDB to be open right away, run the following command. In some environments, the PDB may open automatically.

    ```
    ALTER PLUGGABLE DATABASE ORCL OPEN;
    ```

5. Set the active container to the newly created PDB for each SQLPlus session using the following command. This helps avoid accidentally connecting to the root container (`CDB$ROOT`).

    ```
    ALTER SESSION SET CONTAINER = ORCL;
    ```

6. Confirm that you are connected to the correct container using the following command:

    ```
    SHOW CON_NAME;
    ```

    This should return `ORCL`.

7. Create a tablespace for user data using the following command. The `AUTOEXTEND ON` parameter allows the datafile to grow as needed.

    ```
    CREATE TABLESPACE USERS 
    DATAFILE '<replace-with-oracle-new-dir>/users.dbf'
    SIZE 1G 
    AUTOEXTEND ON;
    ```

8. After setting up the PDB and tablespace, proceed with user and role creations using the `CREATE USER` and `CREATE ROLE` commands according to your security and access policies. For additional guidance on external database schemas or users, refer to [Setup external database (schema / user creation)](./external_db_database_transfer.md#setup-external-database-schema--user-creation).

Following these steps ensures that the Oracle 23ai DB is set up correctly prior to user creation, maintaining proper separation from the root container. For more details, refer to the [CREATE PLUGGABLE DATABASE](https://docs.oracle.com/en/database/oracle/oracle-database/23/sqlrf/CREATE-PLUGGABLE-DATABASE.html){target="_blank"} Oracle documentation.
