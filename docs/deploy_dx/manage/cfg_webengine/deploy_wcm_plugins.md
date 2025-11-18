---
id: deploy_wcm_plugins
title: Deploying and configuring WCM plugins
---

This topic provides the steps to deploy and configure customer-built Web Content Manager (WCM) plugins to be used in HCL DX Compose deployments.

## Customizing the HCL DX Compose WebEngine image

1. Create a Dockerfile that uses an official HCL DX Compose WebEngine image as a parent image. Beginning with DX Compose CF230, the image includes a `resources/customApplications` directory in the server configuration location to hold custom enterprise (EAR) and web (WAR) applications.

    <pre>
        ```
        # Dockerfile contents:

        FROM oci://hclcr.io/dx-compose/hcl-dx-deployment/webengine:CF230_yyyymmdd-xxxxxx

        # Copy the custom theme EAR into the customized image
        COPY --chown=dx_user:dx_users ./MyCustomPlugins.ear /opt/openliberty/wlp/usr/servers/defaultServer/resources/customApplications/MyCustomPlugins.ear

        ```
    </pre>

2. Use the following command to build the image:

    ```
    docker -D build --no-cache=true --progress=plain -t <my_custom_repository>/webengine:<my_custom_tag> .
    ```

## Enabling the customized WebEngine image in DX Compose

Follow these steps to deploy your customized WebEngine image in your HCL DX Compose deployment:

1. Upload your customized WebEngine image to the repository used for your HCL DX Compose deployment using the following command:

    ```sh
    docker push <my_custom_repository>/webengine:<my_custom_tag>
    ```

    For more information, refer to [Load images to your own repository](../../install/kubernetes_deployment/preparation/get_the_code/prepare_load_images.md#loading-images).

2. Fetch the current configuration values from the running Helm release to ensure you preserve existing settings while adding the new image tag value and configuration. Run the following command:

    ```sh
    helm get values dx-deployment -n dxns -o yaml -a > custom-values-all.yaml
    ```

    Replace `dx-deployment` with your Helm release name and `dxns` with your namespace if they differ. This command saves the current values to a file named `custom-values-all.yaml`.

3. In the `custom-values-all.yaml` file, modify the following sections to upgrade your image and load and configure your custom enterprise application. For more information, refer to [Configuration changes using overrides](configuration_changes_using_overrides.md) and [Updating DX properties using Helm values](./update_properties_with_helm.md).

    ```yaml
    images:
      tags:
        webEngine: my_custom_tag
    configuration:
      webEngine:
        configOverrideFiles:
          my-custom-theme.xml: |
            <server description="DX Web Engine server">
              <enterpriseApplication id="MyCustomPlugins.ear" location="${server.config.dir}/resources/customApplications/MyCustomPlugins.ear" name="MyCustomPlugins.ear">
              </enterpriseApplication>
            </server>
    ```

    This configuration enables the WebEngine server to load and start the new enterprise application in your customized WebEngine image when deployed.

4. Use the following `helm upgrade` command to apply the updated configuration. Include both the base values file and the modified `custom-values-all.yaml` file.

    ```sh
    helm -n dxns upgrade dx-deployment ./install-hcl-dx-deployment/ -f install-deploy-values.yaml -f custom-values-all.yaml
    ```

    - Replace `dxns` with your namespace, and adjust the paths to `install-hcl-dx-deployment` and the values files (`install-deploy-values.yaml` and `custom-values-all.yaml`) according to your environment.
    - The `-f` flags specify the base configuration (`install-deploy-values.yaml`) and the updated configuration (`custom-values-all.yaml`).

    For more information, refer to [Upgrading the Helm deployment](../working_with_compose/helm_upgrade_values.md).

Once the upgrade is successfully applied and the DX WebEngine pod(s) have started, your plugins will be available for use in DX Compose.
