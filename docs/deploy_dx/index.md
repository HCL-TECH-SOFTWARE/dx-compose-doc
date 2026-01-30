# Deploying DX Compose

Learn how to efficiently deploy Digital Experience (DX) Compose and its WebEngine Core container within your environment. Starting with environment preparation, this guide covers the deployment process, focusing on Helm-based deployments to Kubernetes environments. Steps for installation, configuration, uninstallation, and troubleshooting to ensure a smooth setup and maintenance of the service are provided.

!!!note
    In this release, instructions for using select features are located in the [HCL Digital Experience Help Center](https://opensource.hcltechsw.com/digital-experience/latest/){target="_blank"}. These will be documented in the HCL Digital Experience Compose Help Center in future releases.

## HCLSoftware U learning materials

For an introduction and a demo on DX deployment, go to [Deployment for Beginners](https://hclsoftwareu.hcl-software.com/component/axs/?view=sso_config&id=4&forward=https%3A%2F%2Fhclsoftwareu.hcl-software.com%2Fcourses%2Flesson%2F%3Fid%3D1479){target="_blank"}. Several deployment options are provided in the course.

To learn how to do a traditional installation, go to [Deployment for Intermediate Users](https://hclsoftwareu.hcl-software.com/component/axs/?view=sso_config&id=4&forward=https%3A%2F%2Fhclsoftwareu.hcl-software.com%2Fcourses%2Flesson%2F%3Fid%3D3086){target="_blank"}. In this course, you will also learn about additional installation tasks that apply to both container-based and traditional deployments using the Configuration Wizard, DXClient, ConfigEngine, and more. You can try it out using the [Deployment Lab](https://hclsoftwareu.hcl-software.com/images/Lc4sMQCcN5uxXmL13gSlsxClNTU3Mjc3NTc4MTc2/DS_Academy/DX/Administrator/HDX-ADM-200_Deployment_Lab.pdf){target="_blank"} and corresponding [Deployment Lab Resources](https://hclsoftwareu.hcl-software.com/images/Lc4sMQCcN5uxXmL13gSlsxClNTU3Mjc3NTc4MTc2/DS_Academy/DX/Administrator/HDX-ADM-200_Deployment_Lab_Resources.zip){target="_blank"}.

To learn how to manage multiple DX sites, go to [Multi-Site Management](https://hclsoftwareu.hcl-software.com/component/axs/?view=sso_config&id=4&forward=https%3A%2F%2Fhclsoftwareu.hcl-software.com%2Fcourses%2Flesson%2F%3Fid%3D3086){target="_blank"}. In this course, you will learn when and how to create and manage base, true, and virtual portals in which you may run one or more DX sites. You can also try it out using the [Multi-Site Management Lab](https://hclsoftwareu.hcl-software.com/images/Lc4sMQCcN5uxXmL13gSlsxClNTU3Mjc3NTc4MTc2/DS_Academy/DX/Administrator/HDX-ADM-200_Multi-Site_Management_Lab.pdf){target="_blank"}.

For an introduction and a demo on DX staging, go to [Staging for Beginners](https://hclsoftwareu.hcl-software.com/component/axs/?view=sso_config&id=4&forward=https%3A%2F%2Fhclsoftwareu.hcl-software.com%2Fcourses%2Flesson%2F%3Fid%3D505){target="_blank"}.

To learn how to use staging tools such as DXClient, Syndication, XMLAccess, ReleaseBuilder/Solution Installer, and ConfigEngine, go to [Staging for Intermediate Users](https://hclsoftwareu.hcl-software.com/component/axs/?view=sso_config&id=4&forward=https%3A%2F%2Fhclsoftwareu.hcl-software.com%2Fcourses%2Flesson%2F%3Fid%3D3328){target="_blank"}. You can try it out using the [Staging Lab for Intermediate Users](https://hclsoftwareu.hcl-software.com/images/Lc4sMQCcN5uxXmL13gSlsxClNTU3Mjc3NTc4MTc2/DS_Academy/DX/Administrator/HDX-ADM-200_Staging_Lab.pdf){target="_blank"} and corresponding [Staging Lab Resources](https://hclsoftwareu.hcl-software.com/images/Lc4sMQCcN5uxXmL13gSlsxClNTU3Mjc3NTc4MTc2/DS_Academy/DX/Administrator/HDX-ADM-200_Staging_Lab_Resources.zip){target="_blank"}.

<!-- Commenting links for now.  If needed can uncomment when manage section is restructured  If uncommented, links will need updating
- [Overview](./manage/overview.md)
- [Installation](./install/install.md)
- [Web Engine Overview](../getting_started/overview.md)
- [Features](../getting_started/product_overview/features.md)
- [Architecture and Dependencies](../getting_started/architecture_dependencies.md)
- [System Requirements](../getting_started/system_requirements.md)
- [Differences](../getting_started/differences.md)
- [Limitations](../getting_started/limitations.md)
- [WebEngine Directory Structure](./manage/webengine_directory_structure.md)
- [Server Configuration](./manage/server_configuration.md)
- [Manage users and Groups](./manage/working_with_compose/cfg_parameters/manage_users_groups_liberty.md)
- [Uninstall](./install/uninstall.md)
- [Troubleshooting](./manage/troubleshooting.md)
- [Adding Custom User Attributes](./manage/adding_custom_attributes.md)
- [Manage Users and Groups](./manage/manage_users_groups_liberty.md)
- [WCM Modules](./manage/wcm_modules.md)
- [DXClient](./manage/dxclient.md)
- [Monitor Metrics](./manage/monitor_metrics.md)
- [Enable CC](./manage/enable_cc.md)
- [Enable DAM](./manage/enable_dam.md)
- [AI Analysis for Web Content Management (WCM)](./manage/enable_content_ai.md)
- [Restart Server](./manage/restart_webengine_server.md)
- [View Logs](./manage/logging_webengine.md)
- [Server Configuration Overrides](./manage/configuration_changes_using_overrides.md)
- [LDAP Configuration](./manage/ldap_configuration.md)
- [Update Properties](./manage/update_properties_with_helm.md)
- [Update Default Username & Password](./manage/update_wpsadmin_password.md)
- [Manage Outbound Connections (Ajax Proxy)](./manage/manage_outbound_connections.md)
- [Using Custom Secret in WebEngine](./manage/custom_secrets.md)
-->