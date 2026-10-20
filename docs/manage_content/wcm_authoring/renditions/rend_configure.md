# Configuring renditions

Renditions are enabled by default. You can enable or disable renditions by specifying a property override in your HCL Digital Experience (DX) Compose Helm chart.

1. Open your custom values file for the Helm deployment.
2. Add or locate the `configuration` section.
3. Specify the `renditions.enabled` property under `webEngine.propertiesFilesOverrides.WCMConfigService.properties`.
4. Set the value to `"true"` to enable renditions or `"false"` to disable them.

    ```yaml
    configuration:
    webEngine:
        propertiesFilesOverrides:
        WCMConfigService.properties: 
            renditions.enabled: "true"
    ```

5. Run the `helm upgrade` command by using the following syntax to apply the changes to your deployment:

    ```bash
    helm upgrade <release_name> <chart_path> -f <your_custom_values_file>.yaml
    ```

    - `<release_name>`: Specifies the name of the installed Helm release.
    - `<chart_path>`: Specifies the file path, archive, or repository name of the Helm chart.
    - `<your_custom_values_file>.yaml`: Specifies the name and path of your custom values YAML file containing the configuration overrides.