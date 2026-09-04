# REST service for Web Content Manager v3

This section discusses how to use the Web Content Manager REST version 3 APIs.

The HCL Digital Experience (DX) Web Content Manager (WCM) API v3 is a modern REST API that provides streamlined access to WCM content, libraries, site areas, categories, taxonomies, and presentation templates. Built on JAX-RS 2.1 and OpenAPI 3.0 standards, it offers a cleaner, more efficient alternative to previous API versions.

## Key features

- **Modern Architecture**: JAX-RS 2.1 compliant REST API built on Java EE 8
- **OpenAPI 3.0 Integration**: Auto-generated API documentation with interactive Swagger UI
- **Simplified Payloads**: Flat, intuitive JSON structures without nested Atom format complexity
- **Advanced HTTP Features**: ETag support, JSON Merge Patch (RFC 7396), sparse fieldsets
- **Built-in API Explorer**: Interactive Swagger UI at `/dx/api/wcm/v3/explorer/` for live API testing

## Available resources

The WCM API v3 provides REST endpoints for managing:

- **Content**: Full CRUD operations for WCM content items
- **Libraries**: Manage WCM libraries
- **Site Areas**: Create and manage site area hierarchies
- **Categories**: Organize content with categories
- **Taxonomies**: Manage taxonomy structures
- **Presentation Templates**: Control content presentation
- **Search**: Unified search across WCM resources

## API Explorer

Access the interactive API Explorer (Swagger UI) at `/dx/api/wcm/v3/explorer/` on your DX host.

The API Explorer provides:

- Interactive testing of all endpoints
- Auto-generated documentation from OpenAPI annotations
- Request/response examples
- Schema definitions for all data models

## Documentation

- **[Getting started with the REST service for Web Content Manager v3](wcm_rest_v3_starting.md)**  
  Learn how to enable, configure, and start using the WCM REST v3 APIs, including authentication methods and basic usage examples.

## Related information

- [REST service for Web Content Manager v2](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_development/wcm_rest_v2/){target="_blank"}
- [REST service for Web Content Manager v1](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_development/wcm_rest/){target="_blank"}
- [HCL Experience API](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/apis/hcl_experience_api/){target="_blank"}
