---
id: custom-certificates
title: Using custom certificates in WebEngine
---

This document outlines how to add custom certificates to the WebEngine server configuration via the Helm `values.yaml` file.

The `customCertificateSecrets` parameter can be used to reference multiple Secrets that contain the certificates and keys required for SSL communication with the WebEngine server and for encrypted communication with other services.

## Implementation

Each Secret specified in `customCertificateSecrets` is mounted into its own folder under the `/mnt/certs/` directory in the container.
Upon startup, the script `/opt/openliberty/wlp/svrcfg/bin/create_keystores.sh` is executed. This script checks each folder in `/mnt/certs/` and uses both **keytool** and **openssl** to create a keystore that aggregates all the provided certificates and keys.
The keystore is located at `resources/security/key.p12` in the Open Liberty server directory.
A random password is generated for the keystore and is directly written into an XML override snippet. This snippet is located at `configDropins/keystoreOverrides/defaultKeyStore.xml`. The Helm chart includes this snippet when `customCertificateSecrets` are provided.

```xml
<server description="webEngineServer">
  <include location="${server.config.dir}/configDropins/keystoreOverrides/defaultKeyStore.xml"/>
</server>
```

## Example

To create a new Secret from TLS key and certificate files:

```sh
kubectl create secret tls keyAndCert --key="certificate.key" --cert="certificate.crt"
```

Alternatively, you can add only the SSL certificate to another Secret:
```sh
kubectl create secret generic myCertFromFile --from-file=ca.crt
```

```yaml
configuration:
  webEngine:
    . . .
    customCertificateSecrets:
      keyAndCert: "keyAndCert"
      certToTrust: "myCertFromFile"
```

This example will add all certificates and keys from the Secrets listed in `customCertificateSecrets` into the `defaultKeyStore`. The `defaultKeyStore` can then be referenced in the `server.xml` or an override and is used as the default by many configuration elements in WebEngine that require a keystore. As described above, an override file will be automatically generated on startup.

The `customCertificateSecrets` keys can be anything; they are used to create a folder inside the /mnt/certs directory.

!!!note
       Changes to the keystores DO require a restart of the Pod.
