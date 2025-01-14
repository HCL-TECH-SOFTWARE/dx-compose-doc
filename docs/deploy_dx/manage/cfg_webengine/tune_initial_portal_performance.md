---
id: tune_initial_portal_performance
title: Tune DX Compose Prior to Load Testing
---
This document has two main purposes:

1) Identify helm charts (yaml files) which provide initial tuning for various WebEngine production environments 

2) Show the helm command used to update those envinroments

In general, these helm charts provide the tunings for WebEngine itself (as opposed the DB server, the OS, the LDAP, etc) which should be applied immediately before tweaking the settings for a specific environment which would contain (among other things) custom themes, skins, pages and portlets. Refer to the "DX Performance Tuning Guide" for complete details. The tuning guide document was originally written for DX running on WebSphere Application Server; either stand-alone or running in Kubenetes. However, most settings in that document are valid for running in DX Compose as well.

As with all parameter changes for performance, it's worth noting that the best settings can only be determined after any changes or addtions to DX Compose are complete. That includes all new themes, skins, portlets and pages to be added. At that point, the optimal setting for any setting can be determined after synthetic simulation of a "test" load against this augmented DX Compose environment.

Note also that from an optimal performance setting point of view, there should be absolutely no errors in SystemOut.log, console.log nor trace.log. As DX Compose (and WebEngine) is Java based software and, in Java, given that the "print writer" (used for logging of errors) is a serialized resource, any errors being written to the log(s) from commonly used themes or portlets can serialize page rendering which inhibits performance.

**The Files**

By default, the two files used to initially tune DX Compose WebEngine are located in the "native-kube/install-hcl-dx-deployment/performance" directory of a Kubernetes deployment.

**Production Rendering**

The file

```
webengine-performance-rendering.yaml
```

contains the recommended initial tuning for a production rendering environment. The term rendering implies an environment where WCM is heavily cached to provide optimal page rendering performance. Changes to that content may not be readily available given that it might be cached. This site is geared to rendering production content to users as responsively as possible.

It is expected that WCM content will be syndicated to this rendering environment (generally from a WCM authoring server). A separate authoring environment should be available for the generation of this content including new WebEngine pages which eventually become available to users of the rendering site.

**Production Authoring**

The file

```
webengine-performance-authoring.yaml
```

contains the recommended intial tuning for an environment where content authors create, delete and edit content. It is also the environment where new pages would be made available to users via syndication to the rendering environment(s).

Little to no caching should be available in this environment. This facilitates an optimal editing experience for content authoring as change become more immediately available.

**Development**

No specific initial tuning file is made available for developers. The reason is that it is envisioned that developers would be using Docker as opposed to Kubernetes. There is no helm in Docker. Therefore, the shipped DX Compose image needs to be defaulted to a developer experience so as to minimize or eliminate the need for the developer to change any settings.

The goal, in general, is to make the DX Compose WebEngine image have defaults "out of the box" that would be applicable to a developer. 

**Applying the Helm Chart Settings**

The helm charts for performance are insufficient for a helm update. They must always be applied in concert with the helm chart for other changes.

So, for example, one might use the following command line for applying the helm chart:

```
helm upgrade -n dxns -f install-deploy-values.yaml -f ./install-hcl-dx-deployment/performance/webengine-performance-rendering.yaml dx-deployment ./install-hcl-dx-deployment
```

In this command, the first "-f" for install-deploy-values.yaml refers to the helm chart for non-performance changes. The second "-f" for webengine-performance-rendering.yaml is the helm chart for performance changes specifically for the initial tunings of a rendering environment.

Note that the WebEngine pod(s) need to be restarted to pick up any changes in the due to the helm changes because a helm upgrade in the currently running pod(s) are not subject to the these changes.

**Notes**

***Datasources***

There is no automated method to find and update the minimum and maximum size of the datasource(s) in server.xml at helm upgrade time. Updating to the correct size will need to be done manually.

The way to do that will be to let kubernetes start the pod, "exec" into that pod and change server.xml and then restart the pod.

Once this optimal size is determined, the performance yaml file could be updated to reflect this new size.