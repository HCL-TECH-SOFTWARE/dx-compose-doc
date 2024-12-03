---
id: restart-webengine-server
title: Restart WebEngine Server
---

## Introduction
This document outlines the steps to restart the WebEngine server through Kubernetes.

To restart the WebEngine server, execute the following command:

```bash
kubectl exec -it  dx-deployment-web-engine-0  -n dxns -c web-engine -- /opt/openliberty/wlp/usr/svrcfg/bin/restart.sh  
```
