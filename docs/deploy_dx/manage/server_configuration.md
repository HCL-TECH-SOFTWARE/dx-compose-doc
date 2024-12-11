---
id: server-configuration
title: Server Configuration
---

## WebEngine Server Configuration
The configuration of the WebEngine server is primarily defined by a mandatory file named `server.xml`. This file is crucial as it contains the core settings required for the server to operate correctly. The `server.xml` file must adhere to the following specifications:

1. **XML Format**: The `server.xml` file must be a well-formed XML document. This means it should follow the standard XML syntax rules, such as having a single root element, properly nested tags, and correctly closed elements.

2. **Root Element**: The root element of the `server.xml` file must be <server>. This element serves as the container for all other configuration settings within the file.

3. **Element and Attribute Handling**: During the processing of the `server.xml` file, the server will parse and apply the configuration settings defined within it. However, any elements or attributes that the server does not recognize or understand will be ignored. This allows for flexibility in the configuration file, enabling the inclusion of custom or future settings without causing errors.

In addition to the `server.xml` file, the WebEngine server configuration can include a set of optional files. These optional files can provide additional configuration settings or override specific settings defined in the `server.xml` file. However, the presence and structure of these optional files are not strictly enforced, and their usage depends on the specific requirements of the server setup.

By adhering to these guidelines, the `server.xml` file ensures a consistent and reliable configuration for the WebEngine server, while also allowing for extensibility and customization.

## Core Features
### Java EE
WebEngine offers extensive support for Java EE (Java Platform, Enterprise Edition), which is a set of specifications and standards designed for developing large-scale, multi-tiered, scalable, and secure enterprise applications. Java EE provides a robust framework for building web applications, enterprise services, and distributed systems. It includes APIs for database access, messaging, web services, and more, enabling developers to create sophisticated and high-performance applications that can handle complex business logic and large user bases. With WebEngine's support for Java EE, developers can leverage these powerful tools and technologies to streamline development processes, ensure application reliability, and enhance security.

### Administration Center
The Administration Center is a centralized interface designed for the management and monitoring of the application server and its associated resources. This interface allows administrators to efficiently oversee server configurations, performance metrics, and other critical aspects of server management.

One of the key features of the Administration Center is the ability to monitor the `server.xml` configuration file. This file contains essential configuration details for the server, such as network settings, resource allocations, and security configurations.

Administrators can access the `server.xml` file through the Administration Center using the following URL template:
```
https://<domain-name>/adminCenter/#explore/serverConfig/${server.config.dir}/server.xml
```
In this URL:

`<domain-name>` should be replaced with the actual domain name of your server.
`${server.config.dir}` is a placeholder for the directory path where the `server.xml` file is located.
By navigating to this URL, administrators can view and manage the server configuration settings directly from the Administration Center, ensuring that the server operates smoothly and efficiently.

### DX Application Extensions
DX Application Extensions provide a framework for extending and customizing DX applications to meet specific business requirements. This includes the ability to add new features, modify existing functionalities, and integrate with other systems. The extensions can be developed using standard programming languages and tools, and they can be deployed and managed within the DX environment.

By leveraging DX Application Extensions, organizations can tailor their DX applications to better align with their unique business processes and requirements.

### REST Connector
The REST Connector facilitates seamless integration with external systems and services through RESTful APIs. This connector allows applications to communicate over HTTP/HTTPS using standard HTTP methods such as GET, POST, PUT, DELETE, and PATCH.

By leveraging the REST Connector, developers can easily integrate their applications with third-party services, enabling data exchange and functionality extension without compromising security or performance.

### Database Connectivity
The server supports robust connectivity to a wide range of databases, ensuring seamless data management and retrieval. This includes support for relational databases such as MySQL, PostgreSQL, Oracle, and SQL Server, as well as NoSQL databases like MongoDB and Cassandra.

By leveraging these features, developers and administrators can ensure efficient and secure database connectivity, enabling their applications to handle data-intensive operations with ease.


## Application Management
### Web Container Settings
The Web Container Settings are responsible for managing the lifecycle of servlets and web applications within the server. This includes the deployment, initialization, execution, and termination of web applications, ensuring they run efficiently and reliably.

By leveraging these Web Container Settings, administrators can ensure that web applications are deployed and managed effectively, providing a stable and high-performance environment for end-users.

