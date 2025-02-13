---
id: custom-certificates
title: Using custom certificates in WebEngine
---

This topic provides the steps on how to add custom certificates to the WebEngine server configuration through the Helm `values.yaml` file.

You can use the `customCertificateSecrets` parameter to reference multiple secrets. These secrets contain the certificates and keys required for Secure Sockets Layer (SSL) communication with the WebEngine server and for encrypted communication with other services.

## Adding custom certificates using the `values.yaml` file

Each secret specified in `customCertificateSecrets` is mounted into its own folder under the `/mnt/certs/` directory in the container. During system startup, the script `/opt/openliberty/wlp/svrcfg/bin/create_keystores.sh` is executed. This script checks each folder in `/mnt/certs/` and uses both **keytool** and **openssl** to create a keystore that aggregates all the provided certificates and keys. The keystore is located in `resources/security/key.p12` in the Open Liberty server directory.

A random password is generated for the keystore and is directly written into an XML override snippet. The following sample snippet is located in `configDropins/keystoreOverrides/defaultKeyStore.xml`. The Helm chart includes this snippet when the `customCertificateSecrets` parameter is provided.

```xml
<server description="webEngineServer">
  <include location="${server.config.dir}/configDropins/keystoreOverrides/defaultKeyStore.xml"/>
</server>
```

To create a new secret from the Transport Layer Security (TLS) key and certificate files, run the following command:

```sh
kubectl create secret tls keyAndCert --key="certificate.key" --cert="certificate.crt"
```

Alternatively, you can add only the SSL certificate to another secret using the following command:

```sh
kubectl create secret generic myCertFromFile --from-file=ca.crt
```

## Example

See the following sample configuration:

```yaml
configuration:
  webEngine:
    . . .
    customCertificateSecrets:
      keyAndCert: "keyAndCert"
      certToTrust: "myCertFromFile"
```

This example adds all certificates and keys from the secrets listed in `customCertificateSecrets` into the `defaultKeyStore`. You can then reference the `defaultKeyStore` in the `server.xml` or in a configuration override. The `defaultKeyStore` is also used as the default keystore by several configuration elements in WebEngine that require a keystore. As described in [Adding custom certificates using the `values.yaml` file](#adding-custom-certificates-using-the-valuesyaml-file), an override file is automatically generated on system startup.

The `customCertificateSecrets` keys can be anything; they are used to create a folder inside the `/mnt/certs` directory.

!!!important
    It is required to restart the pod every time there are changes to the keystores.
