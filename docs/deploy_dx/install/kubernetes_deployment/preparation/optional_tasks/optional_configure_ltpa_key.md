# LTPA Configuration

## Overview

LTPA (Lightweight Third Party Authentication) enables single sign-on (SSO) capabilities for the WebEngine component. Unlike Core which supports both inline values and custom secrets, WebEngine **exclusively uses custom Kubernetes secrets** for LTPA configuration.

## Configuration Method

WebEngine LTPA configuration uses a **custom secret reference** approach:

```yaml
configuration:
  webEngine:
    ltpa:
      customLtpaSecret: "my-webengine-ltpa-secret"
```

**Note:** WebEngine does not support inline LTPA values configuration. You must use a pre-created Kubernetes secret.

## Generating LTPA Keys

To generate LTPA keys for WebEngine, you can use the OpenLiberty `securityUtility` command:

1. Exec into the WebEngine pod:
   ```bash
   kubectl -n <namespace> exec -it pod/<release>-web-engine-0 -- /bin/bash
   ```

2. Generate an LTPA key using the securityUtility command:
   ```bash
   /opt/openliberty/wlp/bin/securityUtility createLTPAKeys --file=/opt/hcl/ltpa.keys --password=<your-password>
   ```

3. Print the LTPA key file content:
   ```bash
   cat /opt/hcl/ltpa.keys
   ```

4. Exit the pod:
   ```bash
   exit
   ```

5. Save the LTPA key file content for creating the secret in the next section

## Secret Structure

The custom LTPA secret must contain these data keys:

| Key | Description | Format |
|-----|-------------|--------|
| `ltpa.keys` | LTPA keys file content | Base64-encoded binary data |
| `password` | Password for LTPA keys | Plain text string |

### Creating a Custom LTPA Secret for WebEngine

#### Using kubectl

```bash
kubectl create secret generic my-webengine-ltpa-secret \
  --from-file=ltpa.keys=/path/to/ltpa.keys \
  --from-literal=password='your-ltpa-password' \
  -n <your-namespace>
```

#### Using a YAML manifest

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-webengine-ltpa-secret
  namespace: dx-namespace
type: Opaque
stringData:
  password: "your-ltpa-password"
data:
  ltpa.keys: <base64-encoded-binary-content>
```

## Configuration Examples

### Example 1: Basic WebEngine LTPA Setup

```yaml
applications:
  webEngine: true
  core: false

configuration:
  webEngine:
    ltpa:
      customLtpaSecret: "webengine-ltpa"
```

**Pre-requisite:** Create the secret

```bash
kubectl create secret generic webengine-ltpa \
  --from-file=ltpa.keys=./ltpa.keys \
  --from-literal=password='myLtpaPassword' \
  -n production
```

### Example 2: WebEngine with Core LTPA Sharing

Synchronize WebEngine LTPA with Core:

```yaml
applications:
  core: true
  webEngine: true

configuration:
  core:
    ltpa:
      enabled: true
      customLtpaSecret: "dx-ltpa-credentials"
  webEngine:
    ltpa:
      customLtpaSecret: "dx-ltpa-credentials"  # Use same secret
```

**Note:** Both must use the same secret to maintain consistent LTPA tokens.

### Example 3: WebEngine with Configuration Sharing

Enable shared LTPA configuration for other applications:

```yaml
incubator:
  enableConfigurationSharing: true

applications:
  webEngine: true

configuration:
  webEngine:
    ltpa:
      customLtpaSecret: "webengine-ltpa"
```

The WebEngine LTPA configuration is exported to `dx-shared-config-v1` secret for consumption by other products (LEAP, MX, etc.).

## Kubernetes Secret Details

### Generated/Referenced Secret Structure

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-webengine-ltpa-secret
  namespace: dx-namespace
type: Opaque
data:
  ltpa.keys: <base64-encoded-binary>
stringData:
  password: "your-password"
```

## Troubleshooting

### Issue: LTPA Keys File Not Found

**Symptom:** WebEngine pod fails with error indicating LTPA keys file is missing.

**Solution:**
1. Verify secret exists:
   ```bash
   kubectl get secret my-webengine-ltpa-secret -n <namespace>
   ```

2. Verify key name:
   ```bash
   kubectl describe secret my-webengine-ltpa-secret -n <namespace>
   ```

3. Recreate secret with correct key:
   ```bash
   kubectl delete secret my-webengine-ltpa-secret
   kubectl create secret generic my-webengine-ltpa-secret \
     --from-file=ltpa.keys=/path/to/ltpa.keys \
     --from-literal=password='password'
   ```
