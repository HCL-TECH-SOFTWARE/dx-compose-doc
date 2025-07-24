---
id: customize_webengine_image
title: Customizing the HCL DX Compose WebEngine image
---

This topic provides the steps to build a customized HCL Digital Experience (DX) Compose WebEngine image for use in HCL DX Compose deployments.

## Customizing the HCL DX Compose WebEngine image with custom JARs (CF228 and later)

Starting with CF228, you can build a customized WebEngine image that includes customer-built JARs by following these steps:

1. Create a Dockerfile that uses an official HCL DX Compose WebEngine image as a parent image. Beginning with DX Compose CF228, the image includes a `customPlugins` directory in the server configuration location to hold custom JAR files and a `customPluginsLib` configured for use with these custom JARs.

    <pre>
        ```
        # Dockerfile contents:

        FROM oci://hclcr.io/dx-compose/hcl-dx-deployment/webengine:CF228_20250516-1642_34573

        # Copy the custom JARs into the customized image
        COPY --chown=dx_user:dx_users ./MyCompanyJar1.jar /opt/openliberty/wlp/usr/servers/defaultServer/customPlugins/MyCompanyJar1.jar

        COPY --chown=dx_user:dx_users ./MyCompanyJar2.jar /opt/openliberty/wlp/usr/servers/defaultServer/customPlugins/MyCompanyJar2.jar

        # Copy any necessary additional files that are required by the custom jars into the customized image
        COPY --chown=dx_user:dx_users ./MySupportingInfo.xml /opt/openliberty/wlp/usr/servers/defaultServer/customPlugins/MySupportingInfo.xml

        ```
    </pre>

2. Use the following command to build the image:

    ```
    docker -D build --no-cache=true --progress=plain -t <my_custom_repository>/webengine:<my_custom_tag> .
    ```

## Adding custom script plugins (CF230 and later)

Starting with CF230, you can extend WebEngine functionality by adding custom shell scripts to designated plugin directories in the container. These scripts can run during container startup or during Cumulative Fix (CF) updates.

### Custom script directories

The WebEngine container includes the following directories for customer-provided scripts:

- `/opt/openliberty/wlp/usr/svrcfg/bin/customer/startup` - Scripts in this directory run during container startup
- `/opt/openliberty/wlp/usr/svrcfg/bin/customer/update` - Scripts in this directory run during CF updates (e.g., when updating from CF228 to CF229)

!!! important
    Only scripts placed directly in these two directories will be automatically scanned and executed. You can place helper scripts in any subdirectory (e.g., `/opt/openliberty/wlp/usr/svrcfg/bin/customer/startup/helpers/` or `/opt/openliberty/wlp/usr/svrcfg/bin/customer/update/helpers/` or `/opt/openliberty/wlp/usr/svrcfg/bin/customer/helpers/`) and call them from your startup or update scripts, but they won't be executed automatically.

### Adding custom scripts to your image

1. Create a Dockerfile that builds upon an official HCL DX Compose WebEngine image. Include your custom scripts in the appropriate directories:

    <pre>
        ```
        # Dockerfile contents:

        FROM oci://hclcr.io/dx-compose/hcl-dx-deployment/webengine:CF230_20250724-1642_34573

        # Create plugin directories for customer scripts (already created in the image)
        # Copy custom startup scripts to be automatically executed
        COPY --chown=dx_user:dx_users ./startup-script1.sh /opt/openliberty/wlp/usr/svrcfg/bin/customer/startup/
        COPY --chown=dx_user:dx_users ./startup-script2.sh /opt/openliberty/wlp/usr/svrcfg/bin/customer/startup/
        
        # Copy custom update scripts to be automatically executed
        COPY --chown=dx_user:dx_users ./update-script.sh /opt/openliberty/wlp/usr/svrcfg/bin/customer/update/
        
        # Helper scripts can be placed in any subdirectory - these won't be auto-executed
        COPY --chown=dx_user:dx_users ./helpers/ /opt/openliberty/wlp/usr/svrcfg/bin/customer/helpers/
        # Or in subdirectories under startup/update
        COPY --chown=dx_user:dx_users ./startup-helpers/ /opt/openliberty/wlp/usr/svrcfg/bin/customer/startup/helpers/
        
        
        # Make all scripts executable
        RUN chmod -R +x /opt/openliberty/wlp/usr/svrcfg/bin/customer/
        ```
    </pre>

