---
id: update-default-admin-password
title: Updating the default administrator password
---
This topic provides the steps for updating the default administrator password.

!!!note
    To change the administrator username, refer to [Changing the default administrator user](configure_default_admin_user.md).

To update the default administrator password, refer to the following steps:

1. Create a secret with the new administrator password using the following command:

    ```sh
    kubectl create secret generic custom-secret-name --from-literal=username=wpsadmin --from-literal=password=CUSTOM_ADMIN_PASSWORD --namespace=<NAMESPACE>
    ```

    Replace the values for the following:

    - `custom-secret-name` with the name of the secret.
    - `CUSTOM_ADMIN_PASSWORD` with the new administrator password.

    !!!important
        Your `custom-secret-name` must be in lowercase. Kubernetes Secret names are validated against RFC 1123 DNS subdomain rules, which strictly enforce lowercase alphanumeric characters, hyphens (`-`), or dots (`.`).

2. Update the `values.yaml` file with the secret name. See the following sample:

    ```yaml
    security:
      webEngine:
        webEngineUser: "wpsadmin"
        webEnginePassword: "WEB_ENGINE_PASSWORD"
        customWebEngineSecret: "custom-secret-name"
    ```

    - Replace `custom-secret-name` with the name of the secret created in Step 1.

    - Replace `WEB_ENGINE_PASSWORD` with the new administrator password.

    - Make sure to either provide a `customWebEngineSecret` or a `webEngineUser` and `webEnginePassword`.

3. Perform a [Helm upgrade](../working_with_compose/helm_upgrade_values.md).

4. [Restart the server](../working_with_compose/restart_webengine_server.md) to apply the updated password.

For adding other administrators and users with no administrator access, refer to [Configuring users or user groups](configuration_changes_using_overrides.md#configuring-users-or-user-groups).
