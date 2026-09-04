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

To re-enable WCM API v3 after disabling it, set `wcmApiV3Enabled: true` in your `values.yaml` and run the same `helm upgrade` command.





## Troubleshooting

### API returns 503 service unavailable

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

### API explorer shows 404 not found

**Cause**: WebEngine pod is not running or the API is not deployed.

**Solution**: Check pod status:

```bash
kubectl get pods -n dx | grep webengine
kubectl logs -n dx dx-deployment-webengine-0 | grep "wcm.api.v3"
```

Look for startup messages indicating WCM API v3 is loaded.

### Authentication fails with 401

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

## Related information

- [REST service for Web Content Manager v3](../working_with_compose/wcm_rest_v3/index.md)
- [Helm deployment configuration](../../install/kubernetes_deployment/preparation/mandatory_tasks/prepare_configuration.md)
- [Configuring DX Compose](./index.md)
