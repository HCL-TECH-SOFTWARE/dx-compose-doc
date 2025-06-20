# Setting up Content as a Service

To be able to work with Content as a Service (CaaS) pages in HCL Digital Experience (DX) Compose, you must enable it using the steps listed in this topic. The setup for CaaS is comprised of resources that are shared across virtual portals and virtual portal scoped resources.

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

Note that you need not be actually logged into Kubernetes nor the pod containing web-engine in order to run the "xmlaccess" command. If you have copied "xmlaccess" to a local machine, you can adjust the fully qualified name for the "xmlaccess" command as well as the "-url" parameter in the example command given. The "url" parameter in the case of a local "xmlaccess" command would contain the actual hostname (and likely NOT "9080") for for DX Compose instance. 

5. Run the following command to register the CaaS Page and Portlet in each virtual portal, including the main virtual portal.

    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -url http://localhost:9080/wps/config -in /opt/openliberty/wlp/usr/svrcfg/templates/caas/deployCaaSPages.xml -out /tmp/deployCaaSPages.xml.out -user "your Portal Admin userid" -password "your password"
    ```

    If you are installing the CaaS pages into a virtual portal apart from the main virtual portal, run the following command. This command includes the `VP Context` in the `url` parameter.

    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -url http://localhost:9080/wps/config/"VP Context" -in /opt/openliberty/wlp/usr/svrcfg/templates/caas/deployCaaSPages.xml -out /tmp/deployCaaSPages.xml.out -user "your Portal Admin userid" -password "your password"
    ```
Like in the previous command, you need not be actually logged into Kubernetes nor the pod containing web-engine in order to run the "xmlaccess" command. If you have copied "xmlaccess" to a local machine, you can adjust the fully qualified name for the "xmlaccess" command as well as the "-url" parameter in the example command given. The "url" in the case of using a local "xmlaccess" command would contain the actual hostname (and likely NOT "9080") for for DX Compose instance. 

6. Restart your HCL DX Compose server.
