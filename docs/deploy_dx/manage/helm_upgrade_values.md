---
id: helm-upgrade-values
title: Upgrading the Helm deployment
---

This topic provides detailed steps for upgrading the Helm deployment using an updated `custom-values.yaml` file.

1. Retrieve the current `values.yaml` File

     You can retrieve the current `custom-values.yaml` file from a previous deployment or by using the following command:

    ```sh
    helm get values <RELEASE-NAME> -n <NAMESPACE> > values.yaml
    ```

    For example:

    ```sh
    helm get values dx-deployment -n dxns > values.yaml
    ```

2. Update the `custom-values.yaml` file with the required changes.

    Make the necessary updates to the `custom-values.yaml` file (for example, `configOverrideFiles`, `images`).

3. Upgrade the Helm deployment with the updated `custom-values.yaml` file.

    Use the following command to apply the updates to your Helm deployment:

    ```sh
    helm upgrade <RELEASE_NAME> -n <NAMESPACE> -f values.yaml <HELM_CHART_DIRECTORY>
    ```

    For example:

    ```sh
    helm upgrade dx-deployment  -n dxns -f values.yaml mycharts/install-hcl-dx-deployment
    ```
