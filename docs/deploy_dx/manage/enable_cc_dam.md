---
id: enable-cc-dam
title: Enable/Disable Content Composer and Digital Asset Management
---

## Introduction
This document outlines configurations to enable/disable Content Composer and Digital Asset Management in HCL Digital Experience (DX) in a Kubernetes deployment using the `values.yaml` file. Content Composer allows users to create and manage content more effectively within the DX environment and DAM is used for managing web-ready digital assets such as images or videos for use in content and sites built with HCL DX.

### Content Composer and  Digital Asset Management Configuration in the values.yaml
Below is an example snippet for configuring the WebEngine server to enable Content Composer and Digital Asset Management.

```yaml
applications:
  contentComposer: true
  digitalAssetManagement: true
```
Set the value of the key `contentComposer` and `digitalAssetManagement` to `true` for enabling and `false` for disabling.

### Validation
After updating the values.yaml file, if running the server for the first time refer the document for [installation](../install/install.md). If upgrading previous configurations refer the document for [upgrading](./helm_upgrade_values.md). 

Access the HCL Content Composer and Digital Asset Management components by navigating to **Practitioner Studio > Web Content > Content** or **Practitioner Studio > Digital Assets**.

```
https://your-portal.net/wps/myportal/Practitioner/Web Content/Content Library
```

```
https://your-portal.net/wps/myportal/Practitioner/Digital Assets
```
**Note**: By default DX Picker will get enabled/disabled on enabling/disabling DAM