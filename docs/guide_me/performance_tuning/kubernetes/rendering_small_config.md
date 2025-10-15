---
title: Rendering - Small configuration
---

# Sizing guidance for rendering in a small Kubernetes configuration

This section describes the environments used for rendering in a small Kubernetes configuration.  
It also provides test results and recommendations.

## Methodology

This sizing activity rendered scenarios for the Web Content Manager (WCM), Digital Asset Management (DAM), and HCL Digital Experience (DX) Compose pages and portlets. This activity used a rendering setup enabled in AWS/Native-Kubernetes, where Kubernetes is installed directly in Amazon Elastic Cloud Compute (EC2) instances. A combination run was performed that rendered WCM content, DAM assets, and DX Compose pages and portlets. The load distribution was WCM content (40%), DAM assets (30%), and DX Compose pages and portlets (30%). All systems were pre-populated before performing the rendering tests.

To achieve 1,000 concurrent users, the tests began with fewer users on a single-node setup.  
The desired load of 1,000 users was reached with an acceptable error rate (< 0.01%).  
Additional steps were taken to optimize resource limits for each pod.

The following table contains the rendering scenario details for a small configuration. 

| Concurrent users     |  WCM pages         |  DAM content         |  Pages and portlets content   |
| -------------------- | ------------------ | -------------------- | ----------------------------- |
| 1,000 users          | 20                 | 2,500                |    6                          |

For more information about the setup of test data, See the following sections:

