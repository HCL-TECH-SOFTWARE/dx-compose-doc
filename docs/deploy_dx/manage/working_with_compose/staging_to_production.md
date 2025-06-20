# Staging one WebEngine instance to another

During WebEngine solution development, the total solution is initially developed, tested, and refined on one server or a limited number of servers. The total solution is then deployed later on systems targeted for production, referred to as the production environment. The process of moving the solution from one environment to another environment is called staging.

Staging is only possible between the same product release or version. In contrast, upgrading from one release to a newer release is called migration.

HCL Digital Experience (DX) Compose, Web Content Manager (WCM) and Digital Asset Manager (DAM) solutions can consist of many artifacts. These artifacts include portlets, themes and skins, portlet services, page layouts, wires, portlet configurations, portlet data, content, and personalization rules. Staging helps you move these artifacts to the production environment in a controlled way.

For naming purposes, this document calls the system that you are staging from the *source* system and the system you are staging to the *target* system.

## Staging from source to target

1. Install and upgrade the target HCL DX Compose system with Helm. The target and source should have exactly the same DX Compose level and preferably be at the latest of both. As both source and target are Kubernetes-based.

    !!!note
        It is recommended to use the latest cumulative fix (CF) on both the source and target systems.

2. Configure security on the target DX Compose system. This might be a different user repository (for example, LDAP) than the source server.

    If both systems are using the same user repository and the same administrator, you can copy the appropriate section (for example, `ldap-repository`) from the `server.xml` of the source to the `server.xml` of the target and update the Helm chart of the target to match the source.

3. Transfer the database to DB2 on the target DX Compose system. Note that this step happens through the Helm chart for the target server.

    While transferring database on the source is not critical, it is assumed that the target system will be used for production use and should have gone through database transfer.

4. Using XMLAccess, export the virtual Portals from the source system.

    Sample command:

    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -out /tmp/ExportVirtualPortals.xml -in     /opt/openliberty/wlp/usr/svrcfg/xml-samples/ExportVirtualPortals.xml -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config
    ```

5. Export XMLAccess with `ExportRelease.xml` on the source Portal **base** virtual Portal. As an example, the result file could be called `baseVPExportRelease.xml`.

    From inside the WebEngine portal deployed on your source system (for example, use `kubectl exec -it webengine-pod-0 bash -n dxns`), you can use the following sample command:

    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -out /tmp/baseVPExportRelease.xml -in     /opt/openliberty/wlp/usr/svrcfg/xml-samples/ExportRelease.xml -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config
    ```

6. Export XMLAccess export with `ExportUniqueRelease.xml` for the first source Portal Virtual Portal 1. As an example, the result file could be called `vp1Export`.xml.

    From inside the WebEngine container deployed on your source system (for example, use `kubectl exec -it webengine-pod-0 bash -n dxns`) you can use the following sample command:

    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -out /tmp/vp1Export.xml -in /opt/openliberty/wlp/usr/svrcfg/xml-samples/ExportUniqueRelease.xml -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config/vp1
    ```

7. Repeat Step 6 for each virtual portal on the source system. Make sure to use a unique name for the XMLAccess output.

8. Remove existing content from the target WebEngine container.

    Ensure that all three XMLAccess tasks are run to complete the operation.

    Sample commands: 

    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -out /tmp/CleanPortalWithoutWebApps.xml.out -in /opt/openliberty/wlp/usr/svrcfg/xml-samples/CleanPortalWithoutWebApps.xml -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config

    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -out /tmp/AddBasePortalResources.xml.out -in ./engine/engine-ear/target/liberty/wlp/usr/installer/wp.config/config/templates/AddBasePortalResources.xml -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config

    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -out /tmp/SchedulerCleanupTask.xml.out -in /opt/openliberty/wlp/usr/installer/wp.config/config/templates/SchedulerCleanupTask.xml -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config
    ```

