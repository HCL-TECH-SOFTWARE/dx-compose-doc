# Enabling and disabling WCM API v3

This guide explains how to enable and disable the Web Content Manager (WCM) REST API v3 in your HCL Digital Experience Compose deployment.

## Overview

WCM API v3 is a modern REST API that provides streamlined access to WCM content, libraries, site areas, and other resources. **Starting with CF238, WCM API v3 is enabled by default.** You can disable it if needed using Helm configuration.

## Prerequisites

- HCL DX Compose CF238 or later
- Helm-based deployment on Kubernetes
- Access to modify Helm values
- WebEngine container running

## Disabling WCM API v3

WCM API v3 is enabled by default in CF238 and later. If you need to disable it, update your `values.yaml` file:

```yaml
configuration:
  webEngine:
    # WCM API v3 is enabled by default. Set to false to disable it
    # (all /dx/api/wcm/v3 endpoints return 503 until re-enabled).
    wcmApiV3Enabled: false
```

Then apply the changes:

```bash
helm upgrade dx-deployment hcl/hcl-dx-deployment \
  -f values.yaml \
  --namespace dx
```

## Re-enabling WCM API v3

If you previously disabled WCM API v3 and want to re-enable it, set the value to `true`:

```yaml
configuration:
  webEngine:
    wcmApiV3Enabled: true
```

Then apply the changes:

```bash
helm upgrade dx-deployment hcl/hcl-dx-deployment \
  -f values.yaml \
  --namespace dx
```

## Verifying the Installation

After enabling WCM API v3, verify that it is running correctly.

### Check Pod Status

Ensure the WebEngine pod is running:

```bash
kubectl get pods -n dx | grep webengine
```

Expected output:
```
dx-deployment-webengine-0   1/1   Running   0   5m
```

### Access API Explorer

Open your browser and navigate to the API Explorer:

```
https://your-dx-host/dx/api/wcm/v3/explorer/
```

You should see the Swagger UI interface with all available WCM v3 endpoints.

### Test a Simple Request

List all libraries:

```bash
curl -k -u user:password \
  https://your-dx-host/dx/api/wcm/v3/libraries?limit=5
```

## Configuration Details

### Helm Value Reference

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `configuration.webEngine.wcmApiV3Enabled` | boolean | `true` | Feature toggle for WCM API v3 (enabled by default in CF238+) |

### Runtime Behavior

When `wcmApiV3Enabled` is set to:

- **`true`** (default): WCM API v3 is enabled and all endpoints are accessible
- **`false`**: WCM API v3 is disabled and all endpoints return `503 Service Unavailable`

### No Server Restart Required

The feature toggle is read at runtime. However, for the Helm change to take effect, the WebEngine pod will be restarted automatically by Kubernetes.



## Troubleshooting

### API Returns 503 Service Unavailable

**Cause**: The WCM API v3 feature toggle has been explicitly disabled.

**Solution**: Verify the Helm configuration:

```bash
helm get values dx-deployment -n dx | grep wcmApiV3Enabled
```

If set to `false`, re-enable it by setting it to `true` (or removing the override to use the default):

```bash
helm upgrade dx-deployment hcl/hcl-dx-deployment \
  --set configuration.webEngine.wcmApiV3Enabled=true \
  --namespace dx
```

### API Explorer Shows 404 Not Found

**Cause**: WebEngine pod is not running or the API is not deployed.

**Solution**: Check pod status:

```bash
kubectl get pods -n dx | grep webengine
kubectl logs -n dx dx-deployment-webengine-0 | grep "wcm.api.v3"
```

Look for startup messages indicating WCM API v3 is loaded.

### Authentication Fails with 401

**Cause**: Invalid credentials or authentication not configured.

**Solution**: Verify credentials by testing with a simple API call:

```bash
# Test with your admin credentials
curl -k -u user:password \
  https://your-dx-host/dx/api/wcm/v3/libraries?limit=1
```

Ensure your credentials are valid and have the necessary permissions to access WCM content.



## Using the API

Once WCM API v3 is enabled, you can start using it. For detailed information on authentication, endpoints, usage examples, and best practices, see [Getting started with the REST service for Web Content Manager v3](../working_with_compose/wcm_rest_v3/wcm_rest_v3_starting.md).

## Related Information

- [REST service for Web Content Manager v3](../working_with_compose/wcm_rest_v3/index.md)
- [Helm deployment configuration](../../install/kubernetes_deployment/preparation/mandatory_tasks/prepare_configuration.md)
- [Configuring DX Compose](./index.md)
