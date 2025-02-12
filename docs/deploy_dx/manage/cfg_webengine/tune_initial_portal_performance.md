---
id: tune_initial_portal_performance
title: Tuning the initial DX Compose performance
---
This topic provides information on how to tune the initial HCL Digital Experience (DX) Compose performance before load testing. This page identifies Helm charts (YAML files) that provide initial tuning for various WebEngine production scenarios and provides the Helm command used to update those environments.

In general, these Helm charts provide the tunings for the WebEngine container. You must immediately apply the tunings provided before modifying the settings for a specific environment which contains custom themes, skins, and pages. For more information, refer to [Tune your environment](https://help.hcl-software.com/digital-experience/9.5/latest/deployment/manage/tune_servers/){target="_blank"} topic. The [Performance Tuning Guide](https://support.hcl-software.com/csm?id=kb_article&sysparm_article=KB0074411){target="_blank"} was created for DX running on WebSphere Application Server, either standalone or running in Kubernetes. However, most settings in the guide are valid for running in DX Compose as well.

Note that you can only determine the most appropriate settings after any changes or additions to DX Compose are complete. These changes include all new themes, skins, and pages to be added. After applying the changes, you can determine the optimal settings after simulating a test load against the augmented DX Compose environment.

To know if the settings are optimal, there should be no errors in `SystemOut.log`, `console.log` and `trace.log`. DX Compose is a Java-based software and in Java, any errors in the logs from commonly used themes can serialize page rendering, which slows down performance.

## Helm charts for initial tuning

The following files are used to initially tune DX Compose WebEngine. They are located in the `hcl-dx-deployment/performance` directory of a Kubernetes deployment:

- [`webengine-performance-rendering.yaml`](#production-rendering-environment)
- [`webengine-performance-authoring.yaml`](#production-authoring-environment)

### Production-rendering environment

The file `webengine-performance-rendering.yaml` contains the recommended initial tuning for a production-rendering environment. The term rendering implies an environment where Web Content Manager (WCM) is heavily cached to provide optimal page-rendering performance. Changes to the content may not be readily available because content might be cached. This environment is geared to rendering production content to users as responsively as possible.

It is expected that WCM content is syndicated to this rendering environment, generally from a WCM authoring server. A separate authoring environment should be available to generate content, including new DX Compose pages, which will be available to users of the site on the rendering environment after syndication occurs.

See the content of the `webengine-performance-rendering.yaml` file.

```yaml
configuration:
  webEngine:
    configOverrideFiles:
      derbyMaxConnections.xml: |
        <server description="DX Web Engine server">
          <!-- This setting is for Derby; if you transfer the database to DB2 you likely need to change this setting to use a higher maxPoolSize; say 300" -->
          <!-- The dataSource id likely needs to be changed as well -->
          <dataSource id="DefaultDataSource" jndiName="jdbc/wpdbDS" statementCacheSize="10" isolationLevel="TRANSACTION_READ_COMMITTED">
            <jdbcDriver libraryRef="derbyLib" />
            <properties.derby.embedded connectionAttributes="upgrade=true" createDatabase="false" databaseName="resources/wpsdb" shutdownDatabase="false" />
            <connectionManager agedTimeout="7200" connectionTimeout="180" maxIdleTime="1800" maxPoolSize="100" minPoolSize="10" purgePolicy="EntirePool" reapTime="180" />
          </dataSource>
          </server>
      WCMDynacachesPerformance.xml: |
        <server description="DX Web Engine server">
              <distributedMap id="services/cache/iwk/abspath" memorySizeInEntries="32000"></distributedMap>
              <distributedMap id="services/cache/iwk/abspathreverse" memorySizeInEntries="32000"></distributedMap>
              <distributedMap id="services/cache/iwk/processing" memorySizeInEntries="10000"></distributedMap>
              <distributedMap id="services/cache/iwk/session" memorySizeInEntries="6000"></distributedMap>
              <distributedMap id="services/cache/iwk/strategy" memorySizeInEntries="32000"></distributedMap>
              <distributedMap id="services/cache/iwk/summary" memorySizeInEntries="4000"></distributedMap>
        </server>
    propertiesFilesOverrides:
      WCMConfigService.properties:
        connect.moduleconfig.ajpe.contentcache.defaultcontentcache: "SECURE"
        connect.moduleconfig.ajpe.contentcache.contentcacheexpires: "REL 2H"
        user.cache.enable: "true"
        versioningStrategy.Default: "manual"
        versioningStrategy.AuthoringTemplate: "manual"
        versioningStrategy.Component: "manual"
        versioningStrategy.Content: "manual"
        versioningStrategy.PresentationTemplate: "manual"
        versioningStrategy.SiteArea: "manual"
        versioningStrategy.PortalPage: "manual"
        versioningStrategy.Taxonomy: "manual"
        versioningStrategy.Workflow: "manual"
        deployment.subscriberOnly: "true"
      CacheManagerService.properties:
        cacheinstance.com.ibm.wps.ac.AccessControlUserContextCache.size: "8403"
        cacheinstance.com.ibm.wps.model.factory.UserSpecificModelCache.size: "8403"
      ConfigService.properties:
        timeout.resume.session: "true"
        persistent.session.level: "0"
        record.lastlogin: "false"
        content.topology.dynamic: "false"
        friendly.enabled: "true"
        friendly.pathinfo.enabled: "true"
        cache.dynamic.content.spot: "false"
        resourceaggregation.cache.markup: "true"
        resourceaggregation.enableRuntimePortletCapabilitiesFilter: "false"
      PumaStoreService.properties:
        store.puma_default.disableACforRead: "true"
      CPConfigurationService.properties:
        com.ibm.wps.cp.tagging.isTaggingEnabled: "false"
        com.ibm.wps.cp.rating.isRatingEnabled: "false"
      CommonComponentConfigService.properties:
        cc.multipart.enabled: "false"
        cc.multipart.correlatehosts: "false"
      NavigatorService.properties:
        public.expires: "3600"
        public.reload: "3600"
        remote.cache.expiration: "28800"
      RegistryService.properties:
        default.interval: "28800"
        bucket.transformationapp: "28800"
        bucket.transformation.int: "28800"
      AccessControlDataManagementService.properties:
        accessControlDataManagement.acucIgnoreResourceTypes: "null"
        accessControlDataManagement.loadRolesParentBased: "false"
environment:
  pod:
    webEngine:
    - name: JVM_ARGS
      value: "-Xmx3548m -Xms3548m -Xmn1024m -XX:MaxDirectMemorySize=256000000"
```

### Production-authoring environment

The file `webengine-performance-authoring.yaml` contains the recommended initial tuning for an environment where content authors create, delete, and edit content. The production-authoring environment is where new pages would be made available to users through syndication to the rendering environments.

There should be minimal to no caching in this environment. This facilitates an optimal editing experience for content authoring as changes become immediately visible.  

See the content of the `webengine-performance-authoring.yaml` file.

```yaml
configuration:
  webEngine:
    configOverrideFiles:
      derbyMaxConnections.xml: |
        <server description="DX Web Engine server">
          <!-- This setting is for Derby; if you transfer the database to DB2 you likely need to change this setting to use a higher maxPoolSize; say 300" -->
          <!-- The dataSource id likely needs to be changed as well -->
          <dataSource id="DefaultDataSource" jndiName="jdbc/wpdbDS" statementCacheSize="10" isolationLevel="TRANSACTION_READ_COMMITTED">
            <jdbcDriver libraryRef="derbyLib" />
            <properties.derby.embedded connectionAttributes="upgrade=true" createDatabase="false" databaseName="resources/wpsdb" shutdownDatabase="false" />
            <connectionManager agedTimeout="7200" connectionTimeout="180" maxIdleTime="1800" maxPoolSize="100" minPoolSize="10" purgePolicy="EntirePool" reapTime="180" />
          </dataSource>
          </server>
      WCMDynacachesPerformance.xml: |
        <server description="DX Web Engine server">
              <distributedMap id="services/cache/iwk/abspath" memorySizeInEntries="8000"></distributedMap>
              <distributedMap id="services/cache/iwk/abspathreverse" memorySizeInEntries="8000"></distributedMap>
              <distributedMap id="services/cache/iwk/processing" memorySizeInEntries="10000"></distributedMap>
              <distributedMap id="services/cache/iwk/session" memorySizeInEntries="6000"></distributedMap>
              <distributedMap id="services/cache/iwk/strategy" memorySizeInEntries="8000"></distributedMap>
              <distributedMap id="services/cache/iwk/summary" memorySizeInEntries="2000"></distributedMap>
        </server>
    propertiesFilesOverrides:
      WCMConfigService.properties:
        user.cache.enable: "true"
        versioningStrategy.Default: "always"
        versioningStrategy.AuthoringTemplate: "always"
        versioningStrategy.Component: "always"
        versioningStrategy.Content: "always"
        versioningStrategy.PresentationTemplate: "always"
        versioningStrategy.SiteArea: "always"
        versioningStrategy.PortalPage: "always"
        versioningStrategy.Taxonomy: "always"
        versioningStrategy.Workflow: "always"
        deployment.subscriberOnly: "false"
      CacheManagerService.properties:
        cacheinstance.com.ibm.wps.ac.AccessControlUserContextCache.size: "8403"
        cacheinstance.com.ibm.wps.model.factory.UserSpecificModelCache.size: "8403"
      ConfigService.properties:
        timeout.resume.session: "true"
        persistent.session.level: "0"
        record.lastlogin: "false"
        content.topology.dynamic: "false"
        friendly.enabled: "true"
        friendly.pathinfo.enabled: "true"
        cache.dynamic.content.spot: "false"
        resourceaggregation.cache.markup: "true"
        resourceaggregation.enableRuntimePortletCapabilitiesFilter: "false"
      PumaStoreService.properties:
        store.puma_default.disableACforRead: "true"
      CPConfigurationService.properties:
        com.ibm.wps.cp.tagging.isTaggingEnabled: "false"
        com.ibm.wps.cp.rating.isRatingEnabled: "false"
      CommonComponentConfigService.properties:
        cc.multipart.enabled: "false"
        cc.multipart.correlatehosts: "false"
      NavigatorService.properties:
        public.expires: "3600"
        public.reload: "3600"
        remote.cache.expiration: "28800"
      RegistryService.properties:
        default.interval: "28800"
        bucket.transformationapp: "28800"
        bucket.transformation.int: "28800"
      AccessControlDataManagementService.properties:
        accessControlDataManagement.acucIgnoreResourceTypes: "null"
        accessControlDataManagement.loadRolesParentBased: "true"

environment:
  pod:
    webEngine:
    - name: JVM_ARGS
      value: "-Xmx3548m -Xms3548m -Xmn1024m -XX:MaxDirectMemorySize=256000000"
```

### Tuning for developers

No specific initial tuning file is available for developers. It is expected that developers use Docker Compose instead of Kubernetes; Helm charts are not available in Docker Compose. If a tuning file is needed for developers, the shipped DX Compose image should be sufficient. If not, developers can modify the shipped DX Compose image to be applicable to their needs using `docker commit` or a Dockerfile.

## Applying the Helm chart settings

The Helm charts for performance listed in [Helm charts for initial tuning](#helm-charts-for-initial-tuning) are insufficient for a Helm update. When updating, you must always use any of the performance Helm charts together with the Helm chart for non-performance changes.

See the following sample command:

```sh
helm upgrade -n dxns -f install-deploy-values.yaml -f ./install-hcl-dx-deployment/performance/webengine-performance-rendering.yaml dx-deployment ./install-hcl-dx-deployment
```

In this sample command, the first `-f` for `install-deploy-values.yaml` refers to the Helm chart for non-performance changes. The second `-f` for `webengine-performance-rendering.yaml` is the Helm chart for performance changes specifically for the initial tunings of a rendering environment.

### Updating the size of `dataSources`

During `helm upgrade`, there is no automated method to find and update the minimum and maximum size of the `dataSources` in `server.xml`. You must manually update the datasources to the correct size. To update the minimum and maximum size, wait until Kubernetes restarts the pod after a `helm upgrade` and do the following steps:

1. In the performance YAML file (`webengine-performance-rendering.yaml` or `webengine-performance-authoring.yaml`), incrementally adjust the `dataSource` sizes until the performance is optimal.
    
    You might have to run the load testing multiple times to determine the right size.

2. Perform a [`helm upgrade`](#applying-the-helm-chart-settings) every time you modify the `dataSource` sizes to apply the changes.

    The WebEngine pods pick up the new sizes automatically after the `helm upgrade` without restarting.