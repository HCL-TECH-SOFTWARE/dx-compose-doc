# WCM modules



This topic explains how to start Web Content Manager (WCM) modules and import or export WCM libraries in DX Compose.

Use a file transfer utility endpoint to upload and download WCM library files in dynamic subdirectories under a specified root directory on the server. For examples of using dxFileTransfer, see the export and import sections.
## Exporting WCM Libraries

When running Digital Experience (DX) Core on WebSphere Application Server (WAS), WCM modules such as workflow checker, importing or exporting libraries, member fixer, and others would be triggered through the ConfigEngine as documented in [Exporting and importing web content libraries](https://opensource.hcltechsw.com/digital-experience/latest/manage_content/wcm_configuration/wcm_adm_tools/wcmlibrary_export/index.html){target="_blank"}.

In DX Compose, you can start WCM modules using HTTP -- through a browser, postman, or other tools. For example, the previous command in Core on WAS was:

```
./ConfigEngine.sh export-wcm-data -DWasPassword=password -DPortalAdminPwd=password -Dexport.directory=/opt/HCL/wp_profile/export -Dexport.libraryname="Web Content"
```

For DX Compose, use the following steps to export a WCM library:

1. Use the dxFileTransfer endpoint to create a subdirectory on the server to contain the exported WCM library files.

!!! note
	The dxFileTransfer endpoint uses a base root transfer directory:
	`/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/`

- Format: `curl -u <admin>:<password> -X POST "https://<hostname:port>/wps/dxFileTransfer/dft?action=createDir&subDirectory=<subdirectory-under-the-root-xfer-dir>"`

- Example: `curl -u myAdmin:myPassword -X POST "https://myserver.hcl.com:443/wps/dxFileTransfer/dft?action=createDir&subDirectory=library_export"`

2. Run the WCM data module export URL. You must log in first to HCL DX or WCM in the same browser before running the command.

```
https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=export&exportLibrary=Web+Content&output.dir=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/library_export
```

!!! note
	The browser command might time out for long-running calls. It is recommended to connect to the container and run `wget` or `curl` with the URL after logging in.

3. Use the dxFileTransfer endpoint to download the exported WCM library files as a ZIP archive.

- Format: `curl -u <admin>:<password> -o ./<filename>.zip "https://<hostname:port>/wps/dxFileTransfer/dft?action=download&subDirectory=<subdirectory-under-the-root-xfer-dir>&file="`
- Example: `curl -u myAdmin:myPassword -o ./wcm_library_export.zip "https://myserver.hcl.com:443/wps/dxFileTransfer/dft?action=download&subDirectory=library_export&file="`

!!! note
	When `action=download` is used with an empty `file` parameter, dxFileTransfer zips the entire subdirectory and returns it as a download.

## Importing WCM libraries

Use the following steps to import a WCM library:

1. Use the dxFileTransfer endpoint to upload the WCM library export ZIP file to the server and extract it into an import subdirectory.

!!! note
	The dxFileTransfer endpoint uses a base root transfer directory:
	`/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/`

- Format: `curl -u <admin>:<password> -X POST -F "file=@/<zip-file-path>" "https://<hostname:port>/wps/dxFileTransfer/dft?action=upload&unzip=true&deleteZip=true&subDirectory=<subdirectory-under-the-root-xfer-dir>&file=<zip-file-name>"`
- Example: `curl -u myAdmin:myPassword -X POST -F "file=@/local/path/testLibrary.zip" "https://myserver.hcl.com:443/wps/dxFileTransfer/dft?action=upload&unzip=true&deleteZip=true&subDirectory=library_import&file=/local/path/testLibrary.zip"`

!!! note
	When `unzip=true` is used, dxFileTransfer extracts the uploaded ZIP into a directory named after the ZIP file without the `.zip` extension. In this example, the extracted directory is `/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/library_import/testLibrary`.

2. Run the WCM data module import URL using the extracted directory path.

```
https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import&input.dir=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/library_import/testLibrary
```

!!! note
	You must log in first to HCL DX or WCM in the same browser before running the command.
