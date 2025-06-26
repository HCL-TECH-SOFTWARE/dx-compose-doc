# Staging one WebEngine instance to another

During WebEngine solution development, the total solution is initially developed, tested, and refined on one server or a limited number of servers. The total solution is then deployed later on systems targeted for production, referred to as the production environment. The process of moving the solution from one environment to another environment is called staging.

Staging is only possible between the same product release or version. In contrast, upgrading from one release to a newer release is called migration.

HCL Digital Experience (DX) Compose, Web Content Manager (WCM) and Digital Asset Manager (DAM) solutions can consist of many artifacts. These artifacts include portlets, themes and skins, portlet services, page layouts, wires, portlet configurations, portlet data, content, and personalization rules. Staging helps you move these artifacts to the production environment in a controlled way.

For naming purposes, this document calls the system that you are staging from the *source* system and the system you are staging to the *target* system.

The detailed examples below are shown using a locally connected XMLAccess command. This implies the the user of the XMLAccess command are logged into the pod containing DX Compose and that XMLAccess is run from inside that pod. This could be problematic is the user of XMLAccess (typically the Portal Administrative user) does NOT have login access to the Kubernetes pod. However, note that one could also (equivantly) install XMLAccess on ones local machine and XMLAccess to the DX Compose remotely (by adjust the URL parameter in the examples below) or by using the "DX Client" command. Using DX Client is the preferred way to do this in a Kubernetes environment.

When using DX Client, note that one must have the ability to "DX Client" into at least the "target" systems to fully complete the tasks below. 
The put to the target system requires XMLAccess input decks producted by the "source" system. Producing these "source" xml files can also be achieved by a local XMLAccess command, a remote XMLAccess command or (the preferred) DX Client command.

## Staging from source to target

