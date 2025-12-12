---
id: web-engine-configuration-changes-using-overrides
title: DX WebEngine configuration changes using overrides
---

This guide provides detailed steps for updating the `server.xml` properties and for configuring the Digital Experience (DX) Compose server using `configuration.webEngine.configOverrideFiles`.

The snippets are merged into the Open Liberty `server.xml` file. After making changes to the respective `values.yaml` file, apply them by using the `helm upgrade` command. Open Liberty picks up and applies changes at runtime; this does not require a restart.

## Configuring users or user groups

The following sample snippet shows how to configure a DX WebEngine server to configure or override a user or a user group.

```yaml
configOverrideFiles:
  user-overrides.xml: |
    <server description="DX Web Engine server"> 
      <basicRegistry id="basic" realm="defaultWIMFileBasedRealm"> 
        <user name="wpsadmin" password="newPass" />
        <user name="newuser1" password="password" />
        <group name="wpsadmins" id="cn=wpsadmins,o=defaultWIMFileBasedRealm">
          <member name="wpsadmin" />
        </group>
        <group name="nonadmins" id="cn=nonadmins,o=defaultWIMFileBasedRealm">
          <member name="newuser1" />
        </group>
      </basicRegistry> 
    </server>
```

The name of the customization in the example (`user-overrides.xml`) can be any string. However, it is recommended that you use a name that describes the change it applies.

To update the default administrator username and password, refer to the steps in [Updating the default admin password](../cfg_webengine/update_wpsadmin_password.md).

## Configuring DX Compose to use a mail server

The following is an example snippet of configuring DX WebEngine server to use a mail server. The `smtphost` will need to be replaced with the proper hostname of the mail server. If authentication is required to communicate with the mail server then replace `smtpUser` and `smtpPassword` with the correct values, otherwise remove those lines from the snippet.

```yaml
configOverrideFiles:
  smtpOverride.xml: | 
    <server description="DX Web Engine server">
      <mailSession
        id="dxWebEngineMail"
        host="smtphost.com"
        from="no-reply@smtphost.com"
        jndiName="mail/BuilderMailSession"
        description="DX WebEngine MailSession"
        mailSessionID="dxWebEngineMail"
        user="smtpUser"
        password="smtpPassword">
          <property name="mail.smtp.auth" value="false" />
          <property name="mail.smtp.port" value="25" />
      </mailSession>
    </server>
```

The name of the customization in the example (`smtpOverride`) can be any string. However, it is recommended that you use a name that describes the change it applies.

## Configuring SSL

The Open Liberty may not trust default certificates. By providing the following configuration setting, Open Liberty trusts the default certificates, enabling communication with third-party services.

```yaml
configOverrideFiles:
   sslOverride.xml: |
      <server description="DX Web Engine server">  
        <ssl id="defaultSSLConfig" trustDefaultCerts="true" />
      </server>
```

The name of the customization in the example (`sslOverride`) can be any string. However, it is recommended that you use a name that describes the change it applies.

## Configuring LDAP

The following is a sample snippet that shows how to configure the DX Compose server to use an OpenLDAP server. Replace the values for `baseDN`, `bindDN`, `bindPassword`, and `host` with the proper values.

