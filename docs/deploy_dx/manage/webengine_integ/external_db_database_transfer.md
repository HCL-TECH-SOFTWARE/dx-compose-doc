---
id: external-db-database-transfer
title: Using an External Database and Database Transfer
---

## Introduction

By default, WebEngine comes with a local Derby database included in the image and persisted in a PersistentVolume. The Derby database can be used to test the basic functionality of HCL Digital Experience (DX) in a Kubernetes deployment. This will work for single-Pod deployments. However, for production environments, it is required to use an external database for better performance and scalability. This document outlines the steps and configurations to take to connect to an external Database and transfer the content of the Derby database to the external database in HCL Digital Experience (DX) in a Kubernetes deployment.

!!! note
    For the currently supported external databases, refer to the [Limitations topic](../limitations/index.md).

## Configuring an External Database

The external database is configured in the Helm custom values file. The values can be added directly to the custom values file or referenced from secrets to hide the plain text entries that can contain credentials.

There are two sets of values used to configure the external database:

- `configuration.webEngine.dbDomainProperties`
- `configuration.webEngine.dbTypeProperties`

The following secrets that can be used instead of the entries above:

- `configuration.webEngine.customDbDomainPropertiesSecret`
- `configuration.webEngine.customDbTypePropertiesSecret`

!!! note
    The `customDbDomainPropertiesSecret` and `customDbTypePropertiesSecret` secrets must be created before the deployment of the Helm chart. If the secrets are used, all property values set in the custom values file will be ignored. Therefore the all properties must be set in the secrets, not only the overridden ones.

### External Database Configuration in the custom values file

```yaml
configuration:
  webEngine:
    dbDomainProperties:
      InitializeFeedbackDB: "true"
      feedback.DbType: "db2"
      feedback.DbName: "WPFDBK"
      feedback.DbSchema: "feedback"
      feedback.DataSourceName: "wpfdbkdbDS"
      feedback.DbUrl: "jdbc:db2://<replace-db-host>:<replace-db-port>/WPFDBK:returnAlias=0;"
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
      likeminds.DbName: "WPLM"
      likeminds.DbSchema: "likeminds"
      likeminds.DataSourceName: "wplmdbDS"
      likeminds.DbUrl: "jdbc:db2://<replace-db-host>:<replace-db-port>/WPLM:returnAlias=0;"
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
      release.DbName: "WPREL"
      release.DbSchema: "release"
      release.DataSourceName: "wpreldbDS"
      release.DbUrl: "jdbc:db2://<replace-db-host>:<replace-db-port>/WPREL:returnAlias=0;"
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
      community.DbName: "WPCOMM"
      community.DbSchema: "community"
      community.DataSourceName: "wpcommdbDS"
      community.DbUrl: "jdbc:db2://<replace-db-host>:<replace-db-port>/WPCOMM:returnAlias=0;"
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
      customization.DbName: "WPCUST"
      customization.DbSchema: "customization"
      customization.DataSourceName: "wpcustdbDS"
      customization.DbUrl: "jdbc:db2://<replace-db-host>:<replace-db-port>/WPCUST:returnAlias=0;"
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
      jcr.DbName: "WPJCR"
      jcr.DbSchema: "jcr"
      jcr.DataSourceName: "wpjcrdbDS"
      jcr.DbUrl: "jdbc:db2://<replace-db-host>:<replace-db-port>/WPJCR:returnAlias=0;"
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
      db2.DbLibrary: "/opt/openliberty/wlp/usr/svrcfg/bin/db2jcc4.jar:/opt/openliberty/wlp/usr/svrcfg/bin/db2jcc_license_cu.jar"
      db2.JdbcProviderName: "wpdbJDBC_db2"
```

### External Database Configuration in the custom secrets file

```yaml
configuration:
  webEngine:
    customDbTypePropertiesSecret: custom-credentials-webengine-dbtype-secret
    customDbDomainPropertiesSecret: custom-credentials-webengine-dbdomain-secret
```

The secrets must be created before the deployment of the Helm chart. The secret names must be referenced in the custom values file. To create the secrets, use the following commands:

```sh
kubectl create secret generic custom-credentials-webengine-dbtype-secret --from-file=dx_dbdomain.properties
kubectl create secret generic custom-credentials-webengine-dbdomain-secret --from-file=dx_dbtype.properties
```

The properties files must be created with the same properties as in the custom values file in the format `key=value`. For example:

