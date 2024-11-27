# Differences

More than you might expect, but comfortably manageable.

## Java
To ensure improved security, modern features, and enhanced performance, WebEngine has transitioned from Java 7/8 to Java 11 and is planning to eventually support later versions of Java.
Additionally, WebEngine moved from IBM JDK to Open JDK, specifically Temurin, to benefit from the latest updates and community support.

## J2EE
To enhance your application's capabilities and maintain compatibility with modern standards, WebEngine migrated from J2EE v6 to J2EE v8. This update includes adopting the following components among others:

EJB 3.2: This version of Enterprise JavaBeans offers improved functionality and performance.
JDBC 4.x: This update to the Java Database Connectivity API provides enhanced support for database operations.
Servlet 4: This version introduces new features and improvements for handling web requests and responses.
JMS 2: The latest update to the Java Message Service API facilitates more efficient and flexible messaging.

The migration process is streamlined by using pluggable configuration in Liberty, which makes it easier to transition to later versions of Java EE as they become available. Furthermore, planning for an eventual transition to Jakarta EE will ensure that your application remains up-to-date with the evolving standards of enterprise Java technology.

## Libraries
With WebSphere Application Server a lot of old and outdated APIs were in place like Apache commons API, Hibernate, JSF, Struts, Spring, and others. In Liberty these have been updated and are also now pluggable via configuration in the server.xml.
This allows to move to modern versions.

## Security
The security J2EE standards like authentication and authorization have been updated with Open Liberty.
The former Virtual Member Manager feature is no longer available in Open Liberty but features like federation for multiple LDAPs are available.
The file based repository is configured out of the box. One or multiple LDAPs can be configured.
The configuration is different with WebEngine - instead of using Configuration Wizard or ConfigEngine the configuration now happens via helm influencing the server.xml and related WebEngine resource environment providers.
User and group management is only possible for read only scenarios.

## Deployment
WebEngine is available for Kubernetes based deployments and docker compose for developers. It ships out of the box with Derby and can be transitioned to other databases for production - at this time IBM DB2.
The configuration has been consolidated to helm - Configuration Engine or Configuration Wizard or wsadmin are no longer required.

## Search
WebEngine uses the new Search containers based on open search.

## Administration
Changes done formerly with ConfigEngine or the WAS console have been consolidated to helm.
Page or WCM or other artifacts are managed via the DX Practitioner user interface as before.

## Default Ports
With Core on WAS the internal default ports are 10039 for http and 10041/10042 for https.
For WebEngine the internal default ports are 9080 and 9043 for https.
For both when accessing via docker compose or Kubernetes it is the default ports 80 for http and 443 for https.

## Theme
When customizing a theme on WebEngine, only the static theme and skin resources deployed to WebDAV can be updated and modified. Currently the dynamic theme resources cannot be modified.

## Limitations
Note more details in the [Limitations](limitations.md) document.