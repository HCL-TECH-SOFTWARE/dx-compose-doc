---
title: Rendering - Small-Sized configuration
---

# Sizing guidance for rendering in a small-sized Kubernetes configuration

This topic provides the details of the environments used for rendering in a small-sized Kubernetes configuration. You can also find the test results and recommendations for small configurations on this page.

## Methodology

This sizing activity evaluated rendering scenarios for the Web Content Manager (WCM), Digital Asset Management (DAM), and HCL Digital Experience (DX) pages and portlets. This activity used a rendering setup enabled in AWS/Native-Kubernetes, where Kubernetes is installed directly in Amazon Elastic Cloud Compute (EC2) instances. A combination run was performed that rendered WCM content, DAM assets, and DX pages and portlets. The load distribution consisted of WCM content (40%), DAM assets (30%), and DX pages and portlets (30%). All systems were pre-populated before performing the rendering tests.

To achieve the 1,000 concurrent users mark, an initial set of runs was done with a lower number of users on a single node setup. The tests started with the desired load of 1,000 users and an acceptable error rate (< 0.01%). Further steps were taken to optimize the limits on the available resources for each pod.

The following table contains the rendering scenario details for a small configuration. 

| Concurrent users     |  WCM pages         |  DAM content         |  Pages and portlets content   |
| -------------------- | ------------------ | -------------------- | ----------------------------- |
| 1,000 users          | 20                 | 2,500                |    8                          |

For more information about the setup of test data, refer to the following sections:

