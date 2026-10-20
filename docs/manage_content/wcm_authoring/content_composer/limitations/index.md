# Limitations

The following limitations exist in HCL Content Composer:

- Content created using Content Composer and Digital Asset Management (DAM) cannot be used with the HCL Digital Experience (DX) Compose Projects capabilities.
- Deployments that set an alternate context root are supported.
- The use of Content Composer features in a Virtual Portal deployment pattern is supported. See the Help Center topic [Enable Content Composer in Virtual Portals](../installation/configure_cc_virtual_portals.md) for more information.
- Content Composer Workflow selections can be established in a content template and workflow stages in content items can be progressed by the content author. Workflow item comments and content item workflow approvals by designated reviewers are available.
- When planning to use the Content Composer features in an authoring environment, it is only supported when running with one DX Compose 9.5 core container \(pod\). This limitation does not apply when using the Web Content Management Authoring Portlet or when just using the new DAM feature. It also does not apply to environments used for rendering.
- When uploading a file or an image using Experience API or Content Composer, the actual file uploaded may be larger than expected when processing through Experience API or Content Composer. This is because REST data in Experience API must be text-based, which is why when uploading files using Experience API or Content Composer, Base64 is used to convert binary content before sending it to HCL DX Compose. The size increase caused by the Base64 transformation causes the encoded file or image to be approximately **30% larger** than the file size on disk.
- In Content Composer, there are two modes you can choose between for WCM, authoring performance and rendering performance. If you have tuned WCM for rendering performance, caches are not invalidated immediately. In this setup, if you upload WCM content it will not be immediately available unless you invalidate the cache.

    There are two ways to do a cache invalidation:

    1. On a Kubernetes platform, it is recommended that you use authoring for any kind of content editing; or
    2. Use the IBM Extended Cache Monitor for IBM WebSphere Application Server.

        - Documentation resource: [IBM Extended Cache Monitor for IBM WebSphere Application Server technology preview](https://www.ibm.com/developerworks/websphere/downloads/cache_monitor.html){:target="_blank"}

- HCL Content Composer 9.5 supports the following Content Elements only:
    - Text elements
    - Media elements (File and Image)
    - Date and Time elements
    - Component Reference elements
    - Link elements
    - Option Selection elements
    - User Selection elements

- If HCL Content Composer is deployed in a Hybrid Configuration, and if image element renditions are set and saved, the results will not be visible to the Content Composer page. This is a known issue, and the underlying content and template are saved successfully. This will be resolved in a future Content Composer update.

    Content authors may use the WCM Authoring portlet to preview the selected image renditions.
