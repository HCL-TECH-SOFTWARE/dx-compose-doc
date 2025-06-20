---
id: configure_transient_users
title: Configuring transient users in DX Compose with OpenID Connect
---

This topic provides the steps to enable transient users in HCL Digital Experience (DX) Compose when using an OpenID Connect (OIDC) identity provider. Transient users are authenticated externally through the OIDC provider and do not require a corresponding entry in the local DX Compose user registry. This allows users managed by an external identity provider to access DX Compose without duplicating their accounts locally.

!!!note "Limitation"
    The transient user suffix is not currently configurable and is set to `o=transparent`. Avoid reusing this identifier for non-transient users to prevent conflicts.

## Prerequisites

Ensure that OIDC authentication is already enabled and configured in your HCL DX Compose deployment. For more details, refer to [Configuring DX Compose to use an OIDC identity provider](./configure_compose_to_use_oidc.md).

## Enabling transient users in DX Compose

Follow these steps to enable transient users in your DX Compose deployment:

1. Fetch the current configuration values from the running Helm release to ensure you preserve existing settings while adding the transient user configuration. Run the following command:

    ```sh
    helm get values dx-deployment -n dxns -o yaml -a > custom-values-all.yaml
    ```

    Replace `dx-deployment` with your Helm release name and `dxns` with your namespace if they differ. This command saves the current values to a file named `custom-values-all.yaml`.

2. In the `custom-values-all.yaml` file, add or modify the following section to enable transient users:

    ```yaml
    configuration:
      webEngine:
        transientUserRegistry:
          # Enable transient users
          enabled: true
    ```

    This configuration enables the `transientUserRegistry` feature.

3. Use the following `helm upgrade` command to apply the updated configuration. Include both the base values file and the modified `custom-values-all.yaml` file.

    ```sh
    helm -n dxns upgrade dx-deployment ./install-hcl-dx-deployment/ -f install-deploy-values.yaml -f custom-values-all.yaml
    ```

    - Replace `dxns` with your namespace, and adjust the paths to `install-hcl-dx-deployment` and the values files (`install-deploy-values.yaml` and `custom-values-all.yaml`) according to your environment.
    - The `-f` flags specify the base configuration (`install-deploy-values.yaml`) and the updated configuration (`custom-values-all.yaml`).

    For more information, see [Upgrading the Helm deployment](../working_with_compose/helm_upgrade_values.md).

Once the upgrade is successfully applied, you can log in with a transient user authenticated through the OpenID Connect (OIDC) identity provider. Ensure that the transient user is properly authenticated by the external OIDC provider and the `o=transparent` suffix is correctly configured in the federated repository if applicable. This setup allows seamless access for transient users without requiring local user registry entries in DX Compose.

### Enabling transient users for federated repositories

If you are using a federated repository, ensure the following entry exists in your configuration to support transient users:

```
<participatingBaseEntry name="o=transparent"/>
```

See the following sample configuration:

```
<federatedRepository>
    <primaryRealm name="FederatedRealm" allowOpIfRepoDown="true">
        <participatingBaseEntry name="o=defaultWIMFileBasedRealm"/>
        <participatingBaseEntry name="dc=dx,dc=com"/>
        <participatingBaseEntry name="o=transparent"/>
    </primaryRealm>
</federatedRepository>
```

For more information on setting up a federated repository, refer to [Configuring federated repositories](../working_with_compose/cfg_parameters/manage_users_groups_liberty.md#configuring-federated-user-registry).

!!!note "Accessing the Portal login page directly"
    In cases where you may need to bypass OIDC authentication (for example, when authenticating as an LDAP user), you can access the portal login page directly by appending the following path to your base portal URL:

    ```
    /poc?uri=nm:oid:wps.Login
    ```
    For example, `https://example.com/wps/poc?uri=nm:oid:wps.Login`.

    Alternatively, you can use a friendly URL configured for your portal login page.