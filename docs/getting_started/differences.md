# Differences from DX Core

This topic provides more information about the differences of the Digital Experience (DX) Compose WebEngine container from the [DX Offerings Core container](https://opensource.hcltechsw.com/digital-experience/latest/deployment/install/container/overview/){target="_blank"}.

## Java

- To ensure improved security, modern features, and enhanced performance, WebEngine transitioned from Java 7/8 to Java 21 and is planned to eventually support later versions of Java.
- WebEngine moved from IBM Java Development Kit (JDK) to Open JDK, specifically Semeru, to benefit from the latest updates and community support.

## J2EE

To enhance your application's capabilities and maintain compatibility with modern standards, DX Compose migrated from Java 2 Enterprise Edition (J2EE) v6 to J2EE v8. This update includes adopting the following components, among others:

- **Enterprise JavaBeans (EJB) 3.2**: This version of EJB offers improved functionality and performance.
- **Java Database Connectivity (JDBC) 4.x**: This update to the JDBC API provides enhanced support for database operations.
- **Servlet 4**: This version introduces new features and improvements for handling web requests and responses.
- **Java Message Service (JMS) 2**: The latest update to the JMS API facilitates more efficient and flexible messaging.

The migration process is streamlined by using pluggable configuration in Open Liberty, which makes it easier to transition to later versions of Java EE as they become available. In addition, planning for a transition to Jakarta EE will ensure that your application remains up-to-date with the evolving standards of enterprise Java technology.

## Libraries

HCL DX offerings utilize the IBM WebSphere Application Server (WAS) as the base application server, and include support for several old and outdated APIs such as Apache commons API, Hibernate, JSF, Struts, Spring, and more. In DX Compose, which is deployed on Open Liberty, these have been updated and are also now pluggable through configuration in the `server.xml`, allowing APIs to move to modern versions.

## Security

- The security J2EE standards such as authentication and authorization have been updated with Open Liberty.
- The former Virtual Member Manager feature is no longer available in Open Liberty. However, features such as federation for multiple LDAPs are available.
- The file-based repository is configured out-of-the box. You can configure one or multiple LDAPs.
- The configuration is different with DX Compose. Instead of using the Configuration Wizard or ConfigEngine, the configuration now happens through the Helm chart, influencing the `server.xml` and related DX Compose resource environment providers.
- User and group management is only possible for read-only scenarios.

## Deployment

- DX Compose is available for Kubernetes-based deployments and Docker Compose for developers. It ships out-of-the-box with Derby and can be transitioned to other databases for production. Currently, the supported database is IBM DB2.
- The configuration is consolidated in the Helm chart. ConfigEngine, Configuration Wizard, and wsadmin are no longer required.

## Search

DX Compose uses new Search containers based on OpenSearch.

## Administration

- Changes done previously with ConfigEngine or the WAS console are consolidated in the Helm chart.
- Page, Web Content Manager (WCM), and other artifacts are managed using the DX Practitioner user interface, just as in HCL DX.

## Default ports

- With DX Offerings, using Core on WAS, the internal default ports are `10039` for `http` and `10041` or `10042` for `https`.
- For DX Compose core WebEngine, the internal default ports are `9080` and `9043` for `https`.
- For both Core on WAS and WebEngine when accessing through Docker Compose or Kubernetes, the default ports are `80` for `http` and `443` for `https`.

## Limitations

For more information about the limitations of DX Compose, see [Limitations](limitations.md).
