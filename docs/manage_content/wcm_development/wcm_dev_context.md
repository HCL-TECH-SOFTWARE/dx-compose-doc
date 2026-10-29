# Determining the current web content context

To determine the current web content context of a portal page or Web Content Viewer portlet, use the Web Content Manager (WCM) Page Context Service. This service provides the ID of the item currently rendered on a page or portlet.

The `WCMPageContextService` provides the following two methods:

- Use `getWcmPageContext` to return the ID of the current web content context. Depending on the parameters passed, the method returns the context of a page or a Web Content Viewer portlet.

    The service evaluates conditions in the following order until it finds a valid context, stopping evaluation after finding a match:

    1. Private render parameter (available only for Web Content Viewer portlets)
    2. `path-info` parameter
    3. Public render parameter
    4. Portlet configuration setting for the Web Content Viewer (Web Content Viewer portlets only)
    5. Web content association defined for the page

    The context can be a content item or site area.

- Use `getWcmDefaultContent` to return the default content of a site area. This method is useful if the current web content context is a site area and you must determine which content item is rendered.

Both methods return the document ID of the current context or default content. If necessary, us `getPathById` in the WCM workspace to convert the ID to the corresponding content path. For more information, refer to [`getPathById`](https://help.hcl-software.com/digital-experience/9.5/dev/javadoc/vrm/850/api_docs/com/ibm/workplace/wcm/api/Workspace.html#getPathById(com.ibm.workplace.wcm.api.DocumentId,%20boolean,%20boolean)){target="_blank"}.

## Obtaining an instance of the service

To obtain an instance of the service, use one of the following home interfaces:

- Use `PortalWcmPageContextServiceHome` if the calling code has access to `HttpServletRequest` (for example, if a theme calls the service).
- Use `PortletWcmPageContextServiceProvider` if the calling code has access to `PortletRequest` (for example, if a portlet calls the service).
- Use `CorWcmPageContextServiceHome` if the calling code has access to `com.ibm.content.operations.registry.api.Context` (for example, if a resolver calls the service).
