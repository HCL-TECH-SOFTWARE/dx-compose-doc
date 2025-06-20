# HCL Digital Experience Compose 9.5 entitlement checks and usage reporting

!!!Important
    Starting March 31, 2025, the software download packages for all current and future HCL Digital Experience (DX) offering product releases will be available through the [My HCLSoftware (MHS)](https://my.hcltechsw.com/){target="_blank"} portal. Customers should plan to transition to access their entitled DX software using the MHS portal by June 30, 2025. For more information refer to [HCL Digital Experience offerings are now available for download from the MyHCLSoftware portal](https://support.hcl-software.com/csm?id=kb_article&sysparm_article=KB0120373){target="_blank"}

The [MHS portal](https://support.hcl-software.com/csm?id=kb_article&sysparm_article=KB0109011){target="_blank"} supports entitlement checking and usage reporting for several HCL Software solutions, including the HCL DX Compose 9.5 Tiers 1 - 3 offerings in the HCL DX portfolio. By checking entitlements, you can track purchased software entitlement periods and usage levels.

For Kubernetes deployments, the HCL License Manager container service is configured to check entitlements and record usage that can be reported to the MHS delivery portal. If you cannot or do not want to integrate directly with a delivery portal for automatic online reporting, you may use alternative options such as producing report extracts in a simple file format, that can be read, uploaded periodically, and shared in other ways. Refer to [Reporting Options](#reporting-options) to identify how to report usage for Kubernetes and traditional deployments.

A standalone tool called the [User Session Reporting Tool](./user_session_reporting_tool.md) was delivered and is available from DX Compose entitlements in the MHS delivery portal.

### Entitlement-check scenarios

When the HCL DX Compose 9.5 License Manager container service starts, and entitlement checking and usage reporting are enabled, it will perform an entitlement check against the configured software delivery portal and report the result of that check in log messages.

During the grace period and beyond, messages are displayed in the License Manager container logs as a reminder that the contracted entitlement has expired. If you encounter these messages, contact your HCL salesperson to discuss the entitlement.

!!!note
    - The grace period is 28 days. This period is determined and defined by the entitlement server. During this time, the DX Compose 9.5 server starts, despite failing an entitlement check.
    - To confirm that your entitlement is verified and that your HCL DX Compose 9.5 server is not in the grace period, access the HCL DX v9.5 Container Update Log Manager pod logs. However, you must first ensure that your DX Compose 9.5 deployment Helm chart is configured for entitlement checking to verify that there are no HCL DX Compose 9.5 entitlement messages.

The following table describes the possible entitlement-check response scenarios and the corresponding behavior of the HCL DX Compose 9.5 Tiers 1 - 3 services.

| Entitlement-Check Response Scenario | HCL DX Compose 9.5 Server Behavior |
| ----------- | ----------- |
| 1. The connection to the entitlement server is successful. You have a valid HCL DX Compose 9.5 entitlement.|The HCL DX Compose 9.5 server starts.|
| 2. The connection to the entitlement server is successful. The HCL DX Compose 9.5 entitlement has expired. You are operating within the HCL DX Compose 9.5 entitlement grace period.|HCL DX Compose 9.5 server starts. The following message is included in the server-side log file and on another DX location: <br><br> `HCL DX Compose 9.5 entitlement has ended on expiry date. The grace period will expire in (number of days remaining). To avoid interruption in service, please contact your HCL salesperson to resolve the entitlement issue.`|
| 3. The connection to the entitlement server is successful. You do not have a valid HCL DX Compose 9.5 entitlement. |HCL DX Compose 9.5 server starts. The following message is included in the server-side log file: <br><br> `HCL DX Compose 9.5 entitlement grace period has ended on grace period end date. Resolve this issue to avoid interruption in the service.`|
| 4. The connection to the entitlement server fails. The HCL DX Compose 9.5 entitlement grace period has started.|HCL DX Compose 9.5 server starts. The following message is included in the server-side log file in the HCL DX 9.5 Container Update License Manager pod logs: <br><br> `The connection to the entitlement server failed. HCL DX C_Compose_N 9.5 entitlement grace period of four weeks has started and will expire on (grace period end date). Please contact HCL Support to resolve the connection issue and try again.`|
| 5. The connection to the entitlement server fails. You are operating within the HCL DX Compose 9.5 entitlement grace period.|HCL DX Compose 9.5 server starts. The following message is included in the HCL DX 9.5 Container Update License Manager pod logs: <br><br> `The connection to the entitlement server failed. You are currently operating within the HCL DX Compose 9.5 entitlement grace period of four weeks, which expires on (grace period end date). Please contact HCL Support to resolve the connection issue and try again.`|
| 6. The connection to the entitlement server fails. The HCL DX Compose 9.5 entitlement grace period has expired.|The following message is included in the HCL DX 9.5 Container Update License Manager pod logs: <br><br> `HCL DX Compose 9.5 entitlement grace period has ended on (grace period end date). If you feel this is an error, please log in to the HCL Customer Support portal ([https://support.hcltechsw.com/csm](https://support.hcltechsw.com/csm)) and open a Licensing case (New cases > Licensing case). Otherwise, contact your HCL salesperson to update your licensing.`<br><br> If you require an extension to the grace period, you can contact support for a one-time extension of up to 14 additional days. |

## HCL DX Compose v9.5 Usage Reporting

### Reporting options

When reporting product usage in HCL DX Compose, the method of reporting depends on the connectivity of your deployment to external licensing services. Two primary modes are available: online and offline (disconnected) usage reporting.

1. Online usage reporting: In online mode, the deployment is connected to the internet and can communicate directly with the MHS license service. Usage data such as user sessions or feature utilization is automatically reported in near real-time through integrated APIs. This is the most seamless and automated method of entitlement tracking and compliance.

2. Offline (disconnected) usage reporting: In offline or disconnected mode, the environment has no external connectivity to licensing servers. This is common in air-gapped, on-premises, or highly secure deployments. In this mode, usage data must be collected manually, converted into supported metric formats, and uploaded manually through a web portal.

Refer to the following table to determine the appropriate reporting method for your existing deployment. It outlines the available usage reporting options for Kubernetes environments, along with the corresponding MHS portal and documentation links.

| **Reporting Target**     | **Deployment Type** | **Further Information**                                                                                                                                             |
|-------------------------|---------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **My HCLSoftware**      | Kubernetes          | [Online Reporting](./mhs_license_and_delivery.md)                                                                     |
|                         | Kubernetes          | [Offline / Disconnected Reporting](./configuring_mhs_file_base_session_reporting.md#mhs-file-based-usage-reporting-for-kubernetes-deployments)                       |
| **Manual Export**       | Kubernetes          | [Manual Report Extracts](./export_usage_report.md)                                                                                                                   |

### Monitoring user-session consumption for HCL DX Compose v9.5 production deployments

!!! note
    Calculating and reporting user session consumption produces the same results, regardless of which software delivery portal is being used.

The MHS delivery portal will collect usage information of HCL Software offerings that have been developed to report usage metrics. This information includes HCL DX Compose 9.5 Tiers 1 - 3 offerings for production deployments.

HCL DX Compose 9.5 Tiers 1 - 3 offerings are purchased according to the number of user sessions to be consumed annually. A user session is defined as a single web session or other online interaction by anonymous or authenticated users of the program when it is deployed for production use. User sessions also include API calls, which deliver production-use website content or application data to external resources, excluding deliveries to a content-delivery network.

- A user session begins when a user (authenticated or anonymous) visits a DX Compose deployment operating for production use and then interacts with program website pages and is identified through appropriate tags that use the appropriate scripts for each site page view request. User session interactions can include one or more production-use website page views.

- A user session ends when the user interaction with the production-use program is idle for 30 minutes or until the user ends the interaction explicitly by closing their authentication or web session with the site.

- The maximum duration for an individual user session with continuous interactions is four hours.

To be included in these reports, your HCL DX Compose 9.5 entitlements must be:

- Mapped to the appropriate software delivery portal for entitlement checking.
- Configured for production use in your deployment Helm charts.

For more information, refer to [Announcing HCLSoftware Download site and Licensing mechanism changes](https://support.hcl-software.com/csm?id=kb_article&sysparm_article=KB0112538){target="_blank"} and [HCL Digital Experience offerings are now available for download from the MyHCLSoftware portal](https://support.hcl-software.com/csm?id=kb_article&sysparm_article=KB0120373){target="_blank"}.

### How user sessions in production deployments are calculated for report totals

HCL DX Compose 9.5 applies the following approach when it reports totals for user-session consumption in deployments configured for production:

When a user interacts with an HCL DX Compose 9.5 production deployment site, the License Manager pod, in conjunction with the HAProxy Pod, coordinates a combination of IP address and user agent to identify a unique user session. For every request, a key is computed based on the requesting IP of the user, combined with the user agent and a forwarding header (`X-Forwarded-For`) for proxy (if a customer uses a proxy in their deployment setup) usage. Subsequent interactions during the same user session period use that key to identify the same user.

This information is stored in memory only for up to four hours and is discarded afterwards. This information is only accessible by a Kubernetes administrator with permissions to access the log files. HCL cannot access this information at any time.

Some customers might choose to use a proxy, for example, a load balancer, DMZ endpoint, or other service that resides between the user and the HCL DX Compose 9.5 deployment. In that case, the customer should ensure the relevant information to facilitate user-session tracking arrives properly at the DX deployment for accurate tracking.

The License Manager pod manages entitlement checking and user-session consumption reporting for production deployments.

The License Manager uses the MHS service endpoint configured to transmit the data total amount and each API request contains in its entirety the following data:

- Timestamp of data transmission (implicit in the call, not explicitly provided)
- Deployment identification information
- Total number of completed user sessions calculated by the License Manager since the last transmission

For more information about MHS entitlement checking and usage reporting, see [Entitlement checking in My HCLSoftware delivery portal](./mhs_license_and_delivery.md).