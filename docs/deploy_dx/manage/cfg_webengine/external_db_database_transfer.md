---
id: external-db-database-transfer
title: Using an external database and database transfer
---

By default, WebEngine comes with a local Derby database included in the image and persisted in a PersistentVolume. You can use the Derby database to test the basic functionality of HCL Digital Experience (DX) Compose in a Kubernetes deployment. This works for single-Pod deployments. However, for production environments, it is required to use an external database for better performance and scalability. This document outlines the steps to connect to an external database and transfer the content of the Derby database to the external database in HCL DX Compose deployment.

!!! note
    For the currently supported external databases, refer to [Limitations](../../../getting_started/limitations.md).

## Setup external database (schema / user creation)

This section provides the custom scripts for setting up the external database schemas (or users).

|Database| Custom setup script|
|--------|--------------------|
|DB2|[DB2 custom setup script](SetupDb2DatabasesManually.sql)|
|Oracle|[Oracle custom setup script](SetupOracleDatabasesManually.sql)|
|SQL Server|[SQL Server custom setup script](SetupSqlServerDatabasesManually.sql)|

!!! Note
    If you are using the Amazon RDS for Oracle, you need to create a custom option group, add the JVM option, and then attach that group to your Amazon RDS instance to support Extended Architecture (XA) transactions for WebEngine. Attaching this custom option group to your instance replaces the default option group. For more information, refer to [Configure Custom Option Groups for Amazon RDS](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithOptionGroups.html){target="_blank"}.

## Configuring an external database

The external database is configured in the Helm custom `values.yaml` file. You can add the values directly to the custom values file or you can reference them from secrets to hide the plain text entries that can contain credentials.

There are two sets of values used to configure the external database:

- `configuration.webEngine.dbDomainProperties`
- `configuration.webEngine.dbTypeProperties`

You can use the following secrets instead of the provided values:

- `configuration.webEngine.customDbDomainPropertiesSecret`
- `configuration.webEngine.customDbTypePropertiesSecret`

!!! note
    You must create the `customDbDomainPropertiesSecret` and `customDbTypePropertiesSecret` secrets before the deployment of the Helm chart. If the secrets are used, all property values set in the custom `values.yaml` file will be ignored. Therefore, all properties must be set in the secrets, not only the overridden ones.

### External database configuration in the custom `values.yaml` file

#### Sample `values.yaml` file for DB2

!!! note
    With DX Compose 9.5 CF226 the location of the DB2 library jar in the container is /opt/openliberty/wlp/usr/svrcfg/templates/jars/db2

    So the value for db2.DbLibrary is now /opt/openliberty/wlp/usr/svrcfg/templates/jars/db2/db2jcc4.jar

    The db2jcc_license_cu.jar is no longer provided or required.

