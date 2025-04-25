---
id: helm-upgrade-values
title: Upgrading the Helm deployment
---

This topic provides detailed steps for upgrading the Helm deployment using an updated `custom-values.yaml` file.

1. Retrieve the current `custom-values.yaml` file from a previous deployment or by using the following command:

    ```sh
    helm get values <RELEASE-NAME> -n <NAMESPACE> -o yaml > custom-values.yaml
    ```

    For example, to retrieve the `custom-values.yaml` file of modified values, use the following command:

    ```sh
    helm get values dx-deployment -n dxns > -o yaml  > custom-values.yaml
    ```

    To retrieve the full `custom-values.yaml` file that includes the default values, use the following command:

    ```sh
    helm get values dx-deployment -n dxns  -o yaml  -a > custom-values-all.yaml
    ```

2. Update the `custom-values.yaml` file with the required changes (for example, `configOverrideFiles`, `images`).

3. Upgrade the Helm deployment with the updated `custom-values.yaml` file.

    Use the following command to apply the updates to your Helm deployment:

    ```sh
    helm upgrade <RELEASE_NAME> -n <NAMESPACE> -f custom-values.yaml <HELM_CHART_DIRECTORY>
    ```

    For example:

    ```sh
    helm upgrade dx-deployment  -n dxns -f custom-values.yaml mycharts/install-hcl-dx-deployment
    ```
