---
id: default-basic-registry-configuration
title: Configuring the default basic registry
---

This topic provides information about the default basic registry configuration in HCL Digital Experience (DX) Compose. The basic registry is a file-based user registry that stores user credentials directly in the Liberty server configuration. Starting with CF234, the default basic registry configuration has been externalized to Helm values. Starting with CF235, all registry settings, including enabling or disabling the basic registry, the realm name, and the administrator username and group, are fully configurable.

The following changes have been made to the basic registry configuration:

- The default basic registry is now controlled using Helm values.
- The test users `admin1` and `nonadmin` have been removed from the default configuration.

    !!!note
        If your scripts, tests, or applications rely on these users, you must recreate them using configuration overrides.

- The `nonadmins` user group has been removed from the default configuration.

## Default basic registry configuration

By default, the basic registry is enabled and configured with the following settings:

```yaml
security:
  webEngine:
    basicRegistry:
      enabled: true
      realm: "defaultWIMFileBasedRealm"
```

This configuration creates a single administrator user (`wpsadmin`) that belongs to the `wpsadmins` group, which is granted the administrator role.

!!!note
    Starting with CF235, you can change the administrator username, disable the basic registry for LDAP-only deployments, and customize the realm name. For details, see [Configuring the administrator user and group](configure_default_admin_user.md) and [Updating the default administrator password](update_wpsadmin_password.md).

## Disabling the basic registry

You can disable the basic registry to rely exclusively on LDAP authentication. Set `enabled` to `false`, ensure `webEngineAdminGroup` points to a valid LDAP group DN, and provide the LDAP administrator credentials via `customWebEngineSecret`:

```yaml
security:
  webEngine:
    webEngineUser: ""
    webEnginePassword: ""
    webEngineAdminGroup: "cn=admins,ou=groups,dc=example,dc=com"
    customWebEngineSecret: "CUSTOM_SECRET_NAME"
    basicRegistry:
      enabled: false
```

!!!note
    When disabling the basic registry, both `webEngineAdminGroup` and the credentials in `customWebEngineSecret` must reference valid entries in your LDAP directory. The WebEngine requires at least one administrator to be defined at startup. For steps on creating the secret with LDAP credentials, see [Configuring the administrator user and group](configure_default_admin_user.md#changing-to-an-ldap-user-as-administrator).

## Customizing the basic registry realm

You can customize the realm name for the basic registry by modifying the `realm` value:

```yaml
security:
  webEngine:
    basicRegistry:
      enabled: true
      realm: "myCustomRealm"
```

The realm name is used in the `basicRegistry` configuration and in the federated repository `participatingBaseEntry`.

## Adding additional users to the basic registry

To add additional users or groups to the basic registry, use configuration overrides. For more information, see [Configuration changes using overrides](configuration_changes_using_overrides.md).

For administrator identity configuration, including changing the administrator username and group, see [Changing the default administrator user](configure_default_admin_user.md).
