# Configuring LTPA

Lightweight Third Party Authentication (LTPA) enables Single Sign-On (SSO) capabilities for the WebEngine component. Unlike Core, which supports both inline values and custom secrets, WebEngine exclusively uses custom Kubernetes secrets for LTPA configuration.

## Configuration method

To configure LTPA in WebEngine, you need to reference an existing Kubernetes Secret containing LTPA credentials. Specify the following properties:

```yaml
configuration:
  webEngine:
    ltpa:
      customLtpaSecret: "my-webengine-ltpa-secret"
```

!!!note
    WebEngine does not support inline LTPA values configuration. You must use a pre-created Kubernetes secret.

## Generating LTPA Keys

To generate LTPA keys for WebEngine, use the OpenLiberty `securityUtility` command:

1. Open a command shell in the WebEngine pod:

    ```bash
    kubectl -n <namespace> exec -it pod/<release>-web-engine-0 -- /bin/bash
    ```

2. Generate an LTPA key using the `securityUtility` command:

    ```bash
    /opt/openliberty/wlp/bin/securityUtility createLTPAKeys --file=/opt/hcl/ltpa.keys --password=<your-password>
    ```

3. Display the LTPA keys:

    ```bash
    cat /opt/hcl/ltpa.keys
    ```

4. Exit the pod:

    ```bash
    exit
    ```

5. Save the command output as a local file for use in the next section.

### Creating a Custom LTPA Secret for WebEngine

When using a custom LTPS Secret, the Secret must contain the following data keys:

| Key | Description | Format |
|-----|-------------|--------|
| `ltpa.keys` | LTPA keys file content | Base64-encoded binary data |
| `password` | Password for LTPA keys | Plain text string |

- To create a custom Secret using `kubectl`, run the following command:

    ```bash
    kubectl create secret generic my-webengine-ltpa-secret \
      --from-file=ltpa.keys=/path/to/ltpa.keys \
      --from-literal=password='your-ltpa-password' \
      -n <your-namespace>
    ```

- To create a custom Secret using a YAML manifest, define the following resource in a separate YAML file (for example, `my-webengine-ltpa-secret.yaml`) and apply it to your cluster:

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

## Configuration examples

The following examples demonstrate how to configure LTPA for different environments:

- **Configure WebEngine with its own LTPA keys**

    1. Create the Kubernetes Secret in your target namespace using an existing key file before you deploy:

        ```bash
        kubectl create secret generic webengine-ltpa \
          --from-file=ltpa.keys=./ltpa.keys \
          --from-literal=password='myLtpaPassword' \
          -n production
        ```

    2. Reference the created Secret in your `values.yaml` file:

        ```yaml
        applications:
          webEngine: true
          core: false

        configuration:
          webEngine:
            ltpa:
              customLtpaSecret: "webengine-ltpa"
        ```

- **Configure WebEngine and Core to share LTPA keys**

    Synchronize WebEngine and Core by configuring both applications to use the same `customLtpaSecret` in your `values.yaml` file:

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

    !!!note
        Both must use the same secret to maintain consistent LTPA tokens.

## Troubleshooting

**LTPA keys file not found error**

Deploying WebEngine with a Secret that is missing the required ltpa.keys data key results in a pod failure.

To resolve this, verify the Secret configuration and recreate it if necessary:

1. Verify the Secret exists:

    ```bash
    kubectl get secret my-webengine-ltpa-secret -n <namespace>
    ```

2. Verify the key name in the Secret data:

    ```bash
    kubectl describe secret my-webengine-ltpa-secret -n <namespace>
    ```

3. If the key is missing or incorrect, recreate the Secret:

    ```bash
    kubectl delete secret my-webengine-ltpa-secret
    kubectl create secret generic my-webengine-ltpa-secret \
      --from-file=ltpa.keys=/path/to/ltpa.keys \
      --from-literal=password='password'
    ```
