---
id: db-over-ssl
title: Managing databases over SSL in WebEngine
---

This document outlines how to enable Secure Sockets Layer (SSL) database connections for different databases in the WebEngine server.

## How SSL connections are established

The SSL handshake is a process by which a client and server set the terms for secure communications during a connection. The handshake occurs before any data is exchanged.

Every Java Database Connectivity (JDBC) driver provider that supports SSL connections has their own implementations and each JDBC driver must be configured differently.

Each driver must be configured with the following capabilities:

- Enable SSL: Tell the driver to use a SSL connection instead of an insecure connection.

- Establish trust: Tell the driver where it can find trusted certificates.

## Connecting WebEngine to DB2 over SSL

This section outlines how you can configure WebEngine to connect to DB2 over SSL (port 50001).

### Prerequisites

Before configuring the WebEngine server, SSL connections must be enabled on the DB2 server. To verify that the DB2 server is listening for SSL connections (for example, on port 50001), use one of the following commands:

- `netstat -tulnp | grep 50001`
- `ss -tulnp | grep 50001`
- `sudo lsof -i :50001`

Once the DB2 server is listening on the SSL port (50001), you can configure the WebEngine server to connect to DB2 over SSL.

### Adding the DB2 SSL certificate to a secret

Refer to the following steps to add the DB2 certificate to a secret.

1. Use the following `kubectl` command to add the certificate (for example, `server.crt`) to a secret:

    ```bash
    kubectl create secret generic db-secret --from-file=server.crt -n dxns
    ```

2. Once the secret is created, add it to the DX Compose Helm charts using the `customTruststoreSecrets` parameter in the `values.yaml` file:

    ```yaml
    configuration: 
    webEngine:
        . . . 
        customTruststoreSecrets: 
        db-secret: db-secret
    ```

    The truststore that includes the DB2 SSL certificate will be located at: `/opt/openliberty/wlp/usr/servers/defaultServer/resources/security/truststore.p12`

### Configuring the DB2 JDBC driver and WebEngine server for SSL connection

Refer to the following steps to enable SSL connections on the DB2 driver.

1. Add the `sslConnection="true"` attribute to the `dataSource` properties element.

    To do this, add the `sslConnection="true"` parameter to the `DbUrl` of the DB2 domains under `dbDomainProperties` in the `values.yaml` file. For example:

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

2. Perform a [helm upgrade](./helm_upgrade_values.md) to apply the changes.

    Once the `sslConnection=true` attribute is set in the `DbUrl`, the datasource elements in the `server.xml` file will be updated with the `sslTrustStoreLocation`, `sslTrustStorePassword` and `sslTrustStoreType` attributes of the trusted certificate. For example:

    ```yaml
    <dataSource id="community" isolationLevel="TRANSACTION_READ_COMMITTED" jndiName="jdbc/wpcommdbDS" statementCacheSize="10" type="javax.sql.XADataSource">
        <jdbcDriver javax.sql.XADataSource="com.ibm.db2.jcc.DB2XADataSource" libraryRef="global"/>
        <properties.db2.jcc databaseName="WPCOMM" driverType="4" password="{xor}OzY6K2s8MDQ6" portNumber="50000" serverName="10.134.210.37" sslConnection="true" sslTrustStoreLocation="/opt/openliberty/wlp/usr/servers/defaultServer/resources/security/truststore.p12" sslTrustStorePassword="<trustStore_password>" sslTrustStoreType="PKCS12" user="db2inst1"/>
       <connectionManager agedTimeout="7200" connectionTimeout="180" maxIdleTime="1800" maxPoolSize="100" minPoolSize="10" purgePolicy="EntirePool" reapTime="180"/>
    </dataSource>
    ```
