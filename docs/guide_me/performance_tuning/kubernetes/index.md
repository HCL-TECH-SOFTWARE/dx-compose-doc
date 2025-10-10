# Performance sizing guide for Kubernetes deployments

This section provides sizing guidance for HCL Digital Experience (DX) Compose rendering scenarios in a Kubernetes configuration.  
The guidance identifies the optimal Kubernetes configurations for small, medium, and large DX workloads.  
It also includes tuning recommendations for Kubernetes pods based on their specific workloads, such as rendering-intensive tasks.

## Introduction

DX Compose performance testing determines container sizing and the relationships between DX components.  
This guide evaluates configurations that support 1,000 (small) and 30,000 (large) virtual users.

The key performance indicators in these tests are the number of concurrent users, the average response time, and throughput. These metrics serve as benchmarks for evaluating the performance of small DX Compose configurations and offer insights into the system's capacity to handle varying loads. This sizing guidance demonstrates how strategic adjustments can result in significant performance improvements.

The sizing tests examined rendering scenarios for the Web Content Manager (WCM), Digital Asset Management (DAM), and HCL DX Compose pages and portlets. The tests were facilitated by rendering setups deployed on AWS/Native-Kubernetes, where Kubernetes is installed directly in Amazon Elastic Cloud Compute (EC2) instances. This guide presents a comprehensive overview of the findings, offering guidance for organizations seeking to optimize their DX Compose platforms for peak performance.

## Definition of terms

Refer to the following definition of terms used throughout the performance tests and sizing guidances:

- Concurrent user: The number of virtual users actively sending requests to the target application simultaneously.

- **Thread groups:** Concurrent users are simulated using thread groups, which are configured with the number of threads (users), the ramp-up period, and the loop count.
    - **Number of threads (users):** The number of concurrent users.  
- **Ramp-up period:** The time required to start all threads (users).  
- **Loop count:** The number of iterations each user performs.
    - Think Time: A timer that can be added to simulate real user behavior. Adding Think Time introduces delays between user actions, which may cause fluctuations in the number of concurrent users at any moment.
    
        For example, Threads (Users): 100, Ramp-up Period: 10 seconds, Loop Count: 1.

        This means JMeter will simulate loading 100 users over 10 seconds, leading to approximately 10 users per second.

- Authenticated user: A Portal “User” role.
- Unauthenticated user:  A Portal “anonymous portal user” role.
- OpenLDAP:  An open-source implementation of LDAP (Lightweight Directory Access Protocol). All authenticated Users are added to OpenLDAP.

**Metrics**

- Average response time: The average time taken to receive a response from the server for all the requests made during the test.
- 95th Percentile Response Time (95th pct): The response time below which 95% of the requests were completed. Only 5% of the requests took longer than this time to complete.
- Throughput: The number of requests processed by the system per unit of time. For example, requests per second or per minute.

## Methodology

Refer to the following methodology used for the performance tests.

### Overview of DX Compose rendering sizing-performance tests

These sizing tests evaluated rendering scenarios for WCM, DAM, and HCL DX Compose pages and portlets. The activities used a rendering setup in AWS/Native-Kubernetes, where Kubernetes was installed directly on Amazon EC2 instances. Combination runs were performed that rendered WCM content, DAM assets, and DX Compose pages and portlets. The load distribution was WCM content (40%), DAM assets (30%), and DX Compose pages and portlets (30%). All systems were pre-populated before performing the rendering tests.

### Rendering scenarios and users details

The following table contains the rendering scenario details for the small configuration setup.

| Concurrent users     |  WCM pages         |  DAM Content         |  Pages and portlets content   |
| -------------------- | ------------------ | -------------------- | ----------------------------- |
| Small – 1,000 users  | 20                 | 2,500                |    6                          |

- The concurrent user load distribution are as follows:
    - WCM: 40% of the user load (50% authenticated and 50% anonymous).
    - Pages and Portlets: 30% of the user load (50% authenticated and 50% anonymous).
    - DAM: 30% of the user load (all anonymous).

    Refer to the [DX Sizing rendering scenarios guide](./dxsizing_rendering_scenarios.pdf){target="_blank"} for more information.

