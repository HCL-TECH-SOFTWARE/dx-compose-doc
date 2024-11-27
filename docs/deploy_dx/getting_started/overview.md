# WebEngine Overview

With WebEngine we provide an updated Core container that runs on Open Liberty instead of IBM WebSphere Application Server. While we transition more and more functionality over - the initial release is focused on running web content, custom script apps, and themes on WebEngine. The ability to run custom java applications and extensions is planned for a future delivery.

For more information on Open Liberty see [Open Liberty](https://openliberty.io/).

Outside of custom java apps all the great features of DX like powerful web content management, personalization, secure and role based delivery, virtual portals, script apps, DAM, content composer integration and many more are delivered by the WebEngine.

WebEngine is delivered the same way as DX with Core on WebSphere - as a set of container images and attached helm charts to deploy to a Kubernetes system or for docker compose. 
WebEngine is not supported for a non container install.

Rather than duplicating the documentation about all the features of DX we will outline in the WebEngine sections what is different for deployment, configuration, support, ...
For all other items refer back to the same DX documentation sections like e.g. [Virtual Portals](https://opensource.hcltechsw.com/digital-experience/latest/build_sites/virtual_portal/).
