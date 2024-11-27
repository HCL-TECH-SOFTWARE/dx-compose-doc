# Differences from DX Core

This topic provides more information about the differences of the Digital Experience (DX) Compose WebEngine container from the DX Core container.

## Java

- To ensure improved security, modern features, and enhanced performance, WebEngine transitioned from Java 7/8 to Java 11 and is planned to eventually support later versions of Java.
- WebEngine moved from IBM Java Development Kit (JDK) to Open JDK, specifically Temurin, to benefit from the latest updates and community support.

## J2EE

To enhance your application's capabilities and maintain compatibility with modern standards, WebEngine migrated from Java 2 Enterprise Edition (J2EE) v6 to J2EE v8. This update includes adopting the following components among others:

- Enterprise JavaBeans (EJB) 3.2: This version of Enterprise JavaBeans offers improved functionality and performance.
- Java Database Connectivity (JDBC) 4.x: This update to the Java Database Connectivity API provides enhanced support for database operations.
- Servlet 4: This version introduces new features and improvements for handling web requests and responses.
- Java Message Service (JMS) 2: The latest update to the JMS API facilitates more efficient and flexible messaging.

The migration process is streamlined by using pluggable configuration in Liberty, which makes it easier to transition to later versions of Java EE as they become available. Furthermore, planning for an eventual transition to Jakarta EE will ensure that your application remains up-to-date with the evolving standards of enterprise Java technology.

## Libraries

With WebSphere Application Server (WAS), several old and outdated APIs were in place such as Apache commons API, Hibernate, JSF, Struts, Spring, and more. In Open Liberty, these have been updated and are also now pluggable through configuration in the `server.xml`, allowing APIs to move to modern versions.

## Security

- The security J2EE standards such as authentication and authorization have been updated with Open Liberty.
- The former Virtual Member Manager feature is no longer available in Open Liberty but features like federation for multiple LDAPs are available.
- The file-based repository is configured out-of-the box. You can configure one or multiple LDAPs.
- The configuration is different with WebEngine. Instead of using Configuration Wizard or ConfigEngine, the configuration now happens through the Helm chart influencing the `server.xml` and related WebEngine resource environment providers.
- User and group management is only possible for read-only scenarios.

## Deployment

- WebEngine is available for Kubernetes-based deployments and Docker Compose for developers. It ships out-of-the-box with Derby and can be transitioned to other databases for production. Currently, the supported database is IBM DB2.
- The configuration is consolidated in the Helm chart. Configuration Engine, Configuration Wizard, or wsadmin are no longer required.

## Search

WebEngine uses new Search containers based on OpenSearch.

## Administration

- Changes done previously with ConfigEngine or the WAS console are consolidated in the have been consolidated in the Helm chart.
- Page, Web Content Manager (WCM), and other artifacts are managed using the DX Practitioner user interface, just as in HCL DX.

## Default ports

- With Core on WAS, the internal default ports are `10039` for `http` and `10041/10042` for `https`.
- For WebEngine, the internal default ports are `9080` and `9043` for https.
- For both Core on WAS and WebEngone when accessing through Docker Compose or Kubernetes, the default ports are `80` for `http` and `443` for `https`.

## Theme

When customizing a theme on WebEngine, you can only update and modify the static theme and skin resources deployed to WebDAV. Currently, the dynamic theme resources cannot be modified.

## Limitations

Fore more information about the limitations of DX Compose, see [Limitations](limitations.md).