```yaml
configuration:
  webEngine:
    dbDomainProperties:
      InitializeFeedbackDB: "true"
      feedback.DbType: "db2"
      feedback.DbName: "WPSDB"
      feedback.DbSchema: "feedback"
      feedback.DataSourceName: "wpfdbkdbDS"
      feedback.DbUrl: "jdbc:db2://<replace-db-host>:<replace-db-port>/WPSDB:returnAlias=0;"
      feedback.DbUser: "<replace-db-user>"
      feedback.DbPassword: "<replace-db-password>"
      feedback.DbRuntimeUser: "<replace-db-user>"
      feedback.DbRuntimePassword: "<replace-db-password>"
      feedback.DBA.DbUser: "<replace-db-user>"
      feedback.DBA.DbPassword: "<replace-db-password>"
      feedback.DbConfigRoleName: "WP_PZN_CONFIG_USERS"
      feedback.DbRuntimeRoleName: "WP_PZN_RUNTIME_USERS"
      feedback.XDbName: "WPFDBK"
      feedback.DbNode: "pznNode"
      likeminds.DbType: "db2"
      likeminds.DbName: "WPSDB"
      likeminds.DbSchema: "likeminds"
      likeminds.DataSourceName: "wplmdbDS"
      likeminds.DbUrl: "jdbc:db2://<replace-db-host>:<replace-db-port>/WPSDB:returnAlias=0;"
      likeminds.DbUser: "<replace-db-user>"
      likeminds.DbPassword: "<replace-db-password>"
      likeminds.DbRuntimeUser: "<replace-db-user>"
      likeminds.DbRuntimePassword: "<replace-db-password>"
      likeminds.DBA.DbUser: "<replace-db-user>"
      likeminds.DBA.DbPassword: "<replace-db-password>"
      likeminds.DbConfigRoleName: "WP_PZN_CONFIG_USERS"
      likeminds.DbRuntimeRoleName: "WP_PZN_RUNTIME_USERS"
      likeminds.XDbName: "WPLM"
      likeminds.DbNode: "pznNode"
      release.DbType: "db2"
      release.DbName: "WPSDB"
      release.DbSchema: "release"
      release.DataSourceName: "wpreldbDS"
      release.DbUrl: "jdbc:db2://<replace-db-host>:<replace-db-port>/WPSDB:returnAlias=0;"
      release.DbUser: "<replace-db-user>"
      release.DbPassword: "<replace-db-password>"
      release.DbRuntimeUser: "<replace-db-user>"
      release.DbRuntimePassword: "<replace-db-password>"
      release.DBA.DbUser: "<replace-db-user>"
      release.DBA.DbPassword: "<replace-db-password>"
      release.DbConfigRoleName: "WP_BASE_CONFIG_USERS"
      release.DbRuntimeRoleName: "WP_BASE_RUNTIME_USERS"
      release.XDbName: "WPREL"
      release.DbNode: "wpsNode"
      community.DbType: "db2"
      community.DbName: "WPSDB"
      community.DbSchema: "community"
      community.DataSourceName: "wpcommdbDS"
      community.DbUrl: "jdbc:db2://<replace-db-host>:<replace-db-port>/WPSDB:returnAlias=0;"
      community.DbUser: "<replace-db-user>"
      community.DbPassword: "<replace-db-password>"
      community.DbRuntimeUser: "<replace-db-user>"
      community.DbRuntimePassword: "<replace-db-password>"
      community.DBA.DbUser: "<replace-db-user>"
      community.DBA.DbPassword: "<replace-db-password>"
      community.DbConfigRoleName: "WP_BASE_CONFIG_USERS"
      community.DbRuntimeRoleName: "WP_BASE_RUNTIME_USERS"
      community.XDbName: "WPCOMM"
      community.DbNode: "wpsNode"
      customization.DbType: "db2"
      customization.DbName: "WPSDB"
      customization.DbSchema: "customization"
      customization.DataSourceName: "wpcustdbDS"
      customization.DbUrl: "jdbc:db2://<replace-db-host>:<replace-db-port>/WPSDB:returnAlias=0;"
      customization.DbUser: "<replace-db-user>"
      customization.DbPassword: "<replace-db-password>"
      customization.DbRuntimeUser: "<replace-db-user>"
      customization.DbRuntimePassword: "<replace-db-password>"
      customization.DBA.DbUser: "<replace-db-user>"
      customization.DBA.DbPassword: "<replace-db-password>"
      customization.DbConfigRoleName: "WP_BASE_CONFIG_USERS"
      customization.DbRuntimeRoleName: "WP_BASE_RUNTIME_USERS"
      customization.XDbName: "WPCUST"
      customization.DbNode: "wpsNode"
      jcr.DbType: "db2"
      jcr.DbName: "WPSDB"
      jcr.DbSchema: "jcr"
      jcr.DataSourceName: "wpjcrdbDS"
      jcr.DbUrl: "jdbc:db2://<replace-db-host>:<replace-db-port>/WPSDB:returnAlias=0;"
      jcr.DbUser: "<replace-db-user>"
      jcr.DbPassword: "<replace-db-password>"
      jcr.DbRuntimeUser: "<replace-db-user>"
      jcr.DbRuntimePassword: "<replace-db-password>"
      jcr.DBA.DbUser: "<replace-db-user>"
      jcr.DBA.DbPassword: "<replace-db-password>"
      jcr.DbConfigRoleName: "WP_JCR_CONFIG_USERS"
      jcr.DbRuntimeRoleName: "WP_JCR_RUNTIME_USERS"
      jcr.XDbName: "WPJCR"
      jcr.DbNode: "wpsNode"
    dbTypeProperties:
      db2.DbDriver: "com.ibm.db2.jcc.DB2Driver"
      db2.DbLibrary: "/opt/openliberty/wlp/usr/svrcfg/templates/jars/db2/db2jcc4.jar"
      db2.JdbcProviderName: "wpdbJDBC_db2"
```

