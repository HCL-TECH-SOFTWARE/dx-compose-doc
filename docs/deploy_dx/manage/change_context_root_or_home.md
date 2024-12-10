---
id: change-context-root-or-home
title: Changing the Context Root or Home URL for DX WebEngine
---

## Overview
This document shows the name and proper usage of the linux bash script used to change either the context root (e.g. wps) of DX WebEngine or the "home" (e.g portal in "wps/portal" or myportal in /wps/myportal).

## Changing Context Root
To change the context root, you use the script 
```
/opt/openliberty/wlp/usr/svrcfg/bin/changeContextRoot.sh
```
### Options
There are several required and a couple of optional parameters to this shell script:
```
-h Show this help message
-s The WebEngine server name (e.g. defaultServer)
-n New Context Root: Specify the new context root
-l DX WebEngine Location: Specify the directory containing your DX Compose WebEngine installation (e.g. /opt/openliberty). Note that it should contain a directory called wlp
-u WebEngine Admin User ID: Used for XMLAccess
-P WebEngine Admin User Password: Used for XMLAccess
-x Do not run any XMLAccess (used for secondary+ pods in kubernetes)
```

The "-n" parameters is optional. However, by not specifying it, you are requesting that the new context root is null.

If the "-x" parameter is present, which implies that the script will do no XMLAccess, then the "-u" and "-P" parameters (which are used for XMLAccess) are not required and will be ignored if present. The "-x" parameter is supplied because all nodes in Kubernetes other than the primary should NOT be doing XMLAccess.

The script will do an XMLAccess export of the Themes and Skins to extract the context root contain therein. If the context root specified by "-n" is the same as the context root extracted from the XMLAccess export, no new XMLAccess for either Portlet update nor Theme/Skins update will take place as the context root is already correct.

Except for the "-h" help and "-x" parameter, all the others are required as noted.

### Example Use of Script
This example changes the context root of the WebEngine server from "wps" to "newRoot".

```
/opt/openliberty/wlp/usr/svrcfg/bin/changeContextRoot.sh -n newRoot -l /opt/openliberty -s defaultServer -u wpsadmin -P wpsadmin
```
This example changes a WebEngine server context root of "wps" to having no context root at all.
```
/opt/openliberty/wlp/usr/svrcfg/bin/changeContextRoot.sh -l /opt/openliberty -s defaultServer -u wpsadmin -P wpsadmin
```
In this case, one might access the portal as
```
localhost/portal
```
## Changing Home Name/URL
In case you want to use a string like "newHome" and "mynewHome" as opposed to "portal" and "myportal" in the URL /wps/portal and /wps/myportal.

To achieve this goal, use the script "changeHomeURLs.sh" located in docker/kubernetes at
```
/opt/openliberty/wlp/usr/svrcfg/bin/changeHomeURLs.sh
```
### Options
The parameters for this script (with the exception of "help") are all required and include:
```
-h Show this help message
-s The WebEngine server name (e.g. defaultServer)
-a The new anonymous Home url
-A The new authenticated Home url
-l DX WebEngine server Location: Specify the directory containing your DX Compose WebEngine installation (e.g. /opt/openliberty). Note that it should contain a directory called wlp
```
### Example Use of Script
This example changes the anonymous home to "newHome" and the authenticated home to "mynewHome".
```
/opt/openliberty/wlp/usr/svrcfg/bin/changeHomeURLs.sh -l /opt/openliberty -s defaultServer -a newHome -A mynewHome
```
In this case, one would now access the Portal as
```
localhost/wps/newHome
```
or
```
localhost/wps/mynewHome
```

