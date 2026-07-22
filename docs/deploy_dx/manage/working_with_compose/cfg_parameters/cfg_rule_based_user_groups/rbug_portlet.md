# Deploying the SoftGroups portlet

You can deploy the **SoftGroups** portlet in two ways:

- Import the [DeploySoftGroupsPortlet.xml](./DeploySoftGroupsPortlet.xml){target="_blank"} file using the `xmlaccess` function of DXClient:

     ```xml
     dxclient xmlaccess -xmlFile DeploySoftGroupsPortlet.xml
     ```

     For more information on installing and using DXClient, refer to [DXClient](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/development_tools/dxclient/){target="_blank"}.

- Use the **XML Import** page in Practitioner Studio. For more information, refer to [Importing pages or page hierarchies by using the XML Import portlet](https://help.hcl-software.com/digital-experience/9.5/latest/deployment/manage/portal_admin_tools/xml_config_interface/working_xml_config_interface/using_admin_portlets_for_xml_config/adxmltsk_portlets_imp/){target="_blank"}.

## Creating the SoftGroups Admin page

After deploying the portlet, create an Admin page to define the rule-based groups:

1. Log in to DX Compose using administrator credentials.
2. Navigate to **Administration > Site Management > Pages > Content Root > Home**.
3. Select **New Page**.
4. Enter the following details:
     - In the **Title** field, enter `SoftGroups Admin`.
     - In the **Unique Name** field, enter `SoftGroups`.
     - In the **Friendly URL name** field, enter `softgroups`.
5. Select **OK**.
6. Locate **SoftGroups Admin** row in the list of pages.
7. Select the **Edit Page Layout** pencil icon.
8. Select **Add portlets**.
9. Search for **softgroups.portlet**, and select its checkbox. <!--I could not find the Portlet Title in the test site, can we use that instead of the unique name (softgroups.portlet)?-->
10. Select **OK > Done**.

## Managing the SoftGroups Admin page permissions

Configure access permissions on the page to restrict administrative rights to authorized users:

1. Navigate to **Home** section, under **Manage Pages** and locate the newly added SoftGroups admin page.
2. Select the key icon. <!--What is the UI name for the key icon?-->
3. Under **Allow Inheritance**, uncheck the boxes for **Privileged User** and **User**.
4. Select **Apply > Done**.

## Defining and verifying rule-based user groups <!--I'm unable to verify this section, can you show a screenshot of how steps 2-4 look like for my reference?-->

Define dynamic group rules and confirm membership evaluation in the user registry:

1. Navigate to `https://&lt;HOSTNAME&gt;/wps/myportal/Home/softgroups` and ensure you are logged in with the administrator credentials.
2. Under the **Create** section, provide a name for your group (for example, `softgrouptest`).
3. Add an optional description for the group.
4. Under the rule, add a specific rule for defining its membership criteria (for example, `(uid=tuser1)`).
5. Navigate to **Administration > Security > Users and Groups**.
6. Verify that you can locate the user-based group by doing a **cn** search using the group name.
7. Confirm that the users that match the rule are visible.
