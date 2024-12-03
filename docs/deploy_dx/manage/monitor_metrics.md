---
id: monitor-metrics
title: Monitor Metrics
---

## Monitor WebEngine Deployment Using Metrics

This topic outlines the use of standards-based metrics to monitor activity and performance of DX WebEngine container only. More information on other DX containers of the deployment can be found at https://opensource.hcltechsw.com/digital-experience/latest/deployment/manage/container_configuration/monitoring/monitor_helm_deployment_metrics/?h=metrics

### Prometheus Metrics and Grafana

The Digital Experience 9.5 Helm deployment supports monitoring the deployment activity with advanced metrics and visualization, by exposing standards-based Prometheus-compatible metrics. Prometheus metrics components can scrape the metrics of most of the DX 9.5 container applications including WebEngine container. The collected data is queried from Prometheus and are visualized in operations dashboard solutions, such as Grafana.

### WebEngine Application Container and Prometheus Metrics

WebEngine container expose metrics that can be tracked with Prometheus metrics and details are as follows.

|Application|Port|Route|
|-----------|----|-----|
|WebEngine|9091|/metrics|

!!!important
    HCL Digital Experience 9.5 does not include a deployment of [Prometheus](https://prometheus.io/) or [Grafana](https://grafana.com/). The metrics are enabled by default for the [DX 9.5 Helm chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack). This exposes Prometheus-compatible metrics, which can be consumed by any common Prometheus installation.

HCL DX 9.5 metrics are compatible with the following deployment and discovery types of Prometheus in [Kubernetes](https://kubernetes.io/) environments:

-   [Prometheus](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus) - Discovers metrics by evaluating the [`annotation`](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) of the services
-   [Prometheus Operator](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) - Discovers metrics using the [`ServiceMonitor`](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/user-guides/getting-started.md#related-resources) custom resources

Administrators can configure the HCL DX 9.5 metrics depending on their specific Prometheus deployment, as outlined in the following sections.

### Configure Prometheus Metrics

Metrics for the WebEngine container in the DX 9.5 Helm chart are enabled by default, with `prometheusDiscoveryType` set to `annotations`. The parameter to disable metrics is included in the example configurations.

|Parameter|Description|Default value|
|---------|-----------|-------------|
|`metrics.<application>.scrape`|Determines if the metrics of this application are scraped by Prometheus.|`true`|
|`metrics.<application>.prometheusDiscoveryType`|Determines how Prometheus discovers the metrics of a service. Accepts `"annotation"` and `"serviceMonitor"`. The`"serviceMonitor"` setting requires that the [ServiceMonitor CRD](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/user-guides/getting-started.md#related-resources) \(which comes with the Prometheus Operator\), is installed in the cluster.|`"annotation"`|

!!!example "Example:"
    -   __Default configuration__: Metrics are enabled for WebEngine with the appropriate [`annotation`](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) for Prometheus:

        ```yaml
        metrics:
          webEngine:
            scrape: true
            prometheusDiscoveryType: "annotation"
        ```

    -   Create a [`ServiceMonitor`](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/user-guides/getting-started.md#related-resources) for Prometheus Operator:

        ```yaml
        metrics:
          webEngine:
            scrape: true
            prometheusDiscoveryType: "serviceMonitor"
        ```

    -   Disable the metrics for WebEngine:

        ```yaml
        metrics:
          webEngine:
            scrape: false
        ```

### Grafana Dashboards

#### Publicly Available Grafana Dashboards

You can directly download or import the following dashboard from the Grafana community page using the IDs or links. Currently this is the only dashboard available publicly for the OpenLiberty metrics version that is compatible with different features we are using in WebEngine application. 

|ID|Dashboard|Applications|
|--|---------|------------|
|11706|[Open Liberty (mpMetrics-2.x)](https://grafana.com/grafana/dashboards/11706-open-liberty/)|WebEngine|

However, this dashboard has few issue due to which it does not display prometheus data. Currently we need to customize query and regex in this imported dashboard a bit so that exposed Prometheus metrics of WebEngine container will be visible in this dashboard.

Till we get a fixed version of above mentioned dashboard for Kube from Openliberty in the grafana marketplace, we have few alternatives available for Grafana Dashboard as mentioned in next sections.

#### Publicly Available Grafana Dashboard JSON

Open liberty community has provided the fixed JSON version of the Grafana dashboard at https://github.com/OpenLiberty/open-liberty-operator/blob/main/deploy/dashboards/metrics/RHOCP4.3-Grafana5.2/open-liberty-grafana-mpMetrics2.x.json. You can directly import this Dashboard JSON so that exposed Prometheus metrics of WebEngine container will be visible in this dashboard.

#### Custom Grafana Dashboards

The following dashboards are provided by [HCL Software](https://www.hcltechsw.com/wps/portal) for use with [HCL Digital Experience 9.5](https://www.hcltechsw.com/dx) deployments. You can directly import Grafana-supported custom dashboard available in JSON format below, so that exposed Prometheus metrics of WebEngine container will be visible in this dashboard.

|Dashboard|Application\(s\)|
|---------|----------------|
|[webengine-grafana-dashboard.json](./webengine-grafana-dashboard.json)|WebEngine|