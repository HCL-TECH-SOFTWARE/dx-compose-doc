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
kubectl create secret tls myTlsCertSecret --key="certificate.key" --cert="certificate.crt"
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
      myTlsCertSecret: "myTlsCertSecret"
      myCertFromFile: "myCertFromFile"
```

This example will add all certificates and keys from the Secrets into the `defaultKeyStore`. For a certificate, either `keyAndCert` or `certToTrust` is sufficient. The `defaultKeyStore` can then be referenced in the `server.xml` or any overrides and is used as the default by many configuration elements in webEngine that require a keystore.

!!!note
       Changes to the keystores DO require a restart of the Pod.
