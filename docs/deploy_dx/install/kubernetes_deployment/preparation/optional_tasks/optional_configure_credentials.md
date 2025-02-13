# Configure Credentials

HCL Digital Experience Compose 9.5 uses several credentials in its deployment to manage access between applications and from outside the container deployment.

## Randomized passwords

Upon initial deployment, passwords in HCL Digital Experience Compose 9.5 are randomized and stored in secrets. Retrieve the randomized credentials using the following commands:

To get the credentials for HCL Digital Experience WebEngine administrative access, use:
```bash
kubectl get secret <release-name>-web-engine-wps --namespace <namespace> -o=jsonpath="{.data.username}" | base64 --decode && echo
kubectl get secret <release-name>-web-engine-wps --namespace <namespace> -o=jsonpath="{.data.password}" | base64 --decode && echo
```


## Adjusting default credentials

You can adjust the default credentials that HCL Digital Experience Compose 9.5 is using by adding the following syntax to your custom-values.yaml file and changing the values you need:

```yaml
# Security related configuration, e.g. default credentials
security:
  # Security configuration for WebEngine
  webEngine:
    # Credentials used for HCL Digital Experience WebEngine administrative access.
    # The credentials defined in these values define the HCL Digital Experience WebEngine administrative user. The user gets created if necessary and/or the password is set to the current value.
    # Admin user for WebEngine, can not be adjusted currently.
    webEngineUser: "wpsadmin"
    webEnginePassword: ""

  # Security configuration for Open LDAP
  openLdap:
    # Admin user for Open LDAP, can not be adjusted currently.
    ldapUser: "REDACTED"
    # Admin password for Open LDAP
    ldapPassword: "REDACTED"
```

## Updating credentials

