---
id: db-over-ssl
title: Managing WebEngine SSL database connections
---

This document outlines how to enable Secure Sockets Layer (SSL) database connections for different databases in the WebEngine server.

!!!note
    Currently, this documentation only provides steps to connect DB2 and Oracle.

## How SSL connections are established

The SSL handshake is a process by which a client and server set the terms for secure communications during a connection. The handshake occurs before any data is exchanged.

Every Java Database Connectivity (JDBC) driver provider that supports SSL connections has their own implementations and each JDBC driver must be configured differently.

Each driver must be configured with the following capabilities:

- Enable SSL: Tell the driver to use a SSL connection instead of an insecure connection.

- Establish trust: Tell the driver where it can find trusted certificates.

!!!note
    While SSL ensures secure database connections, it is recommended to evaluate its necessity as it may introduce performance overhead to the application.

## Connecting WebEngine to DB2 over SSL

This section outlines how you can configure WebEngine to connect to DB2 over SSL (port 50001).

### Prerequisites

Before configuring the WebEngine server, SSL connections must be enabled on the DB2 server. For more information on how to enable SSL on DB2, refer to [Using an external database and database transfer](../cfg_webengine/external_db_database_transfer.md) and [Using custom certificates in WebEngine](custom_certificates.md).

To verify that the DB2 server is listening for SSL connections (for example, on port 50001), use one of the following commands:

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

2. Once the secret is created, add the secret to the DX Compose Helm charts using the `customTruststoreSecrets` parameter in the `values.yaml` file:

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

1. Add the `sslConnection=true` attribute to the `dataSource` properties element.

    To do this, add the `sslConnection=true` parameter to the `DbUrl` parameter of the DB2 domains under `dbDomainProperties` in the `values.yaml` file. For example:

    ```yaml
    configuration: 
      webEngine:
        . . . 
        dbDomainProperties:
          ....
          community.DbType: "db2"
          community.DbUrl: jdbc:db2://local-db2:50000/WPCOMM:sslConnection=true;
          ....
    ```

2. Perform a [helm upgrade](./helm_upgrade_values.md) to apply the changes.

    Once the `sslConnection=true` attribute is set in the `DbUrl`, the datasource elements in the `server.xml` file will be updated with the `sslTrustStoreLocation`, `sslTrustStorePassword`, and `sslTrustStoreType` attributes of the trusted certificate. For example:

    ```xml
    <dataSource id="community" isolationLevel="TRANSACTION_READ_COMMITTED" jndiName="jdbc/wpcommdbDS" statementCacheSize="10" type="javax.sql.XADataSource">
        <jdbcDriver javax.sql.XADataSource="com.ibm.db2.jcc.DB2XADataSource" libraryRef="global"/>
        <properties.db2.jcc databaseName="WPCOMM" driverType="4" password="{xor}OzY6K2s8MDQ6" portNumber="50000" serverName="10.134.210.37" sslConnection="true" sslTrustStoreLocation="/opt/openliberty/wlp/usr/servers/defaultServer/resources/security/truststore.p12" sslTrustStorePassword="<trustStore_password>" sslTrustStoreType="PKCS12" user="db2inst1"/>
       <connectionManager agedTimeout="7200" connectionTimeout="180" maxIdleTime="1800" maxPoolSize="100" minPoolSize="10" purgePolicy="EntirePool" reapTime="180"/>
    </dataSource>
    ```

## Connecting WebEngine to Oracle over SSL

This section outlines how you can configure WebEngine to connect to Oracle Relational Database Service (RDS) over SSL (port 2484).

### Prerequisites

Before configuring the WebEngine server, SSL connections must be enabled on the Oracle server.

If you're using an Amazon RDS for Oracle instance, ensure the following:

- The DB parameter group enables TCP/IP with SSL (TCPS) on port `2484`.
- `SSL_VERSION` is set (for example, `1.2`).
- The RDS instance has a valid server certificate, and you're using the root Certificate Authority (CA) certificate on the client side.

For more information on how to enable SSL on Oracle, refer to [Using an external database and database transfer](../cfg_webengine/external_db_database_transfer.md) and [Using custom certificates in WebEngine](custom_certificates.md).

To verify that the Oracle server is listening for SSL connections (for example, on port 2484), use one of the following commands:

- `openssl s_client -connect <db-identifier>.<unique-identifier>.<region>.rds.amazonaws.com:2484 -tls1_2`
- `nc -zv <db-identifier>.<unique-identifier>.<region>.rds.amazonaws.com 2484`

Once the Oracle server is listening on the SSL port (2484), you can configure the WebEngine server to connect to Oracle over SSL.

### Oracle SSL configuration overview

When configuring WebEngine to connect to [Oracle over SSL](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.Oracle.Options.SSL.html){target="_blank"} it is essential to ensure the following key settings are correctly configured:

