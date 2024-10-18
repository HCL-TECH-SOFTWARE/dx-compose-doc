# WebEngine

The HCL Digital Experience (DX) Core is rebuilt on Open Liberty to be more cloud-native, faster, and to use later JDK and J2EE levels. The name of the new container is WebEngine. HCL will be shipping incremental updates of WebEngine following the CF process as currently used with Core in HCL DX to progressively provide features and fixes.

## Overview

WebEngine provides an updated Core container that runs on [Open Liberty](https://openliberty.io/){target="_blank"} instead of IBM WebSphere Application Server. The initial release is focused on running web content, custom Script Applications, and themes on WebEngine. The ability to run custom Java applications and extensions is planned for a future delivery. This statement is not a guarantee of future releases or their features.

Outside of custom Java apps, all DX features such as web content management, personalization, secure and role-based delivery, virtual portals, Script Applications, Digital Asset Management, and Content Composer integration are delivered by the WebEngine container.

WebEngine is delivered as a set of container images and attached Helm charts to deploy to a Kubernetes system or Docker Compose. Note that WebEngine is not supported for a non-container installation.

-   **[WebEngine Features](webengine_features.md)**  
Know the DX features supported by the WebEngone container. 
-   **[Architecture and Dependencies](webengine_arch.md)**  
Learn more about the transition of architecture from the Core container to the WebEngine container.
-   **[System Requirements](webengine_arch.md)**  
See the system requirements to use the WebEngine container in your DX deployment. 

<!--Rather than duplicating the documentation about all the features of DX we will outline in the WebEngine sections what is different for deployment, configuration, support, ... For all other items refer back to the same DX documentation sections like e.g. Virtual Portals.-->