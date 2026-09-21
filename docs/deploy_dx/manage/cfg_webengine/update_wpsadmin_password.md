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

## HCLSoftware U learning materials

!!!note
	Access HCLSoftware U resources for free. [Log in](https://hclsoftwareu.hcl-software.com/login-page){target="_blank"} or [Sign up](https://hclsoftwareu.hcl-software.com/hclsoftwareu-signup){target="_blank"} to get started. If you have further questions, [Contact us](https://hclsoftwareu.hcl-software.com/contactus){target="_blank"} or check the [FAQ](https://hclsoftwareu.hcl-software.com/frequently-asked-questions){target="_blank"}.


To learn how to do a traditional installation, go to [Deployment for Intermediate Users](https://hclsoftwareu.hcl-software.com/component/axs/?view=sso_config&id=4&forward=https%3A%2F%2Fhclsoftwareu.hcl-software.com%2Fcourses%2Flesson%2F%3Fid%3D3086){target="_blank"}. In this course, you will also learn about additional installation tasks that apply to both container-based and traditional deployments using the Configuration Wizard, DXClient, ConfigEngine, and more. You can try it out using the [Deployment Lab](https://hclsoftwareu.hcl-software.com/images/Lc4sMQCcN5uxXmL13gSlsxClNTU3Mjc3NTc4MTc2/DS_Academy/DX/Administrator/HDX-ADM-200_Deployment_Lab.pdf){target="_blank"} and corresponding [Deployment Lab Resources](https://hclsoftwareu.hcl-software.com/images/Lc4sMQCcN5uxXmL13gSlsxClNTU3Mjc3NTc4MTc2/DS_Academy/DX/Administrator/HDX-ADM-200_Deployment_Lab_Resources.zip){target="_blank"}.
