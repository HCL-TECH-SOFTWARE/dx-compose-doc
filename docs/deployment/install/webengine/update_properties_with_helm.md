---
id: update-properties-with-helm
title: Updating DX Properties with Helm
---

This guide provides instructions for adding, updating, or deleting properties from services using the `values.yaml` file for a HELM chart. The `values.yaml` file contains the default values for the properties used during the deployment of the HELM chart. You can override these default values by updating the `values.yaml` file.

## Update Properties with Helm Values

### Properties Overrides Parameters

**Sample Format for propertiesFilesOverrides**
  
```yaml
incubator:
  configuration:
    webEngine:
      propertiesFilesOverrides: 
        <propertiesFileName>: 
           <propertyKey>: <propertyValue>
```

**Note**: The `propertiesFileName` is the name of the properties file that you want to update. The `propertyKey` is the key of the property that you want to update. The `propertyValue` is the value that you want to set for the property.

#### Updating and adding properties to a Properties file

With key-value pairs under the properties file name, the properties will be updated, and if not present, will be added to the properties file.
- **propertiesFileName**: The name of the properties file that you want to update. e.g., `ConfigService.properties`
- **propertyKey**: The key of the property that you want to update. e.g., `uri.context.path`
- **propertyValue**: The value that you want to set for the property. e.g., `"/wps/mycontenthandler"`

**Example**

```yaml
incubator:
  configuration:
    webEngine:
      propertiesFilesOverrides: 
        FeedbackService.properties:
          feedbackRecordCachePriority: "1"
          newProperty: "test"
          logBufferSize: "5001"
        RegistryService.properties:
          default.interval: '1900'
          newVal: 'test'
        ConfigService.properties
          uri.context.path: "/wps/mycontenthandler"
          uri.poc.protected: "/mypoc"
```

### Disabling properties from a properties file

To disable properties, use the `propertiesDisable` section. It follows a similar key-value pair format as `propertiesFilesOverrides`. The key represents the property you want to disable from the properties file, and the value can be any string or an empty string ("").

**Example**

```yaml
incubator:
  configuration:
    webEngine:
      propertiesDisable:
        FeedbackService.properties: 
          feedbackRecordCachePriority: ""
          logBufferSize: ""
```

**Note**: You can update, delete, or add multiple properties under the same properties file. Additionally, you can use multiple properties files.


### Updating Properties with HELM Values

Refer to the following steps to update the new [HELM values](helm-upgrade-values.md).

#### Update the `values.yaml` File

Add the properties you want to override or delete using the `propertiesFilesOverrides` or `propertiesDisable` section, respectively. Refer to the properties [overrides parameters for guidance](#properties-overrides-parameters), then perform a [HELM upgrade](helm-upgrade-values.md) to apply the changes.

#### To Update the Properties File, You Will Need to Restart the Server

```sh
kubectl exec -it  dx-deployment-web-engine-0  -n dxns -c core -- /opt/openliberty/wlp/usr/svrcfg/bin/restart.sh
```
**Note**: The properties file changes will not be persistent and will be lost after being removed from the `propertiesFilesOverrides` section of the `values.yaml` file.
