# Enabling and disabling Content Composer

This document outlines configurations to enable and disable Content Composer in HCL Digital Experience (DX) Compose using the `values.yaml` file. With Content Composer, you can create and manage content more effectively within the DX environment. 

## Content Composer configuration

Refer to the following sample snippet for configuring the DX Compose server to enable Content Composer:

```yaml
applications:
  contentComposer: true
```

Set the value of the key `contentComposer` to `true` to enable or `false` to disable Content Composer.

## Validation

After updating the `values.yaml` file, perform the following actions:

- If running the server for the first time, refer to [Installing WebEngine](../../install/kubernetes_deployment/install.md).
- If upgrading previous configurations, refer to [Upgrading the Helm deployment](../working_with_compose/helm_upgrade_values.md).

Access the HCL Content Composer component by navigating to **Practitioner Studio > Web Content > Content**.

You can also use the following sample URL: 

```
https://your-portal.net/wps/myportal/Practitioner/Web Content/Content Library
```