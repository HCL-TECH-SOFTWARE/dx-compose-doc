# Using Web Content Manager REST API v3

This guide provides practical examples for using the WCM REST API v3 to manage Web Content Manager (WCM) resources.

## Prerequisites

- Web Content Management (WCM) API v3 is enabled. WCM API v3 is enabled by default in Cumulative Fix (CF) 238 and later versions.
- Valid HCL DX credentials are available.
- A basic understanding of REST APIs and HTTP methods is required.

For authentication and endpoint details, refer to [Configuring Web Content Manager REST API v3](configure_wcm_rest_v3.md).

## API Explorer and `curl` requests

The API Explorer (`https://your-dx-host/dx/api/wcm/v3/explorer/`) loads the canonical OpenAPI specification (`https://your-dx-host/dx/api/wcm/v3/specs/openapi.json`). Replace `your-dx-host` with your DX host. The examples in this guide are standalone `curl` requests using HTTP Basic credentials (`-u`).

Explorer-generated `curl` reflects the values selected in the Explorer, so its query can differ from the following examples:

- Explorer includes `fields=name,title,published` when you select those fields, while the guide's content-list example adds `libraryId` and `limit` as filters. Explorer can also include declared defaults such as `offset=0`, `limit=100`, `page=0`, `pageSize=0`, and `includeMetadata=false`. You do not need to supply all of them. Use either zero-based `offset` and `limit` values or positive `page` and `pageSize` values, not both. Positive `page` and `pageSize` values override `offset` and `limit`.
- Explorer includes `-X GET` and `Accept: application/json` to make the method and response format explicit. The examples omit these options because `curl` defaults to `GET` for requests without a body, and the API returns JSON.
- Explorer requests use a browser session cookie or **Authorize** credentials. A copied `curl` command might not include a browser session cookie, so add `-u user:password` or an appropriate cookie before running the command outside the browser. The examples in this guide use HTTP Basic credentials explicitly.

!!!note
    Replace the `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` placeholders in this guide with IDs from your DX Compose environment. Use IDs returned by create requests in subsequent calls.

## Libraries

### Listing all libraries

To retrieve a list of all WCM libraries:

```bash
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/libraries?limit=10"
```

Response:

```json
{
  "pagination": {
    "offset": 0,
    "limit": 10,
    "total": 1
  },
  "links": {
    "self": "/dx/api/wcm/v3/libraries?offset=0&limit=10",
    "first": "/dx/api/wcm/v3/libraries?offset=0&limit=10",
    "last": "/dx/api/wcm/v3/libraries?offset=0&limit=10"
  },
  "items": [
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
  ]
}
```

### Retrieving a specific library

To retrieve details of a specific library by ID:

```bash
curl -k -u user:password \
  https://your-dx-host/dx/api/wcm/v3/libraries/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

Response:

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

### Creating a new library

To create a new WCM library:

```bash
curl -k -u user:password \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "name": "my-library",
    "title": "My Library",
    "description": "A new WCM library"
  }' \
  https://your-dx-host/dx/api/wcm/v3/libraries
```

Response (201 created):

```json
{
  "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "name": "my-library",
  "title": "My Library",
  "description": "A new WCM library",
  "type": "Library",
  "enabled": true,
  "allowDeletion": true,
  "lastModified": "Wed, 04 Sep 2026 15:30:00.000Z"
}
```

### Updating a library

To update specific fields of a library using `PATCH`:

```bash
# First, get the ETag
ETAG=$(curl -s -I -k -u user:password \
  https://your-dx-host/dx/api/wcm/v3/libraries/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | \
  grep -i etag | cut -d' ' -f2 | tr -d '\r')

# Then update with PATCH
curl -k -u user:password \
  -X PATCH \
  -H "Content-Type: application/merge-patch+json" \
  -H "If-Match: $ETAG" \
  -d '{
    "description": "Updated description"
  }' \
  https://your-dx-host/dx/api/wcm/v3/libraries/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

Response (200 OK):

```json
{
  "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "name": "my-library",
  "title": "My Library",
  "description": "Updated description",
  "type": "Library",
  "enabled": true,
  "allowDeletion": true,
  "lastModified": "Wed, 04 Sep 2026 15:35:00.000Z"
}
```

### Deleting a library

To delete a library:

```bash
curl -k -u user:password \
  -X DELETE \
  https://your-dx-host/dx/api/wcm/v3/libraries/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

Response: (204 No Content)

## Content

### Listing content items

To retrieve a list of content items from a specific library:

```bash
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/contents?libraryId=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx&limit=10"
```

### Retrieving specific content

To retrieve a specific content item:

```bash
curl -k -u user:password \
  https://your-dx-host/dx/api/wcm/v3/contents/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

### Creating content

To create a new content item:

```bash
curl -k -u user:password \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "name": "welcome-article",
    "title": "Welcome Article",
    "libraryId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "siteAreaId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  }' \
  https://your-dx-host/dx/api/wcm/v3/contents
```

