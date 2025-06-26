# Setting up Content as a Service

To be able to work with "Content as a Service" (CaaS) pages in HCL Digital Experience (DX) Compose, you must enable it using the steps listed in this topic. The setup for CaaS is comprised of resources that are shared across virtual portals and virtual portal scoped resources.

Refer to the following steps to install and configure CaaS:

1. These steps will be completed using the "xmlaccess" function of DXClient. If you need help installing or using DXClient, please refer to this article: [DXClient](https://help.hcl-software.com/digital-experience/9.5/CF228/extend_dx/development_tools/dxclient/)

2. Run the following command to make the CaaS theme available to DX Compose. It modifies the "server.xml" on the DX Compose image.

    ```
    helm upgrade -n dxns -f install-deploy-values.yaml -f ./install-hcl-dx-deployment/caas/install-caas.yaml dx-deployment ./install-hcl-dx-deployment
    ```

3. Run the following command to register the CaaS theme. This theme will then be available to all the virtual portals in DX Compose.

	```
	dxclient xmlaccess -xmlFile deployCaaSTheme.xml

    ```
    
    The input for this command is an XMLAccess script to deploy the CaaS theme. It is located here: [CaasTheme](./deployCaaSTheme.xml). Note that there are URLs in this file that refer to NLS properties to be used in the XMLAccess input. These URLs should not be modified as they refer to files in the DX Compose image itself.
    
    
4. Run the following command to register the CaaS Page and Portlet in each virtual portal, including the main virtual portal.

	```
	dxclient xmlaccess -xmlFile deployCaaSPages.xml

    ```
    The input for this command is an XMLAccess script to deploy the CaaS pages and refer back to the CaaS theme. It is located here: [CaasPages](./deployCaaSPages.xml). Note that there are URLs in this file that refer to NLS properties to be used in the XMLAccess input. These URLs should not be modified as they refer to files in the DX Compose image itself.

    If you are installing the CaaS pages into a virtual portal apart from the main virtual portal, run the same command except this time insuring the dxclient parameters command includes the `VP Context` in the `url` parameter.For example, you would specify the parameter
    
    ```
    -xmlConfigPath /wps/config/{vp context root}
    ```
	on the dxclient command itself. Run this command for as many virtual portals upon which you want to run CaaS.

5. Restart your HCL DX Compose server.