# WCM modules

This topic provides the commands for starting Web Content Manager (WCM) modules and importing WCM libraries in DX Compose.

When running Digital Experience (DX) Core on WebSphere Application Server (WAS), WCM modules such as workflow checker, importing or exporting libraries, member fixer, and others would be triggered through the ConfigEngine as documented in [Exporting and importing web content libraries](https://opensource.hcltechsw.com/digital-experience/latest/manage_content/wcm_configuration/wcm_adm_tools/wcmlibrary_export/index.html){target="_blank"}.

In DX Compose, you can start WCM modules using HTTP -- through a browser, postman, or other tools. For example, the previous command in Core on WAS was:

```
./ConfigEngine.sh export-wcm-data -DWasPassword=password -DPortalAdminPwd=password -Dexport.directory=/opt/HCL/wp_profile/export -Dexport.libraryname="Web Content"
```

For DX Compose, the new command is:

```
https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=export&exportLibrary=Web+Content&output.dir=%2Fopt%2FHCL%2Fwp_profile%2Fexport
```

You must log in first to HCL DX or WCM in the same browser before running the command.

The browser command might time out for long-running calls. It is recommended to connect to the container and run `wget` or `curl` with the URL after logging in.

## Importing WCM libraries

To import WCM libraries, ensure that the file is copied into the WebEngine container (for example, `/opt/openliberty/test`). 

The command would be similar to the following:

```
https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import&input.dir="/opt/openliberty/test"&skipScheduleActions=false&renameConflict=false&importLibrary=importLibrary
```