# Managing DX Compose

This section provides information how to manage the deployment of the Digital Experience (DX) Compose WebEngine container within your environment.

The deployment of WebEngine is similar to HCL DX with Core container. Note that the Helm chart has some additional settings related to WebEngine. For more information, see [Deploying using Helm](https://opensource.hcltechsw.com/digital-experience/latest/deployment/install/container/helm_deployment/overview/){target="_blank"} and [Preparation before installing with Helm](https://opensource.hcltechsw.com/digital-experience/latest/deployment/install/container/helm_deployment/preparation/){target="_blank"}.

See the following topics for more information.

-   **[Configuring LDAP](../manage/ldap_configuration.md)**  
Learn how to configure a Lightweight Directory Access Protocol (LDAP) registry in HCL DX on Liberty.
-   **[DX Compose WebEngine configuration changes using overrides](../manage/configuration_changes_using_overrides.md)**  
Learn how to update the `server.xml` properties and how to configure the DX Compose WebEngine server using `configOverrideFiles`.
-   **[Enabling Content Composer](enable_cc.md)**  
Learn how to enable and disable Content Composer.
-   **[Enabling Digital Asset Management](enable_dam.md)**  
Learn how to enable and disable Digital Asset Management.
-   **[Enabling WCM Content AI Analysis](enable_content_ai.md)**  
Learn how to enable and disable artificial intelligence (AI) analysis for Web Content Management (WCM) content.
-   **[Managing outbound connections (Ajax Proxy)](../manage/manage_outbound_connections.md)**  
Learn a different technique that you should use to manage outbound connections with WebEngine. 
-   **[Managing users and groups](configuration_parameters.md)**  
Learn how to configure users and groups in DX Compose.
-   **[Monitoring the WebEngine Deployment](../manage/monitor_metrics.md)**  
Learn how to use metrics to monitor activity and performance of the DX WebEngine container.
-   **[Restarting the WebEngine server](../manage/restart_webengine_server.md)**  
Learn how to restart the WebEngine server.
-   **[Staging to production](../manage/staging_to_production.md)**  
Learn how to stage one WebEngine instance to another. <!--not yet reviewed 11/28-->
-   **[Supported DXClient operations](dxclient.md)**  
Learn the supported DXClient operations in DX Compose. 
-   **[Troubleshooting DX Compose]<!-- (replace with troubleshooting doc link when available)**  -->
Learn how to resolve issues in your DX Compose deployment.
-   **[Using an external database and database transfer](../manage/external_db_database_transfer.md)**  
Learn how to connect to an external database and transfer the content of the Derby database to the external database.
-   **[Using custom secrets](custom_secrets.md)**  
Learn how to use custom secrets through the `values.yaml` file. <!--not yet reviewed 11/28-->
-   **[Updating DX properties using Helm values](../manage/update_properties_with_helm.md)**  
Learn how to use the Helm chart's `values.yaml` file to add, update, or delete DX properties.
-   **[Updating the default administrator password](../manage/update_wpsadmin_password.md)**  
Learn how to update the default `wpsadmin` password.
-   **[Upgrading the Helm deployment](helm_upgrade_values.md)**  
Learn how to upgrade the Helm deployment using the updated `values.yaml` file.
-   **[Viewing WebEngine server logs](../manage/logging_webengine.md)**  
Learn how to view the WebEngine server logs through Kubernetes.
-   **[WCM modules](../manage/wcm_modules.md)**  
Learn how to trigger WCM modules and import WCM libraries.