- All authenticated users were added to openLDAP with the "User" role.
- The same users are utilized for both WCM and Pages and Portlets. 

#### Test data details

Based on the rendering scenarios and user details for small configurations, the following test data are created to support the DX rendering performance tests:

- [WCM default test data](#wcm-default-test-data)
- [DAM default test data](#dam-default-test-data)
- [Pages and portlets default test data](#pages-and-portlets-default-test-data)

#### WCM default test data

The following WCM setup is commonly used in scenarios where there are multi-nested site areas in libraries with content such as rich text, PDF files, and images in a page. 20 pages are used for the small configuration testing. Refer to the following list for more information about this setup:

- The default test data includes a WCM design library named "PerformanceTestDesign" and five content libraries named "PerformanceTestContent01" to "PerformanceTestContent05."

- Each content library has four site area levels, with each level containing four site areas. As a result, there are a total of 256 leaf site areas containing content.

- Each leaf site area holds 10 content items, resulting in a total of 12,800 content items across all libraries.

**Content visibility**

- Half of the content items are accessible to both "Anonymous" and "All Authenticated" users.

- The remaining half is restricted to members of 10 specific groups per content item, distributed among 500 groups in the test LDAP. The groups are named "Group0000" to "Group0499." Half of these restricted content items are tagged with the keyword "MENU" for categorization.

**Portal page setup**

- There are 20 test portal pages labeled "PerformanceTest." Each page is accessible through a user-friendly URL format such as `/perf/page-xx`.

- Each page contains six WCM viewer portlets that display content from one of the 20 top-level site areas.

- Pages 01 to 04 display content from site areas "SA01" to "SA04" in the "PerformanceTestContent01" library.

- Pages 05 to 08 display content from site areas "SA01" to "SA04" in the "PerformanceTestContent02" library, and so on.

**Portlet configurations**

- Four portlets on each page display a single content item from different sub-site areas. For example, on page 01, the portlets will display content items from "SA01.01.01.01," "SA01.02.01.01," and so on.

- One portlet provides a navigator for browsing site areas and content items under the top-level site area.

- The final portlet presents a menu that filters items tagged with the keyword "MENU," scoped to the top-level site area.

**User setup**

A total of 99,999 authenticated users were added to openLDAP for performance testing.

#### DAM default test data

The following DAM setup covers the different types of the most commonly used assets in three different ways: UUID, custom, and friendly URLs. Testers uploaded 2,500 assets for the small configuration testing. These assets include 136 KB JPG images, 199 KB DOCX documents, and 1.1 MB MP4 videos to preheat the environment. After preloading the assets for the respective configurations, 15 assets containing a mix of original images and renditions were uploaded and rendered for one hour at peak load, following the ramp-up time.

The test rendered assets using three custom URLs, eight UUID URLs, and eight friendly URLs over one hour. Refer to the detailed summary of the results below.

| Asset    | Type          | Size                                            |
| -------- | ------------- |-------------------------------------------------|
| Image    | JPG/PNG/TIF   | 155 KB, 2 MB, 5 MB, 500 KB, 100 KB, 2 MB, 300 KB|
| Video    | MP4/WebM      | MP4 - 1 MB, 15 MB, 100 MB<br> WebM - 2 MB       |
| Document | DOCX/XLSX/PPTX| 5 MB, 199 KB, 200 KB, 2 MB, 199 KB              |

Examples of DAM asset rendering APIs of UUID, Custom URL, and Friendly URL are provided below:

- UUID: `https://<host-name>/dx/api/dam/v1/collections/f5764415-afd3-4b18-90ab-5c933e9965a8/items/b2204c8f-bd26-4f9b-865f-1fc1f8e26a13/renditions/09d278d6-1ae7-4a2a-950d-c1fa7f0bacde?binary=true`.
    
- Custom: `https://<host-name>/dx/api/dam/custom/customURL2-1715776542673?binary=true`.
    
- Friendly: `https://<host-name>/dx/api/dam/v1/assets/Jmeter.11667/wcm-sample-content.png?rendition=Tablet?binary=true`.

!!!note
      For DAM, only anonymous rendering is available.

#### Pages and portlets default test data

The following setup includes different types of commonly used portlets. Performance tests measure the response time required to render an entire page along with its associated portlets. Knowing the response times for rendering pages is important, as the portlets on these pages are frequently used in DX Compose content. Refer to the following list for more information about this setup:

- The tests included 6 unique pages with portlets for the small configuration.
- Both anonymous and authenticated users were granted access for authoring and rendering. The same users utilized in WCM rendering are also used here.
- All authenticated users were assigned the "User" role.
- The following list shows the pages, their corresponding page numbers, and the portlet details for authoring on each page:
    - Page 1: Two articles.
    - Page 2: Two rich texts.
    - Page 3: Login portlet.
    - Page 4: Information portlet (JSR).
    - Page 5: Script Application portlet. Added JavaScript Functions and Date and Time object examples.
    - Page 6: Added all mentioned portlets in this section.

    !!!Note
        The JSP portlet file required to load Page 4 and render its portlets is located at `jsp/oob/welcome.jsp`.

Once the authoring steps are completed, both anonymous and authenticated portal users will render the pages. Each page request is triggered using a `/GET` API call such as `/wps/portal/portletsperf/page1`. A response assertion in the sampler also validates the HTML content in the response body.

## JVM heap and pod resource guidelines for performance runs
During performance testing, align JVM heap settings with pod resource limits to ensure consistent performance and prevent unexpected memory issues.

### Memory Requests and Limits

Set the pod’s `requests.memory` value to match its `limits.memory` value. This configuration ensures that the container receives a fixed memory allocation and prevents memory overcommit or out-of-memory (OOM) errors.

### JVM heap size alignment
- Ensure the JVM heap (`-Xms` and `-Xmx`) is smaller than the pod’s memory limit.  
- Leave headroom for:
      - Non-heap memory (Metaspace, thread stacks, direct buffers)
      - Sidecar containers (if any)
      - Additional JVM processes (for example, `server1`)
- Set `-Xms` and `-Xmx` to the same value (for example, 4GB) for performance runs.  This setting prevents dynamic heap expansion, reduces overhead, and ensures stable, predictable performance.

### Equal minimum and maximum heap

- Set `-Xms` and `-Xmx` to the same value (for example, `4g`) for performance runs.  
- This configuration prevents dynamic heap expansion, reduces overhead, and ensures stable, predictable performance.

### Determine final memory requirements

- Conduct local testing with your specific portlets, pages, and customizations.  
- Perform synthetic load testing by using tools such as JMeter to simulate realistic usage scenarios.  
- Adjust memory allocations based on service-level agreements (SLAs) and transaction rates.  
- Allocate a minimum of 3.5 GB of heap memory. Higher allocations might be required depending on actual usage patterns.

### Recommended configuration for performance runs (Core pod)


| Resource type | Setting | Notes |
|----------------|----------|-------|
| Pod memory (`requests` and `limits`) | 8 GB | Fixed allocation |
| JVM heap (`-Xms` / `-Xmx`) | 4 GB (up to 6 GB if pod memory is 8 GB) | Leaves sufficient headroom |
| CPU (`requests` and `limits`) | 5.6 CPUs | Recommended for stable performance |

This configuration leaves approximately **4 GB of memory headroom for non-heap usage and container overhead, ensuring stability during load testing.

## Limitations

These performance tests are primarily focused on DAM API. Client-side rendering, such as browser-based rendering, is excluded from the tests.

???+ info "Related information"
    - For details about the environments used, test results, and recommendations for each configuration, see [Sizing guidance for rendering in a small Kubernetes configuration](./rendering_small_config.md)