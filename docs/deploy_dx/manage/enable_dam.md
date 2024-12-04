# Enabling and disabling DAM

This document outlines configurations to enable and disable Digital Asset Management (DAM) in HCL Digital Experience (DX) Compose using the `values.yaml` file. DAM is used for managing web-ready digital assets such as images or videos to be used in content and sites built with HCL DX.

## DAM configuration

Refer to the following sample snippet for configuring the DX WebEngine server to enable DAM:

```yaml
applications:
  digitalAssetManagement: true
```

Set the value of the key `digitalAssetManagement` to `true` to enable or `false` to disable DAM.

!!!note
    By default, [DX Picker](https://opensource.hcltechsw.com/digital-experience/latest/manage_content/wcm_authoring/dx_picker/){target="_blank"} is enabled when you enable DAM. When you disable DAM, DX Picker is disabled as well.

## Validation

After updating the `values.yaml` file, perform the following actions:

- If running the server for the first time, refer to [Installing WebEngine](../install/install.md). 
- If upgrading previous configurations, refer to [Upgrading the Helm deployment](helm_upgrade_values.md).

Access the DAM components by navigating to **Practitioner Studio > Digital Assets**.

You can also use the following sample URL: <!--Please check if this description is correct.-->

```
https://your-portal.net/wps/myportal/Practitioner/Digital Assets
```