#### Sample `values.yaml` file for ORACLE

```yaml
configuration:
  webEngine:
    dbDomainProperties:
      InitializeFeedbackDB: "true"
      feedback.DbType: "oracle"
      feedback.DbName: "feedback"
      feedback.DbSchema: "feedback"
      feedback.DataSourceName: "wpfdbkdbDS"
      feedback.DbUrl: "jdbc:oracle:thin:@//<replace-db-host>:<replace-db-port>/<replace-service-name>"
      feedback.DbUser: "<replace-db-user>"
      feedback.DbPassword: "<replace-db-password>"
      feedback.DbRuntimeUser: "<replace-db-user>"
      feedback.DbRuntimePassword: "<replace-db-password>"
      feedback.DBA.DbUser: "<replace-db-user>"
      feedback.DBA.DbPassword: "<replace-db-password>"
      feedback.DbConfigRoleName: "WP_PZN_CONFIG_USERS"
      feedback.DbRuntimeRoleName: "WP_PZN_RUNTIME_USERS"
      feedback.XDbName: "WPFDBK"
      feedback.DbNode: "pznNode"
      likeminds.DbType: "oracle"
      likeminds.DbName: "likeminds"
      likeminds.DbSchema: "likeminds"
      likeminds.DataSourceName: "wplmdbDS"
      likeminds.DbUrl: "jdbc:oracle:thin:@//<replace-db-host>:<replace-db-port>/<replace-service-name>"
      likeminds.DbUser: "<replace-db-user>"
      likeminds.DbPassword: "<replace-db-password>"
      likeminds.DbRuntimeUser: "<replace-db-user>"
      likeminds.DbRuntimePassword: "<replace-db-password>"
      likeminds.DBA.DbUser: "<replace-db-user>"
      likeminds.DBA.DbPassword: "<replace-db-password>"
      likeminds.DbConfigRoleName: "WP_PZN_CONFIG_USERS"
      likeminds.DbRuntimeRoleName: "WP_PZN_RUNTIME_USERS"
      likeminds.XDbName: "WPLM"
      likeminds.DbNode: "pznNode"
      release.DbType: "oracle"
      release.DbName: "release"
      release.DbSchema: "release"
      release.DataSourceName: "wpreldbDS"
      release.DbUrl: "jdbc:oracle:thin:@//<replace-db-host>:<replace-db-port>/<replace-service-name>"
      release.DbUser: "<replace-db-user>"
      release.DbPassword: "<replace-db-password>"
      release.DbRuntimeUser: "<replace-db-user>"
      release.DbRuntimePassword: "<replace-db-password>"
      release.DBA.DbUser: "<replace-db-user>"
      release.DBA.DbPassword: "<replace-db-password>"
      release.DbConfigRoleName: "WP_BASE_CONFIG_USERS"
      release.DbRuntimeRoleName: "WP_BASE_RUNTIME_USERS"
      release.XDbName: "WPREL"
      release.DbNode: "wpsNode"
      community.DbType: "oracle"
      community.DbName: "community"
      community.DbSchema: "community"
      community.DataSourceName: "wpcommdbDS"
      community.DbUrl: "jdbc:oracle:thin:@//<replace-db-host>:<replace-db-port>/<replace-service-name>"
      community.DbUser: "<replace-db-user>"
      community.DbPassword: "<replace-db-password>"
      community.DbRuntimeUser: "<replace-db-user>"
      community.DbRuntimePassword: "<replace-db-password>"
      community.DBA.DbUser: "<replace-db-user>"
      community.DBA.DbPassword: "<replace-db-password>"
      community.DbConfigRoleName: "WP_BASE_CONFIG_USERS"
      community.DbRuntimeRoleName: "WP_BASE_RUNTIME_USERS"
      community.XDbName: "WPCOMM"
      community.DbNode: "wpsNode"
      customization.DbType: "oracle"
      customization.DbName: "WPCUST"
      customization.DbSchema: "customization"
      customization.DataSourceName: "wpcustdbDS"
      customization.DbUrl: "jdbc:oracle:thin:@//<replace-db-host>:<replace-db-port>/<replace-service-name>"
      customization.DbUser: "<replace-db-user>"
      customization.DbPassword: "<replace-db-password>"
      customization.DbRuntimeUser: "<replace-db-user>"
      customization.DbRuntimePassword: "<replace-db-password>"
      customization.DBA.DbUser: "<replace-db-user>"
      customization.DBA.DbPassword: "<replace-db-password>"
      customization.DbConfigRoleName: "WP_BASE_CONFIG_USERS"
      customization.DbRuntimeRoleName: "WP_BASE_RUNTIME_USERS"
      customization.XDbName: "WPCUST"
      customization.DbNode: "wpsNode"
      jcr.DbType: "oracle"
      jcr.DbName: "jcr"
      jcr.DbSchema: "jcr"
      jcr.DataSourceName: "wpjcrdbDS"
      jcr.DbUrl: "jdbc:oracle:thin:@//<replace-db-host>:<replace-db-port>/<replace-service-name>"
      jcr.DbUser: "<replace-db-user>"
      jcr.DbPassword: "<replace-db-password>"
      jcr.DbRuntimeUser: "<replace-db-user>"
      jcr.DbRuntimePassword: "<replace-db-password>"
      jcr.DBA.DbUser: "<replace-db-user>"
      jcr.DBA.DbPassword: "<replace-db-password>"
      jcr.DbConfigRoleName: "WP_JCR_CONFIG_USERS"
      jcr.DbRuntimeRoleName: "WP_JCR_RUNTIME_USERS"
      jcr.XDbName: "WPJCR"
      jcr.DbNode: "wpsNode"
    dbTypeProperties:
      oracle.DbDriver: "oracle.jdbc.driver.OracleDriver"
      oracle.DbLibrary: "/opt/openliberty/wlp/usr/svrcfg/templates/jars/oracle/ojdbc11.jar:/opt/openliberty/wlp/usr/svrcfg/templates/jars/oracle/xdb6-11.2.0.4.jar"
      oracle.JdbcProviderName: "wpdbJDBC_oracle"
```