0. Several of these steps will be completed using the "xmlaccess" function of DXClient. If you need help installing or using DXClient, please refer to this article: [DXClient](https://help.hcl-software.com/digital-experience/9.5/CF228/extend_dx/development_tools/dxclient/)

1. Install DX Compose and upgrade the target system with "helm". The target and source should have exactly the same DX Compose level and preferably be at the latest of both. As both source and target are Kubernetes-based.

    !!!note
    It is recommended to use the latest cumulative fix (CF) on both the source and target systems.

2. Configure security on the target DX Compose system. This might be a different user repository (for example, LDAP) than the source server.

    If both systems are using the same user repository and the same administrator, you can copy the appropriate section (for example, `ldap-repository`) from the `server.xml` of the source to the `server.xml` of the target and update the Helm chart of the target to match the source.

3. Transfer the database on the target DX Compose system. Note that this step happens through the Helm chart for the target server.

    While transferring database on the source is not critical, it is assumed that the target system will be used for production use and should have gone through database transfer.

4. Using DXClient, export the virtual Portals from the source system.

    Sample command:

    ```
    dxclient xmlaccess -xmlFile ExportVirtualPortals.xml

    ```

   This command produces a list of all the virtual portal on the source system. It can be found on the server itself and is copied here: [ExportVirtualPortals.xml](./ExportVirtualPortals.xml). Call the output from this command "ExportVirtualPortals.xml.out"

5. Execute "dxclient xmlaccess" with `ExportRelease.xml` on the source Portal's **base** virtual Portal. As an example, the result file could be called `baseVPExportRelease.xml`.

    From inside the DX Compose portal deployed on your source system (for example, use `kubectl exec -it webengine-pod-0 bash -n dxns`), you can use the following sample command:

    ```
    dxclient xmlaccess -xmlFile ExportRelease.xml
    ```

This command produces a list of all the virtual portal on the source system. It can be found on the server itself and is copied here: [ExportRelease.xml](./ExportRelease.xml). Call the output from this command "baseVPExportRelease.xml.out"

6. Execute "dxclient xmlaccess" with `ExportUniqueRelease.xml` for the first source Portal Virtual Portal 1. As an example, the result file could be called `vp1Export`.xml.

    ```
    dxclient xmlaccess -xmlFile ExportUniqueRelease.xml
    ```

This command produces a export of all resources on the virtual portal. It can be found on the server itself and is copied here: [ExportUniqueRelease.xml](./ExportUniqueRelease.xml). Call the output from this command "vp1ExportRelease.xml.out"

7. Repeat the previous step for each virtual portal on the source system. Make sure to use a unique name for the "dxclient xmlaccess" output as they will each be the input for a future "dxclient xmlaccess" step.

8. Remove existing content from the target WebEngine container.

    Ensure that all three XMLAccess tasks are run to complete the operation.

    Sample commands: 

    ```
    dxclient xmlaccess -xmlFile CleanPortalWithoutWebApps.xml 

    dxclient xmlaccess -xmlFile AddBasePortalResources.xml

    dxclient xmlaccess -xmlFile SchedulerCleanupTask.xml
    ```

These commands produces a export of all resources on the virtual portal. It can be found on the server itself and is copied here: [CleanPortalWithoutWebApps.xml](./CleanPortalWithoutWebApps.xml), [AddBasePortalResources.xml](./AddBasePortalResources.xml), [SchedulerCleanupTask.xml](./SchedulerCleanupTask.xml). 

9. Run scheduler through the `Task.xml` on the target WebEngine container.

    Sample command: 

    ```
    dxclient xmlaccess -xmlFile Task.xml
    ```

This commands forces the cleanup task to run which removes resources that were "soft" deleted. It can be found on the server itself and is copied here: [Task.xml](./Task.xml).

10. Transfer the WebDav theme from the source server to the target. 

    !!!note
        WebEngine currently does not support deployment of custom EAR files that persist. Only WebDav-based themes are supported. 

    1. Locate your custom themes on the source server using the Theme Manager in WebEngine. Take note of the names you have assigned to the themes.

    2. Using a WebDav client on your local operating system, create an archive using the TAR utility or compress the files in ZIP format for the custom themes from the WebDav file system. 
    
    3. After all the files are contained in a tarball or ZIP file, move this file to the target and import the files onto the target WebDav using the same theme names as on the source server.

    4. Regardless of the method used to get the theme files onto the target WebDav, you must register the custom themes using XMLAccess. Ensure that one preserves the object id (OID) of the custom theme(s) on the target portal. For example, the OID should be the same on the source and target in the XMLAccess import XML file.

    5. Export the themes and skins from the source:

        ```
        dxclient xmlaccess -xmlFile ExportThemesAndSkins.xml
        ```

    This commands exports all the themes and skins from the source portal. It can be found on the server itself and is copied here: [ExportThemesAndSkins.xml](./ExportThemesAndSkins.xml).
    
    6. Edit the output of the previous command to remove any themes and skins not created using the Theme Manager. This would include all themes included in the base Portal (for example, Portal 8.5 theme). Call this new file "ExportThemesAndSkins.xml.out"
    
    7. Import the resulting XML file on the target to register the new themes and skins:

        ```
        dxclient xmlaccess -xmlFile ExportThemesAndSkins.xml.out
        ```

11. Set the properties required for syndication in WCM ConfigService (for example, enable member fixer to run as part of syndication). You can find more information about custom syndication configuration properties in [Member fixer in Syndication](https://opensource.hcltechsw.com/digital-experience/latest/manage_content/wcm_configuration/wcm_adm_tools/wcm_member_fixer/wcm_admin_member-fixer_synd/).

This will require a "helm chart" to be created to update the WCMConfigService properties file. Here is an example of that helm chart: [WCMConfigServiceHelmChart.yaml](./WCMConfigServiceHelmChart.yaml).

Note that the actual values in the helm chart provided as an example need to match the desired values for this situation. 

12. Import XMLAccess with `baseExport.xml` into the base virtual Portal of the target system.

    Sample command: 

    ```
    dxclient xmlaccess -xmlFile baseVPExportRelease.xml.out
    ```

13. Deploy your DAM assets from your source environment to your target environment using DXClient.

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
    dxclient xmlaccess -xmlFile ExportVirtualPortals.xml.out
    ```

17. Import the XML file generated as the result of "ExportUniqueRelease.xml" for each virtual Portal fronm the source virtual portal into same virtual Portal on the target using "dxclient xmlaccess". Ensure that the VP context root used on the "dxclient xmlaccess" command matches the context root of the target virtual portal.

    Sample command: 

    ```
    dxclient xmlaccess -xmlFile vp1Export.xml -xmlConfigPath /wps/config/vp1
    ```

18. Repeat step until all of your virtual Portals are created and filled through "dxclient xmlaccess" on the target Portal.

19. Validate all DAM artifacts were transferred from your source system to your target system as configured in step 13.

20. Restart webengine pod. 

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
