---
id: configure_ltpa_key
title: Configure an LTPA Key
---

## Introduction
This document outlines the steps to configure an LTPA key for the DX WebEngine server.

## Prerequisites

- You must have the LTPA key file available.
- You must have the LTPA key password available as an xor encoded value.

An LTPA key can be generated inside a running WebEngine Pod using the following command:

```bash
kubectl -n <NAMESPACE> exec pod/<RELEASE-NAME>-web-engine-0 -- bash -c "/opt/openliberty/wlp/bin/securityUtility createLTPAKeys --password=<PASSWORD> --file=/tmp/ltpa.keys | grep -oP 'keysPassword=\"\K[^\"]+'"
```

The output will be the xor encoded password. For example:

```bash
{xor}MiYvPiwsKDAtOw==
```

Then print the actual ltap key using the following command:

```bash
kubectl -n <NAMESPACE> exec pod/<RELEASE-NAME>-web-engine-0 -- bash -c "cat /tmp/ltpa.keys && rm /tmp/ltpa.keys"
```

The output will be the LTPA key. For example:

```bash
#Tue Nov 19 13:49:28 UTC 2024
com.ibm.websphere.ltpa.version=1.0
com.ibm.websphere.ltpa.3DESKey=8ZqBjki1aQ5ZdkbKtt0f/oo0YSuRdCIH740gNP29cMg\=
com.ibm.websphere.ltpa.PrivateKey=iOvAlCGZfOkAU9NszfKCnamSv2ZPXE2PoOIKUjROdZWUnVyz+I9CrJs0LL+7MVJfp0rb8xC6R5CrixIjGFuASPwXbShxNyMZNRqCGE+pb+c833tH7fbFuKhsQDvZoTrEz8K/SjnJHkvNaK+n5ryiL1FN9UqlodozN3ZnO4BqxunYgoQp3NWTyrNmEBK0jhbSnX0OApFI62Ms2ncwbo1QSQzEDHrSdgrPBPue/Ej7soGTkCHgMlRiZzQeddc8EEcXXBymCf/2yQ8CZC9sgxyDA+zdptF2TJW6Utc09wzeRy7hd5gTJPqSfmzcJXiIWm1rO6XZNwR+58vHki1/bmSxxkU9Icsdealy7XVxhs0HzxQ\=
com.ibm.websphere.CreationHost=localhost
com.ibm.websphere.ltpa.Realm=defaultRealm
com.ibm.websphere.ltpa.PublicKey=AJbYDotq40lFm4PqE2qKSOT0ZTOnO8Ss4MUWzyqTFjZHNHJ76oEP/W26RihgWgjepa/01tpG5DhqClqf7sdMWBWwNc1ZU0shZ4GGsJXEj0oZS1XY9Yn2C1KiQIFx5CGwupB3glTVonW+Q8Z4yEGv6iTrpN+kUWluIBVJmIbQh1iZAQAB
com.ibm.websphere.CreationDate=Tue Nov 19 13\:49\:28 UTC 2024
```

Save the LTPA key as a file and keep the xor encoded password for later use.

## Procedure

Create a Kubernetes secret to store the LTPA key and password. The secret must include two entries: `ltpa.keys` and `password`. Use the file and password from the previous steps as input.

```bash
  kubectl -n <NAMESPACE> create secret generic <SECRET NAME> --from-file=ltpa.keys=<PATH/TO/LTPA.KEYS> --from-literal=password=<PASSWORD>
```

## Configure the WebEngine server to use the LTPA key

In the custom values file, add the following configuration where the `customLtpaSecret` is the name of the secret created in the previous step.

```yaml
configuration:
  webEngine:
    ltpa:
      customLtpaSecret: "my-secret"
```

Apply the changes via Helm upgrade.