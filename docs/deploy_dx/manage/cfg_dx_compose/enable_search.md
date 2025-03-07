# Enabling Search V2

[Search V2](https://help.hcl-software.com/digital-experience/9.5/latest/build_sites/search_v2/){target="_blank"} introduces a new user interface with a backend service that utilizes OpenSearch to provide a seamless search experience. Search V2 is enabled by default for HCL Digital Experience (DX) Compose.

## Access

Access the HCL Search V2 by navigating to **Practitioner Studio > Web Content > Search**.

You can also use the following sample URL: 

```
https://your-portal.net/wps/myportal/Practitioner/SearchCenter
```

## People Service with Search V2

You can integrate [People Service](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/integration/people_service/){target="_blank"} with Search V2 to enhance user discoverability and search performance. This integration provides efficient access to user profile data with real-time synchronization.

You can enable the Search V2 integration through the parameter `configuration.search.middleware.enabled` in the People Service Helm chart.

For more information on how to integrate People Service with Search V2, refer to the [People Service and Search V2 integration](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/integration/people_service/integration/people_service_search_v2_integration/){target="_blank"} topic.
