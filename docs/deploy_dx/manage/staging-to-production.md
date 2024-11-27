## Staging one WebEngine Instance to Another
During WebEngine solution development, the total solution is initially developed, tested, and refined on one server or a limited number of servers. The total solution is then deployed later on systems targeted for production, referred to as the production environment. The process of moving the solution from the development environment to the production environment is called **staging**.

Staging is only possible between the same product release/version. In contrast, upgrading from one release to a newer release is called migration.

HCL Digital Experience, HCL Web Content Manager and HCL Digital Asset Manager (DAM) solutions can consist of many artifacts. These artifacts include portlets, themes and skins, portlet services, page layouts, wires, portlet configurations, portlet data, content, and personalization rules. Staging helps you move those artifacts to the production environment in a controlled way.

For naming purposes this document is calling the system that you are staging from the *source* system and the system you are staging to the *target* system.

### Steps for Staging

1. Install and Upgrade the target Portal. The target and source should have exactly the same DX level and preferably be at the latest of both. As both source and target are Kubernetes based, this should be straight forward.

    Note: It is recommended to be using the latest CF on both the source and target systems.

2. Configure security on the target Portal (this might be a different user repository, e.g. LDAP, than the source server).

    Note: There is a shortcut to configuring security: If both systems are using the same user repository and the same admin you can copy the appropriate   section (e.g. "ldap-repository") from the server.xml of the source to the server.xml of the target and/or update the helm chart of the target to match the source.

3. DBTransfer to DB2, Oracle or SQLServer on the target Portal. Note that this step happens via the helm chart for the target server. While DBTransfer on the source is not critical, it is assumed that the target system will be used for production use and, thus, should have gone thru a DBTransfer step.

4. Using XMLAccess, export the virtual portals from the source system:

    Sample Command:

    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -out /tmp/ExportVirtualPortals.xml -in     /opt/openliberty/wlp/usr/svrcfg/xml-samples/ExportVirtualPortals.xml -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config
    ```

5. XMLAccess export with ExportRelease.xml on the source Portal **base** virtual Portal - the result file could for instance be called *baseVPExportRelease.xml*.

    From inside the WebEngine portal deployed on your source system (e.g. use kubectl exec -it webengine-pod-0 bash -n dxns) you can use this sample command:

    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -out /tmp/baseVPExportRelease.xml -in     /opt/openliberty/wlp/usr/svrcfg/xml-samples/ExportRelease.xml -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config
    ```

6. XMLAccess export with ExportUniqueRelease.xml for the first source Portal Virtual Portal 1 - calling the result vp1Export.xml.

    From inside the WebEngine portal deployed on your source system (e.g. use kubectl exec -it webengine-pod-0 bash -n dxns) you can use this sample command:

    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -out /tmp/vp1Export.xml -in /opt/openliberty/wlp/usr/svrcfg/xml-samples/ExportUniqueRelease.xml -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config/vp1
    ```

7. Repeat the previous step for each other virtual portal on the source system using a unique name for the XMLAccess output.

8. Remove existing content on target Portal

    Ensure that all three XMLAccess tasks are run to complete the operation.

    Sample Commands: 
    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -out /tmp/CleanPortalWithoutWebApps.xml.out -in /opt/openliberty/wlp/usr/svrcfg/xml-samples/CleanPortalWithoutWebApps.xml -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config

    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -out /tmp/AddBasePortalResources.xml.out -in ./engine/engine-ear/target/liberty/wlp/usr/installer/wp.config/config/templates/AddBasePortalResources.xml -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config

    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -out /tmp/SchedulerCleanupTask.xml.out -in /opt/openliberty/wlp/usr/installer/wp.config/config/templates/SchedulerCleanupTask.xml -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config
    ```

9. Run scheduler immediately via the Task.xml on the target Portal

    Sample Command: 
    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -out /tmp/Task.xml.out -in /opt/openliberty/wlp/usr/svrcfg/xml-samples/Task.xml -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config
    ```

10. Regarding custom theme(s). WebEngine currently does NOT support deployment of custom EAR files that can persist. Only WebDav based themes are supported. 

    Create your new theme (webdav only) on the source server using the "*Theme Manager*" in WebEngine. Remember the name you have assigned to this theme. 

    Using a WebDav client on your local OS, tar or zip the files this this new theme from the WebDav file system. Once all the files are contained in a tarball or zip file, move this file to the target and import the files onto the target WebDav using the same theme name as on the source server.

    Regardless of the method used to get the theme files onto the target webdav, one must now register the new theme using XMLAccess. Ensure that one preserves the object id (OID) of the custom theme(s) on the target portal. E.g. the OID should be the same on the source and target in the XMLAccess import XML file.

    Export the themes and skins from the source:

    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -out /tmp/ExportThemesAndSkins.xml.out -in /opt/openliberty/wlp/usr/svrcfg/xml-samples/ExportThemesAndSkins.xml -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config
    ```
    At this point, edit the output file (/tmp/ExportThemesAndSkins.xml.out) to remove any themes and skins NOT created using the *Theme Manager*. This would include any/all themes included in the base Portal (e.g. Portal 8.5). Then, import this resulting XML file on the target to register the new themes and skins:
    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -in /tmp/ExportThemesAndSkins.xml.out -in /tmp/ExportThemesAndSkins.xml.out.out -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config
    ```

11. Set the properties required for syndication in WCM ConfigService (e.g. enable member fixer to run as part of syndication).

12. XMLAccess import baseExport.xml into the base virtual Portal of the target system.

    Sample Command: 
    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -in /tmp/baseVPExportRelease.xml -out /tmp/baseVPExportRelease.xml.out -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config
    ```

13. Deploy your DAM (Digital Asset Management) assets from your source environment to you target environment using *dxclient*. 

    ```
    dxclient manage-dam-staging register-dam-subscriber
    dxclient manage-dam-staging trigger-staging
    ```

14. Export the PZN rules from the source system and import them to the target server - this can e.g. be done using the Personalization Administration Portlet Export and Import functions.

15. Verify the base virtual Portal - everything should work.

16. Create your virtual Portals using the output deck from the XMLAccess command used in step "4" to export the virtual portal definitions from the source.

    Sample Command:

    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -in /tmp/ExportVirtualPortals.xml -out /tmp/ExportVirtualPortals.xml.out -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config
    ```

17. Import the XML file for each virtual Portal on the source into same virtual portal on the target using XMLAccess. Ensure that the VP context root in the XMLAccess command matches the VP name in the &quot;/wps/config/&quot; XMLAccess statement.

    Sample Command: 
    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -in /tmp/vp1Export.xml -out /tmp/vp1Export_result.xml -user wpsadmin -password wpsadmin -url http://localhost:9080/wps/config/vp1
    ```

18. Repeat 16 and 17. until all of your virtual Portals are created and filled via XMLAccess on the target Portal.

19. Stage all Digital Asset Management (DAM) artifacts from your source system to your target system.

20. Delete your WebEngine pod, await Kubernetes to restart the pod and then ensure that the WebEngine works correctly. Address potentially missed artifacts. Watch for error messages in console.log, messages.log and trace.log during startup.

21. Setup syndication for the appropriate libraries between the source and the target system (or maybe opposite if you just installed the Authoring system)

    Note: You need to syndicate the Multi-Lingual configuration library.

    Note: You will need to setup syndication as well between your source system virtual Portals to the target system virtual Portals (unless you have managed pages disabled - then the libraries are shared across virtual Portals).

22. After syndication has completed its initial run, setup the library permissions (those permissions are not syndicated).
