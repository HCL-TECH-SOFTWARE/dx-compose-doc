# REST service for WCM V2 APIs

Use the Web Content Manager (WCM) REST V2 APIs to manage web content. The REST service for WCM provides authoring access to content items and elements.

The V2 APIs complete the available actions for content and other WCM artifacts. They were either developed from scratch or created to bring their corresponding [REST service for WCM V1 APIs](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_development/wcm_rest/){target="_blank"} to the V2 Swagger interface. Most of the APIs introduced in the WCM REST V2 API explorer adhere to the same API path or URI fragment structure as the WCM V1 APIs.

For detailed information about V2 APIs, refer to the [WCM REST V2 API documentation](https://opensource.hcltechsw.com/experience-api-documentation/wcm-api/){target="_blank"}. For the WCM REST V1 version of the APIs, refer to [How to manage web content items by using REST](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_development/wcm_rest/wcm_rest_mng_content/){target="_blank"}.

## Differences between V1 and V2 APIs

- The request URL and all links in the response body use `wcmrest-v2` instead of `wcmrest`. For example:

    ```url
    # V1 API URL
    /wps/mycontenthandler/wcmrest/PresentationTemplate

    # V2 API URL
    /wps/mycontenthandler/wcmrest-v2/PresentationTemplate
    ```

- Request and response bodies use JSON exclusively. You do not need to add the `?mime-type=application/json` query parameter to get a JSON response, which was required for V1 APIs when the request body used XML.
- The WCM REST V2 Swagger API explorer provides API descriptions, sample request values, and sample response codes.

## WCM REST V2 API explorer

Developers using HCL DX WCM REST APIs can explore and test all the WCM V2 APIs by using the WCM REST V2 API explorer.

1. Access the API explorer at `http://<host>:<port>/dx/api/wcm/v2/explorer/` or `https://<host>:<port>/dx/api/wcm/v2/explorer/`. For example:

    ```url
    https://host:10039/dx/api/wcm/v2/explorer/
    ```

2. Go to the endpoint you want to test and select **Try it out**.
3. Modify the **Request body** as needed and select **Execute**.

## Cache headers for WCM REST V2

Configure a cache header for `GET` requests for unauthenticated users to improve performance and cacheability. To enable this feature, set the `public.rest.cache.expiry` property to a value for expiry. For example, set `public.rest.cache.expiry=86400s` to represent 24 hours.

Define and manage the cache options by adding or updating properties in the `WCMConfigService.properties` file using the Helm chart, as described in [Updating DX Compose WebEngine properties using Helm values](../../deploy_dx/manage/cfg_webengine/update_properties_with_helm.md).

???+ info "Related information"
    - [WCM REST V2 API documentation](https://opensource.hcltechsw.com/experience-api-documentation/wcm-api/){target="_blank"}
    - [REST API Explorers](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/apis/hcl_experience_api/api_explorers/){target="_blank"}
    - [HCL Experience API](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/apis/hcl_experience_api/){target="_blank"}
