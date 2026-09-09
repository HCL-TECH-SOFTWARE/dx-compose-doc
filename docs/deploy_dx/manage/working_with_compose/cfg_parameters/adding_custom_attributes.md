---
id: adding-custom-attributes
title: Adding custom attributes in DX Compose
---

This topic provides steps on how to add or define custom attributes in Digital Experience (DX) Compose.

## Overview

You can add a single attribute or multiple custom attributes simultaneously by providing a Liberty configuration override file through the Helm `configOverrideFiles` parameter. The `<wplc-add-property>` tag is used to define custom attributes, and it contains one or more `<resource>` tags. Each `<resource>` tag includes attributes that are specific to the property: `propertyName`, `dataType`, `entityTypes`, and `multiValued`.

## Attribute description

The following list provides the description of each attribute:

- `propertyName`: The name of the property you are adding.

- `entityTypes`: This value is a list of entity types to which the new property applies. If you need to enter multiple values, separate each value with a comma (for example "value1,value2"). Valid values are `Group` and `PersonAccount`.

- `dataType`: This defines the type of data stored in the attribute being created. If this attribute is mapped to LDAP, this data type must match the corresponding attribute type in LDAP. Consult your LDAP administrator if you are unsure of the data types. Refer to the following list for the valid values for this attribute:

    - `String`
    - `Int`
    - `DateTime`
    - `Base64Binary`
    - `IdentifierType`
    - `Boolean`
    - `Long`
    - `Double`
    - `Short`

    !!!note
        While it is possible to add attributes of different types, the Registration/Edit My Profile Portlet can only handle attributes of type `String` and `Int`. If you need UI support for other types, you must create your own custom form or portlet that can process those types. The Portal does not have a UI that reads or updates group attributes.

- `multiValued`: This defines whether the property can contain multiple values or not.

## Configure custom attributes with Helm

To define custom attributes in Kubernetes deployments, add a Liberty configuration override file by using the `configOverrideFiles` parameter in your Helm values file. The override file is mounted into the Liberty `configDropins/overrides` directory.

1. Export the current Helm values:

    ```sh
    helm get values dx-deployment -n dxns -o yaml -a > custom-values-all.yaml
    ```

2. Add the custom attribute configuration to `custom-values-all.yaml`:

    ```yaml
    configOverrideFiles:
      custom-attributes.xml: |
        <server description="DX Web Engine server">
          <wplc-add-property>
            <resource propertyName="attribute_name_1" dataType="Int" entityTypes="Group" multiValued="true" />
            <resource propertyName="attribute_name_2" dataType="String" entityTypes="PersonAccount" multiValued="true" />
            <resource propertyName="attribute_name_3" dataType="Base64Binary" entityTypes="Group,PersonAccount" multiValued="false" />
          </wplc-add-property>
        </server>
    ```

    - Replace the `propertyName` value with the actual name of the attributes you want to add.
    - `dataType` should be the type of the data you want to store in the attribute.
    - `entityTypes` should be the entities that can have this attribute.
    - `multiValued` attribute should be set to `true` if an entity can have multiple instances of this attribute, and `false` if otherwise.

3. Apply the updated values:

    ```sh
    helm -n dxns upgrade dx-deployment ./install-hcl-dx-deployment/ -f install-deploy-values.yaml -f custom-values-all.yaml
    ```

4. Restart the DX WebEngine or Core pod to apply the custom attributes.

    !!!note
        Updating the Helm values and mounted configuration file does not automatically reload the custom attribute definitions. The custom attributes are read and cached during runtime initialization, so a Liberty JVM restart is required.

The custom attributes should be successfully added and reflected in the API response after the restart.

!!!note
    If the same custom attribute is defined in both the default Liberty configuration and a file in `configDropins/overrides`, the definition from the override file takes precedence.
