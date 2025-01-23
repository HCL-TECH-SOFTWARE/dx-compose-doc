---
id: tune_initial_portal_performance
title: Tuning the initial DX Compose performance
---
This topic provides information on how to tune the initial HCL Digital Experience (DX) Compose performance before load testing. This page identifies Helm charts (YAML files) that provide initial tuning for various WebEngine production scenarios and provides the Helm command used to update those environments.

In general, these Helm charts provide the tunings for the WebEngine container. You must immediately apply the tunings provided before modifying the settings for a specific environment which contains custom themes, skins, and pages. For more information, refer to [Tune your environment](https://help.hcl-software.com/digital-experience/9.5/latest/deployment/manage/tune_servers/){target="_blank"} topic. The [Performance Tuning Guide](https://support.hcl-software.com/csm?id=kb_article&sysparm_article=KB0074411){target="_blank"} was created for DX running on WebSphere Application Server, either standalone or running in Kubernetes. However, most settings in the guide are valid for running in DX Compose as well.

Note that you only can determine the most appropriate settings after any changes or additions to DX Compose are complete. These changes include all new themes, skins, and pages to be added. After applying the changes, you can determine the optimal settings after simulating a test load against the augmented DX Compose environment.

To know if the settings are optimal, there should be no errors in `SystemOut.log`, `console.log` and `trace.log`. DX Compose is a Java-based software and in Java, any errors in the logs from commonly used themes can serialize page rendering, which slows down performance.

## Helm charts for initial tuning

The following files are used to initially tune DX Compose WebEngine. They are located in the `native-kube/install-hcl-dx-deployment/performance` directory of a Kubernetes deployment:

- [`webengine-performance-rendering.yaml`](#production-rendering-environment)
- [`webengine-performance-authoring.yaml`](#production-authoring-environment)

### Production-rendering environment

The file `webengine-performance-rendering.yaml` contains the recommended initial tuning for a production-rendering environment. The term rendering implies an environment where Web Content Manager (WCM) is heavily cached to provide optimal page-rendering performance. Changes to the content may not be readily available because content might be cached. This environment is geared to rendering production content to users as responsively as possible.

It is expected that WCM content is syndicated to this rendering environment, generally from a WCM authoring server. A separate authoring environment should be available to generate content, including new DX Compose pages, which will be available to users of the site on the rendering environment after syndication occurs.

### Production-authoring environment

The file `webengine-performance-authoring.yaml` contains the recommended initial tuning for an environment where content authors create, delete, and edit content. The production-authoring environment is where new pages would be made available to users through syndication to the rendering environments.

There should be minimal to no caching in this environment. This facilitates an optimal editing experience for content authoring as changes become immediately visible.  

### Tuning for developers

No specific initial tuning file is available for developers. It is expected that developers use Docker instead of Kubernetes and Helm charts are not available in Docker. If a tuning file is needed for developers, the shipped DX Compose image should be sufficient. If not, developers can modify the shipped DX Compose image to be applicable to their needs using `docker commit` or a Dockerfile.

## Applying the Helm chart settings

The Helm charts for performance listed in [Helm charts for initial tuning](#helm-charts-for-initial-tuning) are insufficient for a Helm update. When updating, you must always use any of the performance Helm charts together with the Helm chart for non-performance changes.

See the following sample command:

```sh
helm upgrade -n dxns -f install-deploy-values.yaml -f ./install-hcl-dx-deployment/performance/webengine-performance-rendering.yaml dx-deployment ./install-hcl-dx-deployment
```

In this sample command, the first `-f` for `install-deploy-values.yaml` refers to the Helm chart for non-performance changes. The second `-f` for `webengine-performance-rendering.yaml` is the Helm chart for performance changes specifically for the initial tunings of a rendering environment.

Note that you must restart the WebEngine pods to pick up any changes.

### Updating the size of `dataSources`

During `helm upgrade`, there is no automated method to find and update the minimum and maximum size of the `dataSources` in `server.xml`. You must manually update the datasources to the correct size. To update the minimum and maximum size, wait until Kubernetes restarts the pod after a `helm upgrade` and do the following steps:

1. Log in to the WebEngine pod by running the following command: 

    ```
    kubectl exec -it <Pod Name> bash
    ```

    Make sure to replace the `<Pod Name`> with the actual pod name.

2. In the performance YAML file (`webengine-performance-rendering.yaml` or `webengine-performance-authoring.yaml`), incrementally adjust the `dataSource` sizes until the performance is optimal.
    
    You might have to run the load testing multiple times to determine the right size.

3. Restart the WebEngine pod every time you apply changes.

After the optimal size is determined, you can update the performance YAML file to reflect the new `dataSource` size.