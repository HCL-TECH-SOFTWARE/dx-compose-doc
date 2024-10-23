---
id: update-default-admin-password
title: Update Default Admin Password
---

## Overview
This document provides a snippet for updating the Default Admin username & password.

### Steps to Update Default Admin Username & Password

1. Create a secret with the new admin username and password:
    ```sh
    kubectl create secret generic CUSTOM_SECRET_NAME --from-literal=username=CUSTOM_ADMIN_USER --from-literal=password=CUSTOM_ADMIN_PASSWORD --namespace=dxns
    ```
    Replace the following: 
    - `CUSTOM_SECRET_NAME` with the name of the secret.
    - `CUSTOM_ADMIN_USER` with the new admin username.
    - `CUSTOM_ADMIN_PASSWORD` with the new admin password.

2. Update the `values.yaml` file with secret name and do a Helm upgrade: [more details](./helm-upgrade-values.md).
    ```yaml
    incubator:
      configuration:
        webEngine:
          portalAdminSecret: "CUSTOM_SECRET_NAME"
    ```
    Replace `CUSTOM_SECRET_NAME` with the name of the secret created in step 1.

**Note:** The above steps will update the default admin username and password. But need a server or pod restart as other application used the default admin credentials.

Refer to this for adding other admin and non-admin user: [configOverrideFiles](configuration-changes-using-overrides.md#user--user-group-through-configuration-overrides).