- [WCM default test data](./index.md#wcm-default-test-data)
- [DAM default test data](./index.md#dam-default-test-data)
- [Pages and portlets default test data](./index.md#pages-and-portlets-default-test-data)

## Environment

This section provides details for the Kubernetes cluster, JMeter agents, and database.

### AWS/Native Kubernetes

The Kubernetes platform ran on an Amazon EC2 instance with the DX images installed and configured. In AWS/Native Kubernetes, the tests were executed in EC2 instances with one c5.2xlarge node. Refer to the following node setup details:

**c5.2xlarge node**

- Node details

      ![](../../../images/Header-1-AWS.png){ width="1000" }
      
      ![](../../../images/C5.2xlarge.png){ width="1000" }

- Processor details

      ![](../../../images/Processor_Info_Native-Kube.png){ width="600" }

- Volume details

      ![](../../../images/AWS-Native-Kube-Volume-Info.png){ width="600" }

### DB2 instance

The tests used a c5.2xlarge remote DB2 instance for the core database. Refer to the following DB2 setup details:

**c5.2xlarge remote DB2 instance**

- DB2 details

       ![](../../../images/Header-1-AWS.png){ width="1000" }

       ![](../../../images/C5.2xlarge.png){ width="1000" }

- Processor details

       ![](../../../images/Processor_Info_RemoteDB2.png){ width="600" }

- Volume details

       ![](../../../images/Remote-DB2-Volume-Info.png){ width="600" }

### JMeter agents

To run the tests, a distributed AWS/JMeter agents setup consisting of one primary and two subordinate C5.xlarge instances was used. Refer to the following JMeter setup details:

**C5.xlarge JMeter instance**

- Instance details

       ![](../../../images/Header-1-AWS.png){ width="1000" }

       ![](../../../images/C5.xlarge.png){ width="1000" }

- Processor details

       ![](../../../images/Processor_Info_JMeterAgent.png){ width="600" }

- Volume details

       ![](../../../images/JMeter-Agent-Volume-Info.png){ width="600" }

!!!note
      Ramp-up time is 0.5 seconds per user. The test duration includes the ramp-up time plus one hour at the peak load of concurrent users.

## Results

The initial test runs were conducted on an AWS-distributed Kubernetes setup with a single node. The system successfully handled concurrent user loads of up to 1,000 users with a low error rate (0.1%). To ensure optimal performance, response times should remain under one second. All errors observed at higher loads were related to WCM and DX Pages and Portlets, primarily due to out-of-memory issues.

Test results were analyzed using Prometheus metrics and Grafana dashboards. For OpenLDAP and WebEngine pods, the CPU and memory limits were fully utilized. These limits were increased based on the CPU and memory usage observations from Grafana during the load test. Increasing the CPU and memory limits of OpenLDAP and WebEngine pods resolved the errors.

From these observations, CPU and memory limits of OpenLDAP, WebEngine, and HAProxy pods were tuned one by one to ensure no errors occur during a user load of 1,000 users.

## Conclusion

This performance tuning guide aims to understand how the ratios of key pod limits can improve the rendering response time in a simple single pod system. This is an important step before attempting to illustrate the impact of scaling of pods. This guide concludes that:  

- Changes to the pod limits for the following pods significantly improve the responsiveness of the setup and enable the system to handle more users.

| Pod Name  | Minimum Number of Pods | Container  | Container Image | Container CPU Request and Limit | Container Memory Request and Limit|
| --------  | ---------------------- | ---------  | --------------- | ------------------------------- | ----------------------------------|
| web-engine| 1                      | web-engine | web-engine      | 4300 m                          | 6144 Mi                           |
| openLdap  | 1                      | openLdap   | openLdap        | 100 m                           | 1024 Mi                           |

!!!note
     For more information on OS tuning, Web Server tuning, JSF best practices, and other performance tuning guidelines and recommendations for traditional deployments, refer to the [Performance Tuning Guide for Traditional Deployments](../traditional_deployments.md).

### DX Compose tuning

For tuning details and enhancements made to DX Compose during the tests, each step is mentioned below.

## Results

For a small-sized workload in AWS, the Kubernetes cluster should be started with a single node using at least a c5.2xlarge instance to support a load of 1,000 users. The CPU and memory values used are detailed below. The test results showed no errors or pod restarts throughout the execution. After implementing the tuning changes, both the total average response time and overall throughput improved significantly. Additionally, the average response time for the top five requests showed a noticeable improvement, further validating the effectiveness of the optimizations.

- To hold more authenticated users for testing purposes, increase the OpenLDAP pod values. Note that the OpenLDAP pod is not for production use.

- To improve response times, use the `.jmx` script for the DX Compose Sizing combined test to increase ThinkTime and perform the Helm upgrade using the WebEngine performance rendering YAML file.

Modifications were made to the initial Helm chart configuration during the tests. The following table outlines the pod count and limits for each pod. After applying these values, the setup showed significantly improved responsiveness. These changes allowed the system to handle 1,000 concurrent users with an improved error rate, average response time, throughput, and an event loop lag of Ring API containers.

|                               |                 | Request         | Request             | Limit           | Limit                |
|-------------------------------|-----------------|-----------------|---------------------|-----------------|----------------------|
| **Component**                 | **No. of pods** | **CPU (m)<br>** | **Memory (Mi)<br>** | **CPU (m)<br>** | **Memory (Mi)<br>**  |
| **Webengine**                 | **1**           | **4300**        | **6144**            | **4300**        | **6144**             |
| digitalAssetManagement        | 1               | 500             | 1536                | 500             | 1536                 |
| **imageProcessor**            | 1               | 200             | **768**             | 200             | **768**              |
| **openLdap**                  | 1               | 200             | **1024**            | 200             | **1024**             |
| **persistenceNode**           | 1               | **200**         | **500**             | **100**         | **500**              |
| **persistenceConnectionPool** | 1               | **300**         | **512**             | **300**         | **512**              |
| **ringApi**                   | 1               | **200**         | **256**             | **200**         | **256**              |
| **haproxy**                   | 1               | **500**         | **500**             | **500**         | **500**              |
| **Total**                     |                 | **6400**        | **11240**           | **6400**        | **11240**            |

!!!note
     Values in bold are tuned Helm values while the rest are default minimal values.

## Conclusion

This guidance shows the upper limit on a single-node K8s cluster AWS c5.2xlarge instance. For c5.2xlarge single-node rendering scenarios for DAM, WCM, and DX pages with portlets, the recommended load is 1,000 concurrent users.

### Recommendations

- Currently, we used the CPU and memory values mentioned below for DX Compose small configuration combined runs to achieve better response times without any errors

- To hold more authenticated users for testing purposes, increase the OpenLDAP pod values. Note that the OpenLDAP pod is not for production use.

Modifications were made to the initial Helm chart configuration during the tests. The following table contains the number and limits for each pod in a single-node setup.

|                               |                 | Request         | Request             | Limit           | Limit                |
|-------------------------------|-----------------|-----------------|---------------------|-----------------|----------------------|
| **Component**                 | **No. of pods** | **CPU (m)<br>** | **Memory (Mi)<br>** | **CPU (m)<br>** | **Memory (Mi)<br>**  |
| **Webengine**                 | **1**           | **4300**        | **6144**            | **4300**        | **6144**             |
| digitalAssetManagement        | 1               | 500             | 1536                | 500             | 1536                 |
| **imageProcessor**            | 1               | 200             | **768**             | 200             | **768**              |
| **openLdap**                  | 1               | 200             | **1024**            | 200             | **1024**             |
| **persistenceNode**           | 1               | **200**         | **500**             | **100**         | **500**              |
| **persistenceConnectionPool** | 1               | **300**         | **512**             | **300**         | **512**              |
| **ringApi**                   | 1               | **200**         | **256**             | **200**         | **256**              |
| **haproxy**                   | 1               | **500**         | **500**             | **500**         | **500**              |
| **Total**                     |                 | **6400**        | **11240**           | **6400**        | **11240**            |
| **Total**                     |                 | **30000**       | **50860**           | **30000**        | **50860**           |

!!!note
     Values in bold are tuned Helm values while the rest are default minimal values.

???+ info "Related information"
    - [Performance Tuning Guide for Traditional Deployments](../traditional_deployments.md)
