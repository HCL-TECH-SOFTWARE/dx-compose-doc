# Overview

Dive into the foundational elements of the HCL Digital Experience Compose v9.5 product with this section. This section will introduce you to the service's architecture, core features, and requirements.

Outside of custom java apps all the great features of DX like powerful web content management, personalization, secure and role based delivery, virtual portals, script apps, DAM, Content Composer integration and many more are available in the WebEngine container in DX Compose v9.5.

With DX Compose we provide an updated Core container, WebEngine, that runs on [Open Liberty](https://openliberty.io/){target="_blank"} instead of IBM WebSphere Application Server. While we will transition more and more functionality over - the initial release is focused on running web content, custom script apps, and themes on WebEngine. The ability to run custom java applications and extensions is planned for a future delivery.

Digital Experience Compose is delivered in the same way as the traditional Digital Experience product - as a set of container images and attached helm charts to deploy to a Kubernetes system or Docker Compose. DX Compose is not supported for a non container install.

Rather than duplicating the documentation about all the features of DX we will outline in this documentation what is different for DX Compose deployment, configuration, support ... For all other items refer back to the same DX documentation sections like e.g. [Virtual Portals](https://opensource.hcltechsw.com/digital-experience/latest/build_sites/virtual_portal/){target="_blank"}.