### Portlet Container Settings
The Portlet Container Settings are responsible for managing the lifecycle and execution of portlet-based applications within the server. Portlets are pluggable user interface components that are managed and displayed in a web portal. They are designed to deliver dynamic content and enhance user interaction and experience.

By leveraging these Portlet Container Settings, administrators can ensure that portlet-based applications are efficiently managed, providing a robust and interactive user experience within the web portal.

### Enterprise and Web Applications
The server supports a wide range of enterprise and web applications, offering a flexible and extensible platform for various components such as themes, portlets, and other web elements. This capability allows developers to create and deploy sophisticated applications that can be customized and scaled according to business needs.

By leveraging these features, organizations can ensure that their web applications are not only visually appealing but also highly functional and user-friendly, providing a seamless experience for end-users.


## Security Features and Configurations
### Security Features
- **Application Security**: This feature ensures the protection of application data and resources from unauthorized access and potential threats. It involves measures such as input validation, secure coding practices, and regular security assessments to identify and mitigate vulnerabilities.
- **Transport Security**: This feature secures data transmission between clients and servers, preventing eavesdropping and tampering. It typically uses protocols like TLS (Transport Layer Security) to encrypt data in transit, ensuring confidentiality and integrity.
- **LDAP Registry for Authentication**: Provides a centralized authentication mechanism using the Lightweight Directory Access Protocol (LDAP). LDAP servers store user credentials and authentication information, allowing applications to authenticate users against a single, centralized directory.
- **Federated Registry for Identity Management**: Manages user identities across multiple systems, enabling single sign-on (SSO) and consistent identity management. Federated identity management systems use standards like SAML (Security Assertion Markup Language) or OAuth to share authentication and authorization data across different domains.
- **JAAS Login Modules for Authentication Support**: Supports Java Authentication and Authorization Service (JAAS) for flexible and pluggable authentication. JAAS login modules allow developers to define custom authentication mechanisms, which can be easily integrated into Java applications.

### Trust Association Interceptors
Trust Association Interceptors (TAIs) provide additional authentication mechanisms beyond traditional methods, enhancing security.
TAIs intercept requests and perform custom authentication logic before passing the request to the application, allowing for advanced security measures such as multi-factor authentication.

### Configurations
- **Keystores & SSL**: Ensures secure communications by managing keystores and configuring SSL (Secure Sockets Layer). Keystores store cryptographic keys and certificates, which are used to establish secure SSL connections. Proper configuration of SSL ensures encrypted communication channels.
- **User & Group Management**: Controls user roles and administrator access, ensuring proper authorization and access control. This involves defining user roles, assigning permissions, and managing group memberships to enforce security policies and restrict access to sensitive resources.
- **Authentication Cache**: Optimizes performance by caching authentication results, reducing the need for repeated authentication checks. An authentication cache stores the results of recent authentication attempts, allowing subsequent requests to be authenticated more quickly by reusing cached results.
- **Web Application Security**: Defines policies for securing web applications, protecting against common security threats such as cross-site scripting (XSS) and SQL injection. This includes configuring security headers, implementing input validation, and using security frameworks to enforce security policies and protect web applications from attacks.

By implementing these security features and configurations, the system ensures robust protection of data, secure communication, and effective identity and access management.

## Data and Transaction Management
### Data Sources and JNDI
Data sources are configured to establish and manage connections to databases. This configuration includes specifying the database type, connection URL, credentials, and other connection properties. The Java Naming and Directory Interface (JNDI) is used to reference these data sources within the application, providing a standardized way to access database connections and other resources.

### JNDI Objects and References
JNDI settings are used to define and access various naming resources within the application. These resources can include environment entries, EJB references, and resource links. By using JNDI, applications can look up and retrieve these resources at runtime, enabling dynamic configuration and resource management.

### Transaction Management
Transaction management is crucial for maintaining data consistency and integrity across multiple operations. The server supports both container-managed and bean-managed transactions, allowing developers to choose the appropriate transaction management strategy for their applications. This includes support for distributed transactions, ensuring that all operations within a transaction are either committed or rolled back as a single unit.

### Persistence
The Java Persistence API (JPA) is used for Object-Relational Mapping (ORM) and data handling within applications. JPA provides a standardized way to map Java objects to database tables, enabling developers to interact with the database using Java objects rather than SQL queries. This abstraction simplifies data access and manipulation, while also providing powerful features such as caching, lazy loading, and query optimization.

