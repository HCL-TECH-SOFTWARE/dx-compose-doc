---
id: portlet-container-kube
title: Liberty Portlet Container Kubernetes Deployment
---

## **Liberty Portlet Container Kubernetes Deployment Design**

|||
| --- | --- |
| AUTHOR(S)	| Graham Harper (graham.harper@hcl.com) |
| DATE |	26-JUL-2023 |
| REVISION | 0.01 |
| STATUS | Draft |

# Introduction and Goals

This document considers the design for the deployment of the Liberty Portlet Container into Kubernetes environments.

The goals are:

1. Support the deployment of the Liberty Portlet Container as a WSRP Producer, providing portlets for consumption by the DX Core WSRP Consumer
2. To allow the Liberty Portlet Container to be scaled independently of DX Core, both in terms of pod resources and number of pods
3. To be initially as simple as possible to cover the basic requirements
4. To be initially deployable as a separate "add on" to an existing DX deployment, since the Liberty Portlet Container will only be supplied to a limited set of customers
5. To be easily extensible to cover multiple customer deployment scenarios and preferences in the future

## Current State

There are currently no Helm charts supporting deployment of the Liberty Portlet Container.

# System Design & Architecture

## Initial Helm Charts

Initially a minimal standalone set of Helm charts will be created for the Liberty Portlet Container to achieve goals 3 and 4. These charts will be able to be deployed into a new Kubernetes namespace or, more likely, into a namespace in which DX Core is already deployed. If the latter, deployment will still occur via a separet `helm install` command.

The charts will provide:

* a stateful set of Liberty Portlet Container pods
* a service to access the stateful set from within Kubernetes
* an HPA to scale the stateful set
* a default 'values.yaml' configuring the deployment (that will be overridden as necessary by customers using their own file)
* a schema for checking the correctness of the values

## Full Helm Charts

The full Helm charts will be refined over time, based on what we learn from porting DX Core to Liberty and from feedback by customers receiving an early version. However, the following subsections set out the current intentions concerning various aspects of deployment.

### Portlet Application Deployment

To deploy portlets to the Liberty Portlet Container customers will need to create a new container image from our supplied Liberty Portlet Container image that also has their portlets deployed. They would then select the image name and tag for this new image in their custom `values.yaml`` when they deploy via the Helm charts.

### Persistent Volumes

The Liberty Portlet Container will only, by default, use persistent volumes for logging. Log output will be stored on one RWO persistent volume per pod.

However, in a [similar manner](https://opensource.hcltechsw.com/digital-experience/CF213/deployment/install/container/helm_deployment/preparation/mandatory_tasks/prepare_persistent_volume_claims/#configuring-additional-core-persistent-volumes) to the current DX Core Kubernetes deployment, the Liberty Portlet Container Helm charts will allow additional custom volumes to be configured if customer applications require persistent storage.

### Configuration

Open Liberty server configuration snippets can be included in a customer's custom `values.yaml` file and will be passed to the container via a config map which is mounted in the `configDropins/overrides` directory. The [merging logic of Open Liberty](https://openliberty.io/docs/latest/reference/config/server-configuration-overview.html#configuration-merging) will apply these snippets to the server configuration.

### Operations and Maintenance

The Liberty Portlet Container deployment will accept logging configuration through a customer's custom `values.yaml` file, in a similar format to other DX containers in Kubernetes.

Liberty Portlet Container log output will be available to Kubernetes cluster-level logging solutions via sidecar containers in the pods.

The Liberty Portlet Container image will support running in a "maintenance mode" for diagnosis of issues. "Maintenance mode" can be configured via the customer's custom `values.yaml` file.

The Liberty Portlet Container will emit Prometheus metrics consistent with other DX containers.

### Security

The authentication and authorisation approach for the Liberty Portlet Container in general - and SSO with DX Core specifically - has not yet been investigated (there are stories in the backlog).

However, it is expected that the OpenLiberty configuration merging capabilities mentioned above in the 'Configuration' subsection, together with the ability to mount Kubernetes secrets and config maps as files in containers, will be used to implement whatever is found necessary.

## Automation

A Jenkins job will be created to package the Helm charts and upload them to Artifactory.

Our internal automated deployment jobs will also be updated (see the 'Testing' section below).

## UX Behaviors

There is no specific user interface for the Helm charts.

## Alternate Approaches

Helm charts are our standard Kubernetes deployment mechanism and there is no identified need to depart from this.

# Configuration

The main configuration of the Helm deployment of the Liberty Portlet Container will be via override `values.yaml`` files created by customers, the same as in general DX deployments. For more information, please see the 'Configuration' subsection under 'Full Helm Charts' above.

# Security

See the 'Security' subsection under 'Full Helm Charts' above.

# Performance

Performance will be controlled by the scalability settings used (see next section).

# Scalability

As per goal #2, the Liberty Portlet Container should be scalable independently of other components. To that end the Helm charts will allow separate specification of its pod resources, its number of pods, thresholds etc.

One customer request is to allow multiple independently-scalable deployments of the Liberty Portlet Container connected to a single DX deployment, with each Liberty Portlet Container deployment hosting a different set of portlets with different scalability or isolation requirements. The Helm charts will support this initially by allowing the charts to be deployed multiple times with different values (e.g. container image, resources, deployment name etc.)

# Availability

"High" availability of the Liberty Portlet Container will be provided by allowing multiple pods per Liberty Portlet Container deployment.

# Support, Operations and Monitoring

See the 'Operations and Maintenance' subsection under 'Full Helm Charts'.

# Install and Deployment

Installation of the Liberty Portlet Container will be via `helm install`, consistent with the rest of DX.

## Migration

Customers with JSR 168 / 286 portlets running locally on DX Core on tWAS will only be able to migrate those portlets to the Liberty Portlet Container if they satisfy (or can be updated by the customer to satisfy) the following restrictions:

* The portlets run on the version of Java supplied with the Liberty Portlet Container image
* The portlets run on an OpenLiberty application server (i.e. do not depend on any tWAS-specific functionality)
* The portlets do not require any local access to DX (e.g. do not use any DX local Java APIs)
* The portlets use only interaction methods that are supported by WSRP

Assuming that the portlets satisfy the conditions, the customer will need to create a container image from our Liberty Portlet Container image that also has their portlets deployed and then create a suitable custom `values.yaml` file to deploy it via the Helm charts.

# Internationalization

Helm deployment processes for DX are supported only in English.

# Testing

The Helm charts for the Liberty Portlet Container will be linted and tested during PR checks in the [same way](https://pages.git.cwp.pnp-hcl.com/Team-Q/internal-doc/architecture/helm-and-kube/helm-and-helm-chart/helm-linting-and-static-code-checks/) as the main DX Helm charts.

The native Kubernetes deployment pipelines will be enhanced to support the optional deployment of the Liberty Portlet Container alongside the rest of DX. Once development of the Liberty Portlet Container has advanced further,  automated deployments will be toggled so that the Liberty Portlet Container is always deployed on one of our standard automated environments (e.g. "halo-halo" or "toblerone").

# Documentation

Documentation for deployment of the Liberty Portlet Container will initially be created separately and provided only to customers receiving the Liberty Portlet Container for trial. After the Liberty Portlet Container is generally available this documentation will be combined into the normal DX product documentation.

# License and Delivery

Helm charts will follow the same license as the Liberty Portlet Container image and initially delivered alongside it to selected customers. Longer term the charts will be delivered alongside the Helm charts for the rest of DX.

# Issues and Future Enhancements

The Helm charts for the Liberty Portlet Container will be enhanced based on internal testing and on feedback from trial customers.
