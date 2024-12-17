---
title: Install
---

# Installing Commands to Deploy <!--this page is not visible in the navigation, should we add it?-->.

The following are install commands that are used to deploy HCL Digital Experience Compose 9.5 Helm Charts.

## Install commands

!!!important
    Modification to any files (chart.yaml, templates, crds) in hcl-dx-deployment-vX.X.X\_XXXXXXXX-XXXX.tar.gz, except custom-values.yaml or values.yaml, is not supported.

To run the installation of your prepared configurations using Helm, use the following command:

```
# Helm install command
helm install -n my-namespace -f path/to/your/custom-values.yaml your-release-name path/to/hcl-dx-deployment-vX.X.X_XXXXXXXX-XXXX.tar.gz
```

-   The `my-namespace` is the namespace where your HCL Digital Experience Compose 9.5 deployment is installed to.
-   The `-f path/to/your/custom-values.yaml` must point to the custom-values.yaml you have created, which contains all deployment configuration.
-   `your-release-name` is the Helm release name and prefixes all resources created in that installation, such as Pods, Services, and others.
-   path/to/hcl-dx-deployment-vX.X.X_XXXXXXXX-XXXX.tar.gz is the HCL Digital Experience Compose 9.5 Helm Chart that you have extracted as described earlier in the planning and preparation steps.

After a successful deployment, Helm responds with the following message:

```
    NAME: dx
    LAST DEPLOYED: Thu Jun 17 14:27:58 2021
    NAMESPACE: my-namespace
    STATUS: deployed
    REVISION: 1
    TEST SUITE: None
```

## Default URLs post installation

During the configuration process, you might need the following URLs to access different administration user interfaces.

Use the following default URL to access HCL Digital Experience Compose (WebEngine and WCM):

-   **HCL Digital Experience Compose (WebEngine and WCM)**

    https://yourserver/wps/portal

-   **HCL Digital Experience Compose (WebEngine Administration Center)**

    https://yourserver/adminCenter

## (Optional) Automated host extraction

As described in the [Configure networking](../kubernetes_deployment/preparation/mandatory_tasks/prepare_configure_networking.md) topic, there are instances wherein you do not know the resulting external IP or FQDN for your deployment and the host value is empty. In that case, run a Helm upgrade command, and it automatically polls HAProxy and extracts the IP or FQDN values. The Helm Chart logic then populates all application configurations with the correct settings.

An example is provided below. You may use the following Helm upgrade command to trigger the automated host extraction:

```
# Helm upgrade command
helm upgrade -n my-namespace -f path/to/your/custom-values.yaml your-release-name path/to/hcl-dx-deployment-vX.X.X_XXXXXXXX-XXXX.tar.gz
```
