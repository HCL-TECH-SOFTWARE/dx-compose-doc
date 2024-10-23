---
id: adding-custom-attributes
title: Adding Custom Attributes in Liberty
---

## Introduction

This document provides a guide on how to add or define custom attributes in Liberty.

### Approach

You can add multiple custom attributes simultaneously or a single attribute by including them in the server.xml file. In the server.xml file, the `<wplc-add-property>` tag is used to define custom attributes, and it contains one or more `<resource>` tags. Each `<resource>` tag includes attributes definition that are specific to the property: propertyName, dataType, entityType, and multiValued. 

#### Attribute definition details

- **propertyName**: The name of the property you are adding.

- **entityTypes**: This value is a list of entity types to which the new property applies. If you need to enter multiple values, separate each value with a comma, for example "value1,value2". 
Valid values include `Group` and `PersonAccount`.

- **dataType**: This defines the type of data stored in the attribute being created. If this attribute is mapped to LDAP, this data type must match the corresponding attribute type in LDAP. Consult your LDAP administrator if you are unsure of the data types in LDAP. 
Valid values include `String`, `Int`, `DateTime`, `Base64Binary`, `IdentifierType`, `Boolean`, `Long`, `Double`, `Short`. 

Note that while it is possible to add attributes of different types, the Registration/Edit My Profile Portlet can only handle attributes of type `String` and `Int`. If you need UI support for other types, you will need to create your own custom form or portlet that can process those types. The Portal does not have a UI that reads or updates group attributes.

- **multiValued**: This defines whether the property can contain multiple values or not.

#### Liberty server.xml updates

To define the custom attributes, you need to adjust the Liberty server configuration by adding the custom attributes in the format defined above. For this, locate the `server.xml` file inside of your Liberty container:

```sh
cd /opt/openliberty/wlp/usr/servers/defaultServer
vi server.xml
```
Within the file, define the custom attributes:

Here is an example to add three custom attributes:

```xml
<wplc-add-property>
    <resource propertyName="attribute_name_1" dataType="Int" entityTypes="Group" multiValued="true" />
    <resource propertyName="attribute_name_2" dataType="String" entityTypes="PersonAccount" multiValued="true" />
    <resource propertyName="attribute_name_3" dataType="Base64Binary" entityTypes="Group,PersonAccount" multiValued="false" />
</wplc-add-property>
```

Please replace the propertyName value with the actual name of the attributes you want to add. The dataType should be the type of the data you want to store in the attribute, and entityTypes should be the entities that can have this attribute. The multiValued attribute should be set to true if an entity can have multiple instances of this attribute, and false otherwise.

After making these changes, you need to stop and restart the Liberty server to propagate the changes. The custom attributes should be successfully added and reflected in the API response.