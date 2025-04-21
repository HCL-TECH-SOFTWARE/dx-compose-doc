---
id: oracle23ai_custom_setup
title: Oracle 23ai Custom Setup (Pre-User Creation)
---

# Oracle 23ai Custom Setup (Pre-User Creation)

By default, Oracle 23ai AMI is launched on shared tenancy infrastructure. If needed, it can be deployed with single tenancy by selecting a dedicated instance or host during EC2 provisioning.

Upon creation, the AMI provisions a Container Database (CDB) only, without a Pluggable Database (PDB). Since the CDB enforces the 'C##' prefix for common users and limits certain configuration options, we recommend creating and working within a Pluggable Database (PDB) for standard user management and application compatibility.

Below are the detailed steps and relevant details for setting up the PDB prior to creating users:

1. **Create Directories with Correct Ownership:**  
   - Create the primary directory and set its ownership to `oracle:oinstall` with permissions set to 0750 (or as specified by your security guidelines):
     ```
     mkdir -p <replace-with-oracle-new-dir>
     ```
     ```
     mkdir -p `<oracle-db-home>/ORCL`
     ```
**Note:** *Ensure ownership: `oracle:oinstall` with 0750 (or similar) permissions*

2. **Log into sqlplus on the Oracle AMI Instance as DBA:**  
   Establish an SSH session, elevate privileges, and start sqlplus as the oracle user:
   ```
   ssh  <oracle-user>@<IP>
   sudo su
   su - oracle
   sqlplus / as sysdba
   ```
   **Note:** *Ensure you have the necessary privileges to perform DBA operations.*

3. **Create the Pluggable Database (PDB):**  
   Execute the SQL command to create the PDB. Notice the `FILE_NAME_CONVERT` clause ensures that files are redirected to the correct directories:
   ```
   CREATE PLUGGABLE DATABASE ORCL ADMIN USER <replace-with-user> IDENTIFIED BY <replace-with-user-password> 
   ROLES=(DBA) 
   FILE_NAME_CONVERT = ('<replace-with-oracle-existing-dir>', '<replace-with-oracle-new-dir>');
   ```

4. **Open the Pluggable Database:**  
   Opening the PDB can make it immediately available:
   ```
   ALTER PLUGGABLE DATABASE ORCL OPEN;
   ```
   *Run this if your workflow requires an open PDB immediately. Some environments may open it automatically.*

5. **Set the Container for the Session:**  
   To avoid accidentally connecting to the root container (`CDB$ROOT`), set the active container to the newly created PDB for each sqlplus session:
   ```
   ALTER SESSION SET CONTAINER = ORCL;
   ```

6. **Verify the Active Container:**  
   Confirm that you are connected to the correct container by running:
   ```
   SHOW CON_NAME;
   ```
   This should return `ORCL`.

7. **Create a Tablespace:**  
   Create a tablespace for user data. The `AUTOEXTEND ON` option allows the datafile to grow as needed:
   ```
   CREATE TABLESPACE USERS 
   DATAFILE '<replace-with-oracle-new-dir>/users.dbf' 
   SIZE 1G 
   AUTOEXTEND ON;
   ```

8. **Proceed with User and Role Creation:**  
   Once the PDB and tablespace are set up, continue with the required `CREATE USER` and `CREATE ROLE` commands according to your security and access policies. For additional guidance on external database setup (schema/user creation), refer to the [Setup external database (schema / user creation)](external_db_database_transfer.md#setup-external-database-schema--user-creation) section.

Following these steps ensures that the Oracle 23ai DB is set up correctly prior to user creation, maintaining proper separation from the root container.

[For more details, see the Oracle documentation on CREATE PLUGGABLE DATABASE](https://docs.oracle.com/en/database/oracle/oracle-database/23/sqlrf/CREATE-PLUGGABLE-DATABASE.html)
