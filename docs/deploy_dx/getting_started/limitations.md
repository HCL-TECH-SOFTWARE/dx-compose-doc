# DX Compose limitations

Know the existing limitations of Digital Experience (DX) Compose.

## Deployment

- You cannot deploy the Core container and the WebEngine container together.
- The only supported databases are DB2 and Derby.
- You cannot use Remote Search with the WebEngine container. Instead, you can use the new Search containers based on OpenSearch with WebEngine.
- No ReadWriteMany (RWX) shared volume is used.
- Portal Application Archive (PAA) deployment is not supported.

## Configuration

- There is no WebSphere Application Server (WAS) Admin Console. You can use the Liberty Admin Center instead but this has limited functionality.
- Open Liberty does not provide wsadmin scripting.
- Configuration in resource environment providers earlier managed with WAS must be managed with the Helm chart.
- There is no Configuration Engine or Configuration Wizard with DX Compose. All configuration must be done using the Helm chart.
- A limited set of DXClient commands is supported. For more information, see [DXClient limitations](../../deploy_dx/manage/dxclient.md).

## Applications and extensions

- You cannot deploy Java-based applications such as portlets, EAR-based themes, and WCM extensions.
- Social Media Publisher, Content Template Catalog (CTC), and other WCM extensions are not supported except Multilingual Solution.
- Digital Data Connector is not supported.
- WCM AI Sentiment Analysis in the WCM Authoring user interface (UI) is not supported with the TinyMCE Rich text editor but is supported with CKEditor.

## Image customization

- Not supported at this time.

## User and group management

- Creating, updating, and deleting users and groups using the WebEngine UI, REST APIs, or scripting tools are not possible.
- Lookaside database, application groups, custom user registries, and transient users are not supported.

## Authentication

- Mechanisms other than LDAP, such as Open IDConnect (OIDC), are not supported.
- Step-up authentication is not supported.
- Impersonation is not supported.

## Theme customization of dynamic resources

- Not supported at this time.

## Product features

- Site Template Builder is not supported.