### Script guidelines and restrictions

When creating custom scripts, follow these guidelines:

- Scripts must be executable (`chmod +x`)
- Only scripts placed directly in the designated directories will be executed by the container
- For shared logic, use the documented `safe_source` function to include utility scripts

    ```bash
    # In your customer script
    source /opt/openliberty/wlp/usr/svrcfg/scripts/utility.sh
    safe_source "/opt/openliberty/wlp/usr/svrcfg/bin/common-utility/another_utility.sh"
    ```

- Do not modify or directly reference any scripts in the product feature directories
- For WebEngine utilities, use only documented utility functions from the `common-utility` directory
- You can create and use your own helper functions in any subdirectories of the `customer` directory

## Enabling the customized WebEngine image in DX Compose

Follow these steps to deploy your customized WebEngine image in your HCL DX Compose deployment:

1. Upload your customized WebEngine image to the repository used for your HCL DX Compose deployment using the following command:

    ```sh
    docker push <my_custom_repository>/webengine:<my_custom_tag>
    ```

    For more information see [Load images to your own repository](../../install/kubernetes_deployment/preparation/get_the_code/prepare_load_images.md#loading-images).

2. Fetch the current configuration values from the running Helm release to ensure you preserve existing settings while adding the new image tag value and configuration. Run the following command:

    ```sh
    helm get values dx-deployment -n dxns -o yaml -a > custom-values-all.yaml
    ```

    Replace `dx-deployment` with your Helm release name and `dxns` with your namespace if they differ. This command saves the current values to a file named `custom-values-all.yaml`.

3. In the `custom-values-all.yaml` file, modify the following sections to upgrade your image and load and configure your custom modules. Replace the JAAS module-specific sample values as needed for your deployment. For more information see [Configuration changes using overrides](configuration_changes_using_overrides.md) and [Updating DX properties using Helm values](./update_properties_with_helm.md).

    ```yaml
    images:
      tags:
        webEngine: my_custom_tag
    configuration:
      webEngine:
        configOverrideFiles:
          my-custom-module-1-overrides.xml: |
            <server description="My Proprietary Overrides">
              <customModule id="MyCompanyCustomModule1" className="path.to.your.main.class.in.module.jar.ClassName" controlFlag="REQUIRED" libraryRef="customPluginsLib">
              <options myCustomOption1="value"/>
              </customModule>
              <customModuleContextEntry id="system.WEB_INBOUND" name="system.WEB_INBOUND" loginModuleRef="MyCompanyCustomModule1, hashtable" />
            </server>
          my-custom-module-2-overrides.xml: |
            <server description="My Proprietary Overrides">
              <customModule id="MyCompanyCustomModule2" className="path.to.your.main.class.in.module.jar.ClassName" controlFlag="REQUIRED" libraryRef="customPluginsLib">
              <options myCustomOption2="value"/>
              </customModule>
              <customModuleContextEntry id="system.WEB_INBOUND" name="system.WEB_INBOUND" loginModuleRef="MyCompanyCustomModule2, hashtable" />
            </server>
        propertiesFilesOverrides:
          <propertiesFileName>:
            <propertyKey>: <propertyValue>
    ```

    This configuration enables the WebEngine server to include the custom JARs and required associated settings in your customized WebEngine image when deployed.

4. Use the following `helm upgrade` command to apply the updated configuration. Include both the base values file and the modified `custom-values-all.yaml` file.

    ```sh
    helm -n dxns upgrade dx-deployment ./install-hcl-dx-deployment/ -f install-deploy-values.yaml -f custom-values-all.yaml
    ```

    - Replace `dxns` with your namespace, and adjust the paths to `install-hcl-dx-deployment` and the values files (`install-deploy-values.yaml` and `custom-values-all.yaml`) according to your environment.
    - The `-f` flags specify the base configuration (`install-deploy-values.yaml`) and the updated configuration (`custom-values-all.yaml`).

    For more information, see [Upgrading the Helm deployment](../working_with_compose/helm_upgrade_values.md).

Once the upgrade is successfully applied, you can log in and begin using your custom modules and scripts in DX Compose.

!!! note
    At this time, adding files to the `customPlugins` directory (CF228) and custom scripts to the designated plugin directories (CF230) are the only supported customizations of the image.
