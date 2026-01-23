# DX Compose limitations

Know the existing limitations of Digital Experience (DX) Compose.

## Deployment

- You cannot deploy the Core container used in the DX offerings deployment and the DX Compose WebEngine Core container together on the same deployment.
- Supported databases include Derby, DB2, and Oracle. When using Amazon RDS, the service currently supports Oracle versions 19c and 21c (for both single-tenant and multi-tenant configurations) and SQL Server version 2022.
- It is not possible to use the Remote Search service provided with HCL DX offerings in DX Compose. DX Compose provides support for OpenSearch.
- No ReadWriteMany (RWX) shared volume is used.
- Portal Application Archive (PAA) deployment is not supported.

## Configuration

- DX Compose does not operate on the IBM WebSphere Application Server (WAS). DX Compose administrators should use the Helm chart to make changes they used to perform in the WebSphere Application Server Admin Console. The Open Liberty Admin Console has limited functionality but can be leveraged for starting/stopping applications, investigating the configuration, and monitoring.
- Open Liberty does not provide wsadmin scripting.
- Configuration in resource environment providers, which was earlier managed with the DX Offerings WAS console, is managed with Helm charts in DX Compose.
- There is no ConfigEngine or Configuration Wizard with DX Compose. All configuration must be done through the Helm chart.
- A limited set of DXClient commands is supported. For more information, see [Supported DXClient operations](../deploy_dx/manage/working_with_compose/dxclient.md).

## Applications and extensions

- You cannot deploy custom portlets.
- Social Media Publisher, Content Template Catalog (CTC), and other WCM extensions are not supported except Multilingual Solution.
- WCM AI Sentiment Analysis in the WCM Authoring user interface (UI) is not supported with the TinyMCE Rich text editor but is supported with CKEditor.
- The SpellCheck service for the TinyMCE Rich text editor is currently not supported in DX Compose.
- No command-line interface exists for exporting or importing Personalization rules.

## User and group management

- Creating, updating, and deleting users and groups using the DX Compose Admin UI, REST APIs, or scripting tools are not supported with this initial release.
- Lookaside database, application groups, custom user registries, and transient users are not supported.
- User Profile editing is not supported. To disable the Profile view, refer to [Disabling the Profile view](../deploy_dx/manage/working_with_compose/cfg_parameters/manage_users_groups_liberty.md#disabling-the-profile-view).

## Authentication

- Step-up authentication is not supported.
- Impersonation is supported. However, you must disable the authentication cache for it to work. For more information, see [Disabling Authentication Cache for Impersonation](../deploy_dx/manage/cfg_webengine/configuration_changes_using_overrides.md#disabling-authentication-cache-for-impersonation).
