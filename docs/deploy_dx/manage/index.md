# Managing DX Compose

This section provides information how to manage the deployment of the Digital Experience (DX) Compose WebEngine container within your environment.

The deployment of WebEngine is similar to HCL DX with Core container. Note that the Helm chart has some additional settings related to WebEngine. For more information, see [Deploying using Helm](https://opensource.hcltechsw.com/digital-experience/latest/deployment/install/container/helm_deployment/overview/){target="_blank"} and [Preparation before installing with Helm](https://opensource.hcltechsw.com/digital-experience/latest/deployment/install/container/helm_deployment/preparation/){target="_blank"}.

See the following topics for more information.

-   **[WebEngine Directory Structure](webengine_directory_structure.md)**  
Learn about the WebEngine directory structure to understand different configurations.
-   **[Server Configuration](server_configuration.md)**  
Learn about the WebEngine server configuration to understand the different features, services and libraries configured to run applications.
-   **[Configuration parameters](configuration_parameters.md)**  
Learn how to configure users and groups in DX Compose.
-   **[Troubleshooting DX Compose](troubleshooting.md)**  
Learn how to resolve WebEngine issues.
-   **[DX Compose configuration changes using overrides](configuration_changes_using_overrides.md)**  
Learn how to update the `server.xml` properties and how to configure the DX Compose server using `configOverrideFiles`.
-   **[WCM modules](wcm_modules.md)**  
Learn how to trigger WCM modules and import WCM libraries.
-   **[Supported DXClient operations](dxclient.md)**  
Learn the supported DXClient operations in DX Compose. 
-   **[Monitoring the WebEngine Deployment](monitor_metrics.md)**  
Learn how to use metrics to monitor activity and performance of the DX WebEngine container.
-   **[Enabling Content Composer](enable_cc.md)**  
Learn how to enable and disable Content Composer.
-   **[Enabling Digital Asset Management](enable_dam.md)**  
Learn how to enable and disable Digital Asset Management.
-   **[Enabling WCM Content AI Analysis](enable_content_ai.md)**  
Learn how to enable and disable artificial intelligence (AI) analysis for Web Content Management (WCM) content.
-   **[Restarting the WebEngine server](restart_webengine_server.md)**  
Learn how to restart the WebEngine server.
-   **[Viewing WebEngine server logs](logging_webengine.md)**  
Learn how to view the WebEngine server logs through Kubernetes.
-   **[Configuring LDAP](ldap_configuration.md)**  
Learn how to configure a Lightweight Directory Access Protocol (LDAP) registry in HCL DX on Liberty.
-   **[Updating DX properties using Helm values](update_properties_with_helm.md)**  
Learn how to use the Helm chart's `values.yaml` file to add, update, or delete DX properties.
-   **[Updating the default administrator password](update_wpsadmin_password.md)**  
Learn how to update the default `wpsadmin` password.
-   **[Managing outbound connections (Ajax Proxy)](manage_outbound_connections.md)**  
Learn a different technique that you should use to manage outbound connections with WebEngine. 
-   **[Using custom secrets](custom_secrets.md)**  
Learn how to use custom secrets through the `values.yaml` file. <!--not yet reviewed 11/28-->
-   **[Staging to production](staging_to_production.md)**  
Learn how to stage one WebEngine instance to another. <!--not yet reviewed 11/28-->
-   **[Using an External Database and Database Transfer](external_db_database_transfer.md)**  
Learn how to connect to an external database and transfer the content of the Derby database to the external database.
-   **[Upgrading the Helm deployment](helm_upgrade_values.md)**  
Learn how to upgrade the Helm deployment using the updated `values.yaml` file.

