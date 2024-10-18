# Architecture and Dependencies

The following charts outline the transition from the Core container to the WebEngine container.

The first diagram shows the architecture of the existing DX Core container.

![Kubernetes today](../../../images/webengine_architecture.png)

The second diagram shows the architecture of the WebEngine container.

![Open Liberty](../../../images/webengine-arch-mvp.png)

## Dependencies

See the correct version of Kubernetes in [Kubernetes runtime](../../system_requirements/kubernetes/kubernetes-runtime.md). For production purposes, a Lightweight Directory Access Protocol (LDAP) server and DB2 are required. See [System Requirements](webengine_sysreq.md) for more information.