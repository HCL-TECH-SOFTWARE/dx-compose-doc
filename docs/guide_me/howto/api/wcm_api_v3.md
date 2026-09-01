# WCM API v3

## Overview

The HCL Digital Experience (DX) Web Content Manager (WCM) API v3 is a modern REST API that provides streamlined access to WCM content, libraries, site areas, categories, taxonomies, and presentation templates. Built on JAX-RS 2.1 and OpenAPI 3.0 standards, it offers a cleaner, more efficient alternative to previous API versions.

**Quick Access**: Once enabled, explore the API interactively at:
```
https://localhost:9443/dx/api/wcm/v3/explorer/
```
or replace `localhost:9443` with your DX server hostname and port.

## What's New in WCM API v3

WCM API v3 introduces significant improvements over previous versions:

### Modern Architecture
- **JAX-RS 2.1 Compliant**: Standards-based REST API built on Java EE 8
- **OpenAPI 3.0 Integration**: Auto-generated API documentation with interactive Swagger UI
- **Immutable DTOs**: Java 21 Records for type-safe, immutable data transfer objects
- **Clean Architecture**: Layered design with clear separation of concerns (Resource → Service → Repository)

### Enhanced Developer Experience
- **Built-in API Explorer**: Interactive Swagger UI at `/dx/api/wcm/v3/explorer/` for live API testing
- **Simplified Payloads**: Flat, intuitive JSON structures without nested Atom format complexity
- **RFC 7807 Error Responses**: Standardized problem details for consistent error handling
- **HATEOAS Links**: Hypermedia links on all responses for API discoverability

### Advanced HTTP Features
- **ETag Support**: Conditional GET/PUT operations for optimistic concurrency control
- **JSON Merge Patch**: RFC 7396 compliant PATCH operations for partial updates
- **Sparse Fieldsets**: `?fields=` query parameter to request only needed fields
- **Pagination**: Consistent offset/limit pagination across all list endpoints

### Content Management Capabilities
- **Full CRUD Operations**: Complete create, read, update, delete for all WCM resources
- **Virtual Portal Support**: Automatic VP context detection from hostname or URL path
- **Unified Search**: Simplified search across content, libraries, and site areas
- **Presentation Templates**: Manage WCM presentation templates via REST API

## WCM API Version Comparison

### Summary: v1 vs v2 vs v3

| Feature | v1 (Legacy) | v2 (wcmrest-v2) | v3 (wcm.api.v3) |
|---------|-------------|-----------------|-----------------|
| **Architecture** | Portal Plugin | DX Portal Plugin | Standard JAX-RS WAR |
| **Base URL** | `/wps/mycontenthandler/wcmrest/` | `/wps/mycontenthandler/wcmrest-v2/` | `/dx/api/wcm/v3/` |
| **JSON Format** | Atom-based | Atom-based with enhancements | Clean, flat JSON |
| **OpenAPI Spec** | None | Static JSON (1.2MB) | Auto-generated via annotations |
| **API Explorer** | None | Swagger UI | Swagger UI with live testing |
| **Data Model** | Mutable POJOs | Mutable Atom beans | Immutable Java Records |
| **HTTP Methods** | GET, POST, PUT, DELETE | GET, POST, PUT, DELETE | GET, POST, PUT, PATCH, DELETE |
| **PATCH Support** | ❌ No | ❌ No | ✅ RFC 7396 JSON Merge Patch |
| **ETag/Conditional** | ❌ No | ❌ Limited | ✅ Full support |
| **Error Format** | Custom | Custom | RFC 7807 Problem Details |
| **Virtual Portal** | ✅ Yes | ✅ Yes | ✅ Auto-detection |
| **Content CRUD** | ✅ Full | ✅ Full | ✅ Full |
| **Libraries** | ✅ Full | ✅ Full | ✅ Full |
| **Site Areas** | ✅ Full | ✅ Full | ✅ Full |
| **Categories** | ✅ Full | ✅ Full | ✅ Full |
| **Taxonomies** | ❌ Limited | ✅ Full | ✅ Full |
| **Presentation Templates** | ❌ No | ❌ Limited | ✅ Full CRUD |
| **Search** | ✅ Basic | ✅ Advanced | ✅ Simplified unified search |
| **AI Analysis** | ❌ No | ✅ Sentiment/Keywords | ❌ Not yet (planned) |
| **Bulk Operations** | ❌ No | ✅ Async tracking | ❌ Not yet (planned) |
| **Workflow** | ✅ Basic | ✅ Via wrappers | ❌ Not yet (planned) |
| **Versioning** | ✅ Basic | ✅ Full | ❌ Not yet (planned) |

