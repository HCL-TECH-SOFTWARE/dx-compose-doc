---
id: configure-admin-user-group
title: Configuring the administrator user and group
---

This topic provides the steps for configuring the administrator user and group in HCL Digital Experience (DX) Compose. You can set an administrator from the basic registry or from an external LDAP directory.

!!!note
    To update the administrator password only, see [Updating the default administrator password](update_wpsadmin_password.md).

## Before you begin

Review the following constraints before changing the administrator:

- **Basic registry administrator**: Set `webEngineUser` to a **short username only** (for example, `dxadmin`). Do not use a Distinguished Name (DN). The system automatically constructs the full DN as `uid=<username>,o=<realm>`.
- **LDAP administrator**: The username stored in the Kubernetes secret must be the **full DN** of the LDAP user (for example, `uid=admin,ou=users,dc=example,dc=com`). Partial or short IDs are not supported and will fail to authenticate.
- **LDAP group**: `webEngineAdminGroup` must also be the **full DN** of the LDAP group (for example, `cn=admins,ou=groups,dc=example,dc=com`).
- **Disabling the basic registry**: When `basicRegistry.enabled` is set to `false`, the `wpsadmin` user no longer exists and cannot be used for authentication. Ensure your LDAP configuration is correct before disabling.
- **Replacing the administrator**: Changing the administrator replaces `wpsadmin`. The previous administrator no longer has administrative access after the change is applied.

## Changing to a custom basic registry administrator

To change the administrator to a custom user in the basic registry:

1. Create a Kubernetes secret with the new administrator credentials:

    ```sh
    kubectl create secret generic CUSTOM_SECRET_NAME \
      --from-literal=username=CUSTOM_ADMIN_USERNAME \
      --from-literal=password=CUSTOM_ADMIN_PASSWORD \
      --namespace=<NAMESPACE>
    ```

    Replace the values for the following:
    - `CUSTOM_SECRET_NAME` with the name of the secret.
    - `CUSTOM_ADMIN_USERNAME` with the new short username (for example, `dxadmin`). Do not use a full DN.
    - `CUSTOM_ADMIN_PASSWORD` with the administrator password.

2. Update the `values.yaml` file. See the following sample:

    ```yaml
    security:
      webEngine:
        webEngineUser: ""
        webEnginePassword: ""
        webEngineAdminGroup: "CUSTOM_ADMIN_GROUP"
        customWebEngineSecret: "CUSTOM_SECRET_NAME"
        basicRegistry:
          enabled: true
          realm: "defaultWIMFileBasedRealm"
    ```

    Replace the values for the following:
    - `CUSTOM_ADMIN_GROUP` with the short group name (for example, `dxadmins`). The system constructs the full group DN as `cn=<group>,o=<realm>`.
    - `CUSTOM_SECRET_NAME` with the name of the secret created in Step 1.

    !!!note
        When using `customWebEngineSecret`, leave `webEngineUser` and `webEnginePassword` empty. Do not set both.

3. Do a [Helm upgrade](../working_with_compose/helm_upgrade_values.md).

4. [Restart the server](../working_with_compose/restart_webengine_server.md) to apply the changes if the pod doesn't automatically gets recreated.

5. Verify the change by logging in to DX Compose using the new administrator credentials and confirming that the user has full administrator access.

## Changing to an LDAP user as administrator

When using an external LDAP directory, the username and group must be full DNs and `basicRegistry.enabled` must be set to `false`.

