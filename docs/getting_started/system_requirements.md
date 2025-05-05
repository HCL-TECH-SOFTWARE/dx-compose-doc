# System requirements

The deployment of WebEngine happens as part of the broader Digital Experience (DX) deployment using Helm for Kubernetes or Docker Compose. This topic provides the minimum system requirements for the WebEngine container in DX Compose.

## Kubernetes

See the requirements for Kubernetes in [Kubernetes runtime](../deploy_dx/install/kubernetes_deployment/kubernetes_runtime.md).

### Kubernetes platform policy

HCL DX Compose v9.5 is designed to run on any [Certified Kubernetes platform](https://www.cncf.io/certification/software-conformance){target="_blank"}, provided that the following criteria are met:

- The Kubernetes platform must be hosted on x86-64 hardware.
- The Kubernetes platform must be officially supported by Helm. For more information, see [Kubernetes Distribution Guide](https://helm.sh/docs/topics/kubernetes_distros){target="_blank"}.

## Java SDK

DX Compose requires JDK 11.0 or later for installation.

|Prerequisite|Prerequisite minimum and supported versions|Product minimum|
|----------|----------|-----|
|Apache Termurin, Java Technology Edition|11.0 and later maintenance releases|9.5|

## Databases

|Supported software|Supported software minimum|Product minimum
|-----------|------------------|-----|
|Apache Derby|10.11*<br/>|9.5|
|IBM DB2 Standard and Advanced Edition|11.5** and later maintenance releases (acquired separately)|9.5|
|Oracle Database 19c|19c and later maintenance releases (acquired separately)|9.5|
|Oracle Database 21c|21c and later maintenance releases (acquired separately)|9.5|
|Oracle on Amazon Relational Database Service|19c and later maintenance releases (acquired separately)|9.5|
|Oracle on Amazon Relational Database Service|21c and later maintenance releases (acquired separately)|9.5|

\* Apache Derby is not supported in a product environment.  
\** DB2 includes support for the DB2 pureScale component.  

## LDAP servers

All LDAP Servers that support the LDAP V3 Specification are supported.

## Web browsers

|Supported software|Supported software minimum|Product minimum|
|-----------|------------------|-----|
|Android default browser|Newer levels are supported|9.5|
|Apple Safari|Newer levels are supported|9.5|
|Google Chrome|Newer levels are supported|9.5|
|Microsoft Edge Chromium-Based|Newer levels are supported|9.5|
|Mozilla Firefox|Newer levels are supported|9.5|
|Mozilla Firefox ESR|Newer levels are supported|9.5|