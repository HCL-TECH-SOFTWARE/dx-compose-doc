# Enabling and disabling the Web Content Manager REST API v3 service

This guide explains how to enable and disable the Web Content Manager (WCM) REST API v3 service in an HCL Digital Experience (DX) Compose deployment.

## Overview

The WCM REST API v3 service provides REST API endpoints for accessing WCM content, libraries, site areas, and related resources. Enabling or disabling this configuration toggles request routing for the API endpoints within the WebEngine runtime without stopping the underlying WebEngine container service.

## Prerequisites

- HCL DX Compose CF238 or a later version is installed in the target environment.
- A Kubernetes cluster is running an active Helm deployment.
- Administrative access is available to edit and apply the Helm values.yaml configuration file.
- The WebEngine container service is running and operational.

## Enabling or disabling WCM API v3

WCM API v3 is enabled by default. To change its state:

1. Update `values.yaml` with the target boolean value:

    ```yaml
    configuration:
      webEngine:
        # WCM API v3 is enabled by default. Set to false to disable it
        # (all /dx/api/wcm/v3 endpoints return 503 until re-enabled).
        wcmApiV3Enabled: false
    ```

2. Apply the changes:

    ```bash
    helm upgrade dx-deployment hcl/hcl-dx-deployment \
      -f values.yaml \
      --namespace dx
    ```

## Troubleshooting

Refer to the troubleshooting steps for the following scenarios:

**API returns a 503 Service Unavailable error**

If the WCM API v3 feature toggle is explicitly disabled:

1. Check the current Helm configuration value:

    ```bash
    helm get values dx-deployment -n dx | grep wcmApiV3Enabled
    ```

2. Re-enable the feature toggle:

    ```bash
    helm upgrade dx-deployment hcl/hcl-dx-deployment \
      --set configuration.webEngine.wcmApiV3Enabled=true \
      --namespace dx
    ```

**API Explorer displays a 404 Not Found error**

If the WebEngine pod is not running or the API is not deployed:

1. Check the pod status and the startup logs:

    ```bash
    kubectl get pods -n dx | grep webengine
    kubectl logs -n dx dx-deployment-webengine-0 | grep "wcm.api.v3"
    ```

2. Confirm that the startup logs show that WCM API v3 loaded successfully.

**Authentication fails with a 401 Unauthorized error**

If credentials are invalid or authentication is not configured:

1. Test the credentials against the service:

    ```bash
    # Test with your admin credentials
    curl -k -u user:password \
      https://your-dx-host/dx/api/wcm/v3/libraries?limit=1
    ```

2. Confirm that the credentials are valid and have the necessary permissions to access the WCM content.

## Next step

Once the WCM API v3 service is enabled, you can start using it. For detailed information on authentication, endpoints, usage examples, and best practices, refer to [Configuring Web Content Manager REST API v3](../working_with_compose/wcm_rest_v3/configure_wcm_rest_v3.md).

???+ info "Related information"
    - [Configuring Web Content Manager REST API v3](../working_with_compose/wcm_rest_v3/configure_wcm_rest_v3.md)
    - [REST service for Web Content Manager v3](../working_with_compose/wcm_rest_v3/index.md)
    - [Helm deployment configuration](../../install/kubernetes_deployment/preparation/mandatory_tasks/prepare_configuration.md)
