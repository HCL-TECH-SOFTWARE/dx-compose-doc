---
id: update-properties-additions-with-helm
title: Appending DX Compose WebEngine properties file entries using Helm values
---

This topic explains how to use the Helm chart `values.yaml` file to append lines to WebEngine properties files in HCL Digital Experience (DX) Compose. Use this capability when you need to add entries that must be preserved as raw lines instead of key-value properties, such as `MemberFixerModule.properties` mappings.

## Appending lines in `values.yaml`

To append lines to a WebEngine properties file, add the `propertiesFilesAdditions` section to your custom Helm values file.

Use the following format:

```yaml
configuration:
  webEngine:
    propertiesFilesAdditions:
      <propertiesFileName>:
        - "<lineToAppend1>"
        - "<lineToAppend2>"
```

The parameters have the following meaning:

- `propertiesFileName`: Name of the properties file that you want to update.
- `lineToAppend`: A complete line that is appended as-is to the end of the target file.

### Example configuration

The following example appends two member mapping entries to `MemberFixerModule.properties`:

```yaml
configuration:
  webEngine:
    propertiesFilesAdditions:
      MemberFixerModule.properties:
        - "cn=contentAuthors,dc=lotus,o=ibm -> cn=contentEditors,dc=rational,o=ibm"
        - "cn=group1,dc=lotus,o=ibm -> cn=group2,dc=rational,o=ibm"
```

You can append multiple lines to the same file, and you can target multiple properties files in the same `propertiesFilesAdditions` section.

## Applying the changes

1. Add the lines that you want to append under `configuration.webEngine.propertiesFilesAdditions` in your custom Helm values file.

2. Run a [Helm upgrade](../working_with_compose/helm_upgrade_values.md) to apply the updated values.

## Restarting the server

The server is automatically restarted to pick up properties file changes.

!!!important
    This capability appends lines only to properties files stored in the WebEngine `services` folder.

!!!note
    The appended lines are not persistent after they are removed from the `propertiesFilesAdditions` section of the `values.yaml` file.
