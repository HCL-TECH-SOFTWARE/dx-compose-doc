---
title: Rendering - Large-Sized Configuration
---

# Sizing guidance for rendering in a large-sized Kubernetes configuration

This topic provides the details of the environments used for rendering in a large-sized Kubernetes configuration. You can also find the test results and recommendations for large configurations on this page.

## Methodology

This sizing activity rendered scenarios for the Web Content Manager (WCM), Digital Asset Management (DAM), and HCL Digital Experience (DX) pages and portlets. This activity used a rendering setup enabled in AWS/Native-Kubernetes, where Kubernetes is installed directly in Amazon Elastic Cloud Compute (EC2) instances. A combination run was performed that rendered WCM content, DAM assets, and DX pages and portlets. The load distribution was WCM content (40%), DAM assets (30%), and DX pages and portlets (30%). All systems were pre-populated before performing the rendering tests.

To achieve the 30,000 concurrent users mark, initial test runs started with 12 worker nodes. As the user load increased, the number of worker nodes was scaled up to 14 to handle the 30,000 user load with an acceptable error rate (< 0.01%). After establishing the required node count, further optimizations were made to pod resource limits and the ratios of key pods to each other to ensure stable performance.

The following table contains the rendering scenario details for a large configuration. 

| Concurrent users     |  WCM pages         |  DAM content         |  Pages and portlets content   |
| -------------------- | ------------------ | -------------------- | ----------------------------- |
| 30,000 users         | 2000               | 250,000              |    600                        |

For more information about the setup of test data, refer to the following sections:

