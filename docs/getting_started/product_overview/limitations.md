# DX Compose limitations

## Limitations

Know the existing limitations of Digital Experience (DX) Compose.

## Deployment

- You cannot deploy the Core container used in DX offerings and the DX Compose WebEngine Core container together in the same deployment.
- Supported databases include Derby, DB2, and Oracle. When using Amazon RDS, the service currently supports Oracle 19c and 21c (for both single-tenant and multi-tenant configurations) and SQL Server 2022.
- You cannot use the Remote Search service provided with HCL DX offerings in DX Compose. DX Compose supports OpenSearch.
- ReadWriteMany (RWX) shared volumes are not used.
- Portal Application Archive (PAA) deployment is not supported.

## Configuration

- DX Compose does not run on IBM WebSphere Application Server (WAS). DX Compose administrators should use the Helm chart to make changes that were previously performed in the WebSphere Application Server Admin Console. The Open Liberty Admin Console has limited functionality but can be used to start and stop applications, inspect configuration, and monitor the system.
- Open Liberty does not provide wsadmin scripting.
- Configuration in resource environment providers, which was previously managed through the DX Offerings WAS console, is managed through Helm charts in DX Compose.
- There is no ConfigEngine or Configuration Wizard in DX Compose. All configuration must be done through the Helm chart.
- A limited set of DXClient commands is supported. For more information, see [Supported DXClient operations](../../deploy_dx/manage/working_with_compose/dxclient.md).

## Applications and extensions

- You cannot deploy custom portlets unless you have purchased the Java Transition Module for DX Compose. Refer to the Java Transition Module documentation, available to entitled customers in their MHS downloads for the HCL Java Transition Module for DX Compose, for the steps to deploy portlets.
- Only JSR 168 and JSR 286 portlets are supported.
- DX Compose runs on different Java and Java EE levels than DX Core on WAS. Your portlets may need to be updated for compatibility with Java 21 and Java EE 8.
- JavaServer Faces (JSF) portlets are supported for non-production use if you purchase the Java Transition Module for DX Compose capabilities.
- Because DX Compose runs on Java EE 8, the supported JSF version is 2.3 (compared to 2.2 for DX Core on WebSphere Application Server).
- Social Media Publisher, Content Template Catalog (CTC), and other WCM extensions are not supported, except for Multilingual Solution.
- No command-line interface is available for exporting or importing Personalization rules.

## User and group management

- Creating, updating, and deleting users and groups using the DX Compose Admin UI, REST APIs, or scripting tools is not supported in this initial release.

- Lookaside databases, application groups, and custom user registries are not supported.
- User profile editing is not supported. To hide the profile page, refer to [Disabling Edit My Profile](../../deploy_dx/manage/working_with_compose/cfg_parameters/manage_users_groups_liberty.md#disabling-edit-my-profile).

## Authentication

- Step-up authentication is not supported.
