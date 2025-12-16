# Configuring HCL DX Compose and HCL Leap SSO with OIDC

This page provides information on how to configure the Single Sign-On (SSO) layer between HCL DX Compose and HCL Leap.

## Enabling SSO between HCL Leap and HCL DX Compose in Kubernetes

This guide shows how you can enable SSO between HCL DX Compose and HCL Leap. You can use the modern and natively supported OpenID Connect (OIDC) protocol since both applications run on Open Liberty. The protocol connects directly to your preferred Identity Provider (IdP), such as Azure AD, Keycloak, Okta, or any OIDC-compliant provider. By configuring HCL DX Compose and Leap to trust your central IdP, users get a seamless, single log-in experience.

### Implementing OIDC SSO

1. Choose and configure your IdP.

    Create a client registration for each product (HCL DX Compose and HCL Leap). Your IdP serves as the single source of truth for credential input.

2. Enable OIDC in HCL DX.

    Refer to [Configuring DX Compose to use an OIDC identity provider](./../../../cfg_webengine/configure_compose_to_use_oidc.md) to enable and configure OIDC for DX Compose.

3. Enable OIDC in HCL Leap.

    Leap can be configured to leverage OIDC as the primary authentication mechanism, turning it into a Relying Party (RP) to the specific IdP. RP is an application that relies on a third-party (such as an IdP) for authentication. When OIDC is used, the user and group lookup feature of Leap is not available and must be disabled as part of the configuration.

    1. Configure the OIDC IdP, which will serve as the OIDC provider.

        As part of the configuration process for your identity provider, create or obtain a digital certificate for HTTPS. Deploy this certificate to Leap so the two servers can communicate securely.

        !!!note
            The SSL certificate (`.crt`) and public key (`.key`) should be in PKCS12 format.

    2. After copying the `.key` and `.crt` to the Kubernetes image, create a secret using the following command:

        ```bash
        kubectl -n <namespace> create secret tls <tls-secret> --key="/tmp/oidc.key" --cert="/tmp/oidc.crt"
        ```

        This secret can be referenced in the `values.yaml` file using the following configuration:

        ```yaml
        configuration:
            leap:
                customCertificateSecrets:
                    idpCert: <tls-secret>
        ```

    3. Add the OIDC definition as a server customization in the `values.yaml` file.

        The properties that you need to specify may differ based on your identity provider. For additional information, refer to [Open Liberty documentation on OIDC](https://openliberty.io/docs/latest/reference/config/openidConnectClient.html)

        Before moving on, verify that the `discoveryEndpointURL` property is valid by opening the URL in a browser prior to entering it in the `values.yaml` file and updating the `clientSecret` with the proper value obtained from your IdP.

        Example of an OIDC definition:

        ```yaml
        # Replace placeholder values with your actual OIDC configuration
        configuration:
            leap:
                configOverrideFiles:
                    openIdConnect: |
                        <server description="leapServer">
                        <openidConnectClient id="<unique-oidc-id>"
                            clientId="<your-client-id>"
                            clientSecret="<your-client-secret>"
                            signatureAlgorithm="RS256"
                            authFilterRef="interceptedAuthFilter"
                            mapIdentityToRegistryUser="false"
                            httpsRequired="true"
                            scope="openid"
                            userIdentityToCreateSubject="preferred_username"
                            discoveryEndpointUrl="<your-discovery-endpoint-url>">
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

        For more details on defining a server customization, refer to [Open Liberty server customizations](https://opensource.hcltechsw.com/leap-doc/latest/helm_open_liberty_custom.html){target="_blank"}.

        !!!important
            The openIdConnectClient redirects to `https://<your-domain>/oidcclient/redirect/<your-oidc-id>` after authentication. Make sure that your valid redirect URIs includes an entry that matches this, and that you're using a different id than what you're using for DX. You may also have to modify your Ingress/Gateway API configuration so that `/oidcclient/redirect/<your-oidc-id>` redirects to the Leap service.

    4. Add the following config properties related to OIDC in the `values.yaml` file.

        The following properties must be set to complete the OIDC configuration:

        - `userLookups`: Set this to `false` to disable user lookups, which is not available when configured with OIDC.
        - `userGroups`: Set this to `false` to disable group lookups, which is not available when configured with OIDC.
        - `postLogoutRedirectURL`: Set this to the URL where Leap redirects the browser after a user logs out. This setting completes the sign-out flow with the OIDC IdP. The URL format varies by IdP. For more information, refer to your IdP documentation.

        ```yaml
        configuration:
            leap:
                leapProperties: |
                    ibm.nitro.NitroConfig.userLookup=false
                    ibm.nitro.NitroConfig.userGroups=false
                    `ibm.nitro.LogoutServlet.postLogoutRedirectURL=<your-idp-logout-url>?client_id=<your-client-id>&post_logout_redirect_uri=<your-leap-url>`
        ```

        For more information about setting Leap properties, see [Leap properties](https://opensource.hcltechsw.com/leap-doc/latest/helm_leap_properties.html).

    5. Perform a Helm upgrade to apply your changes.

    6. Restart the Leap pod.

        After restarting the Leap pod, accessing Leap should redirect you to authenticate using your OIDC IdP.