- [WCM default test data](./index.md#wcm-default-test-data)
- [DAM default test data](./index.md#dam-default-test-data)
- [Pages and portlets default test data](./index.md#pages-and-portlets-default-test-data)

## Environment

This section provides details for the Kubernetes cluster, Load Balancer, JMeter agents, LDAP, and tuning setups used for this activity.

### AWS/Native Kubernetes

The Kubernetes platform ran on an Amazon EC2 instance with the DX images installed and configured. In AWS/Native Kubernetes, the tests were executed in EC2 instances with 1 c5.4xlarge master node and 14 c5.4xlarge worker nodes. Refer to the following node setup details:

- **c5.4xlarge worker nodes**

    | Attribute          | Details                          |
    |--------------------|----------------------------------|
    | vCPUs              | 16                               |
    | Memory             | 32 GiB                           |
    | EBS-Optimized      | Yes (8500 Mbps bandwidth)        |
    | Network Bandwidth  | Up to 10 Gbps                    |
    | EBS Volume Type    | General Purpose (gp3/gp2), io1/io2 |
    | Processor          | Intel(R) Xeon(R) Platinum 8275CL CPU @ 3.00GHz |
    | Architecture       | x86_64                           |
    | ENA Support        | Yes                              |
    | NVMe Support       | Yes (EBS using NVMe)             |

- **c5.2xlarge NFS**

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

### DB2 instance

The tests used a c5.4xlarge remote DB2 instance for the webEngine database. Refer to the following DB2 setup details:

**c5.4xlarge remote DB2 instance**

| Attribute          | Details                          |
|--------------------|----------------------------------|
| vCPUs              | 16                               |
| Memory             | 32 GiB                           |
| EBS-Optimized      | Yes (8500 Mbps bandwidth)        |
| Network Bandwidth  | Up to 10 Gbps                    |
| EBS Volume Type    | General Purpose (gp3/gp2), io1/io2 |
| Processor          | Intel(R) Xeon(R) Platinum 8275CL CPU @ 3.00GHz |
| Architecture       | x86_64                           |
| ENA Support        | Yes                              |
| NVMe Support       | Yes (EBS using NVMe)             |

### NFS tuning details

During the 20,000 concurrent user load test with 14 worker nodes, the PostgreSQL pool and node pods occasionally became unstable due to high Input/Output (I/O) pressure on the Network File System (NFS) storage. To resolve this, we increased the NFS instance volume Input/Output Operations Per Second (IOPS) from the default 3,000 to 6,000 and raised the throughput from 128 MiB/s to 256 MiB/s. The `c5.4xlarge` NFS instance was also resized from the default 200 GB to 500 GB due to several issues, such as the NFS instance not initializing and pods failing to remain steady.

Doubling the IOPS and throughput provided the necessary capacity for the NFS storage to handle the intense I/O demands of the PostgreSQL database, resulting in a stabilized persistence layer and improved overall system reliability under heavy load.

### Load Balancer setup

AWS Elastic Load Balancing (ELB) was used to distribute incoming application traffic across multiple targets automatically. The c5.4xlarge instances, which support network bandwidth of up to 10Gbps, were selected to handle more virtual users in a large configuration, making AWS ELB an optimal choice.

During the DX Kubernetes deployment, the `HAProxy` service type was updated from `LoadBalancer` to `NodePort` with a designated `serviceNodePort`. Then, the EC2 worker node instances hosting the `HAProxy `pods were added as a target group within the AWS ELB listeners.

### JMeter agents

To run the tests, a distributed AWS/JMeter agents setup consisting of 1 primary and 10 subordinate c5.2xlarge JMeter instances was used. Refer to the following JMeter setup details:

**c5.2xlarge JMeter instance**

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
    Ramp-up time is five virtual users every two seconds. The test duration includes the ramp-up time plus one hour at the peak load of concurrent users.

### DX Compose tuning

Modifications to the initial Helm chart configuration were applied during testing. The following table specifies the pod count and resource limits for each pod.

!!!note
    For DAM, no tuning details are mentioned in this topic except for the pod resources like CPU and memory limits for all pods related to DAM, such as `ring-api`, `persistence-node`, and `persistence-connection-pool`. Since DAM uses `Node.js`, you can monitor CPU and memory usage using Prometheus and Grafana. Based on your observations, you can modify memory requests and limits in Kubernetes accordingly.

Modifications were also made to the initial Helm chart configuration during the tests. The following table outlines the pod count and limits for each pod. After applying these values, the setup showed significantly improved responsiveness. These changes allowed the system to handle 30,000 concurrent users with a substantial reduction in average response time and a minimal error rate.

| | | Request | Request | Limit | Limit | **Total** | **Total** |
|---|---|---:|---:|---:|---:|---:|---:|
| **Component** | **No. of pods** | **cpu (m)** | **memory (Mi)** | **cpu (m)** | **memory (Mi)** | **CPU Request (m)** | **Memory Request (Mi)** |
| **webEngine** | **25** | **5600** | **8192** | **5600** | **8192** | **140000** | **204800** |
| **digitalAssetManagement** | **4** | **2000** | **4096** | **2000** | **4096** | **8000** | **16384** |
| imageProcessor | 1 | 200 | 2048 | 200 | 2048 | 200 | 2048 |
| **openLdap** | **1** | **300** | **2048** | **300** | **2048** | **300** | **2048** |
| **persistenceNode** | **3** | **3800** | **2048** | **3800** | **2048** | **11400** | **6144** |
| **persistenceConnectionPool** | **3** | **700** | **1024** | **700** | **1024** | **2100** | **3072** |
| **ringApi** | **2** | **500** | **2048** | **500** | **2048** | **1000** | **4096** |
| runtimeController | 1 | 100 | 256 | 100 | 256 | 100 | 256 |
| **haproxy** | **3** | **2500** | **2048** | **2500** | **2048** | **7500** | **6144** |
| licenseManager | 1 | 100 | 300 | 100 | 300 | 100 | 300 |
| **Total** | **45** | **-** | **-** | **-** | **-** | **170700** | **245292** |

!!!note
    - Values in bold are tuned Helm values while the rest are default minimal values.
    - Cache value changes depending on the test data. It is recommended to monitor cache statistics regularly and update them as necessary. To learn how to monitor cache statistics, refer to the [WebEngine Cache Statistics Tool](./rendering_small_config.md#webengine-cache-statistics-tool).

For convenience, these values were added to the `large-config-values.yaml` file in the hcl-dx-deployment Helm chart. To use these values, refer to the following steps:

1. Download the `hcl-dx-deployment` Helm chart from  Harbor.

2. Extract the `hcl-dx-deployment-XXX.tgz` file.

3. In the extracted folder, navigate to `hcl-dx-deployment/value-samples/webEngine/large-config-values.yaml` and copy the `large-config-values.yaml` file.

!!!note
    For enhanced performance, it is recommended to increase the `validationSleepTimer` to 600 seconds (10 minutes) to reduce the frequency of persistence cluster health checks. This adjustment is ideal for stable environments as it lowers overhead from continuous monitoring.

## Results

The initial test runs were conducted on an AWS-distributed Kubernetes setup with one master and twelve worker nodes. The system successfully handled concurrent user loads of 10,000 and 15,000 with a low error rate (< 0.0001%). At 20,000 users, error rates increased dramatically and response times went up. For a response time to be considered optimal, it should be under one second.

Subsequent tests were conducted on a setup with 14 worker nodes, evaluating user loads up to 30,000 concurrent users. Error rates remained low (<0.0001%) and response times were satisfactory. Adjustments were made to the number of pods, CPU, and memory for the following containers: `HAProxy`, `webEngine`, `RingAPI`, `digitalAssetManagement`, `persistenceNode`, and `persistenceConnectionPool`. These changes aimed to identify the most beneficial factors for the sizing activity.

For details on how NFS tuning contributed to stabilizing the persistence layer under heavy load, refer to [NFS tuning details](#nfs-tuning-details).

The test results were analyzed using Prometheus and Grafana dashboards. Resource limits were adjusted based on CPU and memory usage observations from Grafana during the load tests. For the `webEngine` pod, increasing the CPU limit gave a boost to performance, but this effect eventually saturated at 5600 millicore. This result indicated that increasing the number of `webEngine` pods at this point provided additional benefits.

There was a notable improvement in both total average response time and overall throughput after the optimizations. Additionally, the average response time for the top five requests showed significant enhancement.

## Conclusion

There are several factors that can affect the performance of DX in Kubernetes. Changes in the number of running nodes, number of pods, and the capacity of individual pods can improve HCL DX performance. Any changes should be closely monitored to ensure precise tracking of resource utilization.

### Recommendations

- For large-scale DX Compose deployments targeting 30,000 concurrent users in AWS, initialize the Kubernetes cluster with 1 master node and 14 worker nodes.

- To hold more authenticated users for testing purposes, increase the `OpenLDAP` pod values. Note that the deployment of the `OpenLDAP`container in a production environment is not supported.

- To optimize the `webEngine` container, increase the CPU allocation until the container saturates. After the optimal CPU level is determined, increase the number of pods to boost performance.

- To improve response times, increase the number of `webEngine` pods proportionally to the user load. For example, 8 `webEngine` pods were used for a load of 10,000 concurrent users, and 25 webEngine pods for a load of 30,000 concurrent users.

- To maintain DAM performance, add approximately 1-2 additional pods to the DAM service for every 10,000 concurrent users.

- To ensure proper load balancing, add 1 additional pod to the HAProxy service for every 10,000 concurrent users.

- To manage database connections efficiently, add 1 additional pod to the Persistence Connection Pool service for every 10,000 concurrent users.

- For effective data persistence, add 1 additional pod to the Persistence Node service for every 10,000 concurrent users.

- To support API requests, add approximately 1 additional pod to the Ring API service for every 10,000 concurrent users.

- To improve the response times, perform the Helm upgrade using the `webengine-performance-rendering.yaml` file. This file is available in the HCL DX Compose Deployment Helm chart. To use this file, complete the following steps:

    1. Download the `hcl-dx-deployment` Helm chart from Harbor.
    2. Extract the `hcl-dx-deployment-XXX.tgz` file.
    3. In the extracted folder, navigate to `hcl-dx-deployment/performance/webengine-performance-rendering.yaml` and copy the `webengine-performance-rendering.yaml`.

    After performing a Helm upgrade using the `webengine-performance-rendering.yaml` file, the tuned cache values for rendering will be updated.

### Recommended heap size configuration

To ensure optimal performance and stability of HCL DX on Kubernetes, it is essential for you to configure JVM heap memory and pod resource limits correctly. Refer to the following best practices when tuning memory allocation.

!!!note
     Do not set your JVM heap size larger than the allotted memory for the pod.

- Ensure your minimum heap size (`-Xms`) is equal to your maximum heap size (`-Xmx`).
      - Setting the minimum and maximum heap sizes to the same value prevents the JVM from dynamically requesting additional memory (`malloc()`).
      - This eliminates the overhead of heap expansion and improves performance consistency.

- Ensure the Kubernetes pod resource limits match the JVM heap settings
      - The requested memory (`requests.memory`) should match the limit (`limits.memory`) in the pod specification.
      - This ensures that the container is allocated a fixed memory block and prevents unexpected memory reallocation, which could lead to performance degradation or out-of-memory (OOM) errors.

- Determine the final memory requirements based on load testing
      - To determine the optimal memory configuration, you should conduct local testing with your specific portlets, pages, and customizations. You should also perform synthetic load testing using tools like JMeter to simulate realistic usage scenarios.
      - The required memory is highly dependent on Service Level Agreements (SLAs) and transaction rates.
      - A minimum of 3.5GB is recommended, but higher memory allocations may be necessary depending on actual usage patterns.