```properties
db2.DbDriver=com.ibm.db2.jcc.DB2Driver
db2.DbLibrary=/opt/openliberty/wlp/usr/svrcfg/bin/db2jcc4.jar:/opt/openliberty/wlp/usr/svrcfg/bin/db2jcc_license_cu.jar
db2.JdbcProviderName=wpdbJDBC_db2
```

### Changing the database configuration

To change the database configuration, update the custom values file or the custom secrets file with the new values and do a `helm upgrade`. When the database configuration is changed a Pod restart is triggered automatically. This also applies when a new secret is created and referenced in the custom values file. If an existing secret is updated, the Pods have to be restarted manually after the secret is updated for the changes to take effect.

## Using the external database and triggering the database transfer

The external database is used by setting the `configuration.webEngine.useExternalDatabase` property to `true` in the custom values file and doing a  `helm upgrade`. This triggers a database transfer when enabled for the first time. The database transfer is a one-time operation that copies the content of the Derby database to the external database.

## dbDomainProperties

| Property | Description |
| --- | --- |
| \<domain\>.DbType | Database management software to use for the \<domain\> domain. |
| \<domain\>.DbName | The name of the database  to be used for this portal database domain. It must comply with your database management software requirements. This property that is combined with the properties schema name and JDBC database URL must be unique for the portal database domains release, community, customization, and JCR. |
| \<domain\>.DbSchema | The name to be used to qualify database objects of this portal database domain. It must comply with your database management software requirements. This property that is combined with the properties database name and JDBC database URL must be unique for the portal database domains release, community, customization, and JCR. |
| \<domain\>.DataSourceName | The name of the data source to be used for this portal database domain. You cannot use the reserved names releaseDS, communityDS, customizationDS, jcrDS, lmdbDS, and feedback. You can use the same name for all portal database domains that are sharing user ID, password, and JDBC database URL. |
| \<domain\>.DbUrl | The JDBC database URL to be used to connect with the database of this portal database domain. It must comply with your JDBC Driver software requirements. This property that is combined with the properties database name and schema name must be unique for the portal database domains release, community, customization, and JCR. |
| \<domain\>.DbUser | The database user ID to be used to configure the database objects of this portal database domain. It must comply with your database management software requirements. It is also used by the data source to connect with the database, unless you specify a runtime database user. |
| \<domain\>.DbPassword | The password of the database user ID used to configure the database objects of this portal database domain. It must comply with your database management software requirements. It is also used by the data source to connect with the database, unless you specify a runtime database user. |
| \<domain\>.DbRuntimeUser | The database user ID used for the data source of the portal database domain to connect with the database during day-to-day operations. It must comply with your database management software requirements. It has fewer permissions than the configuration database user (DbUser) that is used when you leave this blank.
 |
| \<domain\>.DbRuntimePassword | The password of the database user ID used for the data source of this portal database domain to connect with the database during day-to-day operations. It must comply with your database management software requirements. |
| \<domain\>.DBA.DbUser | The database administration user ID used for privileged database operations during database creation and setup for this portal database domain. It must comply with your database management software requirements. |
| \<domain\>.DBA.DbPassword | The password of the database administration user ID used for privileged database operations during database creation and setup for this portal database domain. It must comply with your database management software requirements. |
| \<domain\>.DbConfigRoleName | The name of the role or group for this portal database domain that includes the database permissions that are required by the configuration database user. The configuration database user configures the database objects of this portal database domain. The role or group must comply with your database management software requirements. The configuration database user must be a member of this role or group. If this role or group does not exist, create it and assign it to the release.DbUser ID. |
| \<domain\>.DbRuntimeRoleName | The name of the role or group for this portal database domain that has the database permissions that are required by the runtime database user during day-to-day operations. The role or group must comply with your database management software requirements. The runtime database user must be a member of this role or group. If this role or group does not exist, create it and assign it to the release.DbRuntimeUser ID. |
| \<domain\>.XDbName | The database alias used to create the database for this portal database domain. It must comply with your database management software requirements. |
| \<domain\>.DbNode | The name of the database node that is used to create the database for this portal database domain. It must comply with your database management software requirements. |
| InitializeFeedbackDB | Specify how to handle the Feedback database during database transfer from Derby. |

## dbTypeProperties

| Property | Description |
| --- | --- |
| db2.DbDriver | Name of the database driver class for IBM DB2. |
| db2.DbLibrary | Path to the database driver library for IBM DB2. |
| db2.JdbcProviderName | Name of the JDBC provider for IBM DB2. |
