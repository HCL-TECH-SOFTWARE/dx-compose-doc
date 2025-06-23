# Setting up Content as a Service

To be able to work with Content as a Service (CaaS) pages in HCL Digital Experience (DX) Compose, you must enable it using the steps listed in this topic. The setup for CaaS is comprised of resources that are shared across virtual portals and virtual portal scoped resources.

The detailed examples below are shown using a locally connected XMLAccess command. This implies the the user of the XMLAccess command(s) are logged into the pod containing DX Compose and that XMLAccess is run from inside that pod. This could be problematic is the user of XMLAccess (typically the Portal Administrative user) does NOT have login access to the Kubernetes pod. However, note that one could also (equivantly) install XMLAccess on ones local machine and XMLAccess to the DX Compose remotely (by adjust the URL parameter in the examples below) or by using the "DX Client" command. Using DX Client is the preferred way to do this in a Kubernetes environment.

Refer to the following steps to install and configure CaaS:

1. On a Kubernetes deployment, change the directory to directory that contains the `install-hcl-dx-deployment` directory on the "master" Kubernetes node.

2. Run "helm upgrade" to make the CaaS theme available to DX Compose.

    ```
    helm upgrade -n dxns -f install-deploy-values.yaml -f ./install-hcl-dx-deployment/caas/install-caas.yaml dx-deployment ./install-hcl-dx-deployment
    ```

3. Run the following command to enter a bash shell on the DX Compose WebEngine pod.

    ```
    kubectl exec -it dx-deployment-web-engine-0 bash -n dxns
    ```

4. Run the following command to register the CaaS theme to all the virtual portals in DX Compose.

    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -url http://localhost:9080/wps/config -in /opt/openliberty/wlp/usr/svrcfg/templates/caas/deployCaaSTheme.xml -out /tmp/deployCaaSTheme.xml.out -user "your Portal Admin userid" -password "your password"
    ```

Note that you need not be actually logged into Kubernetes nor the pod containing web-engine in order to run the "xmlaccess" command. If you have copied "xmlaccess" to a local machine, you can adjust the fully qualified name for the "xmlaccess" command as well as the "-url" parameter in the example command given. The "url" parameter in the case of a local "xmlaccess" command would contain the actual hostname (and likely NOT "9080") for the DX Compose instance. 

One could also use the "DXClient" command to do "xmlaccess". Either of these 3 methods work and the changes are ultimately made in the database connected to DX Compose and not the local file system.

5. Run the following command to register the CaaS Page and Portlet in each virtual portal, including the main virtual portal.

    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -url http://localhost:9080/wps/config -in /opt/openliberty/wlp/usr/svrcfg/templates/caas/deployCaaSPages.xml -out /tmp/deployCaaSPages.xml.out -user "your Portal Admin userid" -password "your password"
    ```

    If you are installing the CaaS pages into a virtual portal apart from the main virtual portal, run the following command. This command includes the `VP Context` in the `url` parameter.

    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -url http://localhost:9080/wps/config/"VP Context" -in /opt/openliberty/wlp/usr/svrcfg/templates/caas/deployCaaSPages.xml -out /tmp/deployCaaSPages.xml.out -user "your Portal Admin userid" -password "your password"
    ```
Like in the previous command, you need not be actually logged into Kubernetes nor the pod containing web-engine in order to run the "xmlaccess" command. If you have copied "xmlaccess" to a local machine, you can adjust the fully qualified name for the "xmlaccess" command as well as the "-url" parameter in the example command given. The "url" in the case of using a local "xmlaccess" command would contain the actual hostname (and likely NOT "9080") for the DX Compose instance. 

6. Restart your HCL DX Compose server.
