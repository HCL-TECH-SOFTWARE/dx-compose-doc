---
id: oracle23ai_custom_setup
title: Oracle 23ai Custom Setup (Pre-User Creation)
---

# Oracle 23ai Custom Setup (Pre-User Creation)

Our Oracle 23ai AMI uses a single tenancy model. To avoid working in the CDB (root container), which enforces the 'C##' prefix on certain properties, we instead create a Pluggable Database (PDB).

Below are the detailed steps and relevant details for setting up the PDB prior to creating users:

1. **Create Directories with Correct Ownership:**  
   - Create the primary directory and set its ownership to `oracle:oinstall` with permissions set to 0750 (or as specified by your security guidelines):
     ```
     mkdir -p /opt/oracle/oradata/ORCL/
     ```
     ```
     mkdir -p /opt/oracle/product/23ai/dbhomeFree/ORCL
     ```
**Note:** *Ensure ownership: `oracle:oinstall` with 0750 (or similar) permissions*

2. **Log into sqlplus on the Oracle AMI Instance as DBA:**  
   Establish an SSH session, elevate privileges, and start sqlplus as the oracle user:
   ```
   ssh -i "test-automation-deployments.pem" -o "StrictHostKeyChecking=no" cloud-user@<IP>
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
   FILE_NAME_CONVERT = ('/opt/oracle/oradata/FREE/pdbseed/', '/opt/oracle/oradata/ORCL/');
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
   DATAFILE '/opt/oracle/oradata/ORCL/users.dbf' 
   SIZE 1G 
   AUTOEXTEND ON;
   ```

8. **Proceed with User and Role Creation:**  
   Once the PDB and tablespace are set up, continue with the required `CREATE USER` and `CREATE ROLE` commands according to your security and access policies. For additional guidance on external database setup (schema/user creation), refer to the [Setup external database (schema / user creation)](external_db_database_transfer.md#setup-external-database-schema--user-creation) section.

Following these steps ensures that the Oracle 23ai DB is set up correctly prior to user creation, maintaining proper separation from the root container.
