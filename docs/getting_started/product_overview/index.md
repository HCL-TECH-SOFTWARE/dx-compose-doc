# DX Compose overview

HCL Digital Experience (DX) Compose provides an updated Core container called WebEngine that runs on [Open Liberty](https://openliberty.io/){target="_blank"} instead of IBM WebSphere Application Server. The initial release is focused on running web content, custom Script Applications, and themes on WebEngine. The ability to run custom Java applications and extensions is planned for a DX Compose future delivery. This statement is not a guarantee of future releases or their features.

In addition, DX features such as Web Content Management (WCM), Personalization, secure and role-based delivery, virtual portals, Script Applications, Digital Asset Management (DAM), and Content Composer integration are available in the DX Compose product.

DX Compose is delivered as a set of container images and attached Helm charts to deploy to a Kubernetes system or Docker Compose. Note that DX Compose is not supported for a non-container installation.

- **[Features](./features.md)**  
Learn about the core capabilities and functional components of DX Compose.
- **[Limitations](./limitations.md)**  
Learn about the current constraints and unsupported configurations in DX Compose.
- **[Differences between DX Compose and DX Core](./differences.md)**  
Learn about the architectural, deployment, and resource management differences between DX Compose and DX Core.

## Java Transition Module for DX Compose

The HCL Java Transition Module for DX Compose, available separately, provides services and extensions to install Java-based workloads on the DX Compose platform.  This module helps DX Compose customers transition key Java workloads deployed on [HCL DX solutions on the IBM WebSphere Application base](https://help.hcl-software.com/digital-experience/9.5/latest/get_started/product_overview/offerings/){target="_blank"} to operate on the DX Compose platform.  

Customers entitled to the HCL Java Transition Module for DX Compose will find installation documentation in their [My HCLSoftware (MHS)](https://support.hcl-software.com/csm?id=kb_article&sysparm_article=KB0109011){target="_blank"} portal entitlement downloads.

!!!note
    In this release, instructions for using select features are located in the [HCL DX Help Center](https://help.hcl-software.com/digital-experience/9.5/latest/){target="_blank"}. These will be documented in the HCL DX Compose Help Center in future releases.
