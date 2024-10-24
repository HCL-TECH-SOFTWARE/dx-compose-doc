---
id: helm-upgrade-values
title: HELM upgrade values
---

## Overview
This document provides detailed steps for upgrading the HELM deployment using the updated `values.yaml` file.

### Steps to Update HELM Values

#### Step 1: Retrieve the Current values.yaml File

The current `values.yaml` file can be retrieved from a previous deployment or by using the following command:

```sh
helm get values <RELEASE-NAME> -n <NAMESPACE> > values.yaml
```

**Example:**
```sh
helm get values dx-deployment -n dxns > values.yaml
```

#### Step 2: Update the `values.yaml` File with the Required Changes

Make the necessary updates to the `values.yaml` file, such as `configOverrideFiles`, `images`, etc.

#### Step 3: Upgrade the Deployment with the Updated values.yaml
Use the following command to apply the updates to your Helm deployment:
```sh
helm upgrade <RELEASE_NAME> -n <NAMESPACE> -f values.yaml <HELM_CHART_DIRECTORY>
```

**Example:**
```sh
helm upgrade dx-deployment  -n dxns -f values.yaml mycharts/install-hcl-dx-deployment
```