!!!warning
    Setting `basicRegistry.enabled: false` removes the `wpsadmin` user entirely. Verify that your LDAP credentials and group DN are correct before applying this change to avoid losing administrator access. If something goes wrong, see the [Rollback](#rollback) section.

1. Create a Kubernetes secret with the LDAP user credentials. The username must be the full DN of the LDAP user:

    ```sh
    kubectl create secret generic CUSTOM_SECRET_NAME \
      --from-literal=username="uid=admin,ou=users,dc=example,dc=com" \
      --from-literal=password=LDAP_USER_PASSWORD \
      --namespace=<NAMESPACE>
    ```

    Replace the values for the following:
    - `CUSTOM_SECRET_NAME` with the name of the secret.
    - `uid=admin,ou=users,dc=example,dc=com` with the full DN of your LDAP user.
    - `LDAP_USER_PASSWORD` with the LDAP user's password.

    !!!note
        The username must be the complete DN including all organizational units. For example, `uid=admin,ou=users,dc=example,dc=com` is valid. A partial DN such as `uid=admin,dc=example,dc=com` (missing `ou=users`) may fail to resolve correctly.

2. Update the `values.yaml` file. See the following sample:

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

    Replace the values for the following:
    - `cn=admins,ou=groups,dc=example,dc=com` with the full DN of the LDAP administrator group.
    - `CUSTOM_SECRET_NAME` with the name of the secret created in Step 1.

    !!!note
        Both the secret username (`webEngineUser`) and `webEngineAdminGroup` must be full DNs when using LDAP authentication.

3. Do a [Helm upgrade](../working_with_compose/helm_upgrade_values.md).

4. [Restart the server](../working_with_compose/restart_webengine_server.md) to apply the changes.

5. Verify the change by logging in to DX Compose using the LDAP user credentials and confirming that the user has full administrator access.

For configuring the LDAP registry itself, see [Configuring LDAP](ldap_configuration.md).

## Rollback

If you provided incorrect credentials or configuration and lost administrator access, use one of the following options to revert to a working state.

### Option 1: Revert using Helm values

1. Retrieve the current deployed values:

    ```sh
    helm get values <RELEASE_NAME> -n <NAMESPACE> -o yaml -a > backup-values.yaml
    ```

2. Edit the file to restore the previous administrator configuration. The following example reverts to the default `wpsadmin` user:

    ```yaml
    security:
      webEngine:
        webEngineUser: ""
        webEnginePassword: ""
        webEngineAdminGroup: "wpsadmins"
        customWebEngineSecret: "<ORIGINAL_SECRET_NAME>"
        basicRegistry:
          enabled: true
          realm: "defaultWIMFileBasedRealm"
    ```

3. Apply the corrected values using a Helm upgrade:

    ```sh
    helm upgrade <RELEASE_NAME> <CHART_PATH> -n <NAMESPACE> -f backup-values.yaml
    ```

4. Once the pod is running, verify the rollback by logging in to DX Compose using the restored administrator credentials and confirming full administrator access.

### Option 2: Roll back using kubectl

If the pod is failing to start due to incorrect configuration, you can roll back the StatefulSet to its previous revision:

1. Check the available rollout history:

    ```sh
    kubectl rollout history statefulset/<RELEASE_NAME>-web-engine -n <NAMESPACE>
    ```

2. Roll back to the previous revision:

    ```sh
    kubectl rollout undo statefulset/<RELEASE_NAME>-web-engine -n <NAMESPACE>
    ```

    To roll back to a specific revision, use the `--to-revision` flag:

    ```sh
    kubectl rollout undo statefulset/<RELEASE_NAME>-web-engine -n <NAMESPACE> --to-revision=<REVISION_NUMBER>
    ```

3. Monitor the pod restart:

    ```sh
    kubectl get pods -n <NAMESPACE>
    ```

    Once the pod is running, verify the rollback by logging in to DX Compose using the restored administrator credentials and confirming full administrator access.

!!!note
    Rolling back the StatefulSet restores the previous pod spec but does not revert Helm values or Kubernetes secrets. After the pod is stable, update your Helm values to match the restored configuration to prevent the mismatch from causing issues on the next Helm upgrade.

For adding other administrators and users with no administrator access, see [configOverrideFiles](configuration_changes_using_overrides.md#configuring-users-or-user-groups).
