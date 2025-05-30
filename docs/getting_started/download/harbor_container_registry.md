# Downloading and deploying DX Compose from a Harbor repository

Customers with entitlements to HCL Digital Experience (DX) Compose 9.5 may access the DX Compose container images and Helm charts from the [HCL Harbor container repository](https://hclcr.io/){:target="_blank"}. Customers with credentials to access entitled software on the HCL Software Licensing Portal can apply those credentials to optionally access these components of DX Compose v9.5.

The Harbor repository provides a registry based on Open Container Initiative (OCI). The Helm chart command is updated to be OCI-compliant.

## Pulling Helm charts using OCI commands

Using OCI commands requires an initial login before you can run the pull command.

!!!Important
    - It is recommended to pull the Helm chart images directly into your own repositories in the event that Harbor becomes unavailable.
    - While the Helm chart images may remain available in Harbor indefinitely, only the three most recent images are guaranteed to be available.

1. Log in to the Helm registry by using the following command:

    ```sh
    helm registry login -u <YOUR_HARBOR_USERNAME> -p <YOUR_HARBOR_CLI_SECRET_> https://hclcr.io/
    ```

2. Run the following OCI-based pull command:

    ```sh
    helm pull oci://hclcr.io/dx-compose/hcl-dx-deployment --version <HELM_CHART_VERSION_NUMBER>
    ```

    !!!note
        Running the pull command without the version parameter downloads the latest Helm chart version. To see the available Helm chart versions, refer to [Helm chart and CF versions](#helm-chart-and-cf-versions).

3. After you run the pull command, you can check whether the Helm Chart was downloaded to your local computer:

    ```sh
    # List directory content to check successful pull
    ls -lah 

    # total 8868
    # -rw-r--r--. 1 user user  136052 Jul  7 11:28 hcl-dx-deployment-2.7.1.tgz
    ```

## Helm chart and CF versions

Refer to the following list of Helm chart versions and their corresponding CF versions for HCL DX Compose.

|HCL DX Deployment version|HCL DX Search version|CF version|
|-------------------------|---------------------|----------|
|2.33.0||CF224|
|2.34.0|2.23.0|CF225|
|2.35.0|2.24.0|CF226|
|2.36.0|2.25.0|CF227|

You downloaded your DX Compose 9.5 Container Update Helm chart from the HCL repository on Harbor and can continue with your deployment.

After the Helm charts are downloaded, the next step is [Retagging images](../../deploy_dx/install/kubernetes_deployment/preparation/get_the_code/prepare_load_images.md#re-tag-images).

???+ info "Related information"
    -   [Deploying container platforms using Helm](../../deploy_dx/install/kubernetes_deployment/overview.md)
