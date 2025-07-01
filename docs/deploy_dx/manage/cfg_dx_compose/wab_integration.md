# Integrating WAB with DX Compose

This topic provides the steps to integrate Web Application Bridge (WAB) with Digital Experience (DX) Compose. Integrating WAB with HCL DX Compose allows you to use external web applications within your HCL DX Compose environment, providing a seamless and unified user experience. Note that there are steps in the integration process for portal administrators and content authors. In this integration, the portal administrator collects information about the content provider and its applications, and then configures DX Compose to enable WAB. Refer to the following steps:

1. [Enable WAB on a portal.](#enabling-wab-on-a-portal)
2. [Create and configure the web dock application.](#creating-and-configuring-the-web-dock-application)
3. [Add the web dock application to a page.](#adding-the-web-dock-application-to-a-page)
4. [Enable WAB with SSL.](#enabling-wab-to-support-ssl-secured-websites)

!!! note
    WAB integration is not supported on a portal with the context root removed.

## Enabling WAB on a portal

Before creating the applications, you must enable WAB on a portal that does not have the context root removed.

!!!note
    Perform the following steps as a portal administrator.

1. Configure the `values.yaml` file to enable WAB. You can use the `configOverrideFiles` snippet or the `wabEnabled` parameter.

    - To enable WAB using `configOverrideFiles`, update the context root of the `wp.vwat.servlet.ear` application to `/` by adding the following snippet to your `values.yaml` file:

        ```yaml
        configOverrideFiles:
        vwat-wab-overrides.xml: |
            <server description="DX Web Engine server"> 
            <enterpriseApplication id="wp.vwat.servlet.ear" location="${server.config.dir}/resources/portlets/VwatReverseProxyServlet.ear" name="wp.vwat.servlet.ear" startAfterRef="engine-ear">
                <web-ext moduleName="wp.vwat.servlet.war" context-root="/"></web-ext>
                <application-bnd>
                <security-role name="All Role">
                    <special-subject type="ALL_AUTHENTICATED_USERS"/>
                </security-role>
                </application-bnd>
            </enterpriseApplication>
            </server>
        ```

    - To enable WAB using the `wabEnabled` parameter, set this parameter to `true`:

        ```yaml
        configuration:
        # Configuration for webEngine
        webEngine:
            wabEnabled: true
        ```

        You can also set `wabEnabled` to false to disable WAB:

        ```yaml
        configuration:
        # Configuration for webEngine
        webEngine:
            wabEnabled: false
        ```

2. Perform a [Helm upgrade](../working_with_compose/helm_upgrade_values.md) to apply the changes. Open Liberty picks up and applies changes at runtime and doesn't require a restart.

## Creating and configuring the web dock application

After enabling WAB and performing a Helm upgrade, the portal administrator should create content provider profiles and a web dock application.

1. Log in to HCL DX Compose as an administrator.

2. In the site toolbar, click the **Administration menu** icon and click **Administration**. Go to **Applications > Virtual Application Manager**.

    !!!important
        Do not enter angel brackets (< or >) into any of the text boxes.

3. Click **Content Provider Profiles > Create Content Provider Profiles**.

4. Create the content provider profiles. For more information, see [Content provider profiles](https://opensource.hcltechsw.com/digital-experience/latest/extend_dx/integration/wab/wab/h_wab_provider/){target="_blank"}.

5. Go to the profile you created and create a policy by clicking **Add policy**. Create at least one policy for the content provider profile.

6. Click **Web Dock Applications > Create Web Dock Applications**.

7. Create the web dock applications. For more information, see [Web dock applications](https://opensource.hcltechsw.com/digital-experience/latest/extend_dx/integration/wab/wab/h_wab_dock/){target="_blank"}.

8. Go to the web dock application you created and select one of the following tabs:

    !!!note
        If the system administrator changes the host or port information in the content provider profile, you must edit the web dock application and reselect the profile. Otherwise, the web dock application does not pick up the changes.

    - **Web Dock Display Settings**
    - **Client Side IPC for Web Dock**
    - **Server Side IPC for Web Dock**
    - **Plugins**

9. Click **Edit** to configure the web dock settings.

## Adding the web dock application to a page

After configuring the web dock application, content authors must add the application to a page.

1. Log in to HCL DX Compose as a content author. 

2. Access the site toolbar and perform one of the following actions:

    - Create a page and add the web dock application portlet to the page.
    - Edit an existing page and add the web dock application portlet to the page.

    !!!note "Tip"
        To get the web dock application to render on a page, the page must either have the **Web Dock** profile or a profile that includes the **wp_webdock** module. Edit the page properties and change the profile or add the **wp_webdock** module to the profile applied to the page.

        If you are using the Resource Aggregator for Portlets, no additional steps are necessary. If you are not using the Resource Aggregator for Portlets, refer to [Adding the wp_webdock module](#adding-the-wp_webdock-module).

### Adding the wp_webdock module

If you are not using the Resource Aggregator for Portlets, add the **wp_webdock** module to an existing profile on your page.

1. Connect to the theme repository with the fs-type1 connection.
2. Go to your theme.
3. Open the profile file in the /profiles directory.
4. Make a copy of the profile file and give it a unique name.
5. Edit the .json file and add the **wp_webdock** module ID.
6. Copy the profile that you created to the `/profiles` directory.
7. Invalidate the resource aggregator cache to integrate your changes. 

    1. Click the **Administration menu** icon in the toolbar.
    2. click **Theme Analyzer > Utilities > Control Center > Invalidate cache**. 
        Auto-invalidation recognizes your changes automatically for WebDAV-based themes. No further action is required.

## Updating the user role

If a content author experiences issues with viewing the web dock applications, complete the following steps to update the user role:

1. Log in to HCL DX Compose as the administrator.

2. Click the **Administration menu** icon in the toolbar. Then, click **Access > Resource Permissions**.

3. Search for the page that contains the web dock application.

4. Provide the content author the correct permissions to the page.

5. (Optional) If the content provider policy is set to use basic or form-based authentication, complete the following steps:

    1. Go to the web dock application and provide the content user the correct permissions.
    2. Go to the credential vault used for the authentication. Provide the content user the correct permissions to the credential vault.

## Enabling WAB to support SSL-secured websites

You can configure WAB to integrate with external websites secured by self-signed certificates if certificates is not directly trusted by browsers.

To enable secure connections, add the self-signed certificate to the truststore. For detailed steps, see [Using custom certificates in WebEngine](../working_with_compose/custom_certificates.md).

!!!note
    The certificate file must begin with `--BEGIN CERTIFICATE--` and end with `--END CERTIFICATE--`.
