# WCM REST API v3 Usage Examples

This guide provides practical examples for using the WCM REST API v3 to manage Web Content Manager resources.

## Prerequisites

- WCM API v3 is enabled (default in CF238+)
- Valid DX credentials
- Basic understanding of REST APIs and HTTP methods

For authentication and endpoint details, see [Getting started with WCM REST API v3](wcm_rest_v3_starting.md).

## Basic Usage Examples

### List All Libraries

Retrieve a list of all WCM libraries:

```bash
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/libraries?limit=10"
```

**Response**:
```json
{
  "items": [
    {
      "id": "wcm:oid:lib-001",
      "name": "web-content",
      "title": "Web Content",
      "description": "Main web content library"
    }
  ],
  "pagination": {
    "offset": 0,
    "limit": 10,
    "total": 5,
    "hasMore": false
  }
}
```

### Get a Specific Library

Retrieve details of a specific library by ID:

```bash
curl -k -u user:password \
  https://your-dx-host/dx/api/wcm/v3/libraries/wcm:oid:lib-001
```

**Response**:
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

### Create a New Library

Create a new WCM library:

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

**Response** (201 Created):
```json
{
  "id": "wcm:oid:lib-002",
  "name": "my-library",
  "title": "My Library",
  "description": "A new WCM library",
  "created": "2026-09-04T15:30:00Z",
  "lastModified": "2026-09-04T15:30:00Z",
  "_links": {
    "self": {
      "href": "/dx/api/wcm/v3/libraries/wcm:oid:lib-002"
    }
  }
}
```

### Update a Library (Partial Update with PATCH)

Update specific fields of a library using PATCH:

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

**Response** (200 OK):
```json
{
  "id": "wcm:oid:lib-002",
  "name": "my-library",
  "title": "My Library",
  "description": "Updated description",
  "created": "2026-09-04T15:30:00Z",
  "lastModified": "2026-09-04T15:35:00Z",
  "_links": {
    "self": {
      "href": "/dx/api/wcm/v3/libraries/wcm:oid:lib-002"
    }
  }
}
```

### Delete a Library

Delete a library:

```bash
curl -k -u user:password \
  -X DELETE \
  https://your-dx-host/dx/api/wcm/v3/libraries/wcm:oid:lib-002
```

**Response**: 204 No Content (successful deletion)

## Working with Content

### List Content Items

Retrieve content items from a specific library:

```bash
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/contents?libraryId=wcm:oid:lib-001&limit=10"
```

### Get Specific Content

Retrieve a specific content item:

```bash
curl -k -u user:password \
  https://your-dx-host/dx/api/wcm/v3/contents/wcm:oid:content-001
```

### Create Content

Create a new content item:

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

## Working with Site Areas

### List Site Areas

Retrieve site areas from a library:

```bash
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/site-areas?libraryId=wcm:oid:lib-001"
```

### Create a Site Area

Create a new site area:

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

## Using Query Parameters

### Pagination

Paginate through large result sets:

```bash
# First page
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/contents?offset=0&limit=20"

# Second page
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/contents?offset=20&limit=20"
```

### Sparse Fieldsets

Request only specific fields to reduce payload size:

```bash
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/libraries?fields=id,name,title"
```

**Response**:
```json
{
  "items": [
    {
      "id": "wcm:oid:lib-001",
      "name": "web-content",
      "title": "Web Content"
    }
  ]
}
```

### Include Metadata

Request full metadata (creator, workflow, etc.):

```bash
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/contents/wcm:oid:content-001?includeMetadata=true"
```

## Search Examples

### Search Across Resources

Search for content across all resources:

```bash
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/search?q=welcome&limit=10"
```

### Filter by Library

Search within a specific library:

```bash
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/search?q=article&libraryId=wcm:oid:lib-001"
```

## Error Handling Examples

### Handle 404 Not Found

```bash
curl -k -u user:password \
  https://your-dx-host/dx/api/wcm/v3/libraries/wcm:oid:invalid-id
```

**Response** (404):
```json
{
  "type": "https://api.hcl.com/problems/not-found",
  "title": "Library not found",
  "status": 404,
  "detail": "Library with id 'wcm:oid:invalid-id' not found",
  "instance": "a1b2c3d4-5e6f-7g8h-9i0j-k1l2m3n4o5p6"
}
```

### Handle 412 Precondition Failed (ETag Mismatch)

```bash
curl -k -u user:password \
  -X PATCH \
  -H "Content-Type: application/merge-patch+json" \
  -H "If-Match: \"wrong-etag\"" \
  -d '{"description": "Updated"}' \
  https://your-dx-host/dx/api/wcm/v3/libraries/wcm:oid:lib-001
```

**Response** (412):
```json
{
  "type": "https://api.hcl.com/problems/precondition-failed",
  "title": "Precondition Failed",
  "status": 412,
  "detail": "The resource has been modified since the ETag was generated",
  "instance": "b2c3d4e5-6f7g-8h9i-0j1k-l2m3n4o5p6q7"
}
```

## Best Practices

### Always Use ETags for Updates

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

### Use PATCH for Partial Updates

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

### Request Only Needed Fields

```bash
# Good: Request only what you need
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/libraries?fields=id,name"

# Avoid: Requesting all fields when you only need a few
```

### Implement Pagination

```bash
# Good: Use pagination for large datasets
curl -k -u user:password \
  "https://your-dx-host/dx/api/wcm/v3/contents?offset=0&limit=50"

# Avoid: Requesting all items at once
```

## Related Information

- [Getting started with WCM REST API v3](wcm_rest_v3_starting.md)
- [REST service for Web Content Manager v3](index.md)
- [Enabling and disabling WCM API v3](../../cfg_dx_compose/enable_wcm_api_v3.md)
