# Getting started with the REST service for Web Content Manager v3

You can use Web Content Manager REST v3 APIs to manage Web Content. The REST service for Web Content Manager v3 provides modern, standards-based access to content items, libraries, site areas, and other WCM resources.

## Overview

WCM REST v3 APIs are built on JAX-RS 2.1 and OpenAPI 3.0 standards, providing a cleaner and more efficient alternative to previous API versions. The v3 APIs feature:

- Simplified JSON payloads without Atom format complexity
- Full support for HTTP standards (ETag, conditional requests, PATCH operations)
- Interactive API Explorer with Swagger UI
- Comprehensive OpenAPI 3.0 specification

## Prerequisites

WCM API v3 is enabled by default in DX Compose CF238 and later. If you need to disable or re-enable it, see [Enabling and disabling WCM API v3](../../cfg_dx_compose/enable_wcm_api_v3.md).

## Authentication

WCM API v3 supports two authentication methods:

### HTTP Basic Authentication

For REST clients (curl, Postman, etc.):

```bash
curl -k -u user:password \
  https://your-dx-host/dx/api/wcm/v3/libraries
```

### SSO (LTPA Token)

For browser-based access:
1. Log in to DX Portal first
2. The LTPA cookie will be used for authentication
3. Useful when accessing the API Explorer

## Base URL and Endpoints

The base URL for all WCM API v3 endpoints is:

```
https://your-dx-host/dx/api/wcm/v3
```

### Available Endpoints

| Resource | Endpoint | Description |
|----------|----------|-------------|
| Categories | `/categories` | Manage WCM categories |
| Contents | `/contents` | Manage content items |
| Libraries | `/libraries` | Manage WCM libraries |
| Presentation Templates | `/presentation-templates` | Manage presentation templates |
| Search | `/search` | Search across WCM resources |
| Site Areas | `/site-areas` | Manage site areas |
| Taxonomies | `/taxonomies` | Manage taxonomies |

