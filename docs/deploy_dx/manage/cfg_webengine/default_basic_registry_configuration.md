---
id: default-basic-registry-configuration
title: Configuring the default basic registry
---

This topic provides information about the default basic registry configuration in HCL Digital Experience (DX) Compose starting with CF234. The basic registry is a file-based user registry that stores user credentials directly in the Liberty server configuration. Starting with CF234, the default basic registry configuration has been externalized to Helm values.

### Key changes

The following changes have been made to the basic registry configuration:

- The default basic registry is now controlled via Helm values.
- The test users `admin1` and `nonadmin` have been removed from the default configuration. If your scripts, tests, or applications rely on these users, you must either recreate them using configuration overrides.
- The `nonadmins` user group has been removed from the default configuration.

## Default basic registry configuration

By default, the default basic registry is enabled and configured with the following settings:

```yaml
security:
  webEngine:
    basicRegistry:
      enabled: true
      realm: "defaultWIMFileBasedRealm"
```

This configuration creates a single administrator user (`wpsadmin`) that belongs to the `wpsadmins` group, which is granted the administrator role.

!!!warning
    The PUMA code still relies on the `wpsadmin` user from the default basic registry. Disabling the basic registry may cause unexpected behavior or failures. Support for LDAP-only deployments without the default basic registry (wpsadmin) is planned for a future release. For now, keep `basicRegistry.enabled: true` even if you are using LDAP for external user authentication. Additionally, while the realm name is configurable via Helm values, continue to use the default realm value (`defaultWIMFileBasedRealm`) to maintain compatibility with internal PUMA code dependencies.


