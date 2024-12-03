---
id: enable-dam
title: Enable/Disable Digital Asset Manager
---

## Introduction
This document outlines configurations to enable/disable Digital Asset Management in HCL Digital Experience (DX) on Liberty in a Kubernetes deployment using the `values.yaml` file. DAM is used for managing web-ready digital assets such as images or videos for use in content and sites built with HCL DX.

### Digital Asset Management Configuration in the values.yaml
Below is an example snippet for configuring the DX Web Engine server to enable Digital Asset Management.

```yaml
applications:
  digitalAssetManagement: true
```
Set the value of the key `digitalAssetManagement` to `true` for enabling and `false` for disabling.

### Validation
After updating the values.yaml file, if running the server for the first time refer the document for [installation](./install.md). If upgrading previous configurations refer the document for [upgrading](./helm-upgrade-values.md). 

Access the HCL Digital Asset Management component by navigating to **Practitioner Studio > Digital Assets**.

```
https://your-portal.net/wps/myportal/Practitioner/Digital Assets
```

**Note**: By default DX Picker will get enabled/disabled on enabling/disabling DAM