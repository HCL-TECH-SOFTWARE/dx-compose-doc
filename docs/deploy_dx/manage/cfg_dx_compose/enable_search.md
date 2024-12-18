# Enabling and disabling Search V2

This document outlines configurations to enable and disable Search V2 in HCL Digital Experience (DX) Compose using the `values.yaml` file. Search introduces a new user interface along with a new backend service that utilizes OpenSearch to provide a seamless search experience.

## Search configuration

Refer to the following sample snippet for configuring the DX Compose server to enable Search V2:

```yaml
# Application configuration
configuration:
  # Application specific configuration for Core
  webEngine:
    # Settings for SearchV2 UI configuration
    search:
      # Determines if search ui v2 is enabled or not
      uiV2Enabled: true
      # Determines to which search center any input box on DX redirects by default
      inputRedirectVersion: "v2"
```

Set the value of the key `uiV2Enabled` to `true` to enable or `false` to disable Search V2.
Set the value of the key `inputRedirectVersion` to `v2` to redirect all searches on DX to the new Search V2 UI.


## Validation

After updating the `values.yaml` file, perform the following actions:

- If running the server for the first time, refer to [Installing WebEngine](../../install/kubernetes_deployment/install.md).
- If upgrading previous configurations, refer to [Upgrading the Helm deployment](../working_with_compose/helm_upgrade_values.md).

Access the HCL Search by navigating to **Practitioner Studio > Web Content > Search**.

You can also use the following sample URL: 

```
https://your-portal.net/wps/myportal/Practitioner/SearchCenter
```