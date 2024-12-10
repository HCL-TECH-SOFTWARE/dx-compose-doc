# Maintenance Mode

The HCL Digital Experience (DX) Compose Helm charts provide the capability to start application containers in a maintenance mode. This can be useful to debug issues that occur during the containers lifecycle, especially during the startup phase.

## Effects

The applications with maintenance mode enabled experience the following effects:

- The application containers within the Pods always remain `ready` and `live`, regardless of the actual application status.
- The startup routine of the application is skipped, and the container does not not execute its main entrypoint routines.
- The application itself is not started, resulting in the container to be idle until manual intervention.

These effects in the applications ensure that:

- Kubernetes always allows for traffic routing into the affected application containers because the `ready` probe is always true.
- Kubernetes does not restart Pods due to containers not being `live`.

The affected application does not start without manual intervention. Enabling maintenance mode impacts application availability for end-users.

Note that depending applications are affected too, because they cannot communicate with the application in maintenance mode until you either manually start it or turn off maintenance mode again.

## Configuration

In your `custom-values.yaml`, you can define the state of the maintenance mode on a per application basis. This allows you to limit the scope of your actions.

Adjust the `maintenanceMode` section accordingly.

Sample configuration:

```yaml
# Allows to start a Pod and its containers in maintenance mode.
# Pods will not perform a regular execute of the application but will remain idle
# This allows for debugging inside the containers if required, e.g. if configuration fixes are required
maintenanceMode:
    contentComposer: false
    # Enabling maintenance mode for WebEngine
    webEngine: true
    damPluginGoogleVision: false
    digitalAssetManagement: false
    imageProcessor: false
    openLdap: false
    persistenceConnectionPool: false
    persistenceNode: false
    remoteSearch: false
    ringApi: false
    runtimeController: false
    haproxy: false
    licenseManager: false
    damPluginKaltura: false
```

You then need to apply the changes by using `helm upgrade`:

```sh
# Using helm upgrade to apply the changes
# Adjust release name, reference to the helm charts and path to your custom-values.yaml accordingly
helm upgrade -n <namespace> <release-name> -f custom-values.yaml ./hcl-dx-deployment.tgz
```

After running the helm command, an explicit mention of your maintenance mode changes appears in the command response:

```sh
# Using helm upgrade to apply the changes
# Adjust release name, reference to the helm charts and path to your custom-values.yaml accordingly
helm upgrade -n <namespace> <release-name> -f custom-values.yaml ./hcl-dx-deployment.tgz

# Release "dx-deployment" has been upgraded. Happy Helming!
# NAME: dx-deployment
# LAST DEPLOYED: Fri Dec  6 17:10:17 2024
# NAMESPACE: dxns
# STATUS: deployed
# REVISION: 2
# TEST SUITE: None
# NOTES:
# Installation of HCL DX 95_CF224 done.

# See https://opensource.hcltechsw.com/digital-experience/latest/platform/kubernetes/overview/ for further information.
# ATTENTION: Maintenance mode is enabled for Pods: webEngine
```

If you check the logs of the affected application, there is also a message regarding the maintenance mode:

```sh
# Checking the logs of a Pod using kubectl
# Please adjust namespace and pod name to match your deployment
kubectl logs -n <namespace> <release-name>-web-engine-0 -c web-engine

# Deployment type is: helm
# Maintenance mode is: true
# Listening for SIGTERM
# Maintenance mode is enabled. This mode solely starts the container without any processes within it.
```

If you come from a state where the application that you want to set into maintenance mode is in an unhealthy state, you may need to delete the corresponding Pod for the changes to take effect. This is because Kubernetes does not apply a new configuration to Pods of a StatefulSet until the previous configuration has successfully started.

In case you need to delete a Pod that is still in a broken state even though you have enabled the maintenance mode, use the following command as reference:

```sh
# Delete the corresponding Pod using kubectl
# Please adjust namespace and pod name to match your deployment

kubectl delete pod -n <namespace> <release-name>-web-engine-0
```

## Usage with WebEngine

The DX WebEngine application performs certain actions during its regular startup routine. These actions are not executed when maintenance mode is enabled.
In order to start the DX WebEngine JVM in maintenance mode, you must perform the following actions:

To be done.