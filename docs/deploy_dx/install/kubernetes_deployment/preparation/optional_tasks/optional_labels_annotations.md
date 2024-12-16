# Configure Labels and Annotations

This section documents the configuration of labels and annotations for different DX Compose resources.

## Annotations

### Services and Pods

To configure annotations for Kubernetes services and pods, update your custom-values.yaml file as follows:

!!!note "Notes:"
    -   Additional annotations are not mandatory for a deployment.
    -   Ensure you do not overwrite existing DX Compose annotations such as the following:
        -  `meta.helm.sh/release-name`
        -  `meta.helm.sh/release-namespace`

#### Sample annotations for WebEngine service
To set annotation `KEY1` with value VALUE1 and annotation `KEY2` with value VALUE2 on the WebEngine service, add the following to your custom-values.yaml file:

```yaml
annotations:
  service: 
    webEngine: 
      - key: KEY1
        value: VALUE1
      - key: KEY2
        value: VALUE2
```

#### Sample annotations for WebEngine pods
To set annotation `KEY1` with value VALUE1 and annotation `KEY2` with value VALUE2 on WebEngine pods, add the following to your custom-values.yaml file:

```yaml
annotations:
  pod: 
    webEngine: 
      - key: KEY1
        value: VALUE1
      - key: KEY2
        value: VALUE2
```

## Labels

### Services and Pods**

To configure labels for Kubernetes services and pods, update your custom-values.yaml file as follows:

!!!note "Notes:"
    -   Additional labels are not mandatory for a deployment.
    -   Ensure that you do not overwrite existing DX Compose Labels such as the following:
        -  `release`
        -  `helm.sh/chart`
        -  `app.kubernetes.io/version`
        -  `app.kubernetes.io/managed-by`
        -  `app.kubernetes.io/name`
        -  `app.kubernetes.io/instance`
      
#### Sample labels for WebEngine services
To set label `KEY1` with value VALUE1 and label `KEY2` with value VALUE2 on the WebEngine services, add the following to your custom-values.yaml file:

```yaml
labels:
  service: 
    webEngine: 
      - key: KEY1
        value: VALUE1
      - key: KEY2
        value: VALUE2
```

#### Sample labels for WebEngine pods
To set label `KEY1` with value VALUE1 and label `KEY2` with value VALUE2 on WebEngine pods, add the following to your custom-values.yaml file:

```yaml
labels:
  pod: 
    webEngine: 
      - key: KEY1
        value: VALUE1
      - key: KEY2
        value: VALUE2
```

## Configure environment variables for DX Compose resources
This section explains the configuration of environment variables for different DX Compose resources.

### Environment variables
To configure environment variables for kubernetes pods, update your custom-values.yaml file as below.

!!! note
    Additional environment values are not mandatory for a deployment.

!!! note
    This environment variable only applies to Pod's main container and will not apply to other containers of the Pod (i.e., logging sidecar).

#### Sample environment variables for WebEngine pods
To set environment variable `KEY1` with value `VALUE1` and environment variable `KEY2` with value `VALUE2` on WebEngine pods, add the following to your `custom-values.yaml` file:

```yaml
environment:
  pod: 
    webEngine: 
      - name: KEY1
        value: VALUE1
      - name: KEY2
        value: VALUE2
```