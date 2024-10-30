---
id: ldap-configuration
title: LDAP Configuration
---

## Introduction

This guide provides instructions for configuring an LDAP registry in HCL Digital Experience (DX) on Liberty. We will cover how to integrate an LDAP server with the DX web engine using HELM.

### LDAP Configuration in the values.yaml
Below is an example snippet for configuring the DX Web Engine server to use an LDAP server. The `host`, `port`, `baseDN`, `bindDN`, and `bindPassword` will need to be replaced with the proper values of the LDAP server.
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

### LDAP Configuration Parameters Explanation

In the above configuration, the following parameters are used:

- **host**: LDAP server hostname, only used if LDAP type is "other".

- **port**: LDAP server port, only used if LDAP type is "other".

- **suffix**: Base Distinguished Name for LDAP searches (also known as baseDN).

- **serverType**: The type of LDAP server. Accepts: "Custom", TODO: add more types.

- **id**: The LDAP configuration ID, only used if LDAP type is "other".

- **type**: The type determines which type of LDAP to use. Accepts: "none", "dx", or "other".

  - **none**: No LDAP configuration.

  - **dx**: For OpenLDAP server (you can also adjust the image version with `images -> tags -> openLdap`).

  - **other**: For other LDAP servers.

- **bindUser**: User used to connect to LDAP, only used if LDAP type is "other".

- **bindPassword**: Password used to connect to LDAP, only used if LDAP type is "other".

- **customLdapSecret**: The name of the secret that contains the bind user and password. This is used to store the bind user and password in a secret, only used if LDAP type is "other".

**Note:** Provide either `customLdapSecret` or `bindUser` & `bindPassword`. If both are provided, the LDAP Bind User and Password from the secret will be used.

#### To create a secret, run the following command:
```sh
kubectl create secret generic CUSTOM_SECRET_NAME --from-literal=bindUser=CUSTOM_BIND_USER --from-literal=bindPassword=CUSTOM_BIND_PASSWORD --namespace=NAME_SERVER
```
**Note:** Replace `CUSTOM_SECRET_NAME`, `CUSTOM_BIND_USER`, `CUSTOM_BIND_PASSWORD`, and `NAME_SERVER` with the actual values.

Example:
```sh
kubectl create secret generic custom-web-engine-secret --from-literal=bindUser=dx_user --from-literal=bindPassword=p0rtal4u --namespace=dxns
```

### LDAP Configuration Through Configuration Overrides
Check [here](configuration-changes-using-overrides.md) for more information on how to configure LDAP using configuration overrides.