If the user credentials were changed manually and not through the Helm values, you must update the values for WebEngine credentials in Helm. Refer to [Adjusting default credentials](#adjusting-default-credentials) for reference. If you are using the [custom secret](#guidelines-for-configuring-credentials-from-secrets), you must also set the credentials in the secret to the current credentials. Then, execute a `helm upgrade` with those values. You can use the Helm values to change the credentials.

If an LDAP is configured as the user registry, you must manually set the security credentials to the credentials of the administrator user from LDAP. If the users are changed in the LDAP, you must manually update the security credentials in the Helm chart. The credentials are used in several startup and configuration scripts. Changes in the Helm values will not cause any changes to the LDAP users.

## Upgrading credentials

Before upgrading, ensure that the current credentials are [set properly](#updating-credentials) in the Helm values.

## WebEngine security credentials
The security credentials defined in the `security` section of the Helm values are necessary to pass the user credentials to the HCL Digital Experience Compose startup scripts. The behavior slightly differs depending on the user registry that is configured for HCL Digital Experience Compose. See [Registry Types](#registry-types).

## Registry Types

### LDAP
If [LDAP is configured](./optional_configure_apps.md#supported-ldap-configuration) in the Helm values under `configuration.webEngine.ldap`, the webEngine security credentials need to be manually set to the credentials of the administrator user(s) from LDAP and kept up to date manually in the helm chart if the users are changed in the LDAP. The credentials are used in several startup and configuration scripts. Changes in the helm values will not cause any changes to the LDAP users.

Please refer to the [Updating the default administrator password](../../../../manage/cfg_webengine/update_wpsadmin_password.md) topic for additional information on how to manually change credentials.

### File-based user registry
If no LDAP is configured in the Helm values, HCL Digital Experience Compose is configured with a default file-based user repository. In this case, the security credentials for WebEngine that are specified in the `custom-values.yaml` are applied to the file-based registry. This means that any changes to the values are automatically reflected in the administrator user accounts for WebEngine and DX Compose.

| Value | Effect |
| --- | --- |
| `security.webEngine.webEngineUser` | Creates a user with this name if it does not exist already. Then makes that user the WebEngine primary admin user. |
| `security.webEngine.webEnginePassword` | Sets the password of the `webEngineUser` to this value. |

## Configuring Credentials from Secrets

You can also configure the credentials that HCL Digital Experience Compose 9.5 is using by creating a secret that contains the credentials and referencing them by adding the secret name to your `custom-values.yaml` file and doing a `helm upgrade` to apply it in the deployments:

```yaml
# Referencing the secret to configure credential, e.g. webEngine credentials
security:
  # Security configuration for webEngine
  webEngine:
    # Provide a secret name that will be used to set credentials for WebEngine
    # Required attributes:
    #   - username
    #   - password
    customWebEngineSecret: ""

```

!!! important
    Only one method of configuring credentials can be applied at once. Either configure it by using secrets or using the credentials in the Helm `custom-values.yaml`, unused credential values should be explicitly set to **empty/null**.

!!! important
    A Helm upgrade is required in order for the new credentials values to reflect inside the containers.

!!! Note
    The mechanism described above for file-based user registries applies in the same way when custom secrets are used.

### Guidelines for Configuring Credentials from Secrets

#### 1. Create a Custom Secret

Create a secret that will be used to reference credentials, this secret should contain all the required attributes (e.g. "username", "password") needed by the credentials.

There are two ways to create and deploy custom secrets:

**By Kubectl Command**\
This is the preferred way of creating a secret inside a cluster, Kubernetes will handle the encoding of the key-value pairs in a base64-encoding format. 

```console
$ kubectl create secret generic <secret-name> --from-literal=username=<your-username> --from-literal=password=<your-password> --namespace=<namespace>
```

For details please refer to the official Kubernetes documentation about [Managing Secrets using kubectl](https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-kubectl/).

**By YAML files**\
Secrets can also be created using a secret yaml manifest. 

!!! note
    The string values assigned in the data fields of the secret should be base64-encoded. The containers expect a base64-encoded string to be passed from the secrets key-value pairs. The credentials will not work if the values passed are plain strings.

```yaml
# Example manifest for creating secret by using a yaml file
apiVersion: "v1"
kind: "Secret"
data:
  # The value of the key-value pair should be strictly base64-encoded
  username: <username>
  # The value of the key-value pair should be strictly base64-encoded
  password: <password>
metadata:
  labels:
  name: <secret-name>
  namespace: <namespace>
type: "Opaque"
```

#### 2. Reference the Secret

Once the secret is created inside the cluster, you can now reference them in their respective custom secret fields inside the `custom-values.yaml` under `security` section. See this [example](./optional_configure_credentials.md#configuring-credentials-from-secrets) for reference.

!!! note
    For WebEngine LTPA AND LDAP you can reference your secrets under `configuration.webEngine` section of the Helm values.

#### 3. Check the Required Attributes in Secrets

There are multiple credentials used in HCL Digital Experience Compose 9.5. Each application has different required attributes for credentials. If you want to use a secret to configure credentials for a specific application, check the data attributes of the secret that you are using. This is for the Helm chart to map and have those values passed or cascaded accordingly to each application. 

`Persistence DAM User Credential secret` has a username limitation. The username can begin with lowercase letters or an underscore and can contain only lowercase letters, numbers, underscore, or a dollar sign. The maximum length is 63 characters.

!!! note
    Helm validates the inputs and the deployment will not be applied if required attributes are not set properly in the custom secrets.

Here's a list of the required credential attributes for each application:

| Secrets | Helm Reference | Required Attributes | Application |
|-----------------------------------------------|--------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|-------------------|
| WebEngine Credential secret | `security.webEngine.customWebEngineSecret` | `username`  <br> `password` | WebEngine |
| WebEngine LDAP Credential secret | `configuration.webEngine.ldap.customLdapSecret` | `bindUser` <br> `bindPassword` | WebEngine |
| WebEngine LTPA Credential secret | `configuration.webEngine.ltpa.customLtpaSecret` | `ltpa.version` <br> `ltpa.realm` <br> `ltpa.desKey` <br> `ltpa.privateKey` <br> `ltpa.publicKey` <br> `ltpa.password` | WebEngine |
| WebEngine Content AI Secret | `security.webEngine.customWebEngineContentAISecret` | `apiKey` | WebEngine |
| DAM Plugin Google Vision Credential secret | `security.damPluginGoogleVision.customDamGoogleVisionSecret` | `authenticationKey` <br> `apiKey` | DAM Google Vision |
| DAM Plugin Kaltura Credential secret | `security.damPluginKaltura.customDamKalturaSecret` | `authenticationKey` <br> `secretKey` | DAM Kaltura |
| Persistence Connection Pool Credential secret | `security.persistence.customConnectionPoolSecret` | `username` <br> `password` | Persistence |
| Persistence DAM User Credential secret | `security.digitalAssetManagement.customDamSecret` | `username`  <br> `password` | Digital Asset Management |
| Persistence Replication Credential secret | `security.digitalAssetManagement.customReplicationSecret` | `username`  <br> `password` | Digital Asset Management |
| Persistence User Credential secret | `security.digitalAssetManagement.customDBSecret` | `username`  <br> `password` | Digital Asset Management |
| Image Processor Credential secret | `security.imageProcessor.customImageProcessorSecret` | `authenticationKey` | Image Processor |
| License Manager Credential secret | `security.licenseManager.customLicenseManagerSecret` | `username`  <br> `password` | License Manager |
| Open LDAP Credential secret | `security.openLdap.customLdapSecret` | `username`  <br> `password` | Open LDAP         |


**WebEngine Credential secret**
```yaml
apiVersion: "v1"
kind: "Secret"
data:
  # Required attribute
  username: <username>
  # Required attribute
  password: <password>
metadata:
  labels:
  name: sample-web-engine-secret
  namespace: <namespace>
type: "Opaque"
```

**WebEngine LDAP Credential secret**
```yaml
apiVersion: "v1"
kind: "Secret"
data:
  # Required attribute
  bindUser: <bindUser>
  # Required attribute
  bindPassword: <bindPassword>
metadata:
  labels:
  name: sample-web-engine-ldap-secret
  namespace: <namespace>
type: "Opaque"
```

**WebEngine LTPA Credential secret**
```yaml
apiVersion: "v1"
kind: "Secret"
data:
  # Required attribute
  "ltpa.version": <version>
  # Required attribute
  "ltpa.realm": <realm>
  # Required attribute
  "ltpa.desKey": <desKey>
  # Required attribute
  "ltpa.privateKey": <privateKey>
  # Required attribute
  "ltpa.publicKey": <publicKey>
  # Required attribute
  "ltpa.password": <password>
metadata:
  labels:
  name: sample-web-engine-ltpa-secret
  namespace: <namespace>
type: "Opaque"
```

**WebEngine Content AI Secret**
```yaml
apiVersion: "v1"
kind: "Secret"
data:
  # Required attribute
  apiKey: <apiKey>
metadata:
  labels:
  name: sample-web-engine-content-ai-secret
  namespace: <namespace>
type: "Opaque"
```

**DAM Plugin Google Vision Credential secret**
```yaml
apiVersion: "v1"
kind: "Secret"
data:
  # Required attribute
  authenticationKey: <authenticationKey>
  # Required attribute
  apiKey: <apiKey>
metadata:
  labels:
  name: sample-google-vision-secret
  namespace: <namespace>
type: "Opaque"
```

**DAM Plugin Kaltura Credential secret**
```yaml
apiVersion: "v1"
kind: "Secret"
data:
  # Required attribute
  authenticationKey: <authenticationKey>
  # Required attribute
  secretKey: <secretKey>
metadata:
  labels:
  name: sample-kaltura-secret
  namespace: <namespace>
type: "Opaque"
```

**Persistence Connection Pool Credential secret**
```yaml
apiVersion: "v1"
kind: "Secret"
data:
  # Required attribute
  username: <username>
  # Required attribute
  password: <password>
metadata:
  labels:
  name: sample-connection-pool-secret
  namespace: <namespace>
type: "Opaque"
```

**Persistence DAM User Credential secret**
```yaml
apiVersion: "v1"
kind: "Secret"
data:
  # Required attribute. The username can begin with lowercase letters or an underscore and can contain only lowercase letters, numbers, underscore, or a dollar sign. The maximum length is 63 characters.
  username: <username>
  # Required attribute
  password: <password>
metadata:
  labels:
  name: sample-dam-user-secret
  namespace: <namespace>
type: "Opaque"
```

**Persistence Replication Credential secret**
```yaml
apiVersion: "v1"
kind: "Secret"
data:
  # Required attribute
  username: <username>
  # Required attribute
  password: <password>
metadata:
  labels:
  name: sample-replication-secret
  namespace: <namespace>
type: "Opaque"
```

**Persistence User Credential secret**
```yaml
apiVersion: "v1"
kind: "Secret"
data:
  # Required attribute
  username: <username>
  # Required attribute
  password: <password>
metadata:
  labels:
  name: sample-replication-secret
  namespace: <namespace>
type: "Opaque"
```

**Image Processor Credential secret**
```yaml
apiVersion: "v1"
kind: "Secret"
data:
  # Required attribute
  authenticationKey: <authenticationKey>
metadata:
  labels:
  name: sample-kaltura-secret
  namespace: <namespace>
type: "Opaque"
```

**License Manager Credential secret**
```yaml
apiVersion: "v1"
kind: "Secret"
data:
  # Required attribute
  username: <username>
  # Required attribute
  password: <password>
metadata:
  labels:
  name: sample-license-manager-secret
  namespace: <namespace>
type: "Opaque"
```

**Open LDAP Credential secret**
```yaml
apiVersion: "v1"
kind: "Secret"
data:
  # Required attribute
  username: <username>
  # Required attribute
  password: <password>
metadata:
  labels:
  name: sample-open-ldap-secret
  namespace: <namespace>
type: "Opaque"
```
