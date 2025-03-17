# Setting up Content as a Service

To be able to work with Content as a Service pages in HCL DX Compose, you must enable it by using a series of 3 actions.

The setup for Content as a Service pages comprises both resources that are shared across virtual portals and virtual portal scoped resources.

1.  On a Kubernetes deployment, change the directory to "/home/centos/native-kube".

2.  Run the following command to make the CaaS theme available to DX Compose

    -   `helm upgrade -n dxns -f install-deploy-values.yaml -f ./install-hcl-dx-deployment/caas/install-caas.yaml dx-deployment ./install-hcl-dx-deployment`

3. Run the following command to enter a bash shell on the DX Compose WebEngine pod

    - `kubectl exec -it dx-deployment-web-engine-0 bash -n dxns`
    
4.  Run the following command to register the CaaS theme to DX Compose

    -   `/opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -url http://localhost:9080/wps/config -in /opt/openliberty/wlp/usr/svrcfg/templates/caas/deployCaaSTheme.xml -out /tmp/deployCaaSTheme.xml.out -user "your userid" -password "your password"`

5.  Run the follow command to register the CaaS Page and Portlet in each VP (including the "main" VP)

    !!! note
        Use the second version of the command listed below if you are installed the CaaS pages into a VP other than the "main" VP.
        Notice the "url" parameter has the VP Context.
        
    -   `/opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -url http://localhost:9080/wps/config -in /opt/openliberty/wlp/usr/svrcfg/templates/caas/deployCaaSPages.xml -out /tmp/deployCaaSPages.xml.out -user "your userid" -password "your password"`

    -   `/opt/openliberty/wlp/usr/svrcfg/scripts/xmlaccess/xmlaccess.sh -d /opt/openliberty/wlp/usr/servers/defaultServer -url http://localhost:9080/wps/config/"VP Context" -in /opt/openliberty/wlp/usr/svrcfg/templates/caas/deployCaaSPages.xml -out /tmp/deployCaaSPages.xml.out -user "your userid" -password "your password"`

5.  Restart your portal server.