- TCPS protocol: Ensure the Oracle JDBC connection URL uses the `@tcps` protocol to enable secure communication over SSL. This ensures that all data transmitted between the WebEngine server and the Oracle database is encrypted.

- SSL version: Explicitly set the Transport Layer Security (TLS) version to ensure compatibility with the Oracle RDS instance. For example, you can set the [TLS version to 1.2](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.Oracle.Options.SSL.html#Appendix.Oracle.Options.SSL.TLS){target="_blank"}, which is widely supported and provides robust security.

- `DbUrl` parameter setting: Configure the `DbUrl` parameter in the `values.yaml` file using the following configuration:

    ```yaml
    community.DbUrl: jdbc:oracle:thin:@tcps://<db-identifier>.<unique-identifier>.<region>.rds.amazonaws.com:2484/<service-name>
    ```

- Truststore configuration: Ensure that the Oracle RDS root CA certificate is added to the truststore. Then, specify the truststore location, type, and password in the `connectionProperties` attribute.

For detailed steps on enabling SSL for Oracle, refer to the following sections:

- [Adding the Oracle SSL certificate to a secret](#adding-the-oracle-ssl-certificate-to-a-secret)
- [Configuring the Oracle JDBC driver and WebEngine server for SSL connection](#configuring-the-oracle-jdbc-driver-and-webengine-server-for-ssl-connection)

By following these guidelines, you can establish a secure and reliable SSL connection between WebEngine and Oracle RDS.

### Adding the Oracle SSL certificate to a secret

Refer to the following steps to add the Oracle SSL certificate to a secret.

1. Use the following `kubectl` command to add the certificate (for example, `server.crt`) to a secret:

    ```bash
    kubectl create secret generic db-secret --from-file=server.crt -n dxns
    ```

2. Once the secret is created, add the secret to the DX Compose Helm charts using the `customTruststoreSecrets` parameter in the `values.yaml` file:

    ```yaml
    configuration: 
      webEngine:
        . . . 
        customTruststoreSecrets: 
          db-secret: db-secret
    ```

    The truststore that includes the Oracle SSL certificate will be located at: `/opt/openliberty/wlp/usr/servers/defaultServer/resources/security/truststore.p12`

### Configuring the Oracle JDBC driver and WebEngine server for SSL connection

Refer to the following steps to enable SSL connections on the Oracle driver.

1. Add the `connectionProperties` attribute to the `dataSource` properties element.

    To do this, add the `@tcps` protocol with the SSL port 2484 to the `DbUrl` parameter of the Oracle domains under `dbDomainProperties` in the values.yaml file. For example:

    ```yaml
    configuration: 
      webEngine:
        . . . 
        dbDomainProperties: 
          ....
          community.DbType: oracle
          community.DbUrl: jdbc:oracle:thin:@tcps://<db-identifier>.<unique-identifier>.<region>.rds.amazonaws.com:2484/<service-name>
          ....
    ```

    The `@tcps` parameter specifies the use of the [TLS protocol](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.Oracle.Options.SSL.html#Appendix.Oracle.Options.SSL.TLS){target="_blank"} for secure database connections.

2. Perform a [helm upgrade](./helm_upgrade_values.md) to apply the changes.

    Once the `@tcps` protocol is set with the SSL port `2484` in the `DbUrl`, the datasource elements in the `server.xml` file will be updated with the `connectionProperties` attribute with the values of truststore location, truststore password, and the truststore type of the trusted certificate. For example:

    ```xml
    <dataSource id="community" isolationLevel="TRANSACTION_READ_COMMITTED" jndiName="jdbc/wpcommdbDS" statementCacheSize="10" type="javax.sql.XADataSource">
        <jdbcDriver javax.sql.XADataSource="oracle.jdbc.xa.client.OracleXADataSource" libraryRef="global"/>
        <properties.oracle URL="jdbc:oracle:thin:@tcps://<db-identifier>.<unique-identifier>.<region>.rds.amazonaws.com:2484/<service-name>" connectionProperties="javax.net.ssl.trustStore=/opt/openliberty/wlp/usr/servers/defaultServer/resources/security/truststore.p12;javax.net.ssl.trustStoreType=PKCS12;javax.net.ssl.trustStorePassword=<truststore-password>" password="{xor}L28tKz4zayo=" user="cwdb01"/>
        <connectionManager agedTimeout="7200" connectionTimeout="180" maxIdleTime="1800" maxPoolSize="100" minPoolSize="10" purgePolicy="EntirePool" reapTime="180"/>
    </dataSource>
    ```

???+ info "Related information"
    - [Using an external database and database transfer](../cfg_webengine/external_db_database_transfer.md)
    - [Using custom certificates in WebEngine](custom_certificates.md)
