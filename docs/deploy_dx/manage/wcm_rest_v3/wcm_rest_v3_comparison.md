# Differences between v1, v2, and v3 APIs

This document compares the three versions of WCM REST APIs to help you understand the improvements and decide which version to use for your integration.

## Summary: v1 vs v2 vs v3

| Feature | v1 (Legacy) | v2 (Current) | v3 (Modern) |
|---------|-------------|--------------|-------------|
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
| **Availability** | CF19+ | CF217+ | CF224+ |

## Feature Comparison

### Content Management

| Feature | v1 | v2 | v3 |
|---------|----|----|-----|
| **Content CRUD** | ✅ Full | ✅ Full | ✅ Full |
| **Libraries** | ✅ Full | ✅ Full | ✅ Full |
| **Site Areas** | ✅ Full | ✅ Full | ✅ Full |
| **Categories** | ✅ Full | ✅ Full | ✅ Full |
| **Taxonomies** | ❌ Limited | ✅ Full | ✅ Full |
| **Presentation Templates** | ❌ No | ❌ Limited | ✅ Full CRUD |
| **Folders** | ✅ Full | ✅ Full | ❌ Not yet (planned) |

### Advanced Features

| Feature | v1 | v2 | v3 |
|---------|----|----|-----|
| **Search** | ✅ Basic | ✅ Advanced | ✅ Simplified unified search |
| **AI Analysis** | ❌ No | ✅ Sentiment/Keywords/Summary | ❌ Not yet (planned) |
| **Bulk Operations** | ❌ No | ✅ Async tracking | ❌ Not yet (planned) |
| **Workflow** | ✅ Basic | ✅ Via wrappers | ❌ Not yet (planned) |
| **Versioning** | ✅ Basic | ✅ Full | ❌ Not yet (planned) |
| **Syndication** | ✅ Basic | ⚠️ Limited (3 handlers) | ❌ Not yet (planned) |
| **Site Manager** | ❌ No | ✅ Pages/Sites/Symbols | ❌ Not yet (planned) |

## Technology Stack Comparison

| Technology | v1 | v2 | v3 |
|------------|-----|-----|-----|
| **Java Version** | 8+ (DX container) | 8+ (DX container) | Java 21 |
| **Spec** | Proprietary DX Plugin | Proprietary DX Plugin | Java EE 8 / JAX-RS 2.1 |
| **JSON Serialization** | IBM JSON4J | IBM JSON4J | Jackson 2.15.2 |
| **Data Classes** | Mutable POJOs | Mutable Atom beans | Immutable Records |
| **Config** | WCM Config / property files | WCM Config / property files | MicroProfile Config |
| **Health Checks** | ❌ N/A | ❌ N/A | ✅ MicroProfile Health |
| **OpenAPI** | ❌ None | Static JSON file | MicroProfile OpenAPI annotations |
| **Deployment** | DX Portal Plugin (JAR) | DX Portal Plugin (JAR) | Standalone WAR |
| **Backend Integration** | Direct WCM Core API | Direct WCM Core API | Via Repository layer |

## Payload Structure Comparison

### Creating a Library

**v1/v2 Request Payload:**
```json
{
  "title": { "lang": "en", "value": "My Library" },
  "name": "my-library",
  "description": { "lang": "en", "value": "Library description" }
}
```

**v3 Request Payload:**
```json
{
  "name": "my-library",
  "title": "My Library",
  "description": "Library description"
}
```

### Response Payload

**v1/v2 Response (Content):**
```json
{
  "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "title": { "lang": "en", "value": "DX Content" },
  "name": "DXContentName",
  "type": "Content",
  "state": "DRAFT",
  "created": "2026-02-05T10:00:00.000Z",
  "lastModified": "2026-02-05T10:30:00.000Z",
  "creator": "uid=wpsadmin,o=defaultWIMFileBasedRealm",
  "lastModifier": "uid=wpsadmin,o=defaultWIMFileBasedRealm",
  "libraryID": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "links": [
    {"rel": "self", "href": "/wps/mycontenthandler/wcmrest-v2/contents/xxx"},
    {"rel": "edit", "href": "/wps/mycontenthandler/wcmrest-v2/contents/xxx"}
  ]
}
```

**v3 Response (Content):**
```json
{
  "id": "wcm:oid:6b3a16a4-5f8e-4b2c-9d1a-3e7c8f9b0a12",
  "name": "welcome-article",
  "title": "Welcome to Our Website",
  "description": "An introductory article for new visitors",
  "status": "PUBLISHED",
  "libraryId": "wcm:oid:lib-001",
  "libraryName": "Web Content",
  "siteAreaId": "wcm:oid:sa-001",
  "siteAreaPath": "/Home/Articles",
  "author": "wpsadmin",
  "lastModifier": "wpsadmin",
  "created": "2026-02-05T10:00:00Z",
  "lastModified": "2026-02-05T10:30:00Z",
  "_links": {
    "self": { "href": "/dx/api/wcm/v3/contents/wcm:oid:xxx" },
    "library": { "href": "/dx/api/wcm/v3/libraries/wcm:oid:lib-001" }
  }
}
```

