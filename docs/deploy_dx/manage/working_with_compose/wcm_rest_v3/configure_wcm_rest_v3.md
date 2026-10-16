# Configuring Web Content Manager REST API v3

You can use Web Content Manager (WCM) REST v3 APIs to manage web content. The REST service for Web Content Manager v3 provides modern, standards-based access to content items, libraries, site areas, and other WCM resources. WCM REST v3 APIs are built on Java API for RESTful Web Services (JAX-RS) 2.1 and OpenAPI 3.0 standards, providing a cleaner and more efficient alternative to previous API versions.

## Authentication

WCM API v3 supports two authentication methods:

### HTTP Basic authentication

Use HTTP basic authentication for programmatic access through REST clients, command-line tools, or automated scripts. Pass standard user credentials in the request header. For example, to retrieve a list of WCM libraries using `curl`:

```bash
curl -u user:password \
  https://your-dx-host/dx/api/wcm/v3/libraries
```

Use `-k` only when testing against a development host with an untrusted TLS certificate. Do not disable certificate verification in production.

### Single Sign-On

Use Single Sign-On (SSO) for interactive API testing in the API Explorer or custom web applications running within the same domain. The browser passes the Lightweight Third-Party Authentication (LTPA) token cookie automatically.

To authenticate using SSO:

1. Sign in to your HCL DX environment in a web browser.
2. Open the API Explorer in the same browser session.

## Endpoints

```url
https://<dx-host>:<port>/dx/api/wcm/v3
```

- `<dx-host>`: The environment hostname.
- `<port>`: The port number.

| Resource | Endpoint | Description |
|----------|----------|-------------|
| Categories | `/categories` | Manages WCM categories |
| Contents | `/contents` | Manages content items |
| Libraries | `/libraries` | Manages WCM libraries |
| Presentation Templates | `/presentation-templates` | Manages presentation templates |
| Search | `/search` | Searches across WCM resources |
| Site Areas | `/site-areas` | Manages site areas |
| Taxonomies | `/taxonomies` | Manages taxonomies |