#### Sample `values.yaml` file for SQL Server

```yaml
configuration:
  webEngine:
    dbDomainProperties:
      InitializeFeedbackDB: "true"
      feedback.DbType: "sqlserver"
      feedback.DbName: "WPFDBK"
      feedback.DbSchema: "FEEDBACK"
      feedback.DataSourceName: "wpfdbkdbDS"
      feedback.DbUrl: "jdbc:sqlserver://DB_HOST_PLACEHOLDER:1433;databaseName=WPFDBK;encrypt=false"
      feedback.DbUser: "<replace-db-user>"
      feedback.DbPassword: "<replace-db-password>"
      feedback.DbRuntimeUser: "<replace-db-user>"
      feedback.DbRuntimePassword: "<replace-db-password>"
      feedback.DBA.DbUser: "<replace-db-user>"
      feedback.DBA.DbPassword: "<replace-db-password>"
      feedback.DbConfigRoleName: "WP_PZN_CONFIG_USERS"
      feedback.DbRuntimeRoleName: "WP_PZN_RUNTIME_USERS"
      feedback.XDbName: "WPFDBK"
      feedback.DbNode: "pznNode"
      likeminds.DbType: "sqlserver"
      likeminds.DbName: "WPLM"
      likeminds.DbSchema: "LIKEMINDS"
      likeminds.DataSourceName: "wplmdbDS"
      likeminds.DbUrl: "jdbc:sqlserver://DB_HOST_PLACEHOLDER:1433;databaseName=WPLM;encrypt=false"
      likeminds.DbUser: "<replace-db-user>"
      likeminds.DbPassword: "<replace-db-password>"
      likeminds.DbRuntimeUser: "<replace-db-user>"
      likeminds.DbRuntimePassword: "<replace-db-password>"
      likeminds.DBA.DbUser: "<replace-db-user>"
      likeminds.DBA.DbPassword: "<replace-db-password>"
      likeminds.DbConfigRoleName: "WP_PZN_CONFIG_USERS"
      likeminds.DbRuntimeRoleName: "WP_PZN_RUNTIME_USERS"
      likeminds.XDbName: "WPLM"
      likeminds.DbNode: "pznNode"
      release.DbType: "sqlserver"
      release.DbName: "WPREL"
      release.DbSchema: "RELEASE"
      release.DataSourceName: "wpreldbDS"
      release.DbUrl: "jdbc:sqlserver://DB_HOST_PLACEHOLDER:1433;databaseName=WPREL;encrypt=false"
      release.DbUser: "<replace-db-user>"
      release.DbPassword: "<replace-db-password>"
      release.DbRuntimeUser: "<replace-db-user>"
      release.DbRuntimePassword: "<replace-db-password>"
      release.DBA.DbUser: "<replace-db-user>"
      release.DBA.DbPassword: "<replace-db-password>"
      release.DbConfigRoleName: "WP_BASE_CONFIG_USERS"
      release.DbRuntimeRoleName: "WP_BASE_RUNTIME_USERS"
      release.XDbName: "WPREL"
      release.DbNode: "wpsNode"
      community.DbType: "sqlserver"
      community.DbName: "WPCOMM"
      community.DbSchema: "COMMUNITY"
      community.DataSourceName: "wpcommdbDS"
      community.DbUrl: "jdbc:sqlserver://DB_HOST_PLACEHOLDER:1433;databaseName=WPCOMM;encrypt=false"
      community.DbUser: "<replace-db-user>"
      community.DbPassword: "<replace-db-password>"
      community.DbRuntimeUser: "<replace-db-user>"
      community.DbRuntimePassword: "<replace-db-password>"
      community.DBA.DbUser: "<replace-db-user>"
      community.DBA.DbPassword: "<replace-db-password>"
      community.DbConfigRoleName: "WP_BASE_CONFIG_USERS"
      community.DbRuntimeRoleName: "WP_BASE_RUNTIME_USERS"
      community.XDbName: "WPCOMM"
      community.DbNode: "wpsNode"
      customization.DbType: "sqlserver"
      customization.DbName: "WPCUST"
      customization.DbSchema: "CUSTOMIZATION"
      customization.DataSourceName: "wpcustdbDS"
      customization.DbUrl: "jdbc:sqlserver://DB_HOST_PLACEHOLDER:1433;databaseName=WPCUST;encrypt=false"
      customization.DbUser: "<replace-db-user>"
      customization.DbPassword: "<replace-db-password>"
      customization.DbRuntimeUser: "<replace-db-user>"
      customization.DbRuntimePassword: "<replace-db-password>"
      customization.DBA.DbUser: "<replace-db-user>"
      customization.DBA.DbPassword: "<replace-db-password>"
      customization.DbConfigRoleName: "WP_BASE_CONFIG_USERS"
      customization.DbRuntimeRoleName: "WP_BASE_RUNTIME_USERS"
      customization.XDbName: "WPCUST"
      customization.DbNode: "wpsNode"
      jcr.DbType: "sqlserver"
      jcr.DbName: "WPJCR"
      jcr.DbSchema: "JCR"
      jcr.DataSourceName: "wpjcrdbDS"
      jcr.DbUrl: "jdbc:sqlserver://DB_HOST_PLACEHOLDER:1433;databaseName=WPJCR;encrypt=false"
      jcr.DbUser: "<replace-db-user>"
      jcr.DbPassword: "<replace-db-password>"
      jcr.DbRuntimeUser: "<replace-db-user>"
      jcr.DbRuntimePassword: "<replace-db-password>"
      jcr.DBA.DbUser: "<replace-db-user>"
      jcr.DBA.DbPassword: "<replace-db-password>"
      jcr.DbConfigRoleName: "WP_JCR_CONFIG_USERS"
      jcr.DbRuntimeRoleName: "WP_JCR_RUNTIME_USERS"
      jcr.XDbName: "WPJCR"
      jcr.DbNode: "wpsNode"
    dbTypeProperties:
      sqlserver.DbDriver: "com.microsoft.sqlserver.jdbc.SQLServerDriver"
      sqlserver.DbLibrary: "/opt/openliberty/wlp/usr/svrcfg/templates/jars/sqlserver/mssql-jdbc.jar"
      sqlserver.JdbcProviderName: "wpdbJDBC_sqlserver"
      sqlserver.DbConnectionPoolDataSource: "com.microsoft.sqlserver.jdbc.SQLServerConnectionPoolDataSource"
```

