---
id: customize_webengine_image
title: Customizing the HCL DX Compose WebEngine image
---

This topic provides the steps to build a customized DX Compose WebEngine image that includes customer built jars to be used in HCL Digital Experience (DX) Compose deployments.

## Customizing the HCL DX Compose WebEngine Image

1. Create a Dockerfile that uses an official HCL DX Compose WebEngine image as a parent image.  Beginning with DX Compose 95 CF228 there is a customPlugins directory in the server configuration location in the image to hold custom jar files and a customPluginsLib configured for use with custom jars. At this time, adding files to the customPlugins directory is the only supported customization of the image.

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

Build the image

    ```
    docker -D build --no-cache=true --progress=plain -t <my_custom_repository>/webengine:<my_custom_tag> .
    ```

## Enabling the customized WebEngine image in DX Compose

Follow these steps to deploy your customized WebEngine image in your HCL DX Compose deployment:

1. Upload your customized WebEngine image to the repository used for your HCL DX Compose deployment.  For more information see [Load Images to Your Own Repository](../../install/kubernetes_deployment/preparation/get_the_code/prepare_load_images.md#loading-images)

    ```sh
    docker push <my_custom_repository>/webengine:<my_custom_tag>
    ```

2. Fetch the current configuration values from the running Helm release to ensure you preserve existing settings while adding the transient user configuration. Run the following command:

    ```sh
    helm get values dx-deployment -n dxns -o yaml -a > custom-values-all.yaml
    ```

    Replace `dx-deployment` with your Helm release name and `dxns` with your namespace if they differ. This command saves the current values to a file named `custom-values-all.yaml`.

3. In the `custom-values-all.yaml` file, modify the following sections to upgrade your image, load and configure your custom modules.  Replace the example values (which are specific to JAAS modules) as needed for your deployment. For more information see [Configuration changes using overrides](configuration_changes_using_overrides.md) and [Updating DX properties using Helm values](./update_properties_with_helm.md).

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

    This configuration enables the WebEngine server to include the custom jars and required associated settings in your customized WebEngine image when deployed.

3. Use the following `helm upgrade` command to apply the updated configuration. Include both the base values file and the modified `custom-values-all.yaml` file.

    ```sh
    helm -n dxns upgrade dx-deployment ./install-hcl-dx-deployment/ -f install-deploy-values.yaml -f custom-values-all.yaml
    ```

    - Replace `dxns` with your namespace, and adjust the paths to `install-hcl-dx-deployment` and the values files (`install-deploy-values.yaml` and `custom-values-all.yaml`) according to your environment.
    - The `-f` flags specify the base configuration (`install-deploy-values.yaml`) and the updated configuration (`custom-values-all.yaml`).

    For more information, see [Upgrading the Helm deployment](../working_with_compose/helm_upgrade_values.md).

Once the upgrade is successfully applied, you can log in and begin using your custom modules in DX Compose.
