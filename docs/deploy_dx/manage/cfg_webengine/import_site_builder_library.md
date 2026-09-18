# Importing the Site Builder Template library onto a new virtual portal

In HCL DX Compose, the ConfigEngine utility is not available. Instead, you can use the Web Content Manager (WCM) Module utility to export and import WCM libraries. The following steps describe how to copy the Site Builder Template library to a new virtual portal.

!!!note
    You must log in to HCL DX Compose first in the same browser before running these commands.

1. Export the Site Builder Template library using the following URL:

    ```
    https://<your-host>/<context-root>/wcm/myconnect?MOD=data&taskType=export&exportLibrary=Site+Builder+Template+Library
    ```

    Replace the following variables:

    1. `<your-host>` with your WebEngine host.
    2. `<context-root>` with your portal context root (which is `wps` by default).

    If you do not specify `output.dir`, the export will be placed in the default export directory inside the WebEngine container:

    ```
    /opt/openliberty/wlp/usr/servers/defaultServer/PortalServer/wcm/ilwwcm/system/export
    ```

    If you want to export the library to a different directory, specify the `output.dir` parameter in the export URL. For example:

    ```
    https://<your-host>/<context-root>/wcm/myconnect?MOD=data&taskType=export&exportLibrary=Site+Builder+Template+Library&output.dir=/custom/export/path
    ```

2. Import the exported library into the new virtual portal using the following URL:

    ```
    https://<your-host>/<context-root>/wcm/myconnect/<vp-context>?MOD=data&processLibraries=false&taskType=import&input.dir=/opt/openliberty/wlp/usr/servers/defaultServer/PortalServer/wcm/ilwwcm/system/export&skipScheduleActions=false&renameConflict=false&importLibrary=Site+Builder+Template+Library
    ```

    Replace the following variables:

    1. `<your-host>` with your WebEngine host.
    2. `<context-root>` with your portal context root (which is `wps` by default).
    3. `<vp-context>` with the context root for your virtual portal, for example `vp1`.

    If you specified a different directory for the export in step 1 using `output.dir`, update the `input.dir` parameter in the URL to match that directory.
