---
id: adding-custom-attributes
title: Adding custom attributes in Liberty
---

This topic provides steps on how to add or define custom attributes in Liberty.

## Overview

You can add a single attribute or multiple custom attributes simultaneously by including them in the `server.xml` file. In the `server.xml` file, the `<wplc-add-property>` tag is used to define custom attributes, and it contains one or more `<resource>` tags. Each `<resource>` tag includes attributes that are specific to the property: `propertyName`, `dataType`, `entityType`, and `multiValued`.

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

## Liberty `server.xml` updates

To define the custom attributes, you must adjust the Liberty server configuration by adding the custom attributes in the following format:

```xml
<wplc-add-property>
    <resource propertyName="xxx" dataType="xxx" entityTypes="xxx" multiValued="xxx" />
</wplc-add-property>
```

1. Locate the `server.xml` file inside your Liberty container:

    ```sh
    cd /opt/openliberty/wlp/usr/servers/defaultServer
    vi server.xml
    ```


2. In the `server.xml` file, define the custom attributes.

    See the following sample to add three custom attributes:

    ```xml
    <wplc-add-property>
        <resource propertyName="attribute_name_1" dataType="Int" entityTypes="Group" multiValued="true" />
        <resource propertyName="attribute_name_2" dataType="String" entityTypes="PersonAccount" multiValued="true" />
        <resource propertyName="attribute_name_3" dataType="Base64Binary" entityTypes="Group,PersonAccount" multiValued="false" />
    </wplc-add-property>
    ```

    - Replace the `propertyName` value with the actual name of the attributes you want to add.
    - `dataType` should be the type of the data you want to store in the attribute.
    - `entityTypes` should be the entities that can have this attribute.
    - `multiValued` attribute should be set to `true` if an entity can have multiple instances of this attribute, and `false` if otherwise.

3. After making these changes, stop and restart the Liberty server to apply the changes. 

The custom attributes should be successfully added and reflected in the API response.