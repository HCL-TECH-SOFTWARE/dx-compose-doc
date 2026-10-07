---
id: manage-users-groups-liberty
title: Managing users and groups in DX Compose
---

This guide provides instructions for configuring user registries and viewing users and groups in Digital Experience (DX) Compose. This covers how to define `basicRegistry` and `ldapRegistry` in the `server.xml` file, and how to view users and groups after the registry is configured.

!!!note
    Creating, updating, and deleting users and groups are currently not supported.

## Configuring user and group management

To view users and groups, you must first configure your `server.xml` to include either a basic or Lightweight Directory Access Protocol (LDAP) registry. This configuration allows DX Compose to interact with the specified user information sources.

### Configuring basic registry

A basic user registry, which is a local, file-based repository, allows developers to set up a simple authentication system for testing application resource access. DX Compose offers a straightforward basic user registry tailored for use in development settings.

Developers can set up the basic user registry within the `server.xml` file. While it is not recommended for production use, this registry offers a convenient way to handle authentication and authorization for development and testing purposes. For example, by configuring a basic user registry with two users, their passwords, and a group assigned to the administrator role, developers can simulate how access control would work. This setup enables testing of application resource access for different roles, such as an administrator, without the need for integrating with an external user registry.

The basic registry is suitable for development environments or scenarios where a simple user list is sufficient.

The following configuration defines a `basicRegistry` with a user and a group. The user admin is part of the `adminGroup`.

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

### Configuring LDAP registry

LDAP is a widely recognized protocol that facilitates authentication and authorization services by defining how application servers should interact with LDAP directories. These directories hold crucial security data, including usernames, passwords, and group memberships. While a basic user registry may be adequate for the initial stages of application development and testing, transitioning to an LDAP user registry is advisable for enhanced security in production environments.

To enable DX Compose to handle authentication through a Lightweight Directory Access Protocol (LDAP) directory, add the Application Security and LDAP User Registry features to your `server.xml`. If the application communicates securely with an LDAP server using TLS, add the Transport Security feature to `featureManager`. <!--Is this sentence relevant to this section? I'm not sure where featureManager is-->

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
              recursiveSearch="false">
</ldapRegistry>
```

Replace the placeholder values with the actual details of your LDAP server:

- `host`: Specifies the LDAP server hostname.
- `port`: Specifies the connection port number for the LDAP server.
- `baseDN`: Specifies the starting point in the LDAP directory tree for search queries.
- `bindDN`: Specifies the distinguished name (DN) of the service account used to authenticate with the LDAP server.
- `bindPassword`: Specifies the password for the bind DN.
- `ldapType`: Specifies the LDAP server vendor type (for example, `Custom` or `AD`).
- `recursiveSearch`: Specifies whether Open Liberty expands nested groups (default: `false`). For more information, refer to [Configuring nested LDAP groups](#configuring-nested-ldap-groups).

For more information about using additional properties, refer to [LDAP User Registry 3.0](https://openliberty.io/docs/latest/reference/feature/ldapRegistry-3.0.html){target="_blank"}.

### Configuring nested LDAP groups

A nested LDAP group is an LDAP group entry that contains another group as a member rather than individual user accounts. Privileges and access permissions assigned to the parent group automatically inherit down to all members of the contained child groups. This hierarchical structure allows administrators to manage access for entire teams or departments by adjusting group memberships instead of editing individual user entries.

The `recursiveSearch` attribute of the `ldapRegistry` element in your `server.xml` file controls whether Open Liberty expands these nested groups when it queries the LDAP server.

- Set to `false` to display direct members and child entries in the Users and Groups UI, allowing navigation down the directory tree. DX Compose resolves parent memberships during login to apply inherited permissions. Use this default setting for most deployments.
- Set to `true` to expand nested memberships through the directory server and display a flat list of users in the Users and Groups UI without showing hierarchy. Use this setting only if required by your directory.

After you change `recursiveSearch`, restart the DX Compose server and verify user access.

### Configuring federated user registry

When user and group data reside in various registries, DX Compose offers the capability to consolidate this dispersed information into a single, cohesive registry. This unified registry integrates data from different sources, including LDAP, basic, and custom user registries, into one centralized repository.

By default, if your `server.xml` file includes configurations for multiple basic, LDAP, or custom user registries, these are automatically unified under the [Federated User Registry](https://openliberty.io/docs/latest/reference/feature/federatedRegistry-1.0.html){target="_blank"}  feature. This federation applies to LDAP user registries as well, whether they represent distinct data sources or are parts of the same LDAP directory.

The following configuration specifies the sample basic and LDAP registries to be included in the federation by referring to them by name within the `federatedRepository` element.

```xml
<federatedRepository>
    <primaryRealm name="PrimaryRealm" allowOpIfRepoDown="true">
        <participatingBaseEntry name="o=SampleBasicRealm"/>
        <participatingBaseEntry name="dc=example,dc=com"/>
    </primaryRealm>
</federatedRepository>
```

### Configuring user registry limits

By default, DX Compose limits user registry searches to 500 users. To change this limit, update the `store.puma_default.userRegistryLimit` under `PumaStoreService.properties` in your `values.yaml` file. For example:

```yaml
configuration:
  webEngine:
    propertiesFilesOverrides: 
      PumaStoreService.properties:
        store.puma_default.userRegistryLimit: "4500"
```

## Viewing users and groups

After the registry is configured, you can view users and groups through the Manage Users and Groups portlet.

1. Log in to DX Compose as an administrator.
2. Click the **Administration menu** icon. Then, click **Access > Users and Groups**.
The portlet lists the direct members of the selected group, including any child groups. Select a child group to view its members and continue navigating the nested group hierarchy. If `recursiveSearch` is set to `true` in your LDAP registry, the users of all child groups are instead shown as a single flat list. For more information, refer to [Configuring nested LDAP groups](#configuring-nested-ldap-groups).

To view detailed information about users, such as passwords, User IDs, first names, last names, email addresses, or preferred languages:

1. Use the search function to locate a specific user, or click the **All Authenticated Portal Users** link to see a comprehensive list of users.
2. Next to the user's name, click the pencil icon to view the user's detailed information.

!!!note
    Editing user profile information is currently not supported.

## Disabling Edit My Profile

DX Compose does not support saving changes to user profiles. To prevent users from attempting to update their information, hide the **Edit My Profile** page.

1. Sign in to DX Compose as an administrator.
2. Select **Open applications menu**, and then go to **Administration > Site Management > Pages**.
3. Select **Content Root > Hidden Pages**.
4. Find **Edit My Profile**.
5. In the **Status** column, select **Active**.
6. In the confirmation dialog box, select **OK**. The status changes to **Inactive**.
7. Sign out, and then sign in with a user ID to verify the profile settings.

!!!note
    To re-enable the profile view when the feature is available, follow these steps and change the status of the **Edit My Profile** page to **Active**.

## Defining custom attributes

You can add multiple custom attributes at once or individually by specifying them in the `server.xml` file. For more information, refer to [Defining Custom Attributes](adding_custom_attributes.md).

## Limitations

- Write operations such as creating, updating, and deleting users and groups are currently not supported in DX Compose.
- You cannot assign attribute definitions to a user or group in a basic user registry.

More complex or less common scenarios that are supported in the WebSphere Application Server (WAS) have not been thoroughly tested with DX Compose and are not supported at this time. These include the following:

- Lookaside database
- Application groups
