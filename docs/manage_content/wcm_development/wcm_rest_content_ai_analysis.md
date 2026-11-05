# Using the AI analyzer API for content

Use the [Web Content Manager (WCM) REST v2 API](https://opensource.hcltechsw.com/experience-api-documentation/wcm-api/#tag/AI-Analyzer-Rest){target="_blank"} to analyze sentiment, extract keywords, and automatically summarize content elements.

## WCM REST V2 API explorer

The WCM REST v2 API explorer allows developers using HCL Digital Experience (DX) Compose WCM REST APIs to explore and test endpoints.

Access the WCM REST v2 API explorer at: `http://host/dx/api/wcm/v2/explorer/` or `https://host/dx/api/wcm/v2/explorer/`

For more information about the WCM REST v2 API explorer, refer to [HCL Experience API](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/apis/hcl_experience_api/).

### Using REST with the AI analyzer API for content

In the WCM REST v2 API explorer, send a `POST` request to the following endpoint:

```url
https://host/wps/mycontenthandler/wcmrest-v2/contents/analysis
```

### Current API capabilities and limitations

- Only content elements are used for AI analysis.
- Only those components within the `elements` data array are used for AI analysis. These components are Text Element components (for example, Plain Text, Short Text, and Rich Text) and HTML Components.
- Parent-level fields such as `description`, `name`, and `title` are not used for AI analysis.
- If the request parameter value is set to `summary`, extractive summarization is performed during analysis by default. Abstractive summarization is currently not supported.

For more information about API request and response details, refer to the `POST /contents/analysis` endpoint in the Swagger REST API documentation.

!!!note
    Before calling the content AI analyzer API of any content AI Provider, configure them in your HCL DX Compose deployment. For instructions on how to enable AI analysis for Kubernetes deployment, refer to [Web content AI analysis in Kubernetes Deployment](https://help.hcl-software.com/digital-experience/9.5/latest/get_started/plan_deployment/container_deployment/wcm_content_ai_analysis/).
