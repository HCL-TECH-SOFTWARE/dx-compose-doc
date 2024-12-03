# Install

Follow [Installing Commands to Deploy](https://opensource.hcltechsw.com/digital-experience/latest/deployment/install/container/helm_deployment/helm_install_commands/).

For WebEngine related configurations, use the sample values file provided inside the chart. The sample values file is located in the unpacked chart directory under `values-samples/webEngine/webEngine-sample.yaml`. It disables Core and enables WebEngine and serves as a starting point for a custom WebEngine configuration.

To install the chart with the sample values file, pass it as an additional argument to the `helm install` command:

```sh
helm install -n <NAMESPACE> <RELEASE-NAME> path/to/the/dx-chart -f <your-existing-custom-values-file> -f webEngine-sample.yaml
```
