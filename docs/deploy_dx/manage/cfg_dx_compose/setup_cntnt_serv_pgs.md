# Setting up Content as a Service

To be able to work with Content as a Service (CaaS) pages in HCL Digital Experience (DX) Compose, you must enable it using the steps listed in this topic. The setup for CaaS is comprised of resources that are shared across virtual portals and virtual portal scoped resources.

Refer to the following steps to install and configure CaaS:

1. On a Kubernetes deployment, change the directory to `/home/centos/native-kube` on the main Kubernetes node.

2. Run the following command to make the CaaS theme available to DX Compose.

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

5. Run the following command to register the CaaS Page and Portlet in each virtual portal, including the main virtual portal.

    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -url http://localhost:9080/wps/config -in /opt/openliberty/wlp/usr/svrcfg/templates/caas/deployCaaSPages.xml -out /tmp/deployCaaSPages.xml.out -user "your Portal Admin userid" -password "your password"
    ```

    If you are installing the CaaS pages into a virtual portal apart from the main virtual portal, run the following command. This command includes the `VP Context` in the `url` parameter.

    ```
    /opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -url http://localhost:9080/wps/config/"VP Context" -in /opt/openliberty/wlp/usr/svrcfg/templates/caas/deployCaaSPages.xml -out /tmp/deployCaaSPages.xml.out -user "your Portal Admin userid" -password "your password"
    ```

6. Restart your HCL DX Compose server.