### External database configuration in the custom secrets file

```yaml
configuration:
  webEngine:
    customDbTypePropertiesSecret: custom-credentials-webengine-dbtype-secret
    customDbDomainPropertiesSecret: custom-credentials-webengine-dbdomain-secret
```

Make sure to create the secrets before the deployment of the Helm chart. You must reference the secret names in the custom `values.yaml` file. To create the secrets, use the following commands:

```sh
kubectl create secret generic custom-credentials-webengine-dbtype-secret --from-file=dx_dbtype.properties
kubectl create secret generic custom-credentials-webengine-dbdomain-secret --from-file=dx_dbdomain.properties
```

Create the properties files with the same properties as in the custom `values.yaml` file in the format `key=value`. For example:

```properties
db2.DbDriver=com.ibm.db2.jcc.DB2Driver
db2.DbLibrary=/opt/openliberty/wlp/usr/svrcfg/bin/db2jcc4.jar:/opt/openliberty/wlp/usr/svrcfg/bin/db2jcc_license_cu.jar
db2.JdbcProviderName=wpdbJDBC_db2
```

### Changing the database configuration

To change the database configuration, update the custom `values.yaml` file or the custom secrets file with the new values and do a `helm upgrade`. When the database configuration is changed, a Pod restart is triggered automatically. This also applies when a new secret is created and referenced in the custom `values.yaml` file. If an existing secret is updated, you must restart the Pods manually after the secret is updated for the changes to take effect.