By leveraging these data and transaction management features, developers can ensure efficient and reliable data handling within their applications, while maintaining data consistency and integrity across all operations.

## Networking and HTTP Endpoints
### Endpoint Configuration
The server supports the configuration of HTTP and HTTPS endpoints, which are essential for handling client requests and facilitating secure communication. Administrators can define multiple endpoints, specifying details such as port numbers, protocols, and security settings. This configuration ensures that the server can efficiently manage incoming and outgoing traffic, providing reliable and secure access to web applications and services.

### Local Communication
Local communication settings facilitate efficient internal communication between server components and services. This includes configuring inter-process communication (IPC) mechanisms and optimizing data exchange within the server environment. By streamlining local communication, the server can enhance performance and reduce latency for internal operations.

By properly configuring networking and HTTP endpoints, as well as optimizing local communication, administrators can ensure that the server operates efficiently, securely, and reliably, providing a robust foundation for web applications and services.

## Caching
Caching is a critical feature for enhancing the performance and scalability of web applications by reducing the load on backend systems and improving response times. The server supports both distributed caching and portlet-level caching, each serving distinct purposes:

### Distributed Caching
Distributed caching involves storing cache data across multiple nodes in a cluster, ensuring high availability and fault tolerance. This type of caching is particularly useful for large-scale applications where data consistency and quick access are crucial.

### Portlet-Level Caching
Portlet-level caching focuses on caching data specific to individual portlets within a web portal. This type of caching is designed to enhance the performance of portlet-based applications by reducing the need to repeatedly fetch or compute data for each user request.

By leveraging both distributed caching and portlet-level caching, the server ensures efficient data access, reduced latency, and improved overall performance for web applications.

## Executor Services
Executor Services are responsible for managing the execution of asynchronous tasks within the application. These services provide a framework for running background tasks, scheduled jobs, and concurrent processing, ensuring that tasks are executed efficiently and reliably.

By leveraging Executor Services, developers can efficiently manage background and concurrent tasks, ensuring that applications remain performant and responsive under varying workloads.

## Shared Libraries
Shared Libraries provide a mechanism for applications to access and utilize reusable libraries, ensuring consistency and reducing redundancy across the server environment. These libraries typically include JAR artifacts that contain common functionalities, utilities, and dependencies required by multiple applications. Examples include jar artifacts in dxconfig, dxcorelib, derbylib, etc.

By leveraging shared libraries, organizations can enhance the development, deployment, and maintenance of their applications, ensuring a more streamlined and efficient server environment.

## Logging
Logging is a critical aspect of application management, providing insights into the application's behavior, performance, and potential issues. The server supports comprehensive logging configurations that enable administrators and developers to track errors, debug issues, and monitor application activities.

By leveraging these logging features, administrators can ensure effective error tracking, debugging, and monitoring of the application.

## Context and Dependency Injection (CDI)
Context and Dependency Injection (CDI) is a powerful framework for managing object lifecycles and dependencies within Java applications. CDI simplifies the development of loosely coupled, testable, and maintainable applications by providing:

- **Dependency Injection**: Automatic injection of dependencies, reducing boilerplate code and enhancing modularity.
- **Context Management**: Scoping and lifecycle management of beans, ensuring proper resource allocation and cleanup.

By utilizing CDI, developers can create more maintainable and scalable applications with reduced complexity.

## Health and Metrics
Health and metrics monitoring is essential for maintaining the reliability and performance of applications. The server provides comprehensive configurations for health checks, metrics collection, and monitoring, including:

- **Health Check Endpoints**: Configurable endpoints that provide real-time health status of the application and its components, enabling proactive issue detection and resolution.
- **Metrics Collection**: Collection of various metrics (e.g., CPU usage, memory usage, request counts) to monitor application performance and resource utilization.
- **Application Monitoring**: Integration with application performance monitoring (APM) tools (e.g., Prometheus, Grafana) for detailed insights into application behavior and performance.
- **System Monitoring**: Monitoring of underlying system resources to ensure optimal operation and prevent resource bottlenecks.

By implementing these health and metrics configurations, administrators can ensure continuous monitoring and proactive management of application and system health.
