# Enabling and disabling People Service

This document outlines configurations to enable and disable [People Service](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/integration/people_service/){target="_blank"} in HCL Digital Experience (DX) Compose using the `values.yaml` file. People Service provides a layer for social connectivity by helping team members to connect, especially in large projects. It enhances user profiles with additional data and interactive features, improving team collaboration and project execution.

!!!note
    In this release, instructions for using this feature is located in the [HCL Digital Experience Help Center](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/integration/people_service/){target="_blank"}. These will be documented in the HCL Digital Experience Compose Help Center in future releases.

## People Service configuration

Refer to the following sample snippet for configuring the DX WebEngine server to enable People Service:

```yaml
peopleservice:
  enabled: true
```

Set the value of the key `peopleservice.enabled` to `true` to enable or `false` to disable People Service.

## Validation

After updating the `values.yaml` file, perform the following actions:

- If running the server for the first time, refer to [Installing WebEngine](../../install/kubernetes_deployment/install.md).
- If upgrading previous configurations, refer to [Upgrading the Helm deployment](../working_with_compose/helm_upgrade_values.md).

Access People Service by using the following sample URL:

```link
https://your-portal.net/dx/ui/people
```

## People Service with Search V2

You can integrate People Service with [Search V2](https://help.hcl-software.com/digital-experience/9.5/latest/build_sites/search_v2/){target="_blank"} to enhance user discoverability and search performance. This integration provides efficient access to user profile data with real-time synchronization.

You can enable the Search V2 integration through the parameter `configuration.search.middleware.enabled` in the People Service Helm chart.

For more information on how to integrate People Service with Search V2, refer to the [People Service and Search V2 integration](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/integration/people_service/integration/people_service_search_v2_integration/){target="_blank"} topic.