## Using the external database and triggering the database transfer

The external database is used by setting the `configuration.webEngine.useExternalDatabase` property to `true` in the custom `values.yaml` file and doing a  `helm upgrade`. This triggers a database transfer when enabled for the first time. The database transfer is a one-time operation that copies the content of the Derby database to the external database.

To drop and recreate all existing WebEngine tables in the external database when transferring the Derby data, set the `configuration.webEngine.dropDatabaseTables` property to `true` in the custom `values.yaml` file when doing the `helm upgrade` for the database transfer. WebEngine data that may exist in the external database will be lost. If you change the `configuration.webEngine.dropDatabaseTables` property to `true`, it is recommended to immediately reset it to `false` after your `helm upgrade`.  Failure to do so could lead to unexpected loss of data.

## dbDomainProperties

Refer to the following table for more information about the properties you can use:
<!--Is \<domain\> supposed to be <domain>? -->
| Property | Description |
| --- | --- |
| <domain\>.DbType | Database management software to use for the \<domain\> domain. |
| <domain\>.DbName | The name of the database  to be used for this portal database domain. It must comply with your database management software requirements. This property that is combined with the properties schema name and JDBC database URL must be unique for the portal database domains release, community, customization, and JCR. |
| <domain\>.DbSchema | The name to be used to qualify database objects of this portal database domain. It must comply with your database management software requirements. This property that is combined with the properties database name and JDBC database URL must be unique for the portal database domains release, community, customization, and JCR. |
| <domain\>.DataSourceName | The name of the data source to be used for this portal database domain. You cannot use the reserved names releaseDS, communityDS, customizationDS, jcrDS, lmdbDS, and feedback. You can use the same name for all portal database domains that are sharing user ID, password, and JDBC database URL. |
| <domain\>.DbUrl | The JDBC database URL to be used to connect with the database of this portal database domain. It must comply with your JDBC Driver software requirements. This property that is combined with the properties database name and schema name must be unique for the portal database domains release, community, customization, and JCR. |
| <domain\>.DbUser | The database user ID to be used to configure the database objects of this portal database domain. It must comply with your database management software requirements. It is also used by the data source to connect with the database, unless you specify a runtime database user. |
| <domain\>.DbPassword | The password of the database user ID used to configure the database objects of this portal database domain. It must comply with your database management software requirements. It is also used by the data source to connect with the database, unless you specify a runtime database user. |
| <domain\>.DbRuntimeUser | The database user ID used for the data source of the portal database domain to connect with the database during day-to-day operations. It must comply with your database management software requirements. It has fewer permissions than the configuration database user (DbUser) that is used when you leave this blank.|
| <domain\>.DbRuntimePassword | The password of the database user ID used for the data source of this portal database domain to connect with the database during day-to-day operations. It must comply with your database management software requirements. |
| <domain\>.DBA.DbUser | The database administration user ID used for privileged database operations during database creation and setup for this portal database domain. It must comply with your database management software requirements. |
| <domain\>.DBA.DbPassword | The password of the database administration user ID used for privileged database operations during database creation and setup for this portal database domain. It must comply with your database management software requirements. |
| <domain\>.DbConfigRoleName | The name of the role or group for this portal database domain that includes the database permissions that are required by the configuration database user. The configuration database user configures the database objects of this portal database domain. The role or group must comply with your database management software requirements. The configuration database user must be a member of this role or group. If this role or group does not exist, create it and assign it to the release.DbUser ID. |
| <domain\>.DbRuntimeRoleName | The name of the role or group for this portal database domain that has the database permissions that are required by the runtime database user during day-to-day operations. The role or group must comply with your database management software requirements. The runtime database user must be a member of this role or group. If this role or group does not exist, create it and assign it to the release.DbRuntimeUser ID. |
| <domain\>.XDbName | The database alias used to create the database for this portal database domain. It must comply with your database management software requirements. |
| <domain\>.DbNode | The name of the database node that is used to create the database for this portal database domain. It must comply with your database management software requirements. |
| InitializeFeedbackDB | Specify how to handle the Feedback database during database transfer from Derby. |

## dbTypeProperties

Refer to the following table for more information about the properties you can use:

| Property | Description |
| --- | --- |
| db2.DbDriver | Name of the database driver class for IBM DB2. |
| db2.DbLibrary | Path to the database driver library for IBM DB2. |
| db2.JdbcProviderName | Name of the JDBC provider for IBM DB2. |
| oracle.DbDriver | Name of the database driver class for ORACLE DB. |
| oracle.DbLibrary | Path to the database driver library for ORACLE DB. |
| oracle.JdbcProviderName | Name of the JDBC provider for ORACLE DB. |
| sqlserver.DbDriver | Name of the database driver class for sqlserver DB. |
| sqlserver.DbLibrary | Path to the database driver library for sqlserver DB. |
| sqlserver.JdbcProviderName | Name of the JDBC provider for sqlserver DB. |

!!! Limitation
    Simultaneous execution of WebEngine pod scaling and external database transfer is not supported. To avoid any unexpected behavior, complete the database transfer before scaling the environment.
