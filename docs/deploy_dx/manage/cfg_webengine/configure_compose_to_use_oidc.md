---
id: configure_compose_to_use_oidc
title: Configuring DX Compose to use an OIDC identity provider
---

This topic provides the steps to enable an OpenID Connect (OIDC) identity provider (for example, Google, Facebook) to authenticate a user to HCL Digital Experience (DX) Compose. In this scenario, the user does not log in to DX Compose, but to an OIDC identity provider.

!!!note "Limitation"
    Currently, the user authenticated to DX Compose through an external identity provider must reside in the DX Compose user registry, generally an LDAP server. These steps do not support transient users (that is, users not in the registry) at this time.

## Prerequisites

A DX Compose system administrator must create an account in the identity provider and obtain the following information:

- clientID
- clientSecret
- hostname (for the discovery endpoint URL and jwt URL)
- userIdentifier

## Enabling OIDC authentication in DX Compose

After securing the required information from the OpenID Connect identity provider, the administrator must make these parameters available to DX Compose.

During DX Compose installation, there is a file named `oidc.yaml` located in the `install-hcl-dx-deployment/oidc` subdirectory of the Kubernetes node where you ran `helm install`. An administrator must fill out the `oidc.yaml` file and use this file during a `helm upgrade` operation to integrate DX Compose to the external identity provider.

Refer to the following steps to enable OIDC authentication in DX Compose:

1. Edit the `oidc.yaml` file and enter the following required parameters from the identity provider:
    - id (see Important below)
    - clientID
    - clientSecret
    - hostname (for the discovery endpoint URL and jwt URL)
    - userIdentifier

    !!!important
        The openIdConnectClient redirects to `https://<your-domain>/oidcclient/redirect/<id>` after authentication. Make sure that your valid redirect URIs includes an entry that matches this.

2. Configure the XMLAccess Authentication Filter (`authFilter`) to prevent XMLAccess configuration scripts from being redirected to the OIDC provider. This filter excludes XMLAccess endpoints from OIDC authentication.

    - If your `oidc.yaml` does not have the `authFilter`:

        1. Add the following before the `<openidConnectClient>` element:

            ```xml
            <authFilter id="oidcAuthFilter">
                <requestUrl id="excludeXMLAccess" urlPattern="/wps/config" matchType="notContain"/>
            </authFilter>
            ```

        2. Add `authFilterRef="oidcAuthFilter"` to the `<openidConnectClient>` element:

            ```xml
            <openidConnectClient id="client01" authFilterRef="oidcAuthFilter"
            ```

    - If your DX Compose environment uses a different context root, update the `urlPattern` value in the `authFilter` to the following:

        - Default (`wps`): `urlPattern="/wps/config"` (already configured)
        - No context root: `urlPattern="/config"`
        - Custom (`custom`): `urlPattern="/custom/config"`

        The context root is configured in your Helm values.

3. In the `oidc.yaml` file, configure the following properties under `ConfigService.properties`:

    - `redirect.logout` to `true`
    - `redirect.logout.ssl` to `true`
    - `redirect.logout.url` to the URL to be shown to the user after logout

    This configuration forces the logout screen to the identity provider instead of the default DX Compose logout screen. This also ensures that any relevant HTTP cookies are cleared and the user is actually logged out.

4. Run `helm upgrade` to apply the changes to DX Compose.

    You must specify two file (`-f`) parameters in the `helm upgrade` command. The first `-f` is the YAML file with all DX Compose values apart from OIDC. The second `-f` is the `oidc.yaml` file. See the following sample command:

    ```sh
    helm upgrade -n dxns -f install-deploy-values.yaml -f ./install-hcl-dx-deployment/oidc/oidc.yaml dx-deployment ./install-hcl-dx-deployment
    ```

    For more information, see [Upgrading the Helm deployment](../working_with_compose/helm_upgrade_values.md).

    If you need to bypass OIDC authentication (for example, when authenticating as an LDAP user), you can access the portal login page directly by appending the following path to your base portal URL:

    ```
    /poc?uri=nm:oid:wps.Login
    ```

    For example:

    ```
    https://example.com/wps/poc?uri=nm:oid:wps.Login
    ```

    Alternatively, you can use a friendly URL configured for your portal login page.
