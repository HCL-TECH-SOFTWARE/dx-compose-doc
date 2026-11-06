# Downloading and deploying DX Compose from a Harbor repository

Customers with entitlements to HCL Digital Experience (DX) Compose 9.5 may access the DX Compose container images and Helm charts from the [HCL Harbor container repository](https://hclcr.io/){target="_blank"}. Customers with credentials to access entitled software on the [My HCLSoftware (MHS) portal](https://my.hcltechsw.com/){target="blank"} can apply those credentials to optionally access these components.

The Harbor repository provides an Open Container Initiative (OCI)-compliant registry for downloading Docker container images and Helm charts. This article explains how to download and deploy HCL DX Compose assets from a Harbor repository.

## Pulling container images using Docker commands

Container images for HCL DX Compose components are hosted in the HCL Harbor container repository. Pulling these images with Docker allows to download required component runtime packages directly to the host machine or deployment environment for local execution, retagging, or relocation to private enterprise registries.

1. Log in to the HCL Harbor container repository by running the following command:

    ```sh
    docker login hclcr.io -u <YOUR_HARBOR_USERNAME> -p <YOUR_HARBOR_CLI_SECRET>
    ```

2. Run the `docker pull` command to retrieve the target container image:

    ```sh
    docker pull hclcr.io/dx-compose/<IMAGE_NAME>:<TAG>
    ```
    
    !!!note

        For example, the following command pulls the `webengine` image:

        ```sh
        docker pull hclcr.io/dx-compose/webengine:CF235_20260429-2302
        ```

3. Verify the image was successfully downloaded to your local machine:

    ```sh
    docker image ls hclcr.io/dx-compose/webengine
    ```
    
    The command output displays details such as repository, tag, image ID, and size upon a successful download.

## Pulling Helm charts using OCI commands

Using OCI commands requires an initial login before you can run the pull command.

!!!Important
    - It is recommended to pull the Helm chart images directly into your own repositories in the event that Harbor becomes unavailable.
    - While the Helm chart images may remain available in Harbor indefinitely, only the three most recent images are guaranteed to be available.

1. Log in to the Helm registry by using the following command:

    ```sh
    helm registry login -u <YOUR_HARBOR_USERNAME> -p <YOUR_HARBOR_CLI_SECRET_> hclcr.io
    ```

2. Run the following OCI-based pull command:

    ```sh
    helm pull oci://hclcr.io/dx-compose/hcl-dx-deployment --version <HELM_CHART_VERSION_NUMBER>
    ```

    !!!note
        Running the pull command without the version parameter downloads the latest Helm chart version. To see the available Helm chart versions, refer to [Helm chart and CF versions](#helm-chart-and-cf-versions).

3. Verify the Helm chart was downloaded to your local computer by running the following command:

    ```sh
    # List directory content to check successful pull
    ls -lah 

    # total 8868
    # -rw-r--r--. 1 user user  136052 Jul  7 11:28 hcl-dx-deployment-2.7.1.tgz
    ```

## Helm chart and CF versions

Refer to the following list of Helm chart versions and their corresponding Cumulative Fix (CF) versions for HCL DX Compose.

| CF version | HCL DX Deployment version | HCL DX Search version | HCL DX IQ version |
| :--------- | :------------------------ | :-------------------- | :---------------- |
| CF239      | 2.50.0                    | 2.37.0                | 1.0.3             |
| CF238      | 2.49.0                    | 2.36.0                | 1.0.2             |
| CF237      | 2.48.0                    | 2.35.0                | 1.0.1             |
| CF236      | 2.47.0                    | 2.34.0                | 1.0.0             |
| CF235      | 2.46.0                    | 2.33.0                |                   |
| CF234      | 2.45.0                    | 2.32.0                |                   |
| CF233      | 2.44.0                    | 2.31.0                |                   |
| CF232      | 2.43.0                    | 2.30.0                |                   |
| CF231      | 2.42.1                    | 2.29.0                |                   |
| CF230      | 2.41.0                    | 2.28.0                |                   |
| CF229      | 2.40.0                    | 2.27.0                |                   |
| CF228      | 2.37.3                    | 2.26.0                |                   |
| CF227      | 2.36.0                    | 2.25.0                |                   |
| CF226      | 2.35.0                    | 2.24.0                |                   |
| CF225      | 2.34.0                    | 2.23.0                |                   |
| CF224      | 2.33.0                    |                       |                   |

Now that you have downloaded your DX Compose 9.5 Container Update Helm chart from the HCL Harbor repository, you can continue with your deployment.

After you download the Helm charts, the next step is to [Retag images](../../deploy_dx/install/kubernetes_deployment/preparation/get_the_code/prepare_load_images.md#re-tag-images).

???+ info "Related information"
    -   [Deploying using Helm](../../deploy_dx/install/kubernetes_deployment/overview.md)
