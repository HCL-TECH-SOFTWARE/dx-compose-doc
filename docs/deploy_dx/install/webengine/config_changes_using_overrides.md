---
id: web-engine-configuration-changes-using-overrides
title: Web Engine configuration changes using overrides
---
## Overview
This document provides detailed steps for updating the `server.xml` properties or for configuration using `configOverrideFiles`.

The snippets are merged into the Open Liberty `server.xml` file. After making changes to the respective `values.yaml` file, apply them by using the **helm upgrade ...** command. Open Liberty picks up and applies changes at runtime; this does not require a restart.

## User / User Group through configuration overrides
Below is an example snippet of  configuring DX Web Engine server to configure or override user or user group.

```
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
**Note:** The name of the customization (`user-overrides.xml` in the example above) can be any string. However, it's beneficial for it to be descriptive of the changes it introduces.
**Note:** To update the default admin username and password, refer to [Updating the Default Admin Password](update-wpsadmin-password.md).

## SMTP configuration through configuration overrides
Below is an example snippet of configuring DX Web Engine server to use a mail server. The `smtphost` will need to be replaced with the proper hostname of the mail server. If authentication is required to communicate with the mail server then replace `smtpUser` and `smtpPassword` with the correct values, otherwise remove those lines from the snippet.

```
configOverrideFiles:
  smtpOverride.xml: | 
    <server description="DX Web Engine server">
      <mailSession
        id="dxWebEngineMail"
        host="smtphost.com"
        from="no-reply@smtphost.com"
        jndiName="mail/BuilderMailSession"
        description="DX Web Engine MailSession"
        mailSessionID="dxWebEngineMail"
        user="smtpUser"
        password="smtpPassword">
          <property name="mail.smtp.auth" value="false" />
          <property name="mail.smtp.port" value="25" />
      </mailSession>
    </server>
```
**Note:** The name of the customization (`smtpOverride` in the example above) can be any string. However, it's beneficial for it to be descriptive of the changes it introduces.

## SSL configuration through configuration overrides
The Open Liberty may not trust default certificates. By providing this config setting, the default certificates will be trusted enabling communication with third-party services.

```
configOverrideFiles:
   sslOverride.xml: |
      <server description="DX Web Engine server">  
        <ssl id="defaultSSLConfig" trustDefaultCerts="true" />
      </server>
```
**Note:** The name of the customization (`sslOverride` in the example above) can be any string. However, it's beneficial for it to be descriptive of the changes it introduces.

## LDAP Configuration Through Configuration Overrides
Below is an example snippet for configuring the DX Web Engine server to use an OpenLDAP server. The **baseDN**, **bindDN**, **bindPassword**, and **host** will need to be replaced with the proper values.
```
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
          <idsFilters
            userFilter="(&amp;(uid=%v)(objectclass=inetOrgPerson))"
            groupFilter="(&amp;(cn=%v)(objectclass=groupOfUniqueNames))"
            userIdMap="*:uid"
            groupIdMap="*:cn"
            groupMemberIdMap="groupOfUniqueNames:uniqueMember">
          </idsFilters>
      </ldapRegistry>
      <federatedRepository>
        <primaryRealm name="FederatedRealm" allowOpIfRepoDown="true">
          <participatingBaseEntry name="o=defaultWIMFileBasedRealm"/>
          <participatingBaseEntry name="dc=dx,dc=com"/>
        </primaryRealm>
      </federatedRepository>
    </server>
```
Follow this document to set up a custom LDAP server in Liberty: [Configuring LDAP with Liberty](ldap-configuration.md).

## Security Hardening

Several out of the box security hardenings have been applied based on [Security hardening for production](https://openliberty.io/docs/latest/security-hardening.html):
```
configOverrideFiles:
  securityOverride.xml: | 
    <server description="DX Web Engine server"> 
      <webAppSecurity httpOnlyCookies="true" removeServerHeader="true" disableXPoweredBy="true" trackLoggedOutSSOCookies="true"/>
      <httpDispatcher enableWelcomePage="false" />
      <httpOptions removeServerHeader="true" />
      <httpSession invalidateOnUnauthorizedSessionRequestException="true" cookieHttpOnly="true"/>
    </server>  
```
To allow http access for developer setups with the docker image, SSL only has not been enforced. 
For a production setup one might apply the following as server.xml override:
```
  configOverrideFiles:
    securityOverride.xml: | 
      <server description="DX Web Engine server"> 
        <webAppSecurity httpOnlyCookies="true" removeServerHeader="true" disableXPoweredBy="true" trackLoggedOutSSOCookies="true" ssoRequiresSSL="true" sameSiteCookie="none"/>
        <httpSession invalidateOnUnauthorizedSessionRequestException="true" cookieHttpOnly="true" cookieSameSite="None"/>
      </server>
```

Also by default we have configured to trust any default certificates, which are typically included in all mainstream browsers.
By providing this config setting, the default certificates will be not trusted disabling communication with third-party services.
```
  configOverrideFiles:
    securityOverride.xml: | 
    <server description="DX Web Engine server"> 
      <ssl id="defaultSSLConfig" trustDefaultCerts="false" />
    </server>
```

**Note**: Refer to this [Update custom values.yaml with configOverrideFiles using HELM upgrade](helm-upgrade-values.md).
