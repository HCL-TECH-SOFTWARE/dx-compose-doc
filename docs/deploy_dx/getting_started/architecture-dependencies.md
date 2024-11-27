# Architecture and dependencies

## Architecture

The following two charts outline the transition from the Core container to the WebEngine container.

![HCL DX deployment with Core as is](./img/current-arch.png)

![WebEngine deployment](./img/webengine-arch-mvp.png)

## Dependencies
Kubernetes with the right version (see system requirements) and helm. For production purposes a LDAP and DB2 are required.