## Site Areas

### Listing site areas

To retrieve a list of site areas from a library:

```bash
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/site-areas?libraryId=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

### Creating a site area

To create a new site area:

```bash
curl -k -u user:password \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "name": "articles",
    "title": "Articles",
    "libraryId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  }' \
  https://your-dx-host/dx/api/wcm/v3/site-areas
```

## Using query parameters

### Paging through results

To page through large result sets:

```bash
# First page
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/contents?offset=0&limit=20"

# Second page
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/contents?offset=20&limit=20"
```

### Requesting specific fields

To request only specific fields to reduce payload size, use names valid for that resource. For example, libraries accept `id,name,title,description,type,enabled,allowDeletion,created,lastModified` and full-response fields such as `creator,lastModifier,links`; contents accept `id,name,title,status,libraryId,siteAreaId,contentType` and full-response fields such as `elements,workflow,links`. These are examples, not exhaustive lists. The `fields` parameter description for each endpoint in the [OpenAPI specification](`https://your-dx-host/dx/api/wcm/v3/specs/openapi.json`) lists its supported fields. Resource field selection uses top-level names; search additionally supports nested paths such as `data.Body` and `workflow.publishDate`.

```bash
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/libraries?fields=id,name,title&limit=50"
```

Response:

```json
{
  "pagination": {
    "offset": 0,
    "limit": 50,
    "total": 1
  },
  "links": {
    "self": "/dx/api/wcm/v3/libraries?fields=id,name,title&offset=0&limit=50",
    "first": "/dx/api/wcm/v3/libraries?fields=id,name,title&offset=0&limit=50",
    "last": "/dx/api/wcm/v3/libraries?fields=id,name,title&offset=0&limit=50"
  },
  "items": [
    {
      "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
      "name": "web content",
      "title": "Web Content"
    }
  ]
}
```

### Including metadata

To request metadata, such as creator and workflow details:

```bash
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/contents/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx?includeMetadata=true"
```

## Search

### Searching across resources

To search for content across all resources:

```bash
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/search?q=welcome&limit=10"
```

### Filtering by library

To search within a specific library:

```bash
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/search?q=article&libraryId=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

## Troubleshooting

### 404 Not Found

```bash
curl -k -u user:password \
  https://your-dx-host/dx/api/wcm/v3/libraries/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

Response (404):

```json
{
  "type": "https://api.hcl.com/problems/not-found",
  "title": "Library not found",
  "status": 404,
  "detail": "Library with id 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' not found",
  "instance": "/dx/api/wcm/v3/libraries/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

### 412 Precondition Failed (`ETAG` mismatch)

```bash
curl -k -u user:password \
  -X PATCH \
  -H "Content-Type: application/merge-patch+json" \
  -H "If-Match: \"wrong-etag\"" \
  -d '{"description": "Updated"}' \
  https://your-dx-host/dx/api/wcm/v3/libraries/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

Response (412):

```json
{
  "type": "https://api.hcl.com/problems/precondition-failed",
  "title": "Precondition Failed",
  "status": 412,
  "detail": "The resource has been modified since the ETag was generated",
  "instance": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

## Best practices

- Always use `ETAG` for updates

    ```bash
    # Good: Get ETag first
    ETAG=$(curl -s -I -k -u user:password \
      https://your-dx-host/dx/api/wcm/v3/libraries/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | \
      grep -i etag | cut -d' ' -f2 | tr -d '\r')

    curl -k -u user:password \
      -X PATCH \
      -H "If-Match: $ETAG" \
      -H "Content-Type: application/merge-patch+json" \
      -d '{"description": "Updated"}' \
      https://your-dx-host/dx/api/wcm/v3/libraries/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    ```

- Use `PATCH` for partial updates

    ```bash
    # Good: PATCH for partial update
    curl -k -u user:password \
      -X PATCH \
      -H "Content-Type: application/merge-patch+json" \
      -H "If-Match: $ETAG" \
      -d '{"description": "New description"}' \
      https://your-dx-host/dx/api/wcm/v3/libraries/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

    # Avoid: PUT requires full resource representation
    ```

- Only request the required fields

    ```bash
    # Good: Request only what you need
    curl -k -u user:password \
      "https://your-dx-host/dx/api/wcm/v3/libraries?fields=id,name"

    # Avoid: Requesting all fields when you only need a few
    ```

- Implement pagination

    ```bash
    # Good: Use pagination for large datasets
    curl -k -u user:password \
      "https://your-dx-host/dx/api/wcm/v3/contents?offset=0&limit=50"

    # Avoid: Requesting all items at once
    ```

???+ info "Related information"
    - [REST service for Web Content Manager v3](index.md)
    - [Enabling and disabling WCM API v3](../../cfg_dx_compose/enable_wcm_api_v3.md)
    - [Configuring WCM REST API v3](configure_wcm_rest_v3.md)
