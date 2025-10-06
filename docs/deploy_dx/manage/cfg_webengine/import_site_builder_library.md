# Importing the Site Builder Template library onto a new Virtual Portal in HCL DX Compose

In HCL DX Compose, the ConfigEngine utility is not available. Instead, you can use WCM Module utility to export and import WCM libraries. The following steps describe how to copy the Site Builder Template Library to a new virtual portal. You must log in first to HCL DX Compose in the same browser before running these commands.

## 1. Export the Site Builder Template Library

Export the library from the source portal using the following URL (replace `<your-host>` with your WebEngine host and `<context-root>` with your portal context root, which is `wps` by default):

```
https://<your-host>/<context-root>/wcm/myconnect?MOD=data&taskType=export&exportLibrary=Site+Builder+Template+Library
```

- If you do not specify `output.dir`, the export will be placed in the default export directory inside the WebEngine container:
  ```
  /opt/openliberty/wlp/usr/servers/defaultServer/PortalServer/wcm/ilwwcm/system/export
  ```

- If you want to export the library to a different directory, you can specify the `output.dir` parameter in the export URL. For example:

  ```
  https://<your-host>/<context-root>/wcm/myconnect?MOD=data&taskType=export&exportLibrary=Site+Builder+Template+Library&output.dir=/custom/export/path
  ```

## 2. Import the Library into the Target Virtual Portal

Import the exported library into the new virtual portal using the following URL (replace `<your-host>` with your WebEngine host, `<context-root>` with your portal context root, which is `wps` by default, and `<vp-context>` with the context root for your virtual portal, for example `vp1`. If you specified a different directory for the export in step 1 using `output.dir`, update the `input.dir` parameter in the URL to match that directory):

```
https://<your-host>/<context-root>/wcm/myconnect/<vp-context>?MOD=data&processLibraries=false&taskType=import&input.dir=/opt/openliberty/wlp/usr/servers/defaultServer/PortalServer/wcm/ilwwcm/system/export&skipScheduleActions=false&renameConflict=false&importLibrary=Site+Builder+Template+Library
```