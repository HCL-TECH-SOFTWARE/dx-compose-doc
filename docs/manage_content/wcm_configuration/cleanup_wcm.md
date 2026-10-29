# Cleaning up WCM items

The amount of Web Content Manager (WCM) items grows over time. To maintain good system performance, clean up old items that you no longer need. Regular cleanup improves authoring performance and shortens migration time when upgrading from an earlier release.

You can clean up the following item types:

- Versions
- Published projects
- References to users and groups that no longer exist
- Item history
- Deleted items
- Unused items

## Versions

Use the clear versions tool to eliminate versions. With this tool, you can specify how many versions to keep or specify a timestamp before which to delete all versions. You can also configure the default policy in `WCMConfigService` to manual instead of automatic so users choose which versions to create. <!--Should this be the `WCMConfigService.properties` file?-->

For more information, refer to [Clearing version history](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_configuration/wcm_adm_tools/wcm_admin_clear_versions/).

## Published projects

To delete published projects, use one of the following methods:

- Use the WCM API to delete the projects programmatically. <!--The previous link here was broken: [WCM API](https://help.hcl-software.com/digital-experience/8.5/dev/javadoc/vrm/850/api_docs/com/ibm/workplace/wcm/api/Workspace.html){target="_blank"} -->
- Delete the projects through the WCM Authoring portlet:

    1. Select **Project > Published**.
    2. Select the target projects.
    3. Select **Delete Project**.

- Configure a background task to delete the projects automatically. For more information, refer to [Configuring Web content cleanup tasks](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_configuration/wcm_adm_tools/wcm_config_clean_tasks/).

## References to users and groups that no longer exist

WCM items reference users and groups to ensure that only authorized users can access content. User names and group names frequently change over time in situations such as the following:

- A user changes their legal name.
- A user transfers to another department (for example, from Human Resources to Finance), which changes their distinguished name from `CN=<firstname lastname>,OU=HR,O=<companyname>` to `CN=<firstname lastname>,OU=Finance,O=<companyname>`.

To update or remove invalid user or group references, use one of the following methods:

- Update references manually in the affected item to point to the new user or group.
- Run the member fixer task to check and repair references across an entire library. When run in report mode, the task lists all member references. When run in fix mode, it repairs references by replacing them with existing members or removing them.

For more information, refer to [Using the member fixer task](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_configuration/wcm_adm_tools/wcm_member_fixer/wcm_admin_member-fixer/).

## Item history

Use the clear history tool to clear the history of an item. For more information, refer to [Clearing item history](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_configuration/wcm_adm_tools/wcm_admin_clear_history/).

## Deleted items

When you delete items, WCM does not permanently remove them so that you can undo deletions. These deleted items accumulate over time.

To permanently delete items, use one of the following methods:

- Purge items through the user interface.
- Purge items programmatically by using the WCM API.
- Configure a background task to purge deleted items automatically. For more information, refer to [Configuring Web content cleanup tasks](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_configuration/wcm_adm_tools/wcm_config_clean_tasks/).

## Unused items

Unused content also accumulates over time. Cleaning up unused items saves storage space and improves performance during syndication and other staging activities. In addition to the items in the cleanup list, unexpired content that is no longer needed can increase system load.

To manage and remove unused content, use one of the following methods:

- Manage old content by using policies (for example, enforce content expiration after one year).
- Query, delete, and purge content and other WCM items by using the WCM API. <!--The previous link here was broken: [WCM API](https://help.hcl-software.com/digital-experience/8.5/dev/javadoc/vrm/850/api_docs/com/ibm/workplace/wcm/api/Workspace.html){target="_blank"} -->
- Locate content that has not been updated recently by using the `findContentModifiedBetween` method in the WCM API. This method returns only content modified between specific dates (for example, run a query from 1970 through 2016 to find content that has not been modified since 2016). For more information, refer to the [WCM API documentation](https://help.hcl-software.com/digital-experience/8.5/dev/javadoc/vrm/850/api_docs/com/ibm/workplace/wcm/api/Workspace.html#findContentModifiedBetween(java.util.Date,%20java.util.Date)){target="_blank"}. <!--This link is broken-->

## Querying version nodes

To determine which JCR nodes are versions, run the following queries:

- To find the nodes per workspace:

    ```sql
    SELECT COUNT(1) AS NODE_COUNT, WSID FROM <schema>.ICMUTSWIDE0 WHERE WSID > 0 GROUP BY WSID
    ```

- To find the workspaces:

    ```sql
    SELECT WSID, WSNAME FROM JCR.ICMSTJCRWS WHERE WSID > 0 ORDER BY WSID
    ```
  
Nodes in `jcr:versioning` and any `_v` workspace for virtual portals represent the version nodes.