For complete endpoint documentation, see the [API Explorer](https://your-dx-host/dx/api/wcm/v3/explorer/).

## Using the API Explorer

The WCM API v3 includes a built-in Swagger UI-based API Explorer for interactive testing and documentation.

### Accessing the Explorer

Navigate to:
```
https://your-dx-host/dx/api/wcm/v3/explorer/
```

### Testing an Endpoint

1. Click "Authorize" and enter your DX credentials
2. Browse to an endpoint (e.g., Libraries > GET /libraries)
3. Click "Try it out"
4. Set parameters (e.g., `limit=10`)
5. Click "Execute"
6. View the response with actual data

### Example: Listing Libraries

1. Navigate to the API Explorer
2. Expand the "Libraries" section
3. Click on `GET /libraries`
4. Click "Try it out"
5. Set `limit` to `10`
6. Click "Execute"
7. View the response showing your WCM libraries

## Common Query Parameters

All WCM API v3 list endpoints support standard query parameters:

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `offset` | int | Zero-based starting index for pagination | `?offset=0` |
| `limit` | int | Maximum items per page (1-1000, default 100) | `?limit=50` |
| `fields` | string | Comma-separated list of fields to include | `?fields=id,title,status` |
| `includeMetadata` | boolean | Include full metadata (creator, workflow, etc.) | `?includeMetadata=true` |
| `libraryId` | string | Filter by library (for contents, site areas, etc.) | `?libraryId=lib-001` |

## Basic Usage Examples

### List All Libraries

```bash
curl -k -u wpsadmin:password \
  "https://your-dx-host/dx/api/wcm/v3/libraries?limit=10"
```

### Get a Specific Library

```bash
curl -k -u user:password \
  https://your-dx-host/dx/api/wcm/v3/libraries/{library-id}
```

### Create a New Library

```bash
curl -k -u wpsadmin:password \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "name": "my-library",
    "title": "My Library",
    "description": "A new WCM library"
  }' \
  https://your-dx-host/dx/api/wcm/v3/libraries
```

### Update a Library (Partial Update with PATCH)

```bash
# First, get the ETag
ETAG=$(curl -s -I -k -u wpsadmin:password \
  https://your-dx-host/dx/api/wcm/v3/libraries/{library-id} | \
  grep -i etag | cut -d' ' -f2)

# Then update with PATCH
curl -k -u wpsadmin:password \
  -X PATCH \
  -H "Content-Type: application/merge-patch+json" \
  -H "If-Match: $ETAG" \
  -d '{
    "description": "Updated description"
  }' \
  https://your-dx-host/dx/api/wcm/v3/libraries/{library-id}
```

### Delete a Library

```bash
curl -k -u wpsadmin:password \
  -X DELETE \
  https://your-dx-host/dx/api/wcm/v3/libraries/{library-id}
```

## Virtual Portal Support

WCM API v3 automatically detects Virtual Portal (VP) context from the request:

- **Hostname-based**: `https://vp1.example.com/dx/api/wcm/v3/libraries`
- **Context-based**: `https://example.com/wps/myconnect/dx/api/wcm/v3/libraries`
- **Base portal**: `https://example.com/dx/api/wcm/v3/libraries`

For the API Explorer, you can specify a virtual portal using a query parameter:
```
https://your-dx-host/dx/api/wcm/v3/explorer/?virtualPortal=myVP
```

## Response Format

All WCM API v3 responses follow a consistent structure:

### Single Resource Response

```json
{
  "id": "wcm:oid:lib-001",
  "name": "web-content",
  "title": "Web Content",
  "description": "Main web content library",
  "created": "2026-01-15T10:00:00Z",
  "lastModified": "2026-08-31T14:30:00Z",
  "_links": {
    "self": {
      "href": "/dx/api/wcm/v3/libraries/wcm:oid:lib-001"
    }
  }
}
```

### Collection Response

```json
{
  "items": [
    { "id": "lib-001", "name": "web-content", "title": "Web Content" },
    { "id": "lib-002", "name": "marketing", "title": "Marketing" }
  ],
  "pagination": {
    "offset": 0,
    "limit": 10,
    "total": 25,
    "hasMore": true
  },
  "_links": {
    "self": { "href": "/dx/api/wcm/v3/libraries?offset=0&limit=10" },
    "next": { "href": "/dx/api/wcm/v3/libraries?offset=10&limit=10" }
  }
}
```

## Error Handling

WCM API v3 returns RFC 7807 Problem Details for errors:

```json
{
  "type": "https://api.hcl.com/problems/not-found",
  "title": "Library not found",
  "status": 404,
  "detail": "Library with id 'wcm:oid:lib-999' not found",
  "instance": "a1b2c3d4-5e6f-7g8h-9i0j-k1l2m3n4o5p6"
}
```

Common HTTP status codes:

| Status | Meaning |
|--------|---------|
| 200 | Success (GET, PUT, PATCH) |
| 201 | Created (POST) |
| 204 | No Content (DELETE) |
| 400 | Bad Request (validation error) |
| 401 | Unauthorized (authentication required) |
| 403 | Forbidden (insufficient permissions) |
| 404 | Not Found |
| 412 | Precondition Failed (ETag mismatch) |
| 428 | Precondition Required (If-Match header missing) |
| 503 | Service Unavailable (API disabled) |

## Best Practices

1. **Use PATCH for Partial Updates**: When updating only a few fields, use PATCH instead of PUT to avoid accidental overwrites and reduce payload size.

2. **Leverage ETags**: Always use the `If-Match` header with PUT and PATCH operations to prevent concurrent update conflicts.

3. **Request Only Needed Fields**: Use the `?fields=` parameter to reduce response payload size and improve performance.

4. **Implement Pagination**: For large datasets, use `offset` and `limit` parameters to paginate through results.

5. **Handle Errors Properly**: Parse RFC 7807 Problem Details for comprehensive error information.

6. **Use the API Explorer**: Leverage the built-in Swagger UI for interactive testing and documentation discovery.

## Next Steps

- Explore the [API Explorer](https://your-dx-host/dx/api/wcm/v3/explorer/) for complete endpoint documentation
- Learn about [Enabling and disabling WCM API v3](../../cfg_dx_compose/enable_wcm_api_v3.md) if you need to disable or re-enable it

## Related Information

- [REST service for Web Content Manager v2](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_development/wcm_rest_v2/){target="_blank"}
- [HCL Experience API](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/apis/hcl_experience_api/){target="_blank"}
- [REST API Explorers](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/apis/hcl_experience_api/api_explorers/){target="_blank"}
