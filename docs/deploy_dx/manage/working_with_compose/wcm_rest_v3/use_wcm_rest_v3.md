# Using Web Content Manager REST API v3

This guide provides practical examples for using the WCM REST API v3 to manage Web Content Manager (WCM) resources.

## Prerequisites

- Web Content Management (WCM) API v3 is enabled (enabled by default in Cumulative Fix (CF) 238 or a later version).
- Valid HCL DX credentials are available.
- A basic understanding of REST APIs and HTTP methods is required.

For authentication and endpoint details, refer to [Configuring Web Content Manager REST API v3](configure_wcm_rest_v3.md).

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
    "total": 5
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
  https://your-dx-host/dx/api/wcm/v3/libraries/wcm:oid:lib-001
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
  https://your-dx-host/dx/api/wcm/v3/libraries/wcm:oid:lib-002 | \
  grep -i etag | cut -d' ' -f2 | tr -d '\r')

# Then update with PATCH
curl -k -u user:password \
  -X PATCH \
  -H "Content-Type: application/merge-patch+json" \
  -H "If-Match: $ETAG" \
  -d '{
    "description": "Updated description"
  }' \
  https://your-dx-host/dx/api/wcm/v3/libraries/wcm:oid:lib-002
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
  https://your-dx-host/dx/api/wcm/v3/libraries/wcm:oid:lib-002
```

Response: (204 No Content)

## Content

### Listing content items

To retrieve a list of content items from a specific library:

```bash
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/contents?libraryId=wcm:oid:lib-001&limit=10"
```

### Retrieving specific content

To retrieve a specific content item:

```bash
curl -k -u user:password \
  https://your-dx-host/dx/api/wcm/v3/contents/wcm:oid:content-001
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
    "libraryId": "wcm:oid:lib-001",
    "siteAreaId": "wcm:oid:sa-001"
  }' \
  https://your-dx-host/dx/api/wcm/v3/contents
```

## Site Areas

### Listing site areas

To retrieve a list of site areas from a library:

```bash
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/site-areas?libraryId=wcm:oid:lib-001"
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
    "libraryId": "wcm:oid:lib-001"
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

To request only specific fields to reduce payload size:

```bash
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/libraries?fields=id,name,title"
```

Response:

```json
{
  "pagination": {
    "offset": 0,
    "limit": 50,
    "total": 5
  },
  "links": {
    "self": "/dx/api/wcm/v3/libraries?fields=id,name&offset=0&limit=50",
    "first": "/dx/api/wcm/v3/libraries?fields=id,name&offset=0&limit=50",
    "last": "/dx/api/wcm/v3/libraries?fields=id,name&offset=0&limit=50"
  },
  "items": [
    {
      "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
      "name": "web content"
    }
  ]
}
```

### Including metadata

To request metadata, such as creator and workflow details:

```bash
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/contents/wcm:oid:content-001?includeMetadata=true"
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
  "https://your-dx-host/dx/api/wcm/v3/search?q=article&libraryId=wcm:oid:lib-001"
```

## Error handling examples

### Handle 404 not found

```bash
curl -k -u user:password \
  https://your-dx-host/dx/api/wcm/v3/libraries/wcm:oid:invalid-id
```

Response (404):

```json
{
  "type": "https://api.hcl.com/problems/not-found",
  "title": "Library not found",
  "status": 404,
  "detail": "Library with id 'wcm:oid:invalid-id' not found",
  "instance": "a1b2c3d4-5e6f-7g8h-9i0j-k1l2m3n4o5p6"
}
```

### Handle 412 precondition failed (ETag mismatch)

```bash
curl -k -u user:password \
  -X PATCH \
  -H "Content-Type: application/merge-patch+json" \
  -H "If-Match: \"wrong-etag\"" \
  -d '{"description": "Updated"}' \
  https://your-dx-host/dx/api/wcm/v3/libraries/wcm:oid:lib-001
```

Response (412):

```json
{
  "type": "https://api.hcl.com/problems/precondition-failed",
  "title": "Precondition Failed",
  "status": 412,
  "detail": "The resource has been modified since the ETag was generated",
  "instance": "b2c3d4e5-6f7g-8h9i-0j1k-l2m3n4o5p6q7"
}
```

## Best practices

### Always use ETags for updates

```bash
# Good: Get ETag first
ETAG=$(curl -s -I -k -u user:password \
  https://your-dx-host/dx/api/wcm/v3/libraries/wcm:oid:lib-001 | \
  grep -i etag | cut -d' ' -f2 | tr -d '\r')

curl -k -u user:password \
  -X PATCH \
  -H "If-Match: $ETAG" \
  -H "Content-Type: application/merge-patch+json" \
  -d '{"description": "Updated"}' \
  https://your-dx-host/dx/api/wcm/v3/libraries/wcm:oid:lib-001
```

### Use PATCH for partial updates

```bash
# Good: PATCH for partial update
curl -k -u user:password \
  -X PATCH \
  -H "Content-Type: application/merge-patch+json" \
  -H "If-Match: $ETAG" \
  -d '{"description": "New description"}' \
  https://your-dx-host/dx/api/wcm/v3/libraries/wcm:oid:lib-001

# Avoid: PUT requires full resource representation
```

### Request only needed fields

```bash
# Good: Request only what you need
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/libraries?fields=id,name"

# Avoid: Requesting all fields when you only need a few
```

### Implement pagination

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