### When to Use Each Version

**Use v1 (Legacy)** when:
- Maintaining legacy integrations that cannot be updated
- Working with very old DX versions

**Use v2 (wcmrest-v2)** when:
- You need AI-powered content analysis (sentiment, keywords, summary)
- Bulk operations with async tracking are required
- Advanced workflow operations are needed
- Full component type support (30+ types) is necessary
- Legacy compatibility is a priority

**Use v3 (wcm.api.v3)** when:
- Building new integrations or modernizing existing ones
- You need simpler, cleaner JSON payloads
- Conditional requests (ETag, If-Match) are important
- Partial updates via PATCH are beneficial
- Standards-based REST API is preferred
- Modern frontend integration is the goal
- Presentation template management is required

## Available Endpoints

WCM API v3 provides the following REST endpoints:

### Health Endpoints
- `GET /health` - Combined health status (WCM connectivity + feature toggle)
- `GET /health/live` - Liveness probe
- `GET /health/ready` - Readiness probe

### Categories
- `GET /categories` - List categories with pagination
- `POST /categories` - Create a new category
- `GET /categories/{id}` - Get category by ID
- `PUT /categories/{id}` - Full update of category
- `PATCH /categories/{id}` - Partial update (JSON Merge Patch)
- `DELETE /categories/{id}` - Delete category

### Contents
- `GET /contents` - List content items with pagination
- `POST /contents` - Create new content
- `GET /contents/{id}` - Get content by ID
- `PUT /contents/{id}` - Full update of content
- `PATCH /contents/{id}` - Partial update (JSON Merge Patch)
- `DELETE /contents/{id}` - Delete content

### Libraries
- `GET /libraries` - List WCM libraries with pagination
- `POST /libraries` - Create a new library
- `GET /libraries/{id}` - Get library by ID
- `PUT /libraries/{id}` - Full update of library
- `PATCH /libraries/{id}` - Partial update (JSON Merge Patch)
- `DELETE /libraries/{id}` - Delete library

### Presentation Templates
- `GET /presentation-templates` - List presentation templates with pagination
- `POST /presentation-templates` - Create a new presentation template
- `GET /presentation-templates/{id}` - Get presentation template by ID
- `PUT /presentation-templates/{id}` - Full update of presentation template
- `PATCH /presentation-templates/{id}` - Partial update (JSON Merge Patch)
- `DELETE /presentation-templates/{id}` - Delete presentation template

### Search
- `GET /search` - Unified search across WCM content, libraries, and site areas

### Site Areas
- `GET /site-areas` - List site areas with pagination
- `POST /site-areas` - Create a new site area
- `GET /site-areas/{id}` - Get site area by ID
- `PUT /site-areas/{id}` - Full update of site area
- `PATCH /site-areas/{id}` - Partial update (JSON Merge Patch)
- `DELETE /site-areas/{id}` - Delete site area

### Taxonomies
- `GET /taxonomies` - List taxonomies with pagination
- `POST /taxonomies` - Create a new taxonomy
- `GET /taxonomies/{id}` - Get taxonomy by ID
- `PUT /taxonomies/{id}` - Full update of taxonomy
- `PATCH /taxonomies/{id}` - Partial update (JSON Merge Patch)
- `DELETE /taxonomies/{id}` - Delete taxonomy

## How to Enable WCM API v3

WCM API v3 is controlled by a feature toggle and can be enabled in DX Compose deployments.

### Helm Configuration

To enable WCM API v3 in your Helm deployment, set the following value in your `values.yaml` or via the `--set` flag:

```yaml
incubator:
  configuration:
    webEngine:
      wcmApiV3Enabled: true
```

Or via command line during Helm install/upgrade:

```bash
helm upgrade dx-deployment hcl/hcl-dx-deployment \
  --set incubator.configuration.webEngine.wcmApiV3Enabled=true \
  --namespace dx
```

### Verification

After enabling the feature, verify that WCM API v3 is running:

1. **Check Health Endpoint**:
   ```bash
   curl -k https://your-dx-host/dx/api/wcm/v3/health
   ```

   Expected response:
   ```json
   {
     "status": "UP",
     "checks": [
       {
         "name": "wcm-connectivity",
         "status": "UP"
       },
       {
         "name": "feature-toggle",
         "status": "UP"
       }
     ]
   }
   ```

