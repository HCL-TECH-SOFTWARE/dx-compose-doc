---
id: ldap-configuration
title: Configuring LDAP
---

This guide provides instructions for configuring an (Lightweight Directory Access Protocol) LDAP registry in HCL Digital Experience (DX) Compose. This covers how to integrate an LDAP server with the WebEngine container using Helm.

## LDAP configuration in the `values.yaml`

Refer to the following sample snippet to configure the DX WebEngine server to use an LDAP server.

```yaml
configuration:
  webEngine:
    ldap: 
      host: "ldap.example.com"
      port: 389
      suffix: "dc=example,dc=com"
      serverType: "Custom"
      id: "dx_ldap"
      type: "other"
      bindUser: 'dx_user'
      bindPassword: 'p0rtal4u'
      customLdapSecret: "customLdapSecret"
```

Replace the values for the following parameters with the values of the LDAP server:

- `host`
- `port`
- `baseDN`
- `bindDN`
- `bindPassword`

## LDAP configuration parameters

In the [sample configuration](#ldap-configuration-in-the-valuesyaml), the following parameters are used:

- `host`: The LDAP server hostname. Only used if LDAP type is `other`.

- `port`: The LDAP server port. Only used if LDAP type is `other`.

- `suffix`: Base Distinguished Name for LDAP searches (also known as `baseDN`).

- `serverType`: The type of LDAP server. Accepts `Custom`.<!--, TODO: add more types.-->

- `id`: The LDAP configuration ID. Only used if LDAP type is `other`.

- `type`: The type determines which type of LDAP to use. Accepts `none`, `dx`, or `other`.

  - `none`: No LDAP configuration.

  - `dx`: For OpenLDAP server. You can also adjust the image version with `images > tags > openLdap`.

  - `other`: For other LDAP servers.

- `bindUser`: User used to connect to LDAP. Only used if LDAP type is `other`.

- `bindPassword`: Password used to connect to LDAP. Only used if LDAP type is `other`.

- `customLdapSecret`: The name of the secret that contains the bind user and password. This is used to store the bind user and password in a secret. Only used if LDAP type is `other`.

!!!note
    Provide either `customLdapSecret` or `bindUser` and `bindPassword`. If both are provided, the LDAP Bind User and Password from the secret will be used.

### Creating a secret

To create a secret, run the following command:

```sh
kubectl create secret generic CUSTOM_SECRET_NAME --from-literal=bindUser=CUSTOM_BIND_USER --from-literal=bindPassword=CUSTOM_BIND_PASSWORD --namespace=NAME_SERVER
```

Replace `CUSTOM_SECRET_NAME`, `CUSTOM_BIND_USER`, `CUSTOM_BIND_PASSWORD`, and `NAME_SERVER` with the actual values.

For example:

```sh
kubectl create secret generic custom-web-engine-secret --from-literal=bindUser=dx_user --from-literal=bindPassword=p0rtal4u --namespace=dxns
```

## LDAP configuration using overrides

For information on how to configure LDAP using configuration overrides, refer to [DX Compose configuration changes using overrides](configuration_changes_using_overrides.md).

## Sample LDAP configurations

Refer to the following sample LDAP configurations for HCL DX Compose:

- [Microsoft Active Directory server](#microsoft-active-directory-server)

### Microsoft Active Directory server

```bash
<?xml version="1.0" encoding="UTF-8"?><server description="DX Web Engine server">

        <ldapRegistry id="ldap" realm="SampleLdapADRealm" host="your_LDAP_Server_HostName" port="389" ignoreCase="true" baseDN="DC=ad,DC=test,DC=com" bindDN="CN=Administrator,CN=Users,DC=ad,DC=test,DC=com" bindPassword="your_password" ldapType="Microsoft Active Directory" sslEnabled="false" referral="ignore" recursiveSearch="true" bindAuthMechanism="simple" returnToPrimaryServer="true">

            <customFilters userFilter="(&amp;(sAMAccountName=%v)(objectcategory=user)" groupFilter="(&amp;(cn=%v)(objectcategory=group))" userIdMap="user:sAMAccountName" groupIdMap="*:cn" groupMemberIdMap="memberOf:member">

            </customFilters>            

           <ldapEntityType name="PersonAccount">

              <objectClass>user</objectClass>

           </ldapEntityType>              

            

            <ldapEntityType name="Group">

               <objectClass>group</objectClass>

           </ldapEntityType>

           <groupProperties>

              <memberAttribute name="member" scope="direct" objectClass="group"/>

              <membershipAttribute name="memberOf" scope="direct"/>

           </groupProperties>

           <loginProperty name="uid">uid</loginProperty>

        </ldapRegistry>

          <federatedRepository>

            <primaryRealm name="FederatedRealm" allowOpIfRepoDown="true" delimiter="/">

              <participatingBaseEntry name="o=defaultWIMFileBasedRealm" id="FileBasedEntry"/>

              <participatingBaseEntry name="DC=ad,DC=test,DC=com" id="LDAPEntry"/>

              

              <uniqueUserIdMapping inputProperty="uniqueName" outputProperty="uniqueName"/>

              <userSecurityNameMapping inputProperty="principalName" outputProperty="principalName"/>            

              <userDisplayNameMapping inputProperty="principalName" outputProperty="principalName"/>

              <uniqueGroupIdMapping inputProperty="uniqueName" outputProperty="uniqueName"/>              

              <groupSecurityNameMapping inputProperty="cn" outputProperty="cn"/>

              <groupDisplayNameMapping inputProperty="cn" outputProperty="cn"/>          

            </primaryRealm>

          </federatedRepository>         

</server>
```
