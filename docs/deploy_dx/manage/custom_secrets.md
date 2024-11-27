---
id: custom-secrets
title: Using Custom Secret in WebEngine
---

## Overview
This document outlines how to use custom secrets in the WebEngine server configuration through the `values.yaml` file.

Apart from the admin credentials, there can be use cases where additional credentials, secrets, or key files are required. To pass them to the deployment, the **configuration.webEngine.customSecrets** value can be used to reference additional [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/).

Secrets are both injected as environment variables and mounted as files in `/mnt/customSecrets` in a subfolder named after the referenced key. From there, they can be referenced in the server configuration or the [configOverrideFiles](./configuration-changes-using-overrides.md).
All keys and values under `customSecrets` must consist of lowercase alphanumeric characters or '-', and must start and end with an alphanumeric character (e.g., 'my-name', or '123-abc'). `helm install` will throw one of the following errors if this criterion is not met:

- "configuration.leap.customSecrets: Additional property is not allowed"
- "configuration.leap.customSecrets.: Does not match pattern '^[a-z0-9]([-a-z0-9]*[a-z0-9])?$'"

## Use Custom Secret for Defining the Admin User and Password

Refer to this [Update admin credential](./update-wpsadmin-password.md).

## Using Custom Secrets as Credentials

Create a secret in the Kubernetes cluster. 
For example, to create a secret named `my-custom-ldap-credentials`, which contains two entries, `LDAP_USERNAME` and `LDAP_PASSWORD`, run the following command:

```bash
kubectl create secret generic my-custom-ldap-credentials --from-literal=LDAP_USERNAME=<your-username> --from-
literal=LDAP_PASSWORD=<your-password> --namespace=<namespace> 
```

The secret is referenced as `ldap-credentials` in the custom Helm values:

```yaml
configuration: 
  webEngine:
    . . . 
    customSecrets: 
      ldap-credentials: my-custom-ldap-credential
```

This will result in:

- The environment variables `LDAP_USERNAME` and `LDAP_PASSWORD` being injected into the Pod.

- The files `LDAP_USERNAME` and `LDAP_PASSWORD` being mounted in `/mnt/customSecrets/ldap-credentials` inside the webEngine Pod each containing the values specified in the secret.

The environment variables can then be referenced in any of the server configurations. For example, configOverrideFiles for LDAP:

```yaml
configuration: 
  webEngine:
    . . .
    configOverrideFiles:
      ldapOverride.xml: | 
        <server description="DX WebEngine server"> 
          <ldapRegistry id="ldap" realm="SampleLdapIDSRealm"
            host="127.0.0.1" port="1389" ignoreCase="true"
            baseDN="dc=dx,dc=com"
            ldapType="Custom"
            sslEnabled="false"
            bindDN="${LDAP_USERNAME}"
            bindPassword="${LDAP_PASSWORD}">
            <idsFilters
              userFilter="(&amp;(uid=%v)(objectclass=inetOrgPerson))"
              groupFilter="(&amp;(cn=%v)(objectclass=groupOfUniqueNames))"
              userIdMap="*:uid"
              groupIdMap="*:cn"
              groupMemberIdMap="groupOfUniqueNames:uniqueMember">
            </idsFilters>
          </ldapRegistry>
          <federatedRepository>
            <primaryRealm name="FederatedRealm" allowOpIfRepoDown="true">
            <participatingBaseEntry name="o=defaultWIMFileBasedRealm"/>
            <participatingBaseEntry name="dc=dx,dc=com"/>
            </primaryRealm>
          </federatedRepository>
        </server>
```

## Using Custom Secrets as a Key File

Below is an example of creating a secret `my-custom-ltpa-key` from an LTPA key file including the entry `LTPA_KEY`:

``` bash
kubectl create secret generic my-custom-ltpa-key --from-file=LTPA_KEY=<path-to-key-file> --namespace=<namespace>
```

The secret is referenced as `ltpa-key` in the custom Helm values:

```yaml
configuration: 
  webEngine:
    . . . 
    customSecrets: 
      ltpa-key: "my-custom-ltpa-key"
```

This will result in:

- The environment variables `ltpa.keys` being injected into the Pod.

- The file `ltpa.keys` being mounted in `/mnt/customSecrets/ltpa-key` inside the Pod containing the same content as the input file.

The file can then be referenced in any of the server configurations. For example, to use the LTPA key for the server:

```yaml
configuration: 
  webEngine:
    . . . 
    configOverrideFiles: 
      . . .
      ltpaOverride: | 
        <server description="DX Web Engine server">  
          <ltpa keysFileName="/mnt/customSecrets/ltpa-key/ltpa.keys" keysPassword="myLtpaKeyPassword" /> 
        </server> 
```

**Note:** Preform a [helm upgrade](./helm-upgrade-values.md) to apply the changes.