2. **Access API Explorer**:
   Open your browser and navigate to:
   ```
   https://your-dx-host/dx/api/wcm/v3/explorer/
   ```
   
   For local development:
   ```
   https://localhost:9443/dx/api/wcm/v3/explorer/
   ```

   The Swagger UI interface should load, showing all available endpoints with interactive testing capabilities.

3. **View OpenAPI Specification**:
   ```bash
   # JSON format
   curl -k -H "Accept: application/json" \
     https://your-dx-host/dx/api/wcm/v3/openapi

   # YAML format
   curl -k -H "Accept: application/yaml" \
     https://your-dx-host/dx/api/wcm/v3/openapi
   ```

### Authentication

WCM API v3 supports two authentication methods:

1. **HTTP Basic Authentication** (for REST clients):
   ```bash
   curl -k -u wpsadmin:password \
     https://your-dx-host/dx/api/wcm/v3/libraries
   ```

2. **SSO (LTPA Token)** (for browser-based access):
   - Log in to DX Portal first
   - The LTPA cookie will be used for authentication
   - Useful when accessing the API Explorer

### Common Query Parameters

All WCM API v3 endpoints support standard query parameters:

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `offset` | int | Zero-based starting index for pagination | `?offset=0` |
| `limit` | int | Maximum items per page (1-1000, default 100) | `?limit=50` |
| `fields` | string | Comma-separated list of fields to include | `?fields=id,title,status` |
| `includeMetadata` | boolean | Include full metadata (creator, workflow, etc.) | `?includeMetadata=true` |
| `libraryId` | string | Filter by library (for contents, site areas, etc.) | `?libraryId=lib-001` |

### Example Usage

**List all libraries**:
```bash
curl -k -u wpsadmin:password \
  https://your-dx-host/dx/api/wcm/v3/libraries?limit=10
```

**Get a specific content item**:
```bash
curl -k -u wpsadmin:password \
  https://your-dx-host/dx/api/wcm/v3/contents/{content-id}
```

**Create a new library**:
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

**Partial update using PATCH**:
```bash
curl -k -u wpsadmin:password \
  -X PATCH \
  -H "Content-Type: application/merge-patch+json" \
  -H "If-Match: \"etag-value\"" \
  -d '{
    "description": "Updated description"
  }' \
  https://your-dx-host/dx/api/wcm/v3/libraries/{library-id}
```

## Using the API Explorer

The WCM API v3 includes a built-in Swagger UI-based API Explorer for interactive testing and documentation.

### Accessing the Explorer

**URL Format**:
```
https://{your-dx-host}/dx/api/wcm/v3/explorer/
```

**Examples**:
- Local development: `https://localhost:9443/dx/api/wcm/v3/explorer/`
- Production: `https://dx.example.com/dx/api/wcm/v3/explorer/`

### Features

The API Explorer provides:

- **Interactive Testing**: Execute API calls directly from your browser
- **Auto-Generated Documentation**: Real-time documentation from OpenAPI annotations
- **Request/Response Examples**: See sample payloads for all endpoints
- **Schema Definitions**: View complete data models for all DTOs
- **Authentication Support**: Test with Basic Auth or SSO credentials
- **Try It Out**: Execute live requests and see actual responses

### Using the Explorer

1. **Navigate to the Explorer URL** in your web browser
2. **Authenticate** (if not already logged into DX Portal):
   - Click "Authorize" button
   - Enter your DX credentials (e.g., `wpsadmin` / `password`)
   - Click "Authorize" to save credentials
3. **Browse Endpoints**: Expand endpoint categories (Categories, Contents, Libraries, etc.)
4. **Test an Endpoint**:
   - Click on an endpoint to expand it
   - Click "Try it out"
   - Fill in required parameters
   - Click "Execute"
   - View the response below

### Example: Testing the Libraries Endpoint

1. Navigate to `https://localhost:9443/dx/api/wcm/v3/explorer/`
2. Click "Authorize" and enter credentials
3. Expand the "Libraries" section
4. Click on `GET /libraries`
5. Click "Try it out"
6. Set parameters (e.g., `limit=10`)
7. Click "Execute"
8. View the response with actual library data

## Virtual Portal Support

WCM API v3 automatically detects Virtual Portal (VP) context from the request:

