# Install

Follow [Installing Commands to Deploy](helm_install_commands.md).

For WebEngine-related configurations, use the sample values file provided inside the Helm chart. The sample values file is located in the unpacked chart directory under `values-samples/webEngine/webEngine-sample.yaml`. This file disables Core and enables the WebEngine container, and serves as a starting point for a custom WebEngine configuration.

To install the Helm chart with the sample values file, add it as an additional argument to the `helm install` command. For example:

```sh
helm install -n <NAMESPACE> <RELEASE-NAME> path/to/the/dx-chart -f <your-existing-custom-values-file> -f webEngine-sample.yaml
```
