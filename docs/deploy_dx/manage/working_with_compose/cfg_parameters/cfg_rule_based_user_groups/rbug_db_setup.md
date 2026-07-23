# Setting up the database

Before using rule-based user groups, manually create the database table required to store group definitions, including names, rules, and descriptions. Run one of the following SQL statements to create the table in your database and schema. Replace `schema_name` in the scripts with your schema name.

!!!note
    HCL Digital Experience (DX) Compose does not support rule-based groups when using Apache Derby. You must use one of the database types listed in this section.

## DB2 databases

```sql
CREATE TABLE schema\_name.SOFTGROUPS
(ID INT NOT NULL GENERATED ALWAYS AS IDENTITY,
  GROUPNAME VARCHAR(128) NOT NULL,
  RULE VARCHAR(300) NOT NULL,
  DESCRIPTION VARCHAR(512),
  LASTMODIFIED TIMESTAMP,
  PRIMARY KEY (ID),
  UNIQUE (GROUPNAME));

CREATE INDEX schema\_name.SOFTGROUPSIX1 ON 
schema\_name.SOFTGROUPS (LASTMODIFIED DESC);
```

## SQL Server databases

```sql
CREATE TABLE schema\_name.SOFTGROUPS
(ID INT NOT NULL IDENTITY PRIMARY KEY,
GROUPNAME VARCHAR(128) NOT NULL UNIQUE,
"RULE" VARCHAR(300) NOT NULL,
DESCRIPTION VARCHAR(512),
LASTMODIFIED DATETIME);

CREATE INDEX SOFTGROUPSIX1 ON 
schema\_name.SOFTGROUPS(LASTMODIFIED DESC);
sp_indexoption 'schema\_name.SOFTGROUPS', 
'disallowpagelocks', TRUE;
```

## Oracle databases

```sql
CREATE TABLE schema\_name.SOFTGROUPS
  (
      ID           INT,
      GROUPNAME    VARCHAR(128) NOT NULL,
      RULE         VARCHAR(300) NOT NULL,
      DESCRIPTION  VARCHAR(512),
      LASTMODIFIED TIMESTAMP,
      PRIMARY KEY  (ID),
      UNIQUE (GROUPNAME)  
  );

CREATE INDEX schema\_name.SOFTGROUPSIX1 ON 
schema\_name.SOFTGROUPS  (LASTMODIFIED DESC);

CREATE SEQUENCE softgroups_seq;

CREATE TRIGGER softgroups_seq_trigger
  before INSERT ON schema\_name.SOFTGROUPS
  FOR each ROW
BEGIN
    IF ( :new.id IS NULL ) THEN
      SELECT softgroups_seq.nextval
      INTO   :new.id
      FROM   dual;
    END IF;
END;
/
```

Oracle does not support the auto-increment or identity feature directly in the column definition. You must create a sequence and a trigger. To submit the statement, include the final slash character (`/`) and press **Enter**.