## Key Payload Differences

| Aspect | v1/v2 | v3 |
|--------|-------|-----|
| **Title Format** | Nested `{lang, value}` object | Simple string |
| **ID Format** | Plain UUID | Prefixed `wcm:oid:uuid` |
| **Status Field** | `state` (string) | `status` (enum) |
| **Elements/Data** | Deeply nested with type metadata | Flat key-value map |
| **Component Types** | Explicit per element | Inferred from schema |
| **Author/Modifier** | Full LDAP DN | Simple username |
| **Timestamps** | Millisecond precision string | ISO 8601 Instant |
| **Links** | Atom-style array | HATEOAS object |
| **Parent Reference** | `parentID` | `siteAreaId` + `siteAreaPath` |

## Error Response Comparison

**v1/v2 Error Response:**
```json
{
  "error": {
    "code": 400,
    "message": "Bad request",
    "details": "Invalid content ID format"
  }
}
```

**v3 Error Response (RFC 7807):**
```json
{
  "type": "https://api.hcl.com/problems/not-found",
  "title": "Content not found",
  "status": 404,
  "detail": "Content with id 'wcm:oid:xxx' not found",
  "instance": "a1b2c3d4-5e6f-7g8h-9i0j-k1l2m3n4o5p6"
}
```

## When to Use Each Version

### Use v1 (Legacy) when:
- Maintaining legacy integrations that cannot be updated
- Working with very old DX versions (pre-CF217)
- Specific v1-only features are required

### Use v2 (Current Production) when:
- You need AI-powered content analysis (sentiment, keywords, summary)
- Bulk operations with async tracking are required
- Advanced workflow operations are needed
- Full component type support (30+ types) is necessary
- Site Manager integration (Pages/Sites/Symbols) is required
- Legacy compatibility is a priority
- Versioning and syndication features are critical

### Use v3 (Modern) when:
- Building new integrations or modernizing existing ones
- You need simpler, cleaner JSON payloads
- Conditional requests (ETag, If-Match) are important
- Partial updates via PATCH are beneficial
- Standards-based REST API is preferred
- Modern frontend integration is the goal
- Presentation template management is required
- You want to leverage OpenAPI 3.0 tooling

## Migration Considerations

### From v1 to v3

- **Breaking Changes**: Complete payload structure redesign
- **Effort**: High - requires full rewrite of integration code
- **Benefits**: Modern standards, cleaner payloads, better tooling
- **Recommendation**: Suitable for new projects or major refactoring

### From v2 to v3

- **Breaking Changes**: Payload structure changes, different base URL
- **Effort**: Medium - similar concepts but different implementation
- **Benefits**: Simplified payloads, PATCH support, better HTTP standards
- **Recommendation**: Suitable when modernizing existing v2 integrations

### Coexistence

All three API versions can coexist in the same DX deployment:
- v1: `/wps/mycontenthandler/wcmrest/`
- v2: `/wps/mycontenthandler/wcmrest-v2/`
- v3: `/dx/api/wcm/v3/`

This allows gradual migration without disrupting existing integrations.

## API Explorer Comparison

| Feature | v1 | v2 | v3 |
|---------|----|----|-----|
| **Explorer Available** | ❌ No | ✅ Yes | ✅ Yes |
| **Explorer URL** | N/A | `/dx/api/wcm/v2/explorer` | `/dx/api/wcm/v3/explorer/` |
| **Interactive Testing** | ❌ No | ✅ Yes | ✅ Yes |
| **OpenAPI Spec** | ❌ No | Static JSON | Auto-generated |
| **Live Documentation** | ❌ No | ✅ Yes | ✅ Yes |
| **Schema Definitions** | ❌ No | ✅ Yes | ✅ Yes |

## Performance Considerations

| Aspect | v1 | v2 | v3 |
|--------|----|----|-----|
| **Payload Size** | Large (Atom format) | Large (Atom format) | Smaller (flat JSON) |
| **Sparse Fieldsets** | ❌ No | ❌ Limited | ✅ Full `?fields=` support |
| **Conditional Requests** | ❌ No | ❌ Limited | ✅ Full ETag support |
| **Pagination** | ✅ Basic | ✅ Advanced | ✅ Consistent offset/limit |
| **Caching** | ❌ Limited | ❌ Limited | ✅ HTTP caching headers |

## Recommendation

**For new projects**: Use **v3** for modern standards, cleaner payloads, and better developer experience.

**For existing v2 integrations**: Continue with **v2** unless you need v3-specific features (PATCH, presentation templates, cleaner payloads).

**For existing v1 integrations**: Migrate to **v2** or **v3** depending on your requirements and migration effort tolerance.

**For production systems**: **v2** is currently the most feature-complete version with AI analysis, bulk operations, and workflow support.

## Related Information

- [Getting started with the REST service for Web Content Manager v3](wcm_rest_v3_starting.md)
- [REST service for Web Content Manager v2](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_development/wcm_rest_v2/){target="_blank"}
- [REST service for Web Content Manager v1](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_development/wcm_rest/){target="_blank"}
