# Setting up Content as a Service

To work with Content as a Service (CaaS) pages in HCL Digital Experience (DX) Compose, you must enable it by following the steps listed in this topic. The setup for CaaS is comprised of resources that are shared across virtual portals and resources scoped to virtual portals. Setting up CaaS requires using the `xmlaccess` function of DXClient. For more information on installing and using DXClient, refer to [DXClient](https://help.hcl-software.com/digital-experience/9.5/latest/extend_dx/development_tools/dxclient/){target="_blank"}.

Refer to the following steps to install and configure CaaS:

1. Run the following command to make the CaaS theme available to DX Compose. This command applies configuration changes that affect the `server.xml` for the DX Compose image.

    ```
    helm upgrade -n dxns -f install-deploy-values.yaml -f ./install-hcl-dx-deployment/caas/install-caas.yaml dx-deployment ./install-hcl-dx-deployment
    ```

2. Run the following command to register the CaaS theme. This command enables the theme for all the virtual portals in DX Compose.

    ```
    dxclient xmlaccess -xmlFile deployCaaSTheme.xml

    ```

    The input for this command is an XMLAccess script to deploy the CaaS theme, located at [CaasTheme](./deployCaaSTheme.xml).

    !!!warning
        Do not modify the URLs in the XML file that refer to National Language Support (NLS) properties. These URLs refer to files in the DX Compose image itself.

3. Run the following command to register the CaaS pages and portlet in each virtual portal, including the main virtual portal.

    ```
    dxclient xmlaccess -xmlFile deployCaaSPages.xml

    ```

    The input for this command is an XMLAccess script that deploys the CaaS pages and references the CaaS theme, located at [CaasPages](./deployCaaSPages.xml).

    !!!warning
        Do not modify the URLs in the XML file that refer to NLS properties. These URLs refer to files in the DX Compose image itself.

    If you are installing the CaaS pages into a virtual portal instead of the base portal, run the same `dxclient` command with the `vp Context` included in the `url` parameter. For example, you would specify the following parameter:

    ```
    -xmlConfigPath /wps/config/{vp context root}
    ```

    Run this command for all the virtual portals where you want to run CaaS.

4. Restart your HCL DX Compose server.
