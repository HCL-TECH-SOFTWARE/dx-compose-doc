# System requirements

The deployment of WebEngine happens as part of the broader DX deployment using Helm for Kubernetes or Docker Compose. This topic provides the minimum system requirements for the WebEngine container in Digital Experience (DX) Compose.

## Kubernetes

See the requirements for Kubernetes in [Kubernetes runtime](https://opensource.hcltechsw.com/digital-experience/latest/get_started/system_requirements/kubernetes/kubernetes-runtime/){target="_blank"}.

### Kubernetes platform policy

- The Kubernetes platform must be hosted on x86-64 hardware.
- The Kubernetes platform must be officially supported by Helm. For more information, see [Kubernetes Distribution Guide](https://helm.sh/docs/topics/kubernetes_distros){target="_blank"}.

## Java SDK

HCL DX 9.5 requires JDK 11.0 or later for installation.

|Prerequisite|Prerequisite minimum and supported versions|Product minimum|
|----------|----------|-----|
|Apache Termurin, Java Technology Edition|11.0 and later maintenance releases|9.5|

## Databases

|Supported software|Supported software minimum|Product minimum
|-----------|------------------|-----|
|Apache Derby|10.11*<br/>|8.5|
|DB2 Standard and Advanced Edition|11.5** and later maintenance releases|9.5|

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