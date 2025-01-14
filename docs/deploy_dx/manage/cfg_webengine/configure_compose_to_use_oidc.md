---
id: configure_compose_to_use_oidc
title: Configure DX Compoese to Use OIDC Identity Provider
---
This topic provides the necessary steps to enable an OpenID Connect (OIDC) identity provider (like Google, Facebook, etc) to authenticate a user to DX Compose (WebEngine). 
This implies that the user does NOT login to WebEngine but rather to the provider.

!!!note "Limitation" 
    As of this release, the user authenticating to DX Compose via an external identity provider must reside in the DX Compose registry (generally an LDAP server). These steps do not support transient users (e.g. users not in the registry) at this time. 

An important prerequisite for allowing DX Compose to allow an external identity provider to "vouch" for an user's identity is that the DX Compose administrator must has secured the ability to do so from the external provider.
Take, for example, the Okta Auth0 identity provider.
A system administrator must have created an account on Auth0 and secured several important pieces of information from that provider such as a "clientID" and a "clientSecret" along with the URL from that provider which contains the JSON for several important URLs used during the OpenID connect process.

Once a system administrator has secured all the important information from the OpenID Connect identity provider, the need to be made available to DX Compose.

In the DX Compose installation, on the Kubernetes node respondible for the deployment, there is a file called "oidc.yaml" located in the "charts/hcl-dx-deployment/oidc" subdirectory which must be filled out and then subsequently used during a "helm update" operation to integrate to the external identity provider.

**The Steps**

1. Examine the oidc.yaml file previously mentioned and obtain (from the identity provider) the required parameters. In the case of, say Okta Auth0, one can create an account and then gather the information from the Auth0 website.

2. Obtain the required parameters from the identity provider and update oidc.yaml as appropriate. 

   In particular, you must obtain:

   a. clientID

   b. clientSecret

   c. hostname for the discovery endpoint Url

   d. userIdentifier

3. In the "oidc.yaml" file, configure the changes needed to the ConfigService.properties file. 
These changes force the logout screen to the provider as opposed to the default DX Compose logout screen.
More importantly, this change insures that any relevant HTTP cookies are cleared so that the user is truly "logged out". 

4. Run the "helm update" in order to propagate these changes to DX Compose.
Note that two "-f" parameters must be specified on the "helm update" command.
The first is the yaml file with all DX Compose values apart from OIDC (values.yaml). 
The second file is the oidc.yaml file.
Therefore, an example command might look like this:

    ```
    helm upgrade -n dxns -f install-deploy-values.yaml -f ./install-hcl-dx-deployment/oidc/oidc.yaml dx-deployment ./install-hcl-dx-deployment
    ```

Consult this topic for further information on doing a 
[helm update](../working_with_compose/helm_upgrade_values.md).

After completing the helm update, the appropriate pods will automatically restart.
