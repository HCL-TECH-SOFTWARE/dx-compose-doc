# Limitations

## Deployment
- Core container and the WebEngine container cannot be deployed together.
- The only supported databases are DB2 and Derby.
- Remote Search cannot be used with WebEngine - use the new Search containers based on open search with WebEngine.
- No RWX shared volume is leveraged.
- PAA deployment.

## Configuration
- There is no WebSphere Application Server Admin Console. The Liberty Admin Center is available instead but has limited functionality.
- Open Liberty does not provide wsadmin scripting.
- Configuration like resource environment providers earlier managed with WebSphere Application Server need to be managed with the helm chart.
- There is no Configuration Engine or Configuration Wizard with WebEngine - instead all configuration should happen via the helm chart.
- A limited set of dxclient commands is supported. [DXClient Limitations](../deploy_dx/manage/dxclient.md)

## Applications and Extensions
- Cannot deploy java based applications like portlets, ear based themes, wcm extensions.
- Social Media Publisher, CTC or other WCM extensions are not supported with the exception of MLS.
- Digital Data Connector
- WCM AI Sentiment Analysis in the WCM Authoring UI with the Tiny Rich text editor (supported with CKEditor)

## Image customization
- Is not supported at this time.

## User and Group Management
- Creation, Update, or Deletion of users and groups via the WebEngine user interface, REST APIs, or scripting tools is not possible.
- Lookaside database, application groups, custom user registries, transient users are not supported.

## Authentication
- Mechanisms other than LDAP like OIDC are not supported.
- Step-up Authentication is not supported.
- Impersonation.

## Theme customization of dynamic resources
- Is not supported at this time.

## Product features
- Site Template Builder.