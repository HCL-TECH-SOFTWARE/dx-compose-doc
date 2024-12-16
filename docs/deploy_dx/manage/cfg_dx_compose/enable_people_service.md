# Enabling and disabling People Service

This document outlines configurations to enable and disable People Service in HCL Digital Experience (DX) Compose using the `values.yaml` file. People Service provides a layer for social connectivity by helping team members to connect, especially in large projects. It enhances user profiles with additional data and interactive features, improving team collaboration and project execution.

!!!note
    In this release, instructions for using this feature is located in the [HCL Digital Experience Help Center](https://opensource.hcltechsw.com/digital-experience/latest/extend_dx/integration/people_service/){target="_blank"}. These will be documented in the HCL Digital Experience Compose Help Center in future releases.

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

Access the People Service by navigating to below sample URL:

```link
https://your-portal.net/dx/ui/people
```
