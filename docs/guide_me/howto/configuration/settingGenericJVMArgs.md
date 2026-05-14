# How to set generic JVM arguments in the DX Compose WebEngine container

## Applies to  

> HCL Digital Experience 9.5 and higher  

## Introduction  

This article describes how to add generic JVM arguments to the HCL DX Compose WebEngine container to enable detailed SSL traces or change other JVM settings.

## Instructions

1. Open the Helm chart `values.yaml` file and locate the following section:

    ```yaml
    environment:
      pod:
        webEngine:[]
    ```

2. Add the `JVM_ARGS` variable to this section and set your generic JVM arguments in the `value` parameter.

    For example, to enable detailed SSL traces, use the following syntax:

    ```yaml
    environment:
      pod:
        webEngine:
          - name: JVM_ARGS
            value: "-Djavax.net.debug=all"
    ```