For custom LDAP types, use `customFilters` to define your own search filters for users and groups. For predefined LDAP types supported by Open Liberty, use `idsFilters`. If your LDAP directory uses nested groups or hierarchical structures, consider enabling `recursiveSearch` to ensure all relevant entries are retrieved. For more information, refer to the [Open Liberty LDAP Registry documentation](https://openliberty.io/docs/latest/reference/config/ldapRegistry.html){target="_blank"}.

The `attributeConfiguration` element in the LDAP registry configuration allows you to map LDAP attributes to user registry attributes. This is useful when the attribute names in your LDAP directory do not match the expected attribute names. Each `attribute` element specifies a mapping:

- `name` - The name of the attribute in the LDAP directory
- `propertyName` - The name of the attribute to be mapped to. In the following example, the LDAP `mail` attribute is mapped to `ibm-primaryEmail`, which is the attribute used to display the email address of a user. The LDAP `title` attribute is mapped to `ibm-jobTitle`, which is the attribute used to display job title of a user.

```xml
configOverrideFiles:
  ldapOverride.xml: | 
    <server description="DX Web Engine server"> 
      <ldapRegistry id="ldap" realm="SampleLdapIDSRealm"
        host="127.0.0.1" port="1389" ignoreCase="true"
        baseDN="dc=dx,dc=com"
        ldapType="Custom"
        sslEnabled="false"
        bindDN="cn=dx_user,dc=dx,dc=com"
        bindPassword="p0rtal4u">
          <customFilters
            userFilter="(&amp;(uid=%v)(objectclass=inetOrgPerson))"
            groupFilter="(&amp;(cn=%v)(objectclass=groupOfUniqueNames))"
            userIdMap="*:uid"
            groupIdMap="*:cn"
            groupMemberIdMap="groupOfUniqueNames:uniqueMember">
          </customFilters>
          <attributeConfiguration>
            <attribute name="mail" propertyName="ibm-primaryEmail" entityType="PersonAccount"/>
            <attribute name="title" propertyName="ibm-jobTitle" entityType="PersonAccount"/>
          </attributeConfiguration>
      </ldapRegistry>
      <federatedRepository>
        <primaryRealm name="FederatedRealm" allowOpIfRepoDown="true">
          <participatingBaseEntry name="o=defaultWIMFileBasedRealm"/>
          <participatingBaseEntry name="dc=dx,dc=com"/>
        </primaryRealm>
      </federatedRepository>
    </server>
```

To set up a custom LDAP server in Liberty, see [Configuring LDAP with Liberty](ldap_configuration.md).

## Additional LDAP Configuration samples

- [IBM Directory Server](#ibm-directory-server)
- [Microsoft Active Directory Server](#microsoft-active-directory-server)

### IBM Directory Server

```xml
    configOverrideFiles:
      myCustomOverride.xml: |
        <?xml version="1.0" encoding="UTF-8"?> 
        <server description="DX Web Engine server">
          <ldapRegistry id="ldap" realm="SampleLdapIDSRealm"
            host='your_LDAP_Server_HostName'
            port='1389' ignoreCase="true"
            baseDN='dc=dx,dc=com'
            ldapType='Custom'
            sslEnabled='false'
            bindDN='${LDAP_BIND_USER}'
            bindPassword='${LDAP_BIND_PASSWORD}'>
            <customFilters
              userFilter="(&amp;(uid=%v)(objectclass=inetOrgPerson))"
              groupFilter="(&amp;(cn=%v)(objectclass=groupOfUniqueNames))"
              userIdMap="*:uid"
              groupIdMap="*:cn"
              groupMemberIdMap="groupOfUniqueNames:uniqueMember">
            </customFilters>
            <ldapCache>
              <attributesCache size="4000" sizeLimit="4000" timeout="2400s" />
              <searchResultsCache resultsSizeLimit="4000" size="4000" timeout="2400s" />
            </ldapCache>
            <contextPool preferredSize="20"/>
            <attributeConfiguration>
              <attribute name="mail" propertyName="ibm-primaryEmail" entityType="PersonAccount"/>
              <attribute name="title" propertyName="ibm-jobTitle" entityType="PersonAccount"/>
            </attributeConfiguration>
          </ldapRegistry>
          <federatedRepository>
            <primaryRealm name="FederatedRealm" allowOpIfRepoDown="true">
              <participatingBaseEntry name="o=defaultWIMFileBasedRealm"/>
              <participatingBaseEntry name='dc=dx,dc=com' />
              <uniqueUserIdMapping inputProperty="uniqueName" outputProperty="uniqueName"/>  
              <userSecurityNameMapping inputProperty="principalName" outputProperty="principalName"/>  
              <userDisplayNameMapping inputProperty="principalName" outputProperty="principalName"/>  
              <uniqueGroupIdMapping inputProperty="uniqueName" outputProperty="uniqueName"/>      
              <groupSecurityNameMapping inputProperty="cn" outputProperty="cn"/>  
              <groupDisplayNameMapping inputProperty="cn" outputProperty="cn"/>                
            </primaryRealm>
          </federatedRepository>   
          <basicRegistry id="basic" realm="defaultWIMFileBasedRealm">
              <user name="${DX_ADMIN}" password="${DX_PASSWORD}" id="uid=wpsadmin,o=defaultWIMFileBasedRealm"/>
              <user name="nonadmin" password="nonadminpwd" id="uid=nonadmin,o=defaultWIMFileBasedRealm"/>
              <user name="admin1" password="admin1pwd" id="uid=admin1,o=defaultWIMFileBasedRealm"/>
              <group name="wpsadmins" id="cn=wpsadmins,o=defaultWIMFileBasedRealm">
                  <member name="${DX_ADMIN}" />
                  <member name="admin1" />
                  <member  name="tuser1"/>
              </group>
              <group name="nonadmins" id="cn=nonadmins,o=defaultWIMFileBasedRealm">
                  <member name="nonadmin" />
              </group>
          </basicRegistry>          
        </server>
```

### Microsoft Active Directory Server

```xml
    configOverrideFiles:
      myCustomOverride.xml: |
        <?xml version="1.0" encoding="UTF-8"?>  
        <server description="DX Web Engine server">  
                <ldapRegistry  
                  id="ldap"  
                  realm="SampleLdapADRealm"  
                  host="your_LDAP_Server_HostName"  
                  port="389"  
                  ignoreCase="true"  
                  baseDN="DC=ad,DC=test,DC=com"  
                  bindDN="CN=Administrator,CN=Users,DC=ad,DC=test,DC=com"  
                  bindPassword="your_password"  
                  ldapType="Microsoft Active Directory"  
                  sslEnabled="false"  
                  referral="ignore"  
                  recursiveSearch="true"  
                  bindAuthMechanism="simple"  
                  returnToPrimaryServer="true">  
                    <customFilters 
                    userFilter="(&amp;(sAMAccountName=%v)(objectcategory=user)" 
                    groupFilter="(&amp;(cn=%v)(objectcategory=group))" 
                    userIdMap="user:sAMAccountName" 
                    groupIdMap="*:cn" 
                    groupMemberIdMap="memberOf:member">  
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

## Security hardening

### Out-of-the-box configuration

Several out of the box security hardenings have been applied based on [Security hardening for production](https://openliberty.io/docs/latest/security-hardening.html)(https://openliberty.io/docs/latest/reference/config/ldapRegistry.html){target="_blank"}:

```yaml
configOverrideFiles:
  securityOverride1.xml: | 
    <server description="DX Web Engine server"> 
      <webAppSecurity httpOnlyCookies="true" trackLoggedOutSSOCookies="false"/>
      <httpDispatcher enableWelcomePage="false" />
      <httpOptions removeServerHeader="true" />
      <httpSession invalidateOnUnauthorizedSessionRequestException="true" cookieHttpOnly="true"/>
    </server>  
```

The `trackLoggedOutSSOCookies` setting, when enabled, ensures that if a user logs out from one browser, the same user will be required to log in again if they try to access the resource from another browser. This setting helps prevent session replay attacks by marking the LTPA cookie as invalid upon logout.

However, enabling `trackLoggedOutSSOCookies` can impact your SSO scenarios. For example, if a user logs in from multiple browsers to the same server and logs out from one browser, they must log in again if they try to access the resource from another browser. As a result, `trackLoggedOutSSOCookies` is set to `false` by default but can be enabled for production environments.

To allow HTTP access for developer setups with the Docker image, SSL only has not been enforced. 

For a production setup, you can apply the following as a `server.xml` override:

```yaml
  configOverrideFiles:
    securityOverride2.xml: | 
      <server description="DX Web Engine server"> 
        <webAppSecurity httpOnlyCookies="true" removeServerHeader="true" disableXPoweredBy="true" trackLoggedOutSSOCookies="true" ssoRequiresSSL="true" sameSiteCookie="none"/>
        <httpSession invalidateOnUnauthorizedSessionRequestException="true" cookieHttpOnly="true" cookieSameSite="None"/>
      </server>
```

By default, the system is configured to trust any default certificates, which are typically included in all mainstream browsers. To change this default behavior and disable communication with third-party services, provide the following configuration setting:

```yaml
  configOverrideFiles:
    securityOverride3.xml: | 
    <server description="DX Web Engine server"> 
      <ssl id="defaultSSLConfig" trustDefaultCerts="false" />
    </server>
```

See [Security hardening for production](https://openliberty.io/docs/latest/security-hardening.html){target="_blank"} for more information.

### Additional configuration

You can use virtual hosts to limit the domains the server responds to. In the following example, the virtual host is configured to not respond to other hosts than `localhost` and `sample.hcl.com`:

```yaml
<virtualHost id="default_host" allowFromEndpointRef="localHostOnly">
    <hostAlias>*:9080</hostAlias>
    <hostAlias>*:9443</hostAlias>
    <hostAlias>sample.hcl.com:80</hostAlias>
    <hostAlias>sample.hcl.com:443</hostAlias>
</virtualHost>
```

## Disabling Authentication Cache for Impersonation

To ensure the impersonation feature works in HCL DX Compose, you must disable the authentication cache. By default, the authentication cache is enabled. Disabling the cache ensures that the impersonated user is not prompted to authenticate again.

!!!note
    Disabling the authentication cache might affect performance.

To disable the authentication cache, use the following configuration snippet in your `values.yaml` file:

```yaml
configOverrideFiles:
  authOverride.xml: | 
    <server description="DX Web Engine server">
      <authentication cacheEnabled="false" />
    </server>
```

The name of the customization in the example (`authOverride`) can be any unique string. However, it is recommended that you use a name that describes the change it applies.

???+ info "Related information"
    - [Update custom values.yaml with configOverrideFiles using HELM upgrade](../working_with_compose/helm_upgrade_values.md).
