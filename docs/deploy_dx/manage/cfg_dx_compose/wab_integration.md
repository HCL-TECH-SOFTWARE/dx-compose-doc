# Getting started with the Web Application Bridge

The portal administrator collects information about the content provider and its applications and then follows basic configuration steps to enable the Web Application Bridge.

1.  Here are the steps to enable Web Application Bridge on a portal that doesn't have the context root removed:

!!! note
    This is not supported on a portal with the context root removed.

        1.  Set the context root for the **wp.vwat.servlet.ear** application:
            1.  Log on to the Open Liberty Admin Center at https://<portal_hostname>/adminCenter/login.jsp.
            2.  Navigate to **Server Config > server.xml**.
            3.  Find and expand the **wp.vwat.servlet.ear** enterprise application link.
            4.  Under the **Enterprise Application wp.vwat.servlet.ear**, click **Web Application Extensions**.
            5.  Update the context root to /. This step can create name conflicts. Add a rewrite rule to avoid these conflicts. For more information read [Apache Module mod_rewrite](http://httpd.apache.org/docs/2.2/mod/mod_rewrite.html).
            6.  Click **Save** to apply your changes.
            7.  The **wp.vwat.servlet.ear** application should restart automatically.

2.  The system administrator logs in to HCL DX Compose.

3.  The system administrator clicks the **Administration menu** icon from the toolbar. Then, clicks **Portlet Management > Virtual Web Application Manager**.

    !!!warning
        Do not enter < or > into any of the text boxes.

4.  The system administrator clicks **Content Provider Profiles** and then selects **Create Content Provider Profiles**.

5.  The system administrator creates the content provider profiles.

6.  The system administrator goes to the profile that was created and clicks **Add policy** to create a policy.

    !!!tip
        The system administrator must create at least one policy for the content provider profile.

7.  The system administrator clicks **Web Dock Applications** and then selects **Create Web Dock Applications**.

8.  The system administrator creates the web dock applications.

9.  The system administrator goes to the application that was created.

10. The system administrator selects one of the following tabs and then click **Edit** to configure the web dock settings:

    !!!note
        If the system administrator changes the host or port information in the content provider profile, you must edit the web dock application and reselect the profile. Otherwise, the web dock application does not pick up the changes.

    -   **Web Dock Display Settings**
    -   **Client Side IPC for Web Dock**
    -   **Server Side IPC for Web Dock**
    -   **Plugins**

11. The content author logs in to HCL DX Compose.

12. The content author accesses the site toolbar and takes one of the following actions:

    -   Creates a page and adds the web dock application portlet to the page.
    -   Edits an existing page and adds the web dock application portlet to the page.
    
    !!!note "Tip"
        To get the web dock application to render on a page, the page must either have the **Web Dock** profile or a profile that includes the wp_webdock module. Edit the page properties and change the profile or add the wp_webdock module to the profile applied to the page:

    Starting with CF03, the Web Dock profile no longer exists. If you are using the Resource Aggregator for Portlets, no additional steps are necessary. If you are not using the Resource Aggregator for Portlets, add the **wp_webdock** module to an existing profile on your page.

    1.  Connect to the theme repository with the fs-type1 connection.
    2.  Go to your theme.
    3.  Open the profile file in the /profiles directory.
    4.  Make a copy of the profile file and give it a unique name.
    5.  Edit the .json file and add the **wp_webdock** module ID.
    6.  Copy the profile that you created to the /profiles directory.
    7.  Invalidate the resource aggregator cache to integrate your changes. Click the **Administration menu** icon in the toolbar. Then, click **Theme Analyzer > Utilities > Control Center > Invalidate cache**. Auto invalidation recognizes your changes automatically for WebDAV based themes. No further action is required.
    
13. If a content author experiences issues with viewing the web dock applications, complete the following steps to update the user role:

    1.  Log on to HCL DX Compose as the administrator.

    2.  Click the **Administration menu** icon in the toolbar. Then, click **Access > Resource Permissions**.

    3.  Search for the page that contains the web dock application.

    4.  Give the content author the correct permissions to the page.

    5.  If the content provider policy is set to use basic or form-based authentication, complete the following steps:

        -   Go to the web dock application and give the content user the correct permissions.
        -   Go to the credential vault used for the authentication. Give the content user the correct permissions to the credential vault.

After following the above steps, you should be able to successfully integrate the Web Application Bridge (WAB) in HCL DX Compose. This integration allows you to leverage external web applications within your HCL DX Compose environment, providing a seamless and unified user experience.