- [WCM default test data](./index.md#wcm-default-test-data)
- [DAM default test data](./index.md#dam-default-test-data)
- [Pages and portlets default test data](./index.md#pages-and-portlets-default-test-data)

## Environment

This section provides details for the Kubernetes cluster, JMeter agents, and database.

### AWS/Native Kubernetes

The Kubernetes platform was deployed on an Amazon EC2 instance with DX Compose images installed and configured. In the AWS/Native Kubernetes setup, the tests were conducted on three EC2 instances using a c5.2xlarge node. This instance type was used for the remote DB2 instance (core database) and the JMeter instance.

See the following setup details:

**c5.2xlarge**

| Attribute          | Details                          |
|--------------------|----------------------------------|
| vCPUs              | 8                                |
| Memory             | 16 GiB                           |
| EBS-Optimized      | Yes (7500 Mbps bandwidth)        |
| Network Bandwidth  | Up to 10 Gbps                    |
| EBS Volume Type    | General Purpose (gp3/gp2), io1/io2 |
| Processor          | Intel(R) Xeon(R) Platinum 8275CL CPU @ 3.00GHz |
| Architecture       | x86_64                           |
| ENA Support        | Yes                              |
| NVMe Support       | Yes (EBS using NVMe)             |

!!!note
    Ramp-up time is 0.4 seconds per user. The test duration includes the ramp-up time plus one hour at the peak load of concurrent users.

## Results

The test results revealed no errors or pod restarts during execution. Following the implementation of the [tuning changes](./rendering_small_config.md#dx-compose-tuning), there was a significant improvement in both the total average response time and overall throughput. Furthermore, the average response time for the top five requests demonstrated a marked enhancement, confirming the effectiveness of the optimizations.

The test results were analyzed using Prometheus and Grafana dashboards. Resource limits were adjusted based on CPU and memory usage observations from Grafana during the load tests. For HAProxy and webEngine pods, the CPU and memory limits were fully utilized and were subsequently increased.

Additionally, after reviewing and updating the cache statistics tool, optimal performance was achieved, with improvements in both average and 95th percentile response times. Increasing webEngine CPU cores by 1.3, adjusting HAProxy from 200m to 500m, and modifying ringApi from 100m to 200m led to a significant improvement in the total average response time, resulting in a tenfold increase in performance. To support these adjustments, CPU limits for persistenceNode, persistenceConnectionPool, and imageProcessor were reduced, prioritizing the optimization of rendering scenarios.

The next section provides detailed guidance on using the cache statistics tool and the tuning steps.

## WebEngine Cache Statistics tool

The WebEngine Cache Statistics tool allows you to monitor the OpenLiberty Dynacache statistics for the DX Compose webEngine pod.

To use the Dynacache Statistics tool, copy the [LibertyCacheStatistics](./LibertyCacheStatistics.war) WAR file into the `defaultServer/dropins` folder of the `webEngine` pod.  Then, run the following `kubectl` command:

```
kubectl cp LibertyCacheStatistics.war dx-deployment-web-engine-0:/opt/openliberty/wlp/usr/servers/defaultServer/dropins -n <namespace>
```
To access the cache statistics, open the following URL in your browser: `https://<hostName>/LibertyCacheStatistics/`. This page displays detailed cache information, including sizes, explicit removals, and Least Recently Used (LRU) removals.

### DX Compose tuning

Modifications to the initial Helm chart configuration were applied during testing. The following table specifies the pod count and resource limits for each pod. Additionally, certain WCM Dynacache sizes, lifetimes, and JVM heap sizes were adjusted based on cache statistics. For further details, see the [Recommendations](./rendering_small_config.md#recommendations) section on performing a Helm upgrade using `webengine-performance-rendering.yaml`

After applying the updated Helm values and cache adjustments, the system showed significantly improved responsiveness. These changes enabled the setup to handle 1,000 concurrent users with better error rates, reduced average response times, increased throughput, and improved 95th percentile response times.

|  |  | Request | Request | Limit | Limit |
|---|---|---:|---|---|---|
| **Component** | **No. of pods** | **CPU (m)<br>** | **memory (MiB)<br>** | **CPU (m)<br>** | **memory (MiB)<br>** |
| contentComposer | 1 | 100 | 128 | 100 | 128 |
| **webEngine** | 1 | **4300** | **5120** | **4300** | **5120** |
| digitalAssetManagement | 1 | 500 | 1536 | 500 | 1536 |
| **imageProcessor** | 1 | **100** | **768** | **100** | **768** |
| **openLdap** | 1 | **100** | **1024** | **100** | **1024** |
| **persistenceNode** | 1 | **200** | 1024 | **200** | 1024 |
| **persistenceConnectionPool** | 1 | **300** | 512 | **300** | 512 |
| **ringApi** | 1 | **200** | 256 | **200** | 256 |
| runtimeController | 1 | 100 | 256 | 100 | 256 |
| **haproxy** | 1 | **500** | **512** | **500** | **512** |
| licenseManager | 1 | 100 | 300 | 100 | 300 |
| **Total** | | **6500** | **11436** | **6500** | **11436** |

!!!note
    - Values in bold are tuned Helm values while the rest are default minimal values.
    Cache values vary based on the test data.  
Monitor cache statistics regularly and update them as needed.  
For more information, see the [WebEngine Cache Statistics Tool](./rendering_small_config.md#webengine-cache-statistics-tool).

For convenience, these values were added to the `small-config-values.yaml` file in the hcl-dx-deployment Helm chart. To use these values, See the following steps:

1. Download the `hcl-dx-deployment` Helm chart from Harbor.

2. Extract the `hcl-dx-deployment-XXX.tgz` file.

3. In the extracted folder, navigate to `hcl-dx-deployment/value-samples/webEngine/small-config-values.yaml` and copy the `small-config-values.yaml` file.

## Conclusion

This guidance outlines the maximum capacity for a single-node Kubernetes cluster deployed on an AWS c5.2xlarge instance. For rendering scenarios involving DAM, WCM, and DX Compose pages with portlets on a c5.2xlarge single-node setup, the recommended load is up to 1,000 concurrent users.

## Recommendations

- For a small workload in AWS, start the Kubernetes cluster with a single node using at least a c5.2xlarge instance to support a load of 1,000 users.

- To hold more authenticated users for testing purposes, increase the OpenLDAP pod CPU and memory values. Note that the OpenLDAP pod is not for production use.

- To improve response times, perform the Helm upgrade using the `webengine-performance-rendering.yaml` file. This file is available in the HCL DX Compose Deployment Helm chart. To use this file, complete the following steps:
    1. Download the `hcl-dx-deployment` Helm chart from Harbor.
    2. Extract the `hcl-dx-deployment-XXX.tgz` file.
    3. In the extracted folder, navigate to `hcl-dx-deployment/performance/webengine-performance-rendering.yaml` and copy the `webengine-performance-rendering.yaml`.

    After performing a Helm upgrade using the `webengine-performance-rendering.yaml` file, the tuned cache values for rendering will be updated.

### Recommended heap size configuration

To ensure optimal performance and stability of HCL DX on Kubernetes, it is essential for you to configure JVM heap memory and pod resource limits correctly. Refer to the following best practices in the [JVM heap and pod resource guidelines for performance runs](./index.md#jvm-heap-and-pod-resource-guidelines-performance-runs) when tuning memory allocation.

