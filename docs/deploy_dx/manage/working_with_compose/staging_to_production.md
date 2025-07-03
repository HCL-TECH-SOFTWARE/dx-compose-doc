# Staging one WebEngine instance to another

During WebEngine solution development, the total solution is initially developed, tested, and refined on one server or a limited number of servers. The total solution is then deployed later on systems targeted for production, referred to as the production environment. The process of moving the solution from one environment to another environment is called staging.

Staging is only possible between the same product release or version. In contrast, upgrading from one release to a newer release is called migration.

HCL Digital Experience (DX) Compose, Web Content Manager (WCM) and Digital Asset Manager (DAM) solutions can consist of many artifacts. These artifacts include portlets, themes and skins, portlet services, page layouts, wires, portlet configurations, portlet data, content, and personalization rules. Staging helps you move these artifacts to the production environment in a controlled way.

For naming purposes, this document calls the system that you are staging from the *source* system and the system you are staging to the *target* system.

When using DXClient, you must be able to connect to at least the target systems to fully complete the following tasks. This connection is essential for the deployment process. Deploying to the target system requires XMLAccess input decks (XML files) produced by the source system. These source XML files can be generated using a local XMLAccess command, a remote XMLAccess command, or, preferably, a DXClient command.

## Staging from source to target

!!!note
    Setting up CaaS requires using the `xmlaccess` function in DXClient. For more information on installing and using DXClient, refer to [DXClient](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/development_tools/dxclient/){target="_blank"}.

Refer to the following steps to stage your solutions from the source system to the target system.

1. Install DX Compose to the target system and perform a Helm upgrade. The target and source should have exactly the same DX Compose Cumulative Fix (CF) level. It is recommended to use the latest CF on the source and target systems.

2. Configure security on the target DX Compose system. This may be a different user repository (for example, LDAP) from that of the source server.

    If both systems are using the same user repository and the same administrator, you can copy the appropriate section (for example, `ldap-repository`) from the `server.xml` of the source to the `server.xml` of the target and update the Helm chart of the target to match the source.

3. Transfer the database from the source system to the target DX Compose system. This step is managed through the Helm chart for the target server.

    While transferring the database from the source to the target is not critical, it is assumed that the target system will be used for production use and should have undergone database transfer.

4. Export the virtual portals from the source system by running the following command using DXClient:

    ```
    dxclient xmlaccess -xmlFile ExportVirtualPortals.xml

    ```

    This command produces an XML output file that contains the list of all the virtual portals on the source system. It can be found on the source system and is copied here: [ExportVirtualPortals.xml](./ExportVirtualPortals.xml){target="_blank"}. Name the output file `ExportVirtualPortals.xml.out`.

5. Export the base portal from the source system by running the following command on the source portal's base virtual portal: As an example, the result file could be called `baseVPExportRelease.xml`.-->

    ```
    dxclient xmlaccess -xmlFile ExportRelease.xml
    ```

    This command produces an XML output file of the base portal on the source system. It can be found on the source system and is copied here: [ExportRelease.xml](./ExportRelease.xml){target="_blank"}. Name the output file `baseVPExportRelease.xml.out`.

6. Export your virtual portals using the following command for the first virtual portal on the source system: As an example, the result file could be called `vp1Export.xml`.

    ```
    dxclient xmlaccess -xmlFile ExportUniqueRelease.xml -xmlConfigPath /wps/config/vp1
    ```

    This command produces an XML output file that contains all the resources on the virtual portal. It can be found on the source system and is copied here: [ExportUniqueRelease.xml](./ExportUniqueRelease.xml){target="_blank"}. Name the output file `vp1ExportRelease.xml.out`.

    Repeat this step for each virtual portal on the source system. Ensure you use a unique name for each `dxclient xmlaccess` output. Each output file will be used as input when you import the virtual portals to the target system.

7. Remove existing content from the target WebEngine container by running the following XMLAccess commands:

    ```
    dxclient xmlaccess -xmlFile CleanPortalWithoutWebApps.xml 

    dxclient xmlaccess -xmlFile AddBasePortalResources.xml

    dxclient xmlaccess -xmlFile SchedulerCleanupTask.xml
    ```

    Ensure all three XMLAccess tasks are successfully completed to finish the operation.

    These XMLAccess files can be found on the source system and are copied here:

    - [CleanPortalWithoutWebApps.xml](./CleanPortalWithoutWebApps.xml){target="_blank"}
    - [AddBasePortalResources.xml](./AddBasePortalResources.xml){target="_blank"}
    - [SchedulerCleanupTask.xml](./SchedulerCleanupTask.xml){target="_blank"}

