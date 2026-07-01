# Enabling rules-based user groups (Softgroups) portlet

## Deploying the Softgroups portlet

To deploy the Softgroups portlet application, you need to import the XML file: [DeploySoftGroupsPortlet.xml](./DeploySoftGroupsPortlet.xml){target="_blank"}.

Import the file using the `xmlaccess` function of DXClient or another method. For more information on installing and using DXClient, refer to [DXClient](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/development_tools/dxclient/){target="_blank"}. Alternative methods to import the XML include the "XML Import" page in Practitioner Studio.

    Run the following DXClient command:

        <pre>
            ```
            dxclient xmlaccess -xmlFile DeploySoftGroupsPortlet.xml
            ```
        </pre>


## Creating Softgroups Admin page

Once the portlet is deployed, create an **Admin** page which will allow you to define the rule-based groups using the following steps:

1. Ensure you are logged in to Compose using the administrator credentials.
1. Navigate to **Administration** > **Site Management** > **Pages** 
1. Select pages **Content Root** > **Home**, click the **New Page** button to view **Page Creation** page.
1. Set the title to **Softgroups Admin**, unique name to **SoftGroups**, and friendly URL to **softgroups**, click **OK**.
1. Add the Softgroups Portlet to the newly created page:
     1. Locate **Softgroups Admin** row in the list of pages.
     1. Click **Pencil** icon.
     1. Click **Add Portlets**.
     1. Search for Soft and select **softgroups.portlet**, click **OK**.
     1. Click **Done**.

## Manage Softgroups Admin page permissions

1. Go back to **Home** section, under **Manage Pages** and locate the newly added Softgroups admin page.
1. Click on the little key icon.
1. Uncheck the boxes for **Privileged User** and **User** in the **Allow Inheritance** column.
1. Click **Apply** and click **Done** button.

## Define Rule-Based User Groups

1. Navigate to https://&lt;HOSTNAME&gt;/wps/myportal/Home/softgroups and ensure you are logged in with the administrator credentials.
1. Under the **Create** section, provide a name for your group, for example, **softgrouptest**.
1. Add an optional description for the group.
1. Under the rule, add a specific rule for defining its membership criteria, for example, **(uid=tuser1)**.

## Verify rule to user resolution works as expected

1. Navigate to **Administration** > **Security** > **Users and Groups**
1. Verify that you can locate the user-based group that was created in the previous step by doing a **cn** search using the group name
1. Click on that group name in the results table to verify that the users that match the rule are visible