9. Run scheduler through the `Task.xml` on the target WebEngine container.

    Sample command: 

    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -out /tmp/Task.xml.out -in /opt/openliberty/wlp/usr/svrcfg/xml-samples/Task.xml -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config
    ```

10. Transfer the WebDav theme from the source server to the target. 

    !!!note
        WebEngine currently does not support deployment of custom EAR files that can persist. Only WebDav-based themes are supported. 

    1. Locate your custom themes on the source server using the Theme Manager in WebEngine. Take note of the names you have assigned to the themes.

    2. Using a WebDav client on your local operating system, create an archive using the TAR utility or compress the files in ZIP format for the custom themes from the WebDav file system. 
    
    3. After all the files are contained in a tarball or ZIP file, move this file to the target and import the files onto the target WebDav using the same theme names as on the source server.

    4. Regardless of the method used to get the theme files onto the target WebDav, you must register the custom themes using XMLAccess. Ensure that one preserves the object id (OID) of the custom theme(s) on the target portal. For example, the OID should be the same on the source and target in the XMLAccess import XML file.

    5. Export the themes and skins from the source:

        ```
        /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -out /tmp/ExportThemesAndSkins.xml.out -in /opt/openliberty/wlp/usr/svrcfg/xml-samples/ExportThemesAndSkins.xml -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config
        ```

    6. Edit the output file (`/tmp/ExportThemesAndSkins.xml.out`) to remove any themes and skins not created using the Theme Manager. This would include all themes included in the base Portal (for example, Portal 8.5 theme).
    
    7. Import the resulting XML file on the target to register the new themes and skins:

        ```
        /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -in /tmp/ExportThemesAndSkins.xml.out -out /tmp/ExportThemesAndSkins.xml.out.out -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config
        ```

11. Set the properties required for syndication in WCM ConfigService (for example, enable member fixer to run as part of syndication). You can find more information about custom syndication configuration properties in [Member fixer in Syndication](https://opensource.hcltechsw.com/digital-experience/latest/manage_content/wcm_configuration/wcm_adm_tools/wcm_member_fixer/wcm_admin_member-fixer_synd/){target="_blank"}.

12. Import XMLAccess with `baseExport.xml` into the base virtual Portal of the target system.

    Sample command: 

    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -in /tmp/baseVPExportRelease.xml -out /tmp/baseVPExportRelease.xml.out -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config
    ```

13. Deploy your DAM assets from your source environment to you target environment using DXClient.

    Run the following commands:

    ```
    dxclient manage-dam-staging register-dam-subscriber
    dxclient manage-dam-staging trigger-staging
    ```

14. Export the Personalization rules from the source system and import them to the target server. You can export and import the rules using the Personalization Administration Portlet Export and Import functions. See [Staging Personalization rules to production](https://opensource.hcltechsw.com/digital-experience/latest/manage_content/pzn/pzn_stage_prod){target="_blank"} for more information.

15. Verify that everything in the base virtual Portal is working. 

    Make sure to check the rendering of the theme and pages, as well as content, Personalization rules, or Script Applications.

16. Create your virtual Portals using the output deck from the XMLAccess command used in step 4 to export the virtual Portal definitions from the source.

    Sample command:

    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -in /tmp/ExportVirtualPortals.xml -out /tmp/ExportVirtualPortals.xml.out -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config
    ```

17. Import the XML file for each virtual Portal on the source into same virtual Portal on the target using XMLAccess. Ensure that the VP context root in the XMLAccess command matches the VP name in the `&quot;/wps/config/&quot;` XMLAccess statement.

    Sample command: 

    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -in /tmp/vp1Export.xml -out /tmp/vp1Export_result.xml -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config/vp1
    ```

18. Repeat steps 16 and 17 until all of your virtual Portals are created and filled through XMLAccess on the target Portal.

19. Validate all DAM artifacts were transferred from your source system to your target system as configured in step 13.

20. Delete your WebEngine pod and wait for Kubernetes to restart the pod. 

    Sample command:
    
    ```
    kubectl delete webengine-pod-0 -n dxns
    ```

21. Make sure that the WebEngine works correctly. 

    Address potentially missed artifacts. Watch out for error messages in `SystemOut.log`, `messages.log`, and `trace.log` during startup.

21. Set up syndication for the appropriate libraries between the source and the target system or target to source depending on your requirements (for example, for an Authoring system, subsequent syndications could go from Authoring to Integration Test or Development environment).

    !!!note
        - You need to syndicate the Multilingual configuration library.
        - You must setup syndication as well between your source system virtual Portals to the target system virtual Portals. 

22. After syndication has completed its initial run, set up the library permissions. 

    Library permissions are not syndicated. For more information, see [Set up access to libraries](https://opensource.hcltechsw.com/digital-experience/latest/manage_content/wcm_authoring/authoring_portlet/web_content_libraries/oob_content_accesslib/){target="_blank"}.
