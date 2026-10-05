# REST service for Web Content Manager v3

The HCL Digital Experience (DX) Web Content Manager (WCM) API v3 provides REST access to WCM content, libraries, site areas, categories, taxonomies, and presentation templates. Built on Java API for RESTful Web Services (JAX-RS) 2.1 and Java Platform, Enterprise Edition (Java EE) 8 standards, it offers simplified JSON payloads and standard HTTP operations.

## Features

- Deploy REST APIs compliant with JAX-RS 2.1 and Java EE 8.
- Generate API documentation automatically using OpenAPI 3.0 specifications.
- Process simplified JSON payloads without nested Atom format complexity.
- Optimize HTTP operations using ETags, JSON Merge Patch (RFC 7396), and sparse fieldsets.
- Test endpoints interactively using the API Explorer.

## Prerequisites

- HCL DX Compose Cumulative Fix (CF) 238 or a later version is installed in the target environment.
- A Kubernetes cluster is running an active Helm deployment.
- Administrative access is available to edit and apply the Helm values.yaml configuration file.
- The WebEngine container service is running and operational.

## Documentation

- **[Enabling and disabling Web Content Manager REST API v3](../../cfg_dx_compose/enable_wcm_api_v3.md)**  
Learn how to enable and disable the WCM REST API v3.
- **[Configuring Web Content Manager REST API v3](configure_wcm_rest_v3.md)**  
Learn how to enable, configure, and start using the WCM REST v3 APIs, including authentication methods and basic usage examples.
- **[Using Web Content Manager REST API v3](use_wcm_rest_v3.md)**  
Learn how to interact with WCM resources, execute queries, and apply best practices when using WCM REST API v3 endpoints.

???+ info "Related information"
    - [REST service for Web Content Manager v2](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_development/wcm_rest_v2/){target="_blank"}
    - [REST service for Web Content Manager v1](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_development/wcm_rest/){target="_blank"}
    - [HCL Experience API](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/apis/hcl_experience_api/){target="_blank"}
