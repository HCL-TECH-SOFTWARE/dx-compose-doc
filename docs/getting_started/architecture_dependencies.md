# Architecture and dependencies

The following images show the transition in terms of architecture from the DX Core container to the WebEngine container in DX Compose.

The first diagram shows the architecture of the existing DX Core container.

![HCL DX deployment with Core as is](./img/current-arch.png)

The second diagram shows the architecture of the WebEngine container.

![WebEngine deployment](./img/webengine-arch-mvp.png){ width="800" }

## Dependencies

For the correct version of Kubernetes to use, see the topic [Kubernetes runtime](https://opensource.hcltechsw.com/digital-experience/latest/get_started/system_requirements/kubernetes/kubernetes-runtime/){target="_blank"}.

For production purposes, a Lightweight Directory Access Protocol (LDAP) server and DB2 are required. See [System Requirements](system_requirements.md) for more information.