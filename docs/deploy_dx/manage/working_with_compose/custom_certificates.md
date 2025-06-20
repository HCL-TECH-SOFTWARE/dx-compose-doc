---
id: custom-certificates
title: Using custom certificates in WebEngine
---

This topic provides the steps on how to add custom certificates to the WebEngine server configuration through the Helm `values.yaml` file.

You can use the `customKeystoreSecrets` and `customTruststoreSecrets` parameters to reference multiple keystore secrets and truststore secrets respectively. These keystore secrets contain the certificates and keys required for Secure Sockets Layer (SSL) communication with the WebEngine server and for encrypted communication with other services and truststore secrets to trust certificates of other services.

## Adding custom certificates using the `values.yaml` file

Each secret specified in `customKeystoreSecrets` is mounted into its own folder under the `/mnt/certs/keystores` directory. Each secret specified in `customTruststoreSecrets` is mounted into its own folder under the `/mnt/certs/truststores` directory in the container. During system startup, the WebEngine server scans for subfolders under `/mnt/certs/keystores` and `/mnt/certs/truststores`. Each subfolder represents a separate mounted secret. The server uses keytool and OpenSSL to create the keystore and truststore files and import the provided certificates and keys. The keystore is created at `resources/security/key.p12` and the truststore at `resources/security/truststore.p12` within the Open Liberty server directory.

Helm parameters `customKeystoreSecrets` and `customTruststoreSecrets` trigger mounting and processing of the corresponding secrets. A random password is generated and inserted into the XML override snippets, which are created as follows:

- If keystore secrets are provided, certificate files in the keystore secrets are imported into a keystore override snippet created at `configDropins/keystoreOverrides/customKeyStore.xml`.
- If truststore secrets are provided, certificate files in the truststore secrets are imported into a truststore override snippet created at `configDropins/keystoreOverrides/customTrustStore.xml`.

These snippets are applied to your server configuration to ensure the correct keystore and truststore are used. For example:

```xml
<!-- customKeyStore.xml -->
<keyStore id="customKeyStore" location="key.p12" password="UvfHFmrM99KV7VU9mnTkgLQZd34=" type="PKCS12" />
```

```xml
<!-- customTrustStore.xml -->
<keyStore id="customTrustStore" location="truststore.p12" password="qvxP3kjx6u+/skWSa56/Hnkmlps=" type="PKCS12" />
```

In addition, a custom SSL override snippet (`customSSL.xml`) is always generated and applied to the server configuration, even if only one of the custom keystore or truststore contains certificates. This is because the SSL configuration requires both entries even if one store is empty. The generated SSL snippet references both `customKeyStore` and `customTrustStore`.

```xml
<!-- customSSL.xml -->
<ssl id="customSSLConfig" keyStoreRef="customKeyStore" trustStoreRef="customTrustStore" trustDefaultCerts="true"/>
```

You can reference this custom SSL configuration using the `sslRef` attribute in your [LDAP Registry configuration](https://openliberty.io/docs/latest/reference/feature/ldapRegistry-3.0.html){target="_blank"} or in your [OpenID Connect Client configuration](https://openliberty.io/docs/latest/reference/config/openidConnectClient.html){target="_blank"} to enable secure SSL communication.

### Creating a keystore secret

To create a new secret from the Transport Layer Security (TLS) key and certificate files, run the following command:

```sh
kubectl create secret tls tls-secret --key="certificate.key" --cert="certificate.crt"
```

### Creating a truststore secret

Alternatively, you can add only the SSL certificate to another secret using the following command:

```sh
kubectl create secret generic ca-secret --from-file=certificate.ca
```

## Example

See the following sample configuration:

```yaml
configuration:
  webEngine:
    . . .
    customKeystoreSecrets:
      tls-secret-1: "tls-secret-1"
      tls-secret-2: "tls-secret-2"
    customTruststoreSecrets:
      ca-secret-1: "ca-secret-1"
      ca-secret-2: "ca-secret-2"
```

!!!important
    For successful inclusion in the keystore or truststore, all secret key names (for example, `tls-secret-1:`) must be in lowercase.

This example aggregates all certificates and keys from the secrets specified in `customKeystoreSecrets` into the `customKeyStore`, and all certificates from the secrets specified in `customTruststoreSecrets` into the `customTrustStore`. These files serve as the default keystore and truststore for various WebEngine configuration elements that require them. As described in [Adding custom certificates using the `values.yaml` file](#adding-custom-certificates-using-the-valuesyaml-file), configuration override files are automatically generated on system startup to use the updated keystore and truststore.

!!!important
    It is required to restart the pod every time there are changes to the keystores or truststores.
