# Enabling Search V2

[Search V2](https://help.hcl-software.com/digital-experience/9.5/latest/build_sites/search_v2/){target="_blank"} introduces a new user interface with a backend service that utilizes OpenSearch to provide a seamless search experience. Search V2 is enabled by default for HCL Digital Experience (DX) Compose when the parameter `configuration.searchMiddleware.enabled` is set to `true` in the HCL DX Deployment Helm chart.

## Search configuration

Refer to the following sample snippet for configuring the DX Compose server to enable Search V2:

```yaml
# Application configuration
configuration:
  # Search Middleware configuration
  searchMiddleware:
    # Enable/Disable Search Middleware
    enabled: true
```

## Validation

After updating the `values.yaml file`, perform the following actions:

- If running the server for the first time, refer to [Installing WebEngine](../../install/kubernetes_deployment/install.md).
- If upgrading previous configurations, refer to [Upgrading the Helm deployment](../working_with_compose/helm_upgrade_values.md).

## Access

Access the HCL Search V2 by navigating to **Practitioner Studio > Web Content > Search**.

You can also use the following sample URL: 

```
https://your-portal.net/wps/myportal/Practitioner/SearchCenter
```

## Search V2 integration

You can enable the following application to use as additional data source for Search V2:

- [People Service](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/integration/people_service/){target="_blank"}

    For more information on how to integrate People Service with Search V2, refer to the [People Service and Search V2 integration](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/integration/people_service/integration/people_service_search_v2_integration/){target="_blank"} topic.
