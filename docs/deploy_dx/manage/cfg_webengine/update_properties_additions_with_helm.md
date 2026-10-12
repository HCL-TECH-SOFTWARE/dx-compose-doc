---
id: update-properties-additions-with-helm
title: "Appending entries to WebEngine `.properties` files using Helm values"
---

Use the `propertiesFilesAdditions` section in your HCL Digital Experience (DX) Compose Helm chart `values.yaml` file to append entries to WebEngine `.properties` files. Use this capability when you need to add entries that must remain raw lines instead of key-value properties, such as `MemberFixerModule.properties` mappings.

1. Add the `propertiesFilesAdditions` section under `configuration.webEngine` in your custom Helm values file using the following format:

    ```yaml
    configuration:
    webEngine:
        propertiesFilesAdditions:
        <propertiesFileName>:
            - "<lineToAppend1>"
            - "<lineToAppend2>"
    ```

    - `propertiesFileName`: The name of the `.properties` file you want to update.
    - `lineToAppend1`, `lineToAppend2`: The complete line you want to append as-is to the end of the target file.

    For example:

    ```yaml
    configuration:
    webEngine:
        propertiesFilesAdditions:
        MemberFixerModule.properties:
            - "cn=contentAuthors,dc=lotus,o=ibm -> cn=contentEditors,dc=rational,o=ibm"
            - "cn=group1,dc=lotus,o=ibm -> cn=group2,dc=rational,o=ibm"
    ```

    !!!note
        You can append multiple lines to the same file and target multiple properties files in the same `propertiesFilesAdditions` section.

2. Run a [Helm upgrade](../working_with_compose/helm_upgrade_values.md) to apply the updated values.

## Restarting the server

The server restarts automatically to apply `.properties` file changes.

!!!important
    - This capability appends lines only to `.properties` files stored in the WebEngine `services` folder.
    - Appended lines do not persist if you remove them from the `propertiesFilesAdditions` section of the `values.yaml` file.
