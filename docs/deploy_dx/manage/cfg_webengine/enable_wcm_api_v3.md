# How to enable WCM API v3

This guide explains how to enable the Web Content Manager (WCM) REST API v3 in your HCL Digital Experience Compose deployment.

## Overview

WCM API v3 is a modern REST API that provides streamlined access to WCM content, libraries, site areas, and other resources. It is controlled by a feature toggle and can be enabled via Helm configuration.

## Prerequisites

- HCL DX Compose CF224 or later
- Helm-based deployment on Kubernetes
- Access to modify Helm values
- WebEngine container running

## Enabling via Helm

### Option 1: Using values.yaml

Add or update the following configuration in your `values.yaml` file:

```yaml
incubator:
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

### Option 2: Using --set Flag

Enable WCM API v3 directly via the command line during Helm install or upgrade:

```bash
helm upgrade dx-deployment hcl/hcl-dx-deployment \
  --set incubator.configuration.webEngine.wcmApiV3Enabled=true \
  --namespace dx
```

### Option 3: Combining with Existing Configuration

If you have other configuration values, combine them:

```bash
helm upgrade dx-deployment hcl/hcl-dx-deployment \
  --set incubator.configuration.webEngine.wcmApiV3Enabled=true \
  --set configuration.webEngine.db2HadrMaxRetries=20 \
  -f values.yaml \
  --namespace dx
```

## Verifying the Installation

After enabling WCM API v3, verify that it is running correctly.

### 1. Check Pod Status

Ensure the WebEngine pod is running:

```bash
kubectl get pods -n dx | grep webengine
```

Expected output:
```
dx-deployment-webengine-0   1/1   Running   0   5m
```

### 2. Check Health Endpoint

Test the health endpoint:

```bash
# Get the service URL
DX_HOST=$(kubectl get svc -n dx dx-deployment-webengine -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

# Check health
curl -k https://$DX_HOST/dx/api/wcm/v3/health
```

Expected response:
```json
{
  "status": "UP",
  "checks": [
    {
      "name": "wcm-connectivity",
      "status": "UP"
    },
    {
      "name": "feature-toggle",
      "status": "UP"
    }
  }
}
```

### 3. Access API Explorer

Open your browser and navigate to the API Explorer:

```
https://your-dx-host/dx/api/wcm/v3/explorer/
```

For local development:
```
https://localhost:9443/dx/api/wcm/v3/explorer/
```

You should see the Swagger UI interface with all available WCM v3 endpoints.

### 4. Test a Simple Request

List all libraries:

```bash
curl -k -u wpsadmin:password \
  https://your-dx-host/dx/api/wcm/v3/libraries?limit=5
```

## Configuration Details

### Helm Value Reference

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `incubator.configuration.webEngine.wcmApiV3Enabled` | boolean | `false` | Master feature toggle for WCM API v3 |

### Runtime Behavior

When `wcmApiV3Enabled` is set to:

- **`true`**: WCM API v3 is enabled and all endpoints are accessible
- **`false`** (default): WCM API v3 is disabled and all endpoints return `503 Service Unavailable`

### No Server Restart Required

The feature toggle is read at runtime. However, for the Helm change to take effect, the WebEngine pod will be restarted automatically by Kubernetes.

## Accessing the API

Once enabled, the WCM API v3 is accessible at:

```
https://your-dx-host/dx/api/wcm/v3
```

### Available Endpoints

| Resource | Endpoint | Description |
|----------|----------|-------------|
| Health | `/health` | API health status |
| Categories | `/categories` | Manage WCM categories |
| Contents | `/contents` | Manage content items |
| Libraries | `/libraries` | Manage WCM libraries |
| Presentation Templates | `/presentation-templates` | Manage presentation templates |
| Search | `/search` | Search across WCM resources |
| Site Areas | `/site-areas` | Manage site areas |
| Taxonomies | `/taxonomies` | Manage taxonomies |

### API Explorer

Interactive Swagger UI:
```
https://your-dx-host/dx/api/wcm/v3/explorer/
```

### OpenAPI Specification

View the OpenAPI spec:
```bash
# JSON format
curl -k -H "Accept: application/json" \
  https://your-dx-host/dx/api/wcm/v3/openapi

# YAML format
curl -k -H "Accept: application/yaml" \
  https://your-dx-host/dx/api/wcm/v3/openapi
```

## Authentication

WCM API v3 supports two authentication methods:

### HTTP Basic Authentication

For REST clients:
```bash
curl -k -u wpsadmin:password \
  https://your-dx-host/dx/api/wcm/v3/libraries
```

### SSO (LTPA Token)

For browser-based access:
1. Log in to DX Portal first
2. The LTPA cookie will be used for authentication
3. Useful when accessing the API Explorer

## Troubleshooting

### API Returns 503 Service Unavailable

**Cause**: The WCM API v3 feature toggle is disabled.

**Solution**: Verify the Helm configuration:

```bash
helm get values dx-deployment -n dx | grep wcmApiV3Enabled
```

If not set or set to `false`, enable it:

```bash
helm upgrade dx-deployment hcl/hcl-dx-deployment \
  --set incubator.configuration.webEngine.wcmApiV3Enabled=true \
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

### Health Endpoint Returns Connection Refused

**Cause**: WebEngine service is not accessible.

**Solution**: Verify the service is running:

```bash
kubectl get svc -n dx | grep webengine
kubectl describe svc dx-deployment-webengine -n dx
```

Check that the service has endpoints:

```bash
kubectl get endpoints dx-deployment-webengine -n dx
```

### Authentication Fails with 401

**Cause**: Invalid credentials or authentication not configured.

**Solution**: Verify credentials:

```bash
# Test with default admin credentials
curl -k -u wpsadmin:wpsadmin \
  https://your-dx-host/dx/api/wcm/v3/health
```

If using custom credentials, ensure they are configured correctly in the WebEngine.

## Disabling WCM API v3

To disable WCM API v3, set the feature toggle to `false`:

```bash
helm upgrade dx-deployment hcl/hcl-dx-deployment \
  --set incubator.configuration.webEngine.wcmApiV3Enabled=false \
  --namespace dx
```

All WCM API v3 endpoints will return `503 Service Unavailable` after the WebEngine pod restarts.

## Next Steps

- Review [Getting started with WCM API v3](../wcm_rest_v3/wcm_rest_v3_starting.md) for usage examples
- Explore the [API Explorer](https://your-dx-host/dx/api/wcm/v3/explorer/) for interactive testing
- Compare [API versions](../wcm_rest_v3/wcm_rest_v3_comparison.md) to understand differences

## Related Information

- [REST service for Web Content Manager v3](../wcm_rest_v3/index.md)
- [Helm deployment configuration](../../install/kubernetes_deployment/preparation/mandatory_tasks/prepare_configuration.md)
- [WebEngine configuration](./index.md)
