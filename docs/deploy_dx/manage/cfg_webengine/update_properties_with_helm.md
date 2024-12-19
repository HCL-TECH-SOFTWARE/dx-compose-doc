---
id: update-properties-with-helm
title: Updating DX properties using Helm values
---

This topic provides steps on how to use the Helm chart's `values.yaml` file to add, update, or delete Digital Experience (DX) Compose properties. The `values.yaml` file contains the default values for the properties used during the deployment of the Helm chart. You can override these default values by updating the `values.yaml` file.

## Overriding default values in `values.yaml`

To override the default values for the properties used during the deployment of the Helm chart, add the `propertiesFilesOverrides` section in the `values.yaml` file.

See the sample format for `propertiesFilesOverrides`:
  
```yaml
configuration:
  webEngine:
    propertiesFilesOverrides: 
      <propertiesFileName>: 
          <propertyKey>: <propertyValue>
```

For the description of each parameter value, refer to the following list:

- `propertiesFileName`: Name of the properties file that you want to update.
- `propertyKey`: Key of the property that you want to update.
- `propertyValue`: Value that you want to set for the property.

### Updating and adding properties to a properties file

With key-value pairs under the properties file name, the properties will be updated, and if not present, will be added to the properties file.
Refer to the following sample values for each parameter in `propertiesFilesOverrides`:

- `propertiesFileName`: `ConfigService.properties`
- `propertyKey`: `uri.context.path`
- `propertyValue`: `"/wps/mycontenthandler"`

See the following sample configuration:

```yaml
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
      ConfigService.properties:
        uri.context.path: "/wps/mycontenthandler"
        uri.poc.protected: "/mypoc"
```

### Disabling properties from a properties file

To disable properties, use the `propertiesDisable` section. `propertiesDisable` follows a similar key-value pair format as `propertiesFilesOverrides`. The key represents the property you want to disable from the properties file, and the value can be any string or you can leave it empty ("").

See the following sample:

```yaml
configuration:
  webEngine:
    propertiesDisable:
      FeedbackService.properties: 
        feedbackRecordCachePriority: ""
        logBufferSize: ""
```

You can update, delete, or add multiple properties under the same properties file. You can also use multiple properties files.

## Updating properties with Helm values

### Updating the `values.yaml` file

1. Add the properties you want to override or delete using the [`propertiesFilesOverrides`](#overriding-default-values-in-valuesyaml) section or [`propertiesDisable`](#disabling-properties-from-a-properties-file) section, respectively.

2. After updating or disabling properties, perform a [Helm upgrade](../working_with_compose/helm_upgrade_values.md) to apply the changes.

### Restarting the server

The server is automatically restarted to pick up properties file changes.

!!!note
    The properties file changes are not persistent and will be lost after being removed from the `propertiesFilesOverrides` section of the `values.yaml` file.