---
id: db-over-ssl
title: Managing Databases over SSL in WebEngine
---

## Overview
This document outlines how to enable SSL database connections for different databases in the WebEngine server.

## How are SSL connections established?
The SSL handshake is a process by which a client and server set the terms for secure communications during a connection. The handshake occurs before any data is exchanged.

Every JDBC driver provider that supports SSL connections has their own implementations and each JDBC driver must be configured differently.

Each driver must be configured with the following capabilities:

- Enable SSL: Tell the driver to use a SSL connection instead of an insecure connection.

- Establish trust: Tell the driver where it can find trusted certificates.

## DB2 over SSL 
The sections below provide information on how to configure WebEngine to connect to DB2 over SSL (port 50001).

### Prerequisite for DB2 over SSL
Before configuring the WebEngine server, SSL connections must be enabled on the DB2 server.
To verify that the DB2 server is listening for SSL connections (e.g. on port 50001), use one of the following commands:

```
netstat -tulnp | grep 50001
```
Or
```
ss -tulnp | grep 50001
```
Or
```
sudo lsof -i :50001
```

Once the DB2 server is listening on the SSL port (50001), we can proceed to configure the WebEngine server to connect to DB2 over SSL.

### customTruststoreSecrets Configuration
kubectl can be used to add the DB2 SSL certificate (in this case 'server.crt') to a secret:

```bash
kubectl create secret generic db-secret --from-file=server.crt -n dxns
```

Once the secret is created, we can pass it to the DX Compose Helm charts via `customTruststoreSecrets` in values.yaml:
```yaml
configuration: 
  webEngine:
    . . . 
    customTruststoreSecrets: 
      db-secret: db-secret
```

The truststore that includes the DB2 SSL certificate will be located at:
`/opt/openliberty/wlp/usr/servers/defaultServer/resources/security/truststore.p12`

### Configure DB2 JDBC driver and WebEngine server for SSL connection
- To enable SSL connections on the DB2 driver, add the `sslConnection="true"` attribute to the dataSource properties element.
To achieve this, pass `sslConnection="true"` in DbUrl of the DB2 domains inside dbDomainProperties in values.yaml. For e.g.

```yaml
configuration: 
  webEngine:
    . . . 
    dbDomainProperties: 
      ....
      community.DbType: "db2"
      community.DbUrl: jdbc:db2://local-db2:50000/WPCOMM:sslConnection=true;
      .....
```

Once sslConnection=true is set in the DbUrl, the datasource elements in the server.xml will be updated with `sslTrustStoreLocation`, `sslTrustStorePassword` and `sslTrustStoreType` attributes of the trusted certificate.

For e.g.

```yaml
 <dataSource id="community" isolationLevel="TRANSACTION_READ_COMMITTED" jndiName="jdbc/wpcommdbDS" statementCacheSize="10" type="javax.sql.XADataSource">
    <jdbcDriver javax.sql.XADataSource="com.ibm.db2.jcc.DB2XADataSource" libraryRef="global"/>
    <properties.db2.jcc databaseName="WPCOMM" driverType="4" password="{xor}OzY6K2s8MDQ6" portNumber="50000" serverName="10.134.210.37" sslConnection="true" sslTrustStoreLocation="/opt/openliberty/wlp/usr/servers/defaultServer/resources/security/truststore.p12" sslTrustStorePassword="<trustStore_password>" sslTrustStoreType="PKCS12" user="db2inst1"/>
    <connectionManager agedTimeout="7200" connectionTimeout="180" maxIdleTime="1800" maxPoolSize="100" minPoolSize="10" purgePolicy="EntirePool" reapTime="180"/>
  </dataSource>
```

**Note:** Perform a [helm upgrade](./helm_upgrade_values.md) to apply the changes.
