---
id: custom-certificates
title: Using custom certificates in WebEngine
---

This topic provides the steps on how to add custom certificates to the WebEngine server configuration through the Helm `values.yaml` file.

You can use the `customKeystoreSecrets` and `customTruststoreSecrets` parameters to reference multiple keystore secrets and truststore secrets respectively. These keystore secrets contain the certificates and keys required for Secure Sockets Layer (SSL) communication with the WebEngine server and for encrypted communication with other services and truststore secrets to trust certificates of other services.

## Adding custom certificates using the `values.yaml` file

Each secret specified in `customKeystoreSecrets` is mounted into its own folder under the `/mnt/certs/keystores` directory, and each secret specified in `customTruststoreSecrets` is mounted into its own folder under the `/mnt/certs/truststores` directory in the container. During system startup, the WebEngine server scans for subfolders under `/mnt/certs/keystores` and `/mnt/certs/truststores`. Each subfolder represents a separate mounted secret. Subfolders in `/mnt/certs/keystores` contain certificates and keys, while those in `/mnt/certs/truststores` contain certificates. The server uses keytool and openssl to create the keystore and truststore files and import the provided certificates and keys. The keystore is created at `resources/security/key.p12` and the truststore at `resources/security/truststore.p12` within the Open Liberty server directory.

A random password is generated for both the keystore and the truststore and is directly inserted into XML override snippets. The keystore override snippet is created at `configDropins/keystoreOverrides/defaultKeyStore.xml`, while the truststore override snippet is created at `configDropins/keystoreOverrides/defaultTrustStore.xml`. The Helm chart includes these snippets when the `customKeystoreSecrets` and `customTruststoreSecrets` parameters are provided.

```xml
<server description="webEngineServer">
  <include location="${server.config.dir}/configDropins/keystoreOverrides/defaultKeyStore.xml"/>
</server>
```

To create a new secret from the Transport Layer Security (TLS) key and certificate files, run the following command:

```sh
kubectl create secret tls tls-secret --key="certificate.key" --cert="certificate.crt"
```

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

This example aggregates all certificates and keys from the secrets specified in `customKeystoreSecrets` into the `defaultKeyStore`, and all certificates from the secrets specified in `customTruststoreSecrets` into the `defaultTruststore`. You can then reference the `defaultKeyStore` and `defaultTruststore` in your `server.xml` or in a configuration override. These files serve as the default keystore and truststore for various WebEngine configuration elements that require them. As described in [Adding custom certificates using the `values.yaml` file](#adding-custom-certificates-using-the-valuesyaml-file), override files are automatically generated on system startup.

Each key in `customKeystoreSecrets` and `customTruststoreSecrets` is used to create a subfolder within `/mnt/certs/keystores` and `/mnt/certs/truststores`, respectively. For proper folder creation, these keys should be in lowercase (i.e., they must not contain capital letters).

!!!important
    It is required to restart the pod every time there are changes to the keystores or truststores.
