# Enabling and disabling IQ

[IQ](https://help.hcl-software.com/digital-experience/9.5/latest/build_sites/iq/){target="_blank"} is an AI-powered intelligent assistant integrated into HCL Digital Experience (DX) that provides real-time, context-aware assistance through a conversational interface. IQ is powered by the Model Context Protocol (MCP) and communicates with the backend service over WebSocket (JSON-RPC 2.0). To enable IQ in DX Compose, you must configure the `networking.dxIqService` parameter in the HCL DX Deployment Helm chart.

## Prerequisites

Before enabling IQ in DX Compose, ensure the following:

- The IQ backend service (`hcl-dx-iq` Helm chart) is deployed in your Kubernetes cluster and the `dx-iq-integrator` service is running. Contact your HCL DX deployment team or HCL Support for assistance with obtaining and deploying the IQ Helm chart.
- Network connectivity is available between DX Compose (WebEngine) pods and the IQ backend service.
- WebSocket connections are not blocked by firewalls or proxies.

## IQ configuration

Refer to the following sample snippet for configuring the DX Compose server to enable IQ:

```yaml
networking:
  # Set the IQ integrator service name to enable IQ
  dxIqService: "dx-iq-integrator"
```

Set the value of the key `dxIqService` to the Kubernetes service name of your IQ integrator deployment to enable IQ. To disable IQ, set the value to an empty string (`""`):

```yaml
networking:
  dxIqService: ""
```

!!! note
    The service name is typically `<release-name>-integrator` based on your `hcl-dx-iq` Helm chart release. For example, if your release name is `dx-iq`, the service name is `dx-iq-integrator`.

## Validation

After updating the `values.yaml` file, perform the following actions:

- If running the server for the first time, refer to [Installing WebEngine](../../install/kubernetes_deployment/install.md).
- If upgrading previous configurations, refer to [Upgrading the Helm deployment](../working_with_compose/helm_upgrade_values.md).

## Access

Once IQ is enabled, you will see the following options in the DX user interface:

- A **sparkle icon** in the toolbar on pages where the Panel view is compatible with the page layout.
- A **Floating Action Button (FAB)** on pages where the Panel view would affect the page layout.

For detailed information on accessing and using IQ, refer to the [IQ documentation](https://help.hcl-software.com/digital-experience/9.5/latest/build_sites/iq/){target="_blank"}.