- **Hostname-based**: `https://vp1.example.com/dx/api/wcm/v3/libraries`
- **Context-based**: `https://example.com/wps/myconnect/dx/api/wcm/v3/libraries`
- **Base portal**: `https://example.com/dx/api/wcm/v3/libraries`

### Virtual Portal in API Explorer

For the API Explorer, you can specify a virtual portal using a query parameter:
```
https://your-dx-host/dx/api/wcm/v3/explorer/?virtualPortal=myVP
```

This allows you to test API calls in the context of a specific virtual portal.

## Best Practices

1. **Use PATCH for Partial Updates**: When updating only a few fields, use PATCH instead of PUT to avoid accidental overwrites and reduce payload size.

2. **Leverage ETags**: Always use the `If-Match` header with PUT and PATCH operations to prevent concurrent update conflicts.

3. **Request Only Needed Fields**: Use the `?fields=` parameter to reduce response payload size and improve performance.

4. **Implement Pagination**: For large datasets, use `offset` and `limit` parameters to paginate through results.

5. **Handle Errors Properly**: WCM API v3 returns RFC 7807 Problem Details for errors. Parse the `type`, `title`, `status`, and `detail` fields for comprehensive error information.

6. **Use the API Explorer**: Leverage the built-in Swagger UI at `/dx/api/wcm/v3/explorer/` for interactive testing and documentation.

## Troubleshooting

### API Returns 503 Service Unavailable

**Cause**: The WCM API v3 feature toggle is disabled.

**Solution**: Enable the feature via Helm configuration:
```bash
helm upgrade dx-deployment hcl/hcl-dx-deployment \
  --set incubator.configuration.webEngine.wcmApiV3Enabled=true
```

### API Explorer Shows 401 Unauthorized

**Cause**: Browser security or CORS blocking Basic Auth header.

**Solution**: Log in to DX Portal first to establish an SSO session, then access the API Explorer.

### PATCH Returns 415 Unsupported Media Type

**Cause**: Missing or incorrect Content-Type header.

**Solution**: Always use `Content-Type: application/merge-patch+json` for PATCH requests:
```bash
curl -X PATCH \
  -H "Content-Type: application/merge-patch+json" \
  -H "If-Match: \"etag-value\"" \
  -d '{"description": "Updated"}' \
  https://your-dx-host/dx/api/wcm/v3/libraries/{id}
```

### PUT/PATCH Returns 428 Precondition Required

**Cause**: Missing `If-Match` header.

**Solution**: All PUT and PATCH operations require the `If-Match` header with the current ETag value:
```bash
# First, get the current ETag
ETAG=$(curl -s -I -k -u wpsadmin:password \
  https://your-dx-host/dx/api/wcm/v3/libraries/{id} | \
  grep -i etag | cut -d' ' -f2)

# Then use it in the update
curl -X PUT \
  -H "If-Match: $ETAG" \
  -H "Content-Type: application/json" \
  -d '{"name": "updated-name", ...}' \
  https://your-dx-host/dx/api/wcm/v3/libraries/{id}
```

## Additional Resources

### Interactive Tools

- **API Explorer (Swagger UI)**: `https://your-dx-host/dx/api/wcm/v3/explorer/`
  - Interactive testing interface
  - Live API documentation
  - Request/response examples
  - Schema definitions
  
- **Health Check**: `https://your-dx-host/dx/api/wcm/v3/health`
  - Monitor API availability
  - Check WCM connectivity
  - Verify feature toggle status

### API Specifications

- **OpenAPI Specification (JSON)**: `https://your-dx-host/dx/api/wcm/v3/openapi`
  - Machine-readable API definition
  - Import into tools like Postman, Insomnia
  
- **OpenAPI Specification (YAML)**: Add header `Accept: application/yaml`
  - Human-readable format
  - Use for documentation generation

### Quick Reference URLs

For local development (default):
- Explorer: `https://localhost:9443/dx/api/wcm/v3/explorer/`
- Health: `https://localhost:9443/dx/api/wcm/v3/health`
- OpenAPI: `https://localhost:9443/dx/api/wcm/v3/openapi`

### Related Documentation

For more information about HCL DX APIs, see:
- [How to use the WCM API to search for pages in the Portal site library](https://help.hcl-software.com/digital-experience/9.5/latest/guide_me/howto/api/searchPagesInPortalSiteLibrary/){target="_blank"}
