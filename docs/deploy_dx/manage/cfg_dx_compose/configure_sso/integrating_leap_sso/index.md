# Configuring HCL DX Compose and HCL Leap SSO with OIDC

This page provides information on how to configure the SSO layer between HCL DX Compose and HCL Leap.

## Enabling SSO between HCL Leap and HCL DX Compose in Kubernetes

This guide shows how to enable Single Sign-On (SSO) between HCL DX and HCL Leap using the modern OpenID Connect protocol. This approach connects directly to the preferred Identity Provider (IDP), like Azure AD, Keycloak or Okta. By configuring DX and Leap to trust your central IDP, users get a seamless 'login once' experience and security is managed in a single place.

#### Implementing OIDC SSO

1. Install and configure your Identity Provider 

    IDPs (e.g. Keycloak, Okta, Azure AD) wil serve as the single point of truth for credential inputs, and create a client for each product.

2. Enable OIDC in HCL DX

    Refer to [Configuring DX Compose to use an OIDC identity provider](./../../../cfg_webengine/configure_compose_to_use_oidc.md) for enabling and configuring OIDC for DX Compose.

3. Enable OIDC in HCL LEAP

    Leap can be configured to leverage OpenID Connect (OIDC) as the primary authentication mechanism. This means that Leap will be turned into a Relying Party (RP) to the specified identity provider (IDP). When OIDC is used, the user and group lookup feature of Leap is not available and must be disabled as part of the configuration.

    1. Configure OIDC identity Provider, the IDP will serve as the OIDC provider

        As part of the configuration process for your identify provider, you will have created or obtained a digital certificate for configuring HTTPS. This certificate will also need to be deployed to Leap so that the two servers can communicate with each other.

        !!!note
            The SSL certificate (.crt) and public key (.key) should be in PKCS12 format.

        After copying the .key and .crt to the kubernetes image, create a secret using the following command:

        ```bash
        kubectl -n <namespace> create secret tls oidccert --key="/tmp/oidc.key" --cert="/tmp/oidc.crt"
        ```
        
        This secret can be referenced in the values file

        ```yaml
        configuration:
            leap:
                customCertificateSecrets:
                keycloakCert: "keycloakcert"
        ```

    2. Add OIDC definition as a server customization

        The properties that you need to specify may differ based on your identify provider. For additional information, refer to [Open Liberty documentation on OpenID Connect](https://openliberty.io/docs/latest/reference/config/openidConnectClient.html)

        Before moving on, verify that the discoveryEndpointURL is valid by opening it in a browser prior to entering it in the yaml file and update the clientSecret with the proper value obtained from your IDP

        Example of an OIDC definition:

        ```yaml
        configOverrideFiles:
        openIdConnect: |
            <server description="leapServer">
            <openidConnectClient id="oidc"
                clientId="hcl-leap-oidc-client"
                clientSecret="clientSecretHash"
                signatureAlgorithm="RS256"
                authFilterRef="interceptedAuthFilter"
                mapIdentityToRegistryUser="false"
                httpsRequired="true"
                scope="openid"
                userIdentityToCreateSubject="preferred_username"
                discoveryEndpointUrl="https://myoidcserver:8443/realms/Leapdev/.well-known/openid-configuration">
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
            For more details on defining a server customization, see [Open Liberty server customizations](https://help.hcl-software.com/Leap/9.3.4/helm_open_liberty_custom.html).

    3. Add config properties related to OIDC config

        The following properties must be set to complete the OIDC configuration:

        - hasUserLookups - By setting this to false it will disable user lookups, which is not available when configured with OIDC.
        - hasUserGroups - By setting this to false it will disable group lookups, which is not available when configured with OIDC.
        - postLogoutRedirectURL - This is the URL to which Leap will redirect the browser after a user chooses to log out. This is necessary to complete the loop with the OIDC IDP.
        
        ```yaml
        configuration:
        leap:
            leapProperties: |
            ibm.nitro.NitroConfig.hasUserLookup=false
            ibm.nitro.NitroConfig.hasUserGroups=false ibm.nitro.LogoutServlet.postLogoutRedirectURL=https://myOIDCServer.com/realms/Leap/protocol/openid-
            connect/logout?client_id=hcl-leap-oidc-client&post_logout_redirect_uri=https://myLeapServer.com/apps/secure/org/ide/manager.html
        ```

        !!!note
            For more details on setting Leap properties, see [Leap properties](https://help.hcl-software.com/Leap/9.3.4/helm_leap_properties.html).

    4. Restart the pod, after restarting the Leap pod, accessing Leap should redirect you to authenticate using your OIDC IDP.




