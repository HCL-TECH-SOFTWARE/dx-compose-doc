---
id: update-default-admin-password
title: Update Default Admin Password
---

!!! warning "Current Limitation"
    It is not possible to change the wpsadmin username at this time. The password can be updated.

## Overview
This document provides a snippet for updating the Default Admin password.

### Steps to Update Default Admin Password

1. Create a secret with the new admin password:
    ```sh
    kubectl create secret generic CUSTOM_SECRET_NAME --from-literal=username=wpsadmin --from-literal=password=CUSTOM_ADMIN_PASSWORD --namespace=dxns
    ```
    Replace the following: 
    - `CUSTOM_SECRET_NAME` with the name of the secret.
    - `CUSTOM_ADMIN_PASSWORD` with the new admin password.

2. Update the `values.yaml` file with secret name and do a [Helm upgrade](./helm_upgrade_values.md).
    ```yaml
    security:
      webEngine:
        webEngineUser: "wpsadmin"
        webEnginePassword: "WEB_ENGINE_PASSWORD"
        customWebEngineSecret: "CUSTOM_SECRET_NAME"
    ```

    - Replace `CUSTOM_SECRET_NAME` with the name of the secret created in step 1.

    - Replace `WEB_ENGINE_PASSWORD` with the new admin password.

    - Make sure either provide `customWebEngineSecret` or `webEngineUser` & `webEnginePassword`. 


**Note:** To apply the updated password, a [server restart](./restart_webengine_server.md) is required.

Refer to this for adding other admin and non-admin user: [configOverrideFiles](configuration_changes_using_overrides.md#user--user-group-through-configuration-overrides).
