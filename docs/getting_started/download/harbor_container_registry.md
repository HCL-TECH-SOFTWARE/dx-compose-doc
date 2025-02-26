# Downloading and deploying DX Compose from a Harbor repository

Customers with entitlements to HCL Digital Experience Compose 9.5 may access the DX Compose container images and Helm charts from the [HCL container repository on Harbor](https://hclcr.io/){:target="_blank"}. Customers with credentials to access entitled software on the HCL Software Licensing Portal can apply those credentials to optionally access these components of DX Compose v9.5.

With the CF216 release (November 2023), the Harbor repository provides a registry based on Open Container Initiative (OCI). The Helm chart command is updated to be OCI-compliant. However, older versions of the Helm chart are still used in the non-OCI approach. Both approaches are described in this topic. 

## OCI-based registry

Helm charts that are pushed and managed through OCI are not part of the `Helm Charts` category in Harbor anymore. Therefore, the `Helm Charts` section does not reflect the newer version of Helm charts, which are pushed by using OCI commands. OCI assets such as container images and Helm charts are currently in the same category and both are listed as an OCI repository.

### Pulling Helm charts by using OCI commands

These commands are different from the previous approach in the non-OCI-based registry. Using OCI commands requires an initial login before you can run the pull command.


1. Log in to the Helm registry by using the following command: 

    ```sh
    helm registry login -u <YOUR_HARBOR_USERNAME> -p <YOUR_HARBOR_CLI_SECRET_> https://hclcr.io/
    ```

2. After you log in, run the following OCI-based pull command:

    ```sh
    helm pull oci://hclcr.io/dx-compose/hcl-dx-deployment --version <HELM_CHART_VERSION_NUMBER>
    ```

3. After you run the pull command, you can check whether the Helm Chart was downloaded to your local computer:

    ```sh
    # List directory content to check successful pull
    ls -lah 

    # total 8868
    # -rw-r--r--. 1 user user  136052 Jul  7 11:28 hcl-dx-deployment-2.7.1.tgz
    ```

## Non-OCI-based registry

This section describes the previous non-OCI approach that still uses older versions of the Helm chart. 

### Configuring the Helm repository on Harbor to your DX Compose 9.5 Kubernetes deployment

As an alternative to downloading the DX Compose 9.5 Helm charts from the Docker components of your HCL DX Compose offering entitlements on the HCL Software License Portal, you can directly use the Helm repository on Harbor with Helm from HCL DX Compose Container update CF226 and later releases.

#### Adding the Helm repository on Harbor to your Helm configuration

To add the Helm repository on Harbor to your Helm configuration, you can use the following command:

```
helm repo add 
--username <YOUR_HARBOR_USERNAME> 
--password <YOUR_HARBOR_CLI_SECRET_> 
dx-compose https://hclcr.io/chartrepo/dx-compose
```

To get the `CLI secret`, refer to the following steps:

1. Log in to [Harbor GitHub site for HCL](https://hclcr.io/){:target="_blank"} using your authorized HCL user credentials. 
2. Navigate to your HCL `User Profile` on Harbor.
3. Copy the CLI secret from the `CLI secret` field.

After you add the repository to your Helm deployment, you should see the following message:

```
"dx-compose" has been added to your repositories
```

#### Listing available Helm chart versions

To verify that your Helm configuration works to connect and to see which [HCL DX Compose 9.5 Container Update CF application versions](../../deploy_dx/install/kubernetes_deployment/image_list.md) are available from the HCL repository on Harbor, you can use the following command:

```
# Using helm search to find available versions, the DX helm charts are named hcl-dx-deployment
    
helm search repo dx-compose/hcl-dx-deployment --versions
```

This command returns a list of available versions, which looks similar to this example:

```
NAME                        CHART VERSION     APP VERSION     DESCRIPTION                                    
dx-compose/hcl-dx-deployment    2.7.1           95_CF226    Kubernetes Deployment of HCL Digital Experience Compose
```

You can see which chart version correlates to which HCL DX Compose 9.5 Container Update CF version. In the preceding example, installing Container Update CF226 requires you to use Helm chart version 2.7.1.

After you complete the preceding actions, your Helm configuration can use HCL DX Compose 9.5 Helm charts directly from the Helm Repository on Harbor.

!!! note
    Applying the method to pull DX Compose 9.5 Container Update images directly from the HCL container registry on Harbor requires that every cluster node can access the HCL container registry on Harbor. To leverage this feature, you have to configure an `ImagePullSecret` with your HCL credentials for the Harbor site. For instructions, see [Configure deployment to use the HCL container registry on Harbor](../../deploy_dx/install/kubernetes_deployment/preparation/optional_tasks/optional_imagepullsecrets.md#configuring-deployment-to-use-the-hcl-harbor-container-registry).

#### Pulling a Helm chart for deployment

To use the HCL Digital Experience Compose v9.5 Helm chart from the Helm repository on Harbor, for best results, pull the Helm chart through Helm to your local computer. By using this method, you can work in the same manner as the manually downloaded method.

To do so, run the following command with the correct Helm chart version:

```
# Use Helm Pull with the version you want to deploy. (This example uses version 2.7.1. Enter the version you want to use.)
helm pull dx-compose/hcl-dx-deployment --version 2.7.1
```

After running this command, you can verify whether the Helm chart was downloaded to your local computer:

```
# List directory content to check successful pull
ls -lah 

# total 8868
# -rw-r--r--. 1 user user  136052 Jul  7 11:28 hcl-dx-deployment-2.7.1.tgz
```

You downloaded your DX Compose 9.5 Container Update Helm chart from the HCL repository on Harbor and can continue with your deployment. 

After the Helm charts are downloaded, the next step is [Retagging images](../../deploy_dx/install/kubernetes_deployment/preparation/get_the_code/prepare_load_images.md#re-tag-images).

???+ info "Related information"
    -   [Deploying container platforms using Helm](../../deploy_dx/install/kubernetes_deployment/overview.md)
