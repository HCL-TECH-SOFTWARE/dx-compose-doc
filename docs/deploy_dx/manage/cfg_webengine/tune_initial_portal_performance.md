---
id: tune_initial_portal_performance
title: Tune DX Compose Prior to Load Testing
---
This topic provides the steps for updating the default administrator (wpsadmin) password.

!!!note "Limitation" 
    It is not possible to change the `wpsadmin` username at this time. However, you can update the `wpsadmin` password.

To update the default administrator password, refer to the following steps:

1. Create a secret with the new administrator password using the following command:

    ```sh
    kubectl create secret generic CUSTOM_SECRET_NAME --from-literal=username=wpsadmin --from-literal=password=CUSTOM_ADMIN_PASSWORD --namespace=<NAMESPACE>
    ```

    Replace the values for the following: 
    - `CUSTOM_SECRET_NAME` with the name of the secret.
    - `CUSTOM_ADMIN_PASSWORD` with the new administrator password.

2. Update the `values.yaml` file with the secret name. See the following sample:

    ```yaml
    security:
      webEngine:
        webEngineUser: "wpsadmin"
        webEnginePassword: "WEB_ENGINE_PASSWORD"
        customWebEngineSecret: "CUSTOM_SECRET_NAME"
    ```

    - Replace `CUSTOM_SECRET_NAME` with the name of the secret created in Step 1.

    - Replace `WEB_ENGINE_PASSWORD` with the new administrator password.

    - Make sure to either provide a `customWebEngineSecret` or a `webEngineUser` and `webEnginePassword`.

3. Do a [Helm upgrade](../working_with_compose/helm_upgrade_values.md).

4. [Restart the server](../working_with_compose/restart_webengine_server.md) to apply the updated password.

For adding other administrators and users with no administrator access, see [configOverrideFiles](configuration_changes_using_overrides.md#configuring-users-or-user-groups).