8. Run the scheduler using the `Task.xml` script on the target WebEngine container by executing the following command:

    ```
    dxclient xmlaccess -xmlFile Task.xml
    ```

    This command forces the cleanup task to run, which removes resources that were *soft*-deleted. It can be found on the source system and is copied here: [Task.xml](./Task.xml){target="_blank"}.

9. Transfer the WebDAV themes from the source system to the target system.

    !!!note
        WebEngine currently does not support deployment of custom EAR files that persist. Only WebDAV-based themes are supported.

    1. Locate your custom themes on the source system using the Theme Manager in WebEngine. Take note of the names you have assigned to the themes.

    2. Using a WebDAV client on your local operating system, create an archive using the TAR utility or compress the files in ZIP format for the custom themes from the WebDAV file system.

    3. After all the files are contained in a tarball or ZIP file, move this file to the target and import the files into the target WebDAV directory using the same theme names as on the source system.

    4. Regardless of the method used to get the theme files onto the target WebDAV, you must register the custom themes using XMLAccess. Ensure you preserve the object ID (OID) of the custom theme(s) on the target portal. For example, the OID should be the same on the source and target in the XMLAccess import XML file.

    5. Export the themes and skins from the source using the following command:

        ```
        dxclient xmlaccess -xmlFile ExportThemesAndSkins.xml
        ```

        This command exports all the themes and skins from the source portal. It can be found on the source system and is copied here: [ExportThemesAndSkins.xml](./ExportThemesAndSkins.xml){target="_blank"}.

    6. Edit the XML output file created in step 5 to remove any themes and skins not created using the Theme Manager. This includes all the themes in the base portal (for example, Portal 8.5 theme). Name the output file `ExportThemesAndSkins.xml.out`.

    7. Import the resulting XML file on the target system to register the new themes and skins using the following command:

        ```
        dxclient xmlaccess -xmlFile ExportThemesAndSkins.xml.out
        ```

10. Set the properties required for syndication in `WCMConfigService` (for example, enabling the member fixer to run as part of syndication). You can find more information about custom syndication configuration properties in [Member fixer with syndication](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_configuration/wcm_adm_tools/wcm_member_fixer/wcm_admin_member-fixer_synd/){target="_blank"}.

    You need to create a Helm `values.yaml` file to update the `WCMConfigService` properties file. For example: [WCMConfigServiceHelmChart.yaml](./WCMConfigServiceHelmChart.yaml). The actual values in the sample Helm `values.yaml` must match the desired values for your situation.

11. Import the base virtual portal (exported in step 5) into the base virtual portal of the target system using the following command:

    ```
    dxclient xmlaccess -xmlFile baseVPExportRelease.xml.out
    ```

    This command imports the `baseVPExportRelease.xml.out` file generated in step 5.

12. Deploy your DAM assets from your source environment to your target environment using the following commands:

    ```
    dxclient manage-dam-staging register-dam-subscriber
    dxclient manage-dam-staging trigger-staging
    ```

13. Export the Personalization rules from the source system, then import them to the target system. You can export and import the rules using the Personalization Administration Portlet Export and Import functions. For more information, refer to [Staging Personalization rules to production](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/pzn/pzn_stage_prod/){target="_blank"}.

14. Ensure the base virtual portal is working properly. Verify the content, rendering of the theme and pages, Personalization rules, and Script Applications.

15. Import the virtual portals (exported in step 4) from the source system into the target system using the following command:

    ```
    dxclient xmlaccess -xmlFile ExportVirtualPortals.xml.out
    ```

    This command imports the `ExportVirtualPortals.xml.out` file generated in step 4.

16. Import the XML files generated in step 6 for each virtual portal from the source system into the corresponding virtual portal on the target system using the following command.

    ```
    dxclient xmlaccess -xmlFile vp1Export.xml -xmlConfigPath /wps/config/vp1
    ```

    Ensure that the VP context root used in every command matches the context root of each target virtual portal.

17. Verify that all DAM artifacts were transferred from your source system to your target system as configured in step 13.

18. Restart the `webengine` pod using the following command on your local machine's terminal:

    ```
    kubectl delete webengine-pod-0 -n dxns
    ```

19. Ensure that WebEngine is functioning as expected. Address potentially missed artifacts and look for error messages in `SystemOut.log`, `messages.log`, and `trace.log` during startup.

20. Set up syndication for the appropriate libraries between the source and target systems (or target to source depending on your requirements). For example, for an Authoring system, subsequent syndications could go from Authoring to Integration Test or Development environment.

    !!!note
        - You need to syndicate the Multilingual configuration library.
        - You must set up syndication between your source system's virtual portals and the target system's virtual portals.

21. After syndication has completed its initial run, set up the library permissions.

    Library permissions are not syndicated. For more information, refer to [Set up access to libraries](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_authoring/authoring_portlet/web_content_libraries/oob_content_accesslib/){target="_blank"}.
