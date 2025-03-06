---
id: custom-certificates
title: Using custom certificates in WebEngine
---

This topic provides the steps on how to add custom certificates to the WebEngine server configuration through the Helm `values.yaml` file.

You can use the `customKeystoreSecrets` and `customTruststoreSecrets` parameters to reference multiple keystore secrets and truststore secrets respectively. These keystore secrets contain the certificates and keys required for Secure Sockets Layer (SSL) communication with the WebEngine server and for encrypted communication with other services and truststore secrets to trust certificates of other services.

## Adding custom certificates using the `values.yaml` file

Each secret specified in `customKeystoreSecrets` is mounted into its own folder under the `/mnt/certs/keystores` directory, and each secret specified in `customTruststoreSecrets` is mounted into its own folder under the `/mnt/certs/truststores` directory in the container. During system startup, the WebEngine server scans for subfolders under `/mnt/certs/keystores` and `/mnt/certs/truststores`. Each subfolder represents a separate mounted secret. The server uses keytool and openssl to create the keystore and truststore files and import the provided certificates and keys. The keystore is created at `resources/security/key.p12` and the truststore at `resources/security/truststore.p12` within the Open Liberty server directory.

Helm parameters `customKeystoreSecrets` and/or `customTruststoreSecrets` trigger mounting and processing of the corresponding secrets. A random password is generated and inserted into XML override snippets—created at:

- `configDropins/keystoreOverrides/customKeyStore.xml` (if keystore secrets are provided)
- `configDropins/keystoreOverrides/customTrustStore.xml` (if truststore secrets are provided)

These snippets are applied to your server configuration to ensure the correct keystore and truststore are used.

Example XML override snippets:

```xml
<!-- customKeyStore.xml -->
<keyStore id="customKeyStore" location="key.p12" password="UvfHFmrM99KV7VU9mnTkgLQZd34=" type="PKCS12" />
```

```xml
<!-- customTrustStore.xml -->
<keyStore id="customTrustStore" location="truststore.p12" password="qvxP3kjx6u+/skWSa56/Hnkmlps=" type="PKCS12" />
```

Additionally, a custom SSL override snippet (`customSSL.xml`) is generated dynamically based on the availability of these snippets and applied to the server configuration. You can then use the `sslRef` attribute in your LDAP or OIDC override configurations etc. to test SSL communication with this custom SSL setup.

```xml
<!-- customSSL.xml -->
<ssl id="customSSLConfig" keyStoreRef="customKeyStore" trustStoreRef="customTrustStore" trustDefaultCerts="true"/>
```

### Creating KeyStore Secret

To create a new secret from the Transport Layer Security (TLS) key and certificate files, run the following command:

```sh
kubectl create secret tls tls-secret --key="certificate.key" --cert="certificate.crt"
```

### Creating TrustStore Secret

Alternatively, you can add only the SSL certificate to another secret using the following command:

```sh
kubectl create secret generic ca-secret --from-file=certificate.ca
```

!!!important
    For successful inclusion in the keystore or truststore, all secret names must be in lowercase.

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

This example aggregates all certificates and keys from the secrets specified in `customKeystoreSecrets` into the `customKeyStore`, and all certificates from the secrets specified in `customTruststoreSecrets` into the `customTrustStore`. These files serve as the default keystore and truststore for various WebEngine configuration elements that require them. As described in [Adding custom certificates using the `values.yaml` file](#adding-custom-certificates-using-the-valuesyaml-file), configuration override files are automatically generated on system startup to use the updated keystore and truststore.

!!!important
    It is required to restart the pod every time there are changes to the keystores or truststores.
