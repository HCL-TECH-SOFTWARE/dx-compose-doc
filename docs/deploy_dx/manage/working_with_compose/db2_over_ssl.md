---
id: db2-over-ssl
title: Managing Db2 over ssl in WebEngine
---

## Overview
This document outlines how to enable SSL database connections for Db2 in the WebEngine server. 

## How are SSL connections established?
The SSL handshake is a process by which a client and server set the terms for secure communications during a connection. The handshake occurs before any data is exchanged.

Every JDBC driver provider that supports SSL connections has their own implementations and each JDBC driver must be configured differently.

Each driver must be configured with the following capabilities:

- Enable SSL: Tell the driver to use a SSL connection instead of an insecure connection.

- Establish trust: Tell the driver where it can find trusted certificates.

## Prerequisite
Before configuring the WebEngine server, SSL connections must be enabled on the Db2 server.
To verify that the Db2 server is listening for SSL connections (e.g., on port 50001), use one of the following commands:

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

Once the Db2 server is listening on the SSL port (50001), we can proceed to configure the WebEngine server to connect to Db2 over SSL.

## customTruststoreSecrets Configuartion
In WebEngine server, the `customTruststoreSecrets` parameter can be used to add Db2 SSL certificate(server.crt) to a secret:

```bash
kubectl create secret generic db-secret --from-file=server.crt -n dxns
```

Once the above secret is created, we can pass this secret to `customTruststoreSecrets` in values.yaml:
```yaml
configuration: 
  webEngine:
    . . . 
    customTruststoreSecrets: 
      db-secret: db-secret
```

We can validate this in `server.xml` with following entry:

```bash
 <keyStore id="customTrustStore" location="truststore.p12" password="<trustStore_password>" type="PKCS12"/>
```

## Configure DB2 JDBC driver and WebEngine server for SSL connection
- To enable SSL connections on the Db2 driver, add the `sslConnection="true"` attribute to the dataSource properties element.

- Configure `sslTrustStoreLocation`, `sslTrustStorePassword`, and `sslTrustStoreType` attributes on the dataSource properties element that has the trusted certificate.

Following example shows the updated datasource properties for one of the domain for Db2 in WebEngine.

```yaml
 <dataSource id="community" isolationLevel="TRANSACTION_READ_COMMITTED" jndiName="jdbc/wpcommdbDS" statementCacheSize="10" type="javax.sql.XADataSource">
        <jdbcDriver javax.sql.XADataSource="com.ibm.db2.jcc.DB2XADataSource" libraryRef="global"/>
        <properties.db2.jcc databaseName="WPCOMM" driverType="4" password="{xor}OzY6K2s8MDQ6" portNumber="50000" serverName="10.134.210.37" sslConnection="true" sslTrustStoreLocation="/opt/openliberty/wlp/usr/servers/defaultServer/resources/security/truststore.p12" sslTrustStorePassword="<trustStore_password>" sslTrustStoreType="PKCS12" user="db2inst1"/>
        <connectionManager agedTimeout="7200" connectionTimeout="180" maxIdleTime="1800" maxPoolSize="100" minPoolSize="10" purgePolicy="EntirePool" reapTime="180"/>
    </dataSource>
```


**Note:** Preform a [helm upgrade](./helm_upgrade_values.md) to apply the changes.
