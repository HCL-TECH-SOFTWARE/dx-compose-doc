---
id: helm-upgrade-values
title: HELM upgrade values
---

## Overview
This document provides detailed steps for upgrading the HELM deployment using the new `values.yaml` file.

### Steps to Update HELM Values

#### Step 1: Get the current values.yaml file - either from a previous deployment or extracting via the following sample commands:
```sh
helm get values dx-deployment -n dxns > values.yaml

#### Step 2: Update the `values.yaml` File with the Required Changes
Make the necessary updates to the `values.yaml` file, such as `configOverrideFiles`, `images`, `incubator`, etc.

#### Step 3: Apply the Updated `values.yaml` File
```sh
helm upgrade dx-deployment  -n <namespace> -f values.yaml <helm template directory>
```
**Note**: After the HELM upgrade, the HELM charts will pick up the changes immediately. There is no need to restart the server.
