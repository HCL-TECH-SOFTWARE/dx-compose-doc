---
id: manage-users-groups-liberty
title: Manage Users and Groups in WebEngine
---

## Introduction

This guide provides instructions for configuring user registries and viewing users and groups in HCL Digital Experience (DX) on WebEngine. We will cover how to define basicRegistry and ldapRegistry in the server.xml file, and how to view users and groups once the registry is configured.

Note: The creation, update, or deletion of users and groups is currently not supported. 

## Configuring User and Group Management

To view users and groups, you must first configure your `server.xml` to include either a basic or LDAP registry. This configuration allows WebEngine to interact with the specified user information sources.

### Basic Registry Configuration

A basic user registry, which is a local, file-based repository, allows developers to set up a simple authentication system for testing application resource access. WebEngine offers a straightforward basic user registry tailored for use in development settings.

This registry can be easily set up within the server.xml file. While it's not recommended for use in production, it offers a convenient way to handle authentication and authorization for development and testing purposes. For instance, by configuring a basic user registry with two users, their passwords, and a group assigned to the administrator role, developers can simulate how access control would work. This setup enables testing of application resource access for different roles, such as an administrator, without the need for integrating with an external user registry.

The basic registry is suitable for development environments or scenarios where a simple user list is sufficient.

```xml
<server>    
    <basicRegistry id="basic" realm="SampleBasicRealm">
        <user name="admin" password="adminpwd" />
        <group name="adminGroup">
            <member name="admin" />
        </group>
    </basicRegistry>
</server>
```

The above configuration defines a `basicRegistry` with a user and a group. The user admin is part of the adminGroup.


### LDAP Registry Configuration

LDAP is a widely recognized protocol that facilitates authentication and authorization services by defining how application servers should interact with LDAP directories. These directories hold crucial security data, including usernames, passwords, and group memberships. While a basic user registry may be adequate for the initial stages of application development and testing, transitioning to an LDAP user registry is advisable for enhanced security in production environments.

To enable WebEngine to handle authentication via an LDAP directory, it's necessary to incorporate both the Application Security and LDAP User Registry features into your `server.xml` configuration. Additionally, if your application needs to communicate securely with an LDAP server that uses TLS, including the Transport Security feature in your configuration featureManager is essential.

Add the following configuration to define the `ldapRegistry`:
```xml
<ldapRegistry id="ldap" realm="LdapRealm"
              host="ldap.example.com"
              port="389"
              baseDN="dc=example,dc=com"
              bindDN="cn=admin,dc=example,dc=com"
              bindPassword="adminpassword"
              ldapType="Custom"
              ignoreCase="true"
              recursiveSearch="true">

</ldapRegistry>
```

Replace the placeholder values with the actual details of your LDAP server:

`host`: LDAP server hostname
`port`: LDAP server port
`baseDN`: Base Distinguished Name for LDAP searches
`bindDN`: Distinguished Name to bind to the LDAP server
`bindPassword`: Password for the bind DN
`ldapType`: Type of LDAP server (e.g., Custom, AD, etc.)

Note: If the LDAP server doesn't support recursive server-side searches, you can set the value of `recursiveSearch` to true to allow recursive searches for users.

For more information and using additional properties, see the [LDAP User Registry](https://openliberty.io/docs/latest/reference/feature/ldapRegistry-3.0.html) feature.


### Federated User Registry Configuration

When user and group data reside in various registries, WebEngine offers the capability to consolidate this dispersed information into a single, cohesive registry. This unified registry integrates data from different sources, including LDAP, basic, and custom user registries, into one centralized repository.

By default, if your `server.xml` file includes configurations for multiple basic, LDAP, or custom user registries, these are automatically unified under the Federated User Registry feature. This federation applies to LDAP user registries as well, whether they represent distinct data sources or are parts of the same LDAP directory. For detailed information, refer to the documentation on the [Federated User Registry](https://openliberty.io/docs/latest/reference/feature/federatedRegistry-1.0.html) feature.

```xml
<federatedRepository>
    <primaryRealm name="PrimaryRealm" allowOpIfRepoDown="true">
        <participatingBaseEntry name="o=SampleBasicRealm"/>
        <participatingBaseEntry name="dc=example,dc=com"/>
    </primaryRealm>
</federatedRepository>
```
The above configuration specifies the sample basic and LDAP registries to be included in the federation by referring to them by name within the `federatedRepository` element.

### Viewing Users and Groups

Once the registry is configured, you can view users and groups through the Manage Users and Groups portlet.

1. Log in to HCL Digital Experience as an administrator.

2. Click the **Administration menu** icon. Then, click **Access** > **Users and Groups**.

To view detailed information about users, such as passwords, User IDs, first names, last names, email addresses, or preferred languages:

1. Use the search function to locate a specific user, or click on the **All Authenticated Portal Users** link to see a comprehensive list of users.

2. Next to the user's name, click the pencil icon to view the user's detailed information.

Please note that editing user profile information is currently not supported.

### Defining Custom Attributes

Multiple custom attributes can be added at once or individually by specifying them in the `server.xml` file. Please refer to [Defining Custom Attributes](./adding_custom_attributes.md) on how to define Custom Attributes.

### Limitations

- Write operations like creating, updating, and deleting users and groups are currently not supported in HCL DX on WebEngine.
- You cannot assign attribute definitions to a user or group in a basicRegistry.
- Nested group search is not supported.

Certain more complex or less common scenarios that are supported in tWAS have not been thoroughly tested with WebEngine and are therefore not supported at this time. These include:

- Lookaside
- Application Groups
- Transient Users
