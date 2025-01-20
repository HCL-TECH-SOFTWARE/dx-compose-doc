# Upgrading Helm Deployment

This section describes how to update the configuration of an HCL Digital Experience (DX) Compose 9.5 CF225 or later deployment to Kubernetes or OpenShift installed using Helm.

This section assumes that you prepared your cluster and your custom-values.yaml file, using guidance provided in the [Preparation before installing HCL DX  using Helm](../kubernetes_deployment/preparation/index.md) topic, and then installed your deployment using the instructions in the [Install](../kubernetes_deployment/helm_install_commands.md) topic and you also have followed instructions provided in the topic [Configuring an external database](../../../manage/cfg_webengine/external_db_database_transfer.md#configuring-an-external-database) to configure values for external database transfer and carried out database transfer using the instructions at [Using the external database and triggering the database transfer](../../../manage/cfg_webengine/external_db_database_transfer.md#using-the-external-database-and-triggering-the-database-transfer)

At this point of time you are successfully using external DB for HCL Digital Experience (DX) Compose 9.5 deployment

## Recommended actions before a CF upgrade

In a Helm-based deployment, moving from one cumulative fix (CF) to another one is also handled through Helm upgrade. The following actions are recommended when applying cumulative fixes:

- Back up the file system of the persistent volumes associated with the namespace. Also, take a matching backup of the database associated with the WebEngine pod.
- If you are running a 24/7 environment, it is recommended to set up a blue/green deployment before applying a CF to ensure high availability. While DX WebEngine stays available with multiple pods, DAM is not highly available during CF application. See the topic [Difference and Similarities Between Traditional and Kubernetes DX Deployments](https://opensource.hcltechsw.com/digital-experience/latest/deployment/manage/container_configuration/deploy_container_artifact_updates.md#difference-and-similarities-between-traditional-and-kubernetes-dx-deployments) that shows how a DX Compose solution could be deployed for high availability and blue/green deployments in a single Kubernetes cluster.
- Before upgrading, temporarily set the DAM staging interval to 1440 (24 hours) using the `dxclient manage-dam-staging trigger-staging` command or adjust the cycleLength to 1440 using the DAM REST API [StagingController.updateSubscriberData](https://opensource.hcltechsw.com/experience-api-documentation/dam-api/#operation/StagingController.updateSubscriberData). Alternatively, you can disable DAM Staging while the publisher (source) and the subscriber (target) are not yet on the same CF version but note that reestablishing staging restages all assets.
- (Optional) Consider disabling WCM Syndication from and to the current environment.

## Helm Upgrade configuration command

After making the needed changes to your custom-values.yaml file, use the following command:

``` sh
# Helm upgrade command
helm upgrade -n your-namespace -f path/to/your/custom-values.yaml your-release-name path/to/hcl-dx-deployment-vX.X.X_XXXXXXXX-XXXX.tar.gz
```

-   The `your-namespace` is the namespace in which your HCL Digital Experience 9.5 deployment is installed and `your-release-name` is the Helm release name you used when installing.
-   The `-f path/to/your/custom-values.yaml` parameter must point to the custom-values.yaml you have updated.
-   The path/to/hcl-dx-deployment-vX.X.X\_XXXXXXXX-XXXX.tar.gz is the HCL Digital Experience Helm Chart that you extracted in the preparation steps.



