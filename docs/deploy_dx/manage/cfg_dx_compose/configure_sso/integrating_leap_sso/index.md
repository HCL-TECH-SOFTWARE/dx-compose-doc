# Configuring HCL DX Compose and HCL Leap SSO with OIDC

This page provides information on how to configure the SSO layer between HCL DX Compose and HCL Leap.

## Enabling SSO between HCL Leap and HCL DX Compose in Kubernetes

This guide shows how to enable Single Sign-On (SSO) between HCL DX and HCL Leap, since both applications run on Open Liberty, the modern OpenID Connect (OIDC) protocol is natively supported and can be used. The protocol connects directly to the preferred Identity Provider (IdP), such as Azure AD, Keycloak or Okta. By configuring DX and Leap to trust your central IdP, users get a seamless, single log-in experience.

#### Implementing OIDC SSO

1. Install and configure your Identity Provider 

    IdPs (e.g. Keycloak, Okta, Azure AD) will serve as the single point of truth for credential inputs, You will also need to create a client for each product.

2. Enable OIDC in HCL DX

    Refer to [Configuring DX Compose to use an OIDC identity provider](./../../../cfg_webengine/configure_compose_to_use_oidc.md) for enabling and configuring OIDC for DX Compose.

3. Enable OIDC in HCL LEAP

    Leap can be configured to leverage OpenID Connect (OIDC) as the primary authentication mechanism. This means that Leap will be turned into a Relying Party (RP) (i.e., an application that relies on a third-party--the IdP--for authentication) to the specified identity provider (IdP). When OIDC is used, the user and group lookup feature of Leap is not available and must be disabled as part of the configuration.

    1. Configure OIDC identity Provider, the IdP will serve as the OIDC provider

        As part of the configuration process for your identify provider, you will have created or obtained a digital certificate for configuring HTTPS. This certificate will also need to be deployed to Leap so that the two servers can communicate with each other.

        !!!note
            The SSL certificate (`.crt`) and public key (`.key`) should be in PKCS12 format.

        After copying the .key and .crt to the kubernetes image, create a secret using the following command:

        ```bash
        kubectl -n <namespace> create secret tls <tls-secret> --key="/tmp/oidc.key" --cert="/tmp/oidc.crt"
        ```
        
        This secret can be referenced in the values file

        ```yaml
        configuration:
            leap:
                customCertificateSecrets:
                    keycloakCert: <tls-secret>
        ```

    2. Add OIDC definition as a server customization

        The properties that you need to specify may differ based on your identity provider. For additional information, refer to [Open Liberty documentation on OIDC](https://openliberty.io/docs/latest/reference/config/openidConnectClient.html)

        Before moving on, verify that the discoveryEndpointURL is valid by opening it in a browser prior to entering it in the yaml file and update the clientSecret with the proper value obtained from your IdP

        Example of an OIDC definition:

        ```yaml
        # Enter appropriate values for <your-oidc-id>, <your-client-id>, <your-client-secret>, <your-oidc-server>, <your-realm-name>. 
        # You may have to refer to your identity provider's configuration.
        configuration:
            leap:
                configOverrideFiles:
                    openIdConnect: |
                        <server description="leapServer">
                        <openidConnectClient id="<your-oidc-id>"
                            clientId="<your-client-id>"
                            clientSecret="<your-client-secret>"
                            signatureAlgorithm="RS256"
                            authFilterRef="interceptedAuthFilter"
                            mapIdentityToRegistryUser="false"
                            httpsRequired="true"
                            scope="openid"
                            userIdentityToCreateSubject="preferred_username"
                            discoveryEndpointUrl="https://<your-oidc-server>/realms/<your-realm-name>/.well-known/openid-configuration">
                        </openidConnectClient>
                        <authFilter id="interceptedAuthFilter">
                            <requestUrl id="authRequestUrl" matchType="contains" urlPattern="/apps/secure|/apps/secured"/>
                        </authFilter>
                        <httpEndpoint id="defaultHttpEndpoint"
                            host="*"
                            httpPort="9080"
                            httpsPort="9443">
                            <samesite none="*" />
                        </httpEndpoint>
                        </server>
        ```

        !!!note
            For more details on defining a server customization, see [Open Liberty server customizations](https://opensource.hcltechsw.com/leap-doc/latest/helm_open_liberty_custom.html).

        !!!important
            The openIdConnectClient redirects to `https://<your-domain>/oidcclient/redirect/<your-oidc-id>` after authentication. Make sure that your valid redirect URIs includes an entry that matches this, and that you're using a different id than what you're using for DX. You may also have to modify your Ingress/Gateway API configuration so that `/oidcclient/redirect/<your-oidc-id>` redirects to the Leap service.

    3. Add config properties related to OIDC

        The following properties must be set to complete the OIDC configuration:

        - userLookups - By setting this to false it will disable user lookups, which is not available when configured with OIDC.
        - userGroups - By setting this to false it will disable group lookups, which is not available when configured with OIDC.
        - postLogoutRedirectURL - This is the URL to which Leap will redirect the browser after a user chooses to log out. This is necessary to complete the loop with the OIDC IdP.
        
        ```yaml
        configuration:
            leap:
                leapProperties: |
                    ibm.nitro.NitroConfig.userLookup=false
                    ibm.nitro.NitroConfig.userGroups=false
                    ibm.nitro.LogoutServlet.postLogoutRedirectURL=https://myOIDCServer.com/realms/Leap/protocol/openid-connect/logout?client_id=hcl-leap-oidc-client&post_logout_redirect_uri=https://myLeapServer.com/apps/secure/org/ide/manager.html
        ```

        !!!note
            For more details on setting Leap properties, see [Leap properties](https://opensource.hcltechsw.com/leap-doc/latest/helm_leap_properties.html).

    5. Run a helm upgrade.

    6. Restart the Leap pod. After restarting the Leap pod, accessing Leap should redirect you to authenticate using your OIDC IdP. For example, the below screenshot shows a page for authenticating via Keycloak:

    ![](../../../../../assets/Keycloak-Login.png)




