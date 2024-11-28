---
id: monitor-metrics
title: Monitoring the DX Compose deployment
---

This topic outlines the use of standards-based metrics to monitor activity and performance of the Digital Experience (DX) Compose WebEngine container. For information on the deployment of other DX containers, see [Monitor Deployment Using Metrics](https://opensource.hcltechsw.com/digital-experience/CF222/deployment/manage/container_configuration/monitoring/monitor_helm_deployment_metrics/){target="_blank"}.

## Prometheus metrics and Grafana

DX Helm deployment supports monitoring the deployment activity with advanced metrics and visualization by exposing standards-based, Prometheus-compatible metrics. Components of Prometheus metrics can scrape the metrics of most of the DX container applications, including WebEngine container. The collected data is queried from Prometheus and are visualized in operations dashboard solutions, such as Grafana.

### WebEngine application container and Prometheus metrics

WebEngine container exposes metrics that you can track with Prometheus metrics. See the following details:

|Application|Port|Route|
|-----------|----|-----|
|WebEngine|9091|/metrics|

!!!important
    DX Compose does not include a deployment of [Prometheus](https://prometheus.io/){target="_blank"} or [Grafana](https://grafana.com/){target="_blank"}. The metrics are enabled by default for the [DX Helm chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack){target="_blank"}. This exposes Prometheus-compatible metrics, which can be consumed by any common Prometheus installation.

HCL DX Compose metrics are compatible with the following deployment and discovery types of Prometheus in [Kubernetes](https://kubernetes.io/){target="_blank"} environments:

-   [Prometheus](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus){target="_blank"} - Discovers metrics by evaluating the [`annotation`](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/){target="_blank"} of the services.
-   [Prometheus Operator](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack){target="_blank"} - Discovers metrics using the [`ServiceMonitor`](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/user-guides/getting-started.md#related-resources){target="_blank"} custom resources.

Administrators can configure the HCL DX Compose metrics depending on their specific Prometheus deployment, as outlined in the following sections.

### Configuring Prometheus metrics

Metrics for the WebEngine container in the DX Helm chart are enabled by default, with `prometheusDiscoveryType` set to `annotations`. The parameter to disable metrics is included in the example configurations.

|Parameter|Description|Default value|
|---------|-----------|-------------|
|`metrics.<application>.scrape`|Determines if the metrics of this application are scraped by Prometheus.|`true`|
|`metrics.<application>.prometheusDiscoveryType`|Determines how Prometheus discovers the metrics of a service. Accepts the values `"annotation"` and `"serviceMonitor"`. The`"serviceMonitor"` setting requires that the [ServiceMonitor CRD](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/user-guides/getting-started.md#related-resources){target="_blank"} \(which comes with the Prometheus Operator\), is installed in the cluster.|`"annotation"`|

!!!example "Example:"
    -   __Default configuration__: Metrics are enabled for WebEngine with the appropriate [`annotation`](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/){target="_blank"} for Prometheus:

        ```yaml
        metrics:
          webEngine:
            scrape: true
            prometheusDiscoveryType: "annotation"
        ```

    -   Create a [`ServiceMonitor`](https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/user-guides/getting-started.md#related-resources){target="_blank"} for Prometheus Operator:

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

## Using Grafana dashboards

### Publicly available Grafana dashboards

You can directly download or import the following dashboard from the Grafana community page using the IDs or links. Currently, Grafana is the only publicly available dashboard for the Open Liberty metrics version that is compatible with the different features used in the DX Compose application.

|ID|Dashboard|Applications|
|--|---------|------------|
|11706|[Open Liberty (mpMetrics-2.x)](https://grafana.com/grafana/dashboards/11706-open-liberty/){target="_blank"}|WebEngine|

However, this dashboard must be configured to display Prometheus data. Currently, it is required to customize query and regex in this imported dashboard for the exposed Prometheus metrics of WebEngine container to be visible in the Grafana dashboard.

Until a fixed version of Grafana is available for Kube from Open Liberty in the Grafana Marketplace, there is a custom alternative available for Grafana Dashboard as described in the next section.

### Publicly available Grafana dashboard JSON

Open Liberty community has provided the fixed JSON version of the Grafana dashboard at [open-liberty-grafana-mpMetrics2.x.json](https://github.com/OpenLiberty/open-liberty-operator/blob/main/deploy/dashboards/metrics/RHOCP4.3-Grafana5.2/open-liberty-grafana-mpMetrics2.x.json){target="_blank"}. You can directly import this Dashboard JSON so that exposed Prometheus metrics of WebEngine container will be visible in this dashboard.

### Custom Grafana dashboards

The following dashboard is provided by [HCL Software](https://www.hcltechsw.com/wps/portal) for use with HCL DX deployments. For exposed Prometheus metrics of WebEngine container to be visible, you can directly import a Grafana-supported custom dashboard available in the following JSON format.

|Dashboard|Application\(s\)|
|---------|----------------|
|[webengine-grafana-dashboard.json](../../../../static/assets/liberty/webengine-grafana-dashboard.json)<!--file must be uploaded-->|WebEngine|