For details on how to view complete list of endpoints, refer to [Testing an endpoint](#testing-an-endpoint) section.

## API Explorer

The WCM API v3 includes a built-in Swagger UI-based API Explorer for interactive testing and documentation. Access the interactive API Explorer at `/dx/api/wcm/v3/explorer/` on the DX host to test endpoints and inspect OpenAPI specifications directly in the browser. Use the interface to perform the following tasks:

The canonical OpenAPI document served by the same host is `/dx/api/wcm/v3/specs/openapi.json`. Use it for endpoint-specific parameter descriptions and request/response schemas.

- Execute live HTTP requests against server endpoints.
- Inspect auto-generated OpenAPI 3.0 schemas and data models.
- Review request parameters, header requirements, and payload structures.
- View formatted HTTP response status codes and JSON payloads.

### Testing an endpoint

1. Sign in to the DX server's web UI in the same browser to use your session cookie, or select **Authorize** and enter DX credentials for HTTP Basic authentication.
2. Browse to an endpoint (for example **Libraries > GET /libraries**).
3. Select **Try it out**.
4. Set parameters (for example `limit=10`).
5. Select **Execute**.
6. View the response with actual data.

Explorer-generated cURL reflects the values selected in the Explorer, so its query can differ from the examples in this guide. For example, `fields=name,title,published` is included when those fields are selected, while the guide's content-list example adds `libraryId` and `limit` as filters. Explorer may also include declared defaults such as `offset=0`, `limit=100`, `page=0`, `pageSize=0`, and `includeMetadata=false`; these do not all need to be supplied. Use either `offset`/`limit` (zero-based offset) or positive `page`/`pageSize` values, not both; positive `page`/`pageSize` values override `offset`/`limit`.

Explorer-generated cURL also includes `-X GET` and `Accept: application/json` to make the method and response format explicit. The examples omit these because cURL defaults to GET for requests without a body, and the API returns JSON.

Explorer requests use a browser session cookie or **Authorize** credentials. A copied cURL command may not include a browser-session cookie, so add `-u user:password` (or an appropriate cookie) before running it outside the browser. The examples in this guide use HTTP Basic credentials explicitly.

Explorer-generated cURL includes `-X GET` explicitly and `Accept: application/json`; these examples omit them because cURL uses GET by default, while the `Accept` header makes the requested JSON response explicit.

For example to show a list of libraries:

1. Navigate to the API Explorer.
2. Expand the **Libraries** section.
3. Select **GET /libraries**.
4. Select **Try it out**.
5. Set **limit** to `10`.
6. Select **Execute**.
7. View the response showing your WCM libraries.

## Common query parameters

All WCM API v3 list endpoints support standard query parameters:

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `offset` | int | Zero-based starting index for pagination | `?offset=0` |
| `limit` | int | Maximum items per page (`1` to `1000`, default `100`) | `?limit=50` |
| `fields` | string | Comma-separated resource-specific fields; see the OpenAPI parameter for each endpoint | `?fields=id,name,title` (libraries) |
| `includeMetadata` | boolean | Include full metadata (creator, workflow, etc.) | `?includeMetadata=true` |
| `libraryId` | string | Filter by library (for contents, site areas, etc.) | `?libraryId=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` |

UUIDs shown as `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` in the examples are placeholders, not real IDs. Replace them with IDs from your DX environment.

## Usage examples

For practical examples of using the WCM REST API v3, including CRUD operations, query parameters, and best practices, see [WCM REST API v3 Usage Examples](use_wcm_rest_v3.md).

## Virtual portal support

WCM API v3 automatically detects Virtual Portal (VP) context from the request:

- Hostname-based requests

    ```url
    https://vp1.example.com/dx/api/wcm/v3/libraries
    ```

- Context-based requests

    ```url
    https://example.com/wps/myconnect/dx/api/wcm/v3/libraries
    ```

- Base portal requests

    ```url
    https://example.com/dx/api/wcm/v3/libraries
    ```

!!!note
    You can specify a virtual portal in the API explorer using a query parameter: `/dx/api/wcm/v3/explorer/?virtualPortal=myVP`

## Response format

All WCM API v3 responses follow a consistent structure:

Single resource response:

```json
{
  "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "name": "web content",
  "title": "Web Content",
  "titleTextProviderName": "com.ibm.wps.plugins.WebResourcesTextProvider",
  "titleTextProviderKey": "OOB_WEB_CONTENT_LIBRARY",
  "type": "Library",
  "enabled": true,
  "allowDeletion": true,
  "lastModified": "Wed, 26 Aug 2026 16:44:07.820Z"
}
```

Collection response (two items shown from a 10-item page):

```json
{
  "pagination": {
    "offset": 0,
    "limit": 10,
    "total": 25
  },
  "links": {
    "self": "/dx/api/wcm/v3/libraries?offset=0&limit=10",
    "first": "/dx/api/wcm/v3/libraries?offset=0&limit=10",
    "last": "/dx/api/wcm/v3/libraries?offset=20&limit=10",
    "next": "/dx/api/wcm/v3/libraries?offset=10&limit=10"
  },
  "items": [
    {
      "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
      "name": "web content",
      "title": "Web Content",
      "type": "Library",
      "enabled": true,
      "allowDeletion": true,
      "lastModified": "Wed, 26 Aug 2026 16:44:07.820Z"
    },
    {
      "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
      "name": "marketing",
      "title": "Marketing",
      "type": "Library",
      "enabled": true,
      "allowDeletion": true,
      "lastModified": "Wed, 26 Aug 2026 15:30:00.000Z"
    }
  ]
}
```

## Error handling

WCM API v3 returns RFC 7807 Problem Details for errors:

```json
{
  "type": "https://api.hcl.com/problems/not-found",
  "title": "Library not found",
  "status": 404,
  "detail": "Library with id 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' not found",
  "instance": "/dx/api/wcm/v3/libraries/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

Common HTTP status codes:

| Status | Meaning |
|--------|---------|
| 200 | Success (`GET`, `PUT`, `PATCH`) |
| 201 | Created (`POST`) |
| 204 | No Content (`DELETE`) |
| 400 | Bad Request (validation error) |
| 401 | Unauthorized (authentication required) |
| 403 | Forbidden (insufficient permissions) |
| 404 | Not Found |
| 412 | Precondition Failed (`ETAG` mismatch) |
| 428 | Precondition Required (`If-Match` header missing) |
| 503 | Service Unavailable (API disabled) |

## Best practices

1. For partial updates, use `PATCH` instead of `PUT` to avoid accidental overwrites and reduce payload size.
2. Always use the `If-Match` header with `PUT` and `PATCH` operations to prevent concurrent update conflicts.
3. Use the `?fields=` parameter to reduce response payload size and improve performance.
4. For large datasets, use `offset` and `limit` parameters to paginate through results.
5. Parse `RFC 7807 Problem Details` for comprehensive error information.
6. Leverage the built-in Swagger UI for interactive testing and documentation discovery.

## Next steps

- See [Using Web Content Manager REST API v3](use_wcm_rest_v3.md) for hands-on examples.
- Try the API Explorer for the complete endpoint documentation.
- Learn about [Enabling and disabling WCM API v3](../../cfg_dx_compose/enable_wcm_api_v3.md) if you need to disable or re-enable it.

???+ info "Related information"
    - [REST service for Web Content Manager v2](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_development/wcm_rest_v2/){target="_blank"}
    - [HCL Experience API](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/apis/hcl_experience_api/){target="_blank"}
    - [REST API Explorers](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/apis/hcl_experience_api/api_explorers/){target="_blank"}
