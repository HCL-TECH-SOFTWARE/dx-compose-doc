---
title: Upgrading Helm deployment
---

# Upgrading Helm deployment

This section describes how to update the configuration of an HCL Digital Experience (DX) Compose 9.5 CF224 or later deployment to Kubernetes or OpenShift installed using Helm.

## Prerequisites

Make sure that you have completed the following steps:

- Prepare your cluster and your `custom-values.yaml` file. For more information, see [Preparation before installing HCL DX Compose using Helm](../kubernetes_deployment/preparation/index.md).
- Install your deployment. For more information, see [Install commands to deploy](../kubernetes_deployment/helm_install_commands.md).
- Ensure customizations made to your deployment are reflected in your `custom-values.yaml` file.
    - If an external database is used, make sure the values for the external database are correct in the `custom-values.yaml` and relevant Kubernetes secrets. For more information, see [Configuring an external database](../../manage/cfg_webengine/external_db_database_transfer.md#configuring-an-external-database) and [Using the external database and triggering the database transfer](../../manage/cfg_webengine/external_db_database_transfer.md#using-the-external-database-and-triggering-the-database-transfer).
    - If LDAP is configured for the environment, make sure the values for the LDAP directory are correct in the `custom-values.yaml` file and relevant Kubernetes secrets. For more information, see [Configuring LDAP](../../manage/cfg_webengine/ldap_configuration.md)
    - If WebEngine properties are updated, make sure the updated values are correct in the `custom-values.yaml`. For more information, see [Updating DX Compose WebEngine properties using Helm values](../../manage/cfg_webengine/update_properties_with_helm.md).
    - If the WebEngine administrator password is updated in the environment, make sure the Kubernetes secret is up-to-date and the correct values are in the `custom-values.yaml` file. For more information, see [Updating the default administrator password](../../manage/cfg_webengine/update_wpsadmin_password.md).
    - If configuration changes are made to the deployment using configuration override files, make sure the values are correct in the `custom-values.yaml` file. For more information, see [Configuration changes using overrides](../../manage/cfg_webengine/configuration_changes_using_overrides.md) and [Upgrading the Helm deployment](../../manage/working_with_compose/helm_upgrade_values.md).
    - If the WebEngine URL was changed from the default, make sure the values are correct in the `custom-values.yaml` file. For more information, see [Changing the WebEngine URL](../../manage/working_with_compose/change_context_root_or_home.md#changing-the-context-root-using-helm) and [Upgrading the Helm deployment](../../manage/working_with_compose/helm_upgrade_values.md).
    - If custom PVCs are used in your deployment, make sure the values are correct in your `custom-values.yaml` file.  For more information, see [PersistentVolumeClaims](../kubernetes_deployment/preparation/mandatory_tasks/prepare_persistent_volume_claims.md#configuring-additional-webengine-persistent-volumes).

## Recommended actions before a CF upgrade

In a Helm-based deployment, moving from one cumulative fix (CF) to another one is also handled through Helm upgrade. The following actions are recommended when applying cumulative fixes:

- Back up the file system of the persistent volumes associated with the namespace. Also, take a matching backup of the database associated with the WebEngine pod.
- If you are running a 24/7 environment, it is recommended to set up a blue/green deployment before applying a CF to ensure high availability. While DX WebEngine stays available with multiple pods, Digital Asset Management (DAM) is not highly available during CF application. See the topic [Difference and Similarities Between Traditional and Kubernetes DX Deployments](https://help.hcl-software.com/digital-experience/9.5/latest/deployment/manage/container_configuration/deploy_container_artifact_updates/#difference-and-similarities-between-traditional-and-kubernetes-dx-deployments){target="_blank"} that shows how a DX Compose solution could be deployed for high availability and blue/green deployments in a single Kubernetes cluster.
- Before upgrading, temporarily set the DAM staging interval to 1440 (24 hours) using the `dxclient manage-dam-staging trigger-staging` command or adjust the cycleLength to 1440 using the DAM REST API [StagingController.updateSubscriberData](https://opensource.hcltechsw.com/experience-api-documentation/dam-api/#operation/StagingController.updateSubscriberData){target="_blank"}. Alternatively, you can disable DAM Staging while the publisher (source) and the subscriber (target) are not yet on the same CF version but note that reestablishing staging restages all assets.
- (Optional) Consider disabling Web Content Manager (WCM) Syndication from and to the current environment.

## Helm Upgrade configuration command

After making the needed changes to your `custom-values.yaml` file, run the following command:

``` sh
# Helm upgrade command
helm upgrade -n your-namespace -f path/to/your/custom-values.yaml your-release-name path/to/hcl-dx-deployment-vX.X.X_XXXXXXXX-XXXX.tar.gz
```

-   The `your-namespace` is the namespace in which your HCL DX Compose 9.5 deployment is installed and `your-release-name` is the Helm release name you used when installing.
-   The `-f path/to/your/custom-values.yaml` parameter must point to the `custom-values.yaml` you have updated.
-   The `path/to/hcl-dx-deployment-vX.X.X\_XXXXXXXX-XXXX.tar.gz` is the HCL DX Compose Helm Chart that you extracted in [Preparation before installing HCL DX Compose using Helm](../kubernetes_deployment/preparation/index.md).



