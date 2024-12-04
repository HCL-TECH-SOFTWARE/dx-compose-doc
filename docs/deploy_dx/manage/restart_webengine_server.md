---
id: restart-webengine-server
title: Restarting the WebEngine server
---

This topic provides the command to restart the WebEngine server through Kubernetes.

To restart the WebEngine server, execute the following command:

```bash
kubectl exec -it  dx-deployment-web-engine-0  -n dxns -c web-engine -- /opt/openliberty/wlp/usr/svrcfg/bin/restart.sh  
```
