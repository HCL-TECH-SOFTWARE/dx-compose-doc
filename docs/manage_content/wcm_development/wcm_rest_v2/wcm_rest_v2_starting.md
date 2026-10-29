---
title: Getting started with the REST service for WCM V2
---

# Getting started with the REST service for WCM V2

This topic provides information about the new APIs available.

These V2 APIs are created to complete the available actions for content and other Web Content Manager (WCM) artifacts. They are either developed from scratch or created to bring their corresponding [REST service for WCM V1 APIs](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_development/wcm_rest/) to the V2 Swagger interface. You can find detailed information about V2 APIs at [WCM REST V2 API documentation](https://opensource.hcltechsw.com/experience-api-documentation/wcm-api/). For a comparison of V1 and V2 APIs, see [Differences between V1 and V2 APIs](comparison_v1_v2.md).

If you are working with WCM via REST, it is recommended to use the WCM REST V2 API.

!!! note
    Most of the APIs introduced in the WCM REST V2 API explorer adhere to the same API path or URI fragment structure as the WCM V1 APIs.

For the WCM REST V1 version of the APIs, refer to **[How to manage web content items by using REST](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_development/wcm_rest/wcm_rest_mng_content/)**.

## WCM REST V2 API explorer

With WCM REST V2 API explorer, developers using the Digital Experience WCM REST APIs can explore and test all the WCM V2 APIs. 

Access the WCM REST V2 API explorer located at:

```
http or https://host:port/dx/api/wcm/v2/explorer/
```

!!! example

    ```
    https://host:10039/dx/api/wcm/v2/explorer/
    ```

## Cache headers for WCM REST V2

You can configure a cache header for GET requests for unauthenticated users. Configuring cache headers results in better performance and cachability. To enable this feature, set the property to a value for expiry: ```public.rest.cache.expiry=86400s```. "86400s" is an example representing 24 hours.

Define and manage the cache options by adding or updating properties in the `WCM WCMConfigService.properties` file using the Helm chart, as described in [Updating DX Compose WebEngine properties using Helm values](../../../../../docs/deploy_dx/manage/cfg_webengine/update_properties_with_helm.md).

???+ info "Related information"
    - [WCM REST V2 API documentation](https://opensource.hcltechsw.com/experience-api-documentation/wcm-api/)
    - [REST API Explorers](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/apis/hcl_experience_api/api_explorers/)
    - [HCL Experience API](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/apis/hcl_experience_api/)


