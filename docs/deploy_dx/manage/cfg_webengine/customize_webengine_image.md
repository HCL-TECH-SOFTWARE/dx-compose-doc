---
id: customize_webengine_image
title: Customizing the HCL DX Compose WebEngine image with custom scripts
---

This topic provides the steps to build a customized HCL Digital Experience (DX) Compose WebEngine image with custom scripts for use in HCL DX Compose deployments.

## Adding custom script plugins

Starting with CF230, you can extend WebEngine functionality by adding custom shell scripts to designated plugin directories in the container. These scripts can run during container startup or during Cumulative Fix (CF) updates.

### Custom script directories

The WebEngine container includes the following directories for customer-provided scripts:

- `/opt/openliberty/wlp/usr/svrcfg/bin/customer/startup`: Scripts in this directory run during container startup.
- `/opt/openliberty/wlp/usr/svrcfg/bin/customer/update`: Scripts in this directory run during CF updates (for example, when updating from CF229 to CF230).

!!! important
    Only scripts placed directly in these two directories will be automatically scanned and executed. You can place helper scripts in any subdirectory and call them from your startup or update scripts, but they won't be executed automatically. Sample subdirectories include the following:

    - `/opt/openliberty/wlp/usr/svrcfg/bin/customer/startup/helpers/`
    - `/opt/openliberty/wlp/usr/svrcfg/bin/customer/update/helpers/`
    - `/opt/openliberty/wlp/usr/svrcfg/bin/customer/helpers/`

### Adding custom scripts to your image

To add custom scripts to your image, create a Dockerfile that builds upon an official HCL DX Compose WebEngine image. Include your custom scripts in the appropriate directories:

    <pre>
        ```
        # Dockerfile contents:

        FROM oci://hclcr.io/dx-compose/hcl-dx-deployment/webengine:CF230_20250724-1642_34573

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

- Scripts must be executable. You can ensure this in your Dockerfile by running a `chmod +x` command against any copied script files.
- Only scripts placed directly in the designated directories will be executed by the container.
- For shared logic, use the documented `safe_source` function to include utility scripts:

    ```bash
    # In your custom script
    source /opt/openliberty/wlp/usr/svrcfg/scripts/utility.sh
    safe_source "/opt/openliberty/wlp/usr/svrcfg/bin/common-utility/another_utility.sh"
    ```

- Do not modify or directly reference any scripts in the product feature directories.
- For WebEngine utilities, only use documented utility functions from the `common-utility` directory. These are described in the `README.md` file in that directory and in the individual script files.
- You can create and use your own helper functions in any subdirectories of the `customer` directory.

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

3. In the `custom-values-all.yaml` file, modify the following section to upgrade your image:

    ```yaml
    images:
      tags:
        webEngine: my_custom_tag
    ```

4. Use the following `helm upgrade` command to apply the updated configuration. Include both the base values file and the modified `custom-values-all.yaml` file.

    ```sh
    helm -n dxns upgrade dx-deployment ./install-hcl-dx-deployment/ -f install-deploy-values.yaml -f custom-values-all.yaml
    ```

    - Replace `dxns` with your namespace, and adjust the paths to `install-hcl-dx-deployment` and the values files (`install-deploy-values.yaml` and `custom-values-all.yaml`) according to your environment.
    - The `-f` flags specify the base configuration (`install-deploy-values.yaml`) and the updated configuration (`custom-values-all.yaml`).

    For more information, see [Upgrading the Helm deployment](../working_with_compose/helm_upgrade_values.md).

Once the upgrade is successfully applied, your custom startup scripts will execute in DX Compose.
