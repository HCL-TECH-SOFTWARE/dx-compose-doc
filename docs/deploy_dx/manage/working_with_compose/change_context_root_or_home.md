---
id: change-context-root-or-home
title: Changing the WebEngine context root or home URI
---

HCL Digital Experience (DX) Compose consists of multiple applications and services that can be deployed. Depending on your needs, you can change the default WebEngine context root of the Uniform Resource Locator (URL) and the Uniform Resource Identifier (URI) any time after you install HCL DX Compose to better suit the requirements of your organization. Note that the default context root values are `/wps/portal` and `/wps/myportal`.

To change the WebEngine URL or URI in Kubernetes deployments, adjust the `custom-values.yaml` file used for your Helm deployment. For more information, see [Custom value files](../../install/kubernetes_deployment/preparation/mandatory_tasks/prepare_configuration.md#custom-value-files)

!!!note
    Configuration changes to Helm-based deployments using methods outside of running `helm upgrade` will not persist through image upgrades or pod restarts.

## Changing the URL context root using Helm

To change the WebEngine context root in a Helm-based deployment:

1. Update the `networking.webengine.contextRoot` value in the `custom-values.yaml` file to your desired context root.

  ```yaml
  # Networking configuration specific to webEngine
  webEngine:
    # Host of webEngine, must be specified as a FQDN
    host: ""
    # Port of webEngine
    port:
    # Setting if SSL is enabled for webEngine
    ssl: true
    # webEngine Context root, only alter if your deployment already uses a non default context route
    contextRoot: "myContextRoot"
  ```

2. Upgrade the deployment using Helm:

```sh
   helm upgrade <RELEASE_NAME> -n <NAMESPACE> -f custom-values.yaml <HELM_CHART_DIRECTORY>
```

## Changing the URI using Helm

1. Update the `networking.webengine.home` and `networking.webengine.personalizedHome` values in the `custom-values.yaml` file to your desired values.

  ```yaml
  # Networking configuration specific to webEngine
  webEngine:
    # webEngine Context root, only alter if your deployment already uses a non default context route
    contextRoot: "myContextRoot"
    # webEngine personalized home, only alter if your deployment already uses a non default personalized home
    personalizedHome: "myAuthenticatedHome"
    # webEngine home, only alter if your deployment already uses a non default home
    home: "myAnonymousHome"
  ```

2. Upgrade the deployment using Helm:

```sh
   helm upgrade <RELEASE_NAME> -n <NAMESPACE> -f custom-values.yaml <HELM_CHART_DIRECTORY>
```

## Changing the context root in People Service

The People Service Helm chart cannot automatically detect changes in the parent chart. If you have deployed HCL People Service along with DX Compose, you must adjust the `configuration.dx.portletPageContextRoot` in the People Service `custom-values.yaml` file and the `configuration.peopleservice.configuration.dx.portletPageContextRoot` in the DX Compose `custom-values.yaml` file. After updating these values, upgrade the deployment using both `custom-values.yaml` files. Refer to the following steps:

1. Update the `configuration.dx.portletPageContextRoot` in the People Service `custom-values.yaml` file.

  ```yaml
  # Application configuration
  configuration:
    # Authencation configuration for DX integration
    dx:
      # -- (string) Context root for the People Service portlet page
      # @section -- DX configuration
      portletPageContextRoot: "/myContextRoot/myAuthenticatedHome/Practitioner/PeopleService"
  ```

2. Update the `configuration.peopleservice.configuration.dx.portletPageContextRoot` in the DX Compose `custom-values.yaml` file.

  ```yaml
  # Application configuration
  configuration:
    # Configuration for the peopleservice sub-chart.
    # Set `enabled` to `true` to enable the peopleservice sub-chart, or `false` to disable it.
    peopleservice:
    enabled: true
    # Application configuration
    configuration:
      # Integration configuration
      integration:
      # Indicates if DX integration is enabled
      dx: true
      # Integration specific configuration for DX
      dx:
      # Context root for the People Service portlet page
      portletPageContextRoot: "/myContextRoot/myAuthenticatedHome/Practitioner/PeopleService"
  ```

3. Upgrade the deployment using Helm:

```sh
   helm upgrade <RELEASE_NAME> -n <NAMESPACE> -f dx-compose-custom-values.yaml -f peopleservice-custom-values.yaml <HELM_CHART_DIRECTORY>
```

## Changing the context root in a non-Helm deployment

The following instructions provide the name and proper usage of the Linux bash script used to change either the context root (for example, `wps`) or the home URL (for example, `portal` in `wps/portal` or `myportal` in `/wps/myportal`) of DX WebEngine in a non-Helm deployment.

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

This example changes the context root of the WebEngine server from `wps` to `newRoot`:

```
/opt/openliberty/wlp/usr/svrcfg/bin/changeContextRoot.sh -n newRoot -l /opt/openliberty -s defaultServer -u wpsadmin -P wpsadmin
```

This example changes a WebEngine server context root of `wps` to having no context root at all:

```
/opt/openliberty/wlp/usr/svrcfg/bin/changeContextRoot.sh -l /opt/openliberty -s defaultServer -u wpsadmin -P wpsadmin
```

In this case, you can access the portal as:

```
localhost/portal
```

## Changing the home URL in a non-Helm deployment

Follow the steps in this section in case you want to use a string like `newHome` and `mynewHome` in the home URL, as opposed to `portal` and `myportal` in `/wps/portal` and `/wps/myportal`.

To change the home URL, use the script `changeHomeURLs.sh` located in Docker or Kubernetes at:

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

This example changes the anonymous home to `newHome` and the authenticated home to `mynewHome`:

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