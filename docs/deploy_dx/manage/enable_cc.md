---
id: enable-cc
title: Enable/Disable Content Composer
---

## Introduction
This document outlines configurations to enable/disable Content Composer in HCL Digital Experience (DX) in a Kubernetes deployment using the `values.yaml` file. Content Composer allows users to create and manage content more effectively within the DX environment.

### Content Composer Configuration in the values.yaml
Below is an example snippet for configuring the DX Web Engine server to enable Content Composer.

```yaml
applications:
  contentComposer: true
```
Set the value of the key `contentComposer` to `true` for enabling and `false` for disabling.

### Validation
After updating the values.yaml file, if running the server for the first time refer the document for [installation](./install.md). If upgrading previous configurations refer the document for [upgrading](./helm-upgrade-values.md). 

Access the HCL Content Composer components by navigating to **Practitioner Studio > Web Content > Content**.

```
https://your-portal.net/wps/myportal/Practitioner/Web Content/Content Library
```