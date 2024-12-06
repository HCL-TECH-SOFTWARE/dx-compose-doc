---
id: custom-secrets
title: Using custom secrets in WebEngine
---

This document outlines how to use custom secrets in the WebEngine server configuration through the `values.yaml` file.

Apart from administrator credentials, there can be use cases where additional credentials, secrets, or key files are required. To pass them to the deployment, you can use the `configuration.webEngine.customSecrets` value to reference additional [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/){target="_blank"}.

Secrets are both injected as environment variables and mounted as files in `/mnt/customSecrets` in a subfolder named after the referenced key. From there, you can reference secrets in the server configuration or in [configOverrideFiles](./configuration_changes_using_overrides.md). All keys and values under `customSecrets` must consist of lowercase alphanumeric characters or dashes (-), and must start and end with an alphanumeric character (for example, `my-name`, or `123-abc`). `helm install` throws one of the following errors if this criterion is not met:

- `configuration.webEngine.customSecrets: Additional property is not allowed`
- `configuration.webEngine.customSecrets.: Does not match pattern '^\[a-z0-9\]([-a-z0-9]*[a-z0-9])?$'`

## Using custom secrets to define administrator password

To use a custom secret to define the WebEngine administrator password, see [Updating the default administrator password](update_wpsadmin_password.md) for instructions.

!!!note
       It is not possible to change the `wpsadmin` username at this time.
       
## Using custom secrets as credentials

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

This results in:

- The environment variables `LDAP_USERNAME` and `LDAP_PASSWORD` being injected into the Pod.

- The files `LDAP_USERNAME` and `LDAP_PASSWORD` being mounted in `/mnt/customSecrets/ldap-credentials` inside the webEngine Pod, each containing the values specified in the secret.

You can then reference the environment variables in any of the server configurations. For example, `configOverrideFiles` for LDAP:

```yaml
configuration: 
  webEngine:
    . . .
    configOverrideFiles:
      ldapOverride.xml: | 
        <server description="DX Web Engine server"> 
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

## Using custom secrets as a key file

The following is a sample command for creating a secret `my-custom-ltpa-key` from an LTPA key file, including the entry `LTPA_KEY`:

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

This results in:

- The environment variables `ltpa.keys` being injected into the Pod.

- The file `ltpa.keys` being mounted in `/mnt/customSecrets/ltpa-key` inside the Pod containing the same content as the input file.

You can then reference the file in any of the server configurations. For example, to use the LTPA key for the server:

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

Perform a [Helm upgrade](./helm_upgrade_values.md) to apply the changes.