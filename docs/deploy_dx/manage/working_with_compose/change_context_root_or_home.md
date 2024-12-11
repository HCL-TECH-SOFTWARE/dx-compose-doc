---
id: change-context-root-or-home
title: Changing the context root or home URL for DX WebEngine
---

This topic provides the name and proper usage of the Linux bash script used to change either the context root (for example, wps) or the home URL (for example, portal in "wps/portal" or myportal in "/wps/myportal") of DX WebEngine .

## Changing the context root

To change the context root, use the following script:

```sh
/opt/openliberty/wlp/usr/svrcfg/bin/changeContextRoot.sh
```

### Script options

The following are the required and optional parameters to this shell script:

```
-h Show this help message
-s The WebEngine server name (for example, defaultServer)
-n New Context Root: Specify the new context root
-l DX WebEngine Location: Specify the directory containing your DX Compose WebEngine installation (for example, /opt/openliberty). Note that it should contain a directory called wlp
-u WebEngine Admin User ID: Used for XMLAccess
-P WebEngine Admin User Password: Used for XMLAccess
-x Do not run any XMLAccess (used for secondary pods in Kubernetes)
```

The `-n` parameter is optional. However, by not specifying it, you are requesting that the new context root is null.

If the `-x` parameter is present, which implies that the script will not run XMLAccess, then the `-u` and `-P` parameters (which are used for XMLAccess) are not required and will be ignored if present. The `-x` parameter is supplied because all nodes in Kubernetes other than the primary should not be doing XMLAccess.

The script does an XMLAccess export of the Themes and Skins to extract the context root contained therein. If the context root specified by the `-n` parameter is the same as the context root extracted from the XMLAccess export, no new XMLAccess for the Portlet update and the Theme/Skins update will take place because the context root is already correct.

Except for the `-h` and `-x` parameters, all other options are required.

### Sample use of script

This example changes the context root of the WebEngine server from "wps" to "newRoot":

```
/opt/openliberty/wlp/usr/svrcfg/bin/changeContextRoot.sh -n newRoot -l /opt/openliberty -s defaultServer -u wpsadmin -P wpsadmin
```

This example changes a WebEngine server context root of "wps" to having no context root at all:

```
/opt/openliberty/wlp/usr/svrcfg/bin/changeContextRoot.sh -l /opt/openliberty -s defaultServer -u wpsadmin -P wpsadmin
```

In this case, you can access the portal as:

```
localhost/portal
```

## Changing the home URL

Follow the steps in this section in case you want to use a string like "newHome" and "mynewHome" in the home URL, as opposed to "portal" and "myportal" /wps/portal and /wps/myportal.

To change the home URL, use the script "changeHomeURLs.sh" located in Docker or Kubernetes at

```
/opt/openliberty/wlp/usr/svrcfg/bin/changeHomeURLs.sh
```

### Script options

The parameters for this script (except of `-h`) are all required and include:

```
-h Show this help message
-s The WebEngine server name (for example, defaultServer)
-a The new anonymous Home url
-A The new authenticated Home url
-l DX WebEngine server Location: Specify the directory containing your DX Compose WebEngine installation (for example, /opt/openliberty). Note that it should contain a directory called wlp.
```

### Sample use of script

This example changes the anonymous home to "newHome" and the authenticated home to "mynewHome":

```
/opt/openliberty/wlp/usr/svrcfg/bin/changeHomeURLs.sh -l /opt/openliberty -s defaultServer -a newHome -A mynewHome
```

In this case, you can access the Portal as:

```
localhost/wps/newHome
```

or

```
localhost/wps/mynewHome
```