---
id: configure_jaas_modules
title: Configuring HCL Sammple JAAS modules for use with transient users in DX Compose
---

While enabling transient users allows external OIDC users to log in, custom Java Authentication and Authorization Service (JAAS) login modules can provide further integration. This topic provides the steps to enable the HCL provided sample Java Authentication and Authorization Service (JAAS) modules for transient users. For the sample modules deployment instructions, we have configured an [Auth0](https://auth0.auth0.com/){target="_blank"} account and are using the Default App values.

!!!warning "Sample Code Disclaimer"
The JAAS login modules described (HCLDummyJAASSimpleAuth0 and HCLDummyJAASGroupsAuth0) are provided as samples for proof-of-concept and testing purposes only. They have not been fully evaluated for security vulnerabilities. Any implementation based on this sample code should undergo thorough security analysis and testing prior to use in a production environment. You may need to customize them to fit your specific security and attribute/group mapping requirements.

## Prerequisites

<!-- Placeholder for instructions on how/where to download the Dummy modules -->

Ensure that OIDC authentication is already enabled and configured in your HCL DX Compose deployment. For more details, refer to [Configuring DX Compose to use an OIDC identity provider](./configure_compose_to_use_oidc.md).

Ensure that transient users are already enabled and configured in your HCL DX Compose deployment. For more details, refer to [Configuring transient users in DX Compose with OpenID Connect](./configure_transient_users.md).

Ensure you have built a custom WebEngine image with the HCL provided sample JAAS modules.  For more details, refer to [Customizing the HCL DX Compose WebEngine image](./customize_webengine_image.md).

For our sample deployment we used the following Dockerfile contents to build the custom image.

<pre>
    ```
    # Dockerfile contents:

    FROM oci://hclcr.io/dx-compose/hcl-dx-deployment/webengine:CF228_20250516-1642_34573

    # Copy the custom modules into the customized image
    COPY --chown=dx_user:dx_users ./HCLDummyJAASSimpleAuth0LoginModule.jar /opt/openliberty/wlp/usr/servers/defaultServer/customPlugins/HCLDummyJAASSimpleAuth0LoginModule.jar

    COPY --chown=dx_user:dx_users ./HCLDummyJAASGroupsAuth0LoginModule.jar /opt/openliberty/wlp/usr/servers/defaultServer/customPlugins/HCLDummyJAASGroupsAuth0LoginModule.jar

    # Copy any necessary additional files that are required by the custom jars into the customized image
    COPY --chown=dx_user:dx_users ./auth0_opInfo.json /opt/openliberty/wlp/usr/servers/defaultServer/customPlugins/opInfo.json

    ```
</pre>

The Docker build command for this sample deployment was

    ```
    docker -D build --no-cache=true --progress=plain -t <my_custom_repository>/webengine:<my_custom_tag> .
    ```


## Enabling HCL Sample JAAS modules in DX Compose

This section describes how to deploy and configure two sample JAAS login modules:
HCLDummyJAASSimpleAuth0: Provides mapping of common attributes for a transient user.
HCLDummyJAASGroupsAuth0: In addition to attribute mapping, this module has the ability to assign a transient user to pre-configured DX groups.

Follow these steps to enable the HCL Sample JAAS modules in your DX Compose deployment:

1. Fetch the current configuration values from the running Helm release to ensure you preserve existing settings while adding the JAAS module configuration. Run the following command:

    ```sh
    helm get values dx-deployment -n dxns -o yaml -a > custom-values-all.yaml
    ```

    Replace `dx-deployment` with your Helm release name and `dxns` with your namespace if they differ. This command saves the current values to a file named `custom-values-all.yaml`.

2. In the `custom-values-all.yaml` file, add or modify the following section to enable and configure the HCL Sample JAAS Modules in your HCL DX Compose deployment. For more information see [Configuration changes using overrides](configuration_changes_using_overrides.md) and [Updating DX properties using Helm values](./update_properties_with_helm.md).

    * The `HCLDummyJAASSimpleAuth0` module focuses on mapping essential user attributes from the OIDC token (ID token or UserInfo endpoint) to the JAAS Subject.  This module makes these attributes available within the DX session. Typically mapped attributes include unique ID, username, email, and full name.

    ```yaml
    images:
    tags:
        webEngine: my_custom_tag
    configuration:
    webEngine:
        configOverrideFiles:
            jaas-simple-overrides.xml: |
              <server description="HCL Dummy JAAS Simple Overrides">
                <jaasLoginModule id="HCLDummyJAASSimpleAuth0LoginModule" className="com.hcl.HCLDummyJAASSimpleAuth0" controlFlag="REQUIRED" libraryRef="customPluginsLib">
                  <!-- options debug="true" / -->
                </jaasLoginModule>
                <jaasLoginContextEntry id="system.WEB_INBOUND" name="system.WEB_INBOUND" loginModuleRef="HCLDummyJAASSimpleAuth0LoginModule, hashtable" />
              </server>
        propertiesFilesOverrides:
            ConfigService.properties:
                redirect.logout: "true"
                redirect.logout.ssl: "true"
                redirect.logout.url: https://<dev-auth0-domain>.us.auth0.com/oidc/logout?returnTo=https://<my-dx-compose-host>.com/wps/portal
    ```

    This configuration enables the HCL DX Compose deployment to utilize enhanced functionality for your transient users by mapping additional user attributes from the OIDC provider to the DX user session.

    * The `HCLDummyJAASGroupsAuth0` module extends the functionality of HCLDummyJAASSimpleAuth0. Besides attribute mapping, it allows you to assign transient users to one or more DX groups based on information present in the OIDC claims (e.g., a groups or roles claim). This is useful for controlling access to DX resources (pages, portlets, content) based on group memberships derived from the external OIDC provider, without needing to manage these memberships directly in DX for transient users.

    ```yaml
    images:
    tags:
        webEngine: my_custom_tag
    configuration:
    webEngine:
        configOverrideFiles:
            jaas-group-overrides.xml: |
                <server description="HCL Dummy JAAS Group Overrides">
                <jaasLoginModule id="HCLDummyJAASGroupsAuth0LoginModule" className="com.hcl.HCLDummyJAASGroupsAuth0" controlFlag="REQUIRED" libraryRef="customPluginsLib">
                    <!-- options debug="true" / -->
                    <options opInfoPath="/opt/openliberty/wlp/usr/servers/defaultServer/customPlugins/opInfo.json"/>
                </jaasLoginModule>
                <jaasLoginContextEntry id="system.WEB_INBOUND" name="system.WEB_INBOUND" loginModuleRef="HCLDummyJAASGroupsAuth0LoginModule, hashtable" />
                </server>
            user-overrides.xml: |
                <server descriptions="HCL JAAS User Overrides">
                    <basicRegistry id="basic" realm="defaultWIMFileBasedRealm">
                        <group id="cn=testRole01,o=defaultWIMFileBasedRealm" name="testRole01" />
                    </basicRegistry>
                </server>
        propertiesFilesOverrides:
            PACGroupManagementService.properties:
                accessControlGroupManagement.useWSSubject: "true"
    ```

    This configuration enables the HCL DX Compose deployment to utilize enhanced functionality for your transient users including mapping additional user attributes from the OIDC provider to the DX user session or assigning transient users to specific DX groups based on OIDC claims.

3. Use the following `helm upgrade` command to apply the updated configuration. Include both the base values file and the modified `custom-values-all.yaml` file.

    ```sh
    helm -n dxns upgrade dx-deployment ./install-hcl-dx-deployment/ -f install-deploy-values.yaml -f custom-values-all.yaml
    ```

    - Replace `dxns` with your namespace, and adjust the paths to `install-hcl-dx-deployment` and the values files (`install-deploy-values.yaml` and `custom-values-all.yaml`) according to your environment.
    - The `-f` flags specify the base configuration (`install-deploy-values.yaml`) and the updated configuration (`custom-values-all.yaml`).

    For more information, see [Upgrading the Helm deployment](../working_with_compose/helm_upgrade_values.md).
