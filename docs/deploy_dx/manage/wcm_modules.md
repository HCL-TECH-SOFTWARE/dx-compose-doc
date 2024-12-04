# WCM Modules

When running Core on WAS WCM Modules like workflow checker, importing or exporting libraries, member fixer and others would be triggered via ConfigEngine as e.g. documented [here](https://opensource.hcltechsw.com/digital-experience/latest/manage_content/wcm_configuration/wcm_adm_tools/wcmlibrary_export/index.html).

## General Approach

The modules can be triggered via HTTP - e.g. via browser or postman or other tools at this time. For instance when the previous command in Core on WAS was:
```
./ConfigEngine.sh export-wcm-data -DWasPassword=password -DPortalAdminPwd=password -Dexport.directory=/opt/HCL/wp_profile/export -Dexport.libraryname="Web Content"
```

The new command will be:
```
https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=export&exportLibrary=Web+Content&output.dir=%2Fopt%2FHCL%2Fwp_profile%2Fexport
```

It requires the user to be logged in - you can login first to DX in the same browser. Or if the login is displayed for WCM login.

Since the browser command might time out for long running calls it can be beneficial to connect to the container and running wget or curl with the URL (after triggering a login).

## Importing WCM Libraries

Ensure that the file is copied into the webEngine container - for instance /opt/openliberty/test. 

The command would look like the following:
```
https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import&input.dir="/opt/openliberty/test"&skipScheduleActions=false&renameConflict=false&importLibrary=importLibrary
```