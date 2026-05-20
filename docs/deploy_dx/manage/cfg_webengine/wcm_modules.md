# WCM modules

This topic explains how to start Web Content Manager (WCM) modules and import or export WCM libraries in Digital Experience (DX) Compose.

Use a file transfer utility endpoint to upload and download WCM library files in dynamic subdirectories under a specified root directory on the server.

## Starting WCM modules

When you run DX Core on WebSphere Application Server (WAS), When you run DX Core on WebSphere Application Server (WAS), WCM modules such as the workflow checker, library import and export, and the member fixer [trigger through the ConfigEngine](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_configuration/wcm_adm_tools/wcmlibrary_export/){target="_blank"}.

In DX Compose, you can start WCM modules using HTTP through a browser, Postman, or other tools. For example, the previous WAS command in Core was:

```bash
./ConfigEngine.sh export-wcm-data -DWasPassword=password -DPortalAdminPwd=password -Dexport.directory=/opt/HCL/wp_profile/export -Dexport.libraryname="Web Content"
```

## Exporting WCM libraries

To export a WCM library in DX Compose, follow these steps:

1. Use the `dxFileTransfer` endpoint to create a subdirectory on the server to store the exported WCM library files. The `dxFileTransfer` endpoint uses `/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/` as the base root transfer directory.

    - **Syntax:**

        ```bash
        curl -u <admin>:<password> -X POST "https://<hostname:port>/<context-root>/dxFileTransfer/dft?action=createDir&subDirectory=<subdirectory-under-the-root-xfer-dir>"
        ```

    - **Example:**

        ```bash
        curl -u myAdmin:myPassword -X POST "https://myserver.hcl.com:443/wps/dxFileTransfer/dft?action=createDir&subDirectory=library_export"
        ```

2. Sign in to HCL DX or WCM in your browser, and then run the WCM data module export URL.

    ```http
    https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=export&exportLibrary=Web+Content&output.dir=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/library_export
    ```

    If the browser request times out during a long-running call, sign in and then connect to the container to run `wget` or `curl` with the URL.

3. Use the `dxFileTransfer` endpoint to download the exported WCM library files as a ZIP archive.

    - **Syntax:**

        ```bash
        curl -u <admin>:<password> -o ./<filename>.zip "https://<hostname:port>/<context-root>/dxFileTransfer/dft?action=download&subDirectory=<subdirectory-under-the-root-xfer-dir>&file="
        ```

    - **Example:**

        ```bash
        curl -u myAdmin:myPassword -o ./wcm_library_export.zip "https://myserver.hcl.com:443/wps/dxFileTransfer/dft?action=download&subDirectory=library_export&file="
        ```

    !!! note
        When you use `action=download` with an empty file parameter, `dxFileTransfer` compresses the entire subdirectory into a ZIP archive and downloads it. <!--confirm accuracy-->

## Importing WCM libraries

To import a WCM library, follow these steps:

1. Use the `dxFileTransfer` endpoint to upload the expoted WCM library ZIP file to the server and extract it into an import subdirectory.

    The `dxFileTransfer` endpoint uses the following base root transfer directory: `/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/`

    - **Syntax:**

        ```bash
        curl -u <admin>:<password> -X POST -F "file=@/<zip-file-path>" "https://<hostname:port>/<context-root>/dxFileTransfer/dft?action=upload&unzip=true&deleteZip=true&subDirectory=<subdirectory-under-the-root-xfer-dir>&file=<zip-file-name>"
        ```

    - **Example:**

        ```bash
        curl -u myAdmin:myPassword -X POST -F "file=@/local/path/testLibrary.zip" "https://myserver.hcl.com:443/wps/dxFileTransfer/dft?action=upload&unzip=true&deleteZip=true&subDirectory=library_import&file=/local/path/testLibrary.zip"
        ```

    When you set `unzip=true`, `dxFileTransfer` extracts the uploaded ZIP file into a directory named after the ZIP file (without the `.zip` extension). In this example, the extracted directory is `/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/library_import/testLibrary`.

2. Run the WCM data module import URL using the extracted directory path.

    ```http
    https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import&input.dir=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/library_import/testLibrary
    ```

!!! note
    Sign in to HCL DX or WCM in your browser before you run the command.
