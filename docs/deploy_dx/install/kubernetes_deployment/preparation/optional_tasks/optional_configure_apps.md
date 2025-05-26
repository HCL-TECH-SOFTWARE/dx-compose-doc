# Configure Applications

## WebEngine

### Supported LDAP configuration

You can specify a LDAP configuration that can be used by HCL Digital Experience Compose 9.5.

The Helm chart provides a `ldap` section under the `configuration` and `webengine` section. This section can be used to configure a `none`, `dx` or `other` LDAP. This defaults to none, so there is no LDAP configured.

If you adjust this to `other`, you can configure an external LDAP that you want to connect to. WebEngine is then configured to use this LDAP.

Currently, the configuration capability is quite limited.

**Example Configuration**

You can use the following syntax in your custom-values.yaml file to adjust LDAP settings:

```yaml
# Application configuration
configuration:
  # Application specific configuration for WebEngine
  webEngine:
    # Settings for LDAP configuration
    ldap:
      # Determines which type of LDAP to use
      # Accepts: "none", "dx" or "other"
      # "none" - no LDAP configuration
      # "dx" - use DX openLDAP and configure it
      # "other" - use provided configuration for other LDAP
      type: "none"
      # User used to connect to LDAP, only used if ldap type is "other"
      bindUser: ""
      # Password used to connect to LDAP, only used if ldap type is "other"
      bindPassword: ""
      # Suffix in LDAP, only used if ldap type is "other"
      suffix: ""
      # Host of LDAP, only used if ldap type is "other"
      host: ""
      # Port of LDAP, only used if ldap type is "other"
      port: 
      # Supported LDAP Server types - CUSTOM
      serverType: "CUSTOM"
      # LDAP configuration id
      id: "dx_compose_ldap"
      # Mapping attributes between LDAP and DX Compose, LDAP attribute names (array of elements)
      attributeMappingLdap: 
        - "mail"
        - "title"
        - "userPassword"
      # Mapping attributes between LDAP and DX Compose, DX attribute names (array of elements)
      attributeMappingPortal: 
        - "ibm-primaryEmail"
        - "ibm-jobTitle"
        - "password"
      # Non-supported LDAP attributes (array of elements)
      attributeNonSupported: 
        - "certificate"
        - "members"
```

Refer to the following Help Center documentation for more information about LDAP configuration:

-   [Enable federated security](../../../../manage/working_with_compose/cfg_parameters/manage_users_groups_liberty.md#configuring-federated-user-registry)
-   [Troubleshooting](../../../../manage/working_with_compose/troubleshooting/index.md)


### Authoring/Rendering configuration

You can choose if the environment you deploy is configured as a WCM authoring or rendering type. This has implications on things like caching of WebEngine.

As default, this defaults to true. The deployment is configured as an authoring environment.

If you want to adjust this to deploy a rendering environment, you can use the following syntax in your custom-values.yaml file:

```yaml
# Application configuration
configuration:
  # Application specific configuration for WebEngine
  webEngine:
    # Settings for tuning
    tuning:
      # Configures if the environment should be configured for authoring or not
      authoring: false
```

## OpenLDAP configuration

If you choose to deploy the OpenLDAP container in your deployment, you can change country, organization and suffix, that may be configured in OpenLDAP for use.

Use the following syntax in your custom-values.yaml file to adjust the configuration:

```yaml
# Application configuration
configuration:
  # Application specific configuration for Open LDAP
  openLdap:
    # Country configuration for Open LDAP
    country: "US"
    # Org configuration for Open LDAP
    org: "DX"
    # Suffix configuration for Open LDAP
    suffix: "dc=dx,dc=com"
```