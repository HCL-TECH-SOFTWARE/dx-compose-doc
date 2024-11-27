---
id: logging-webengine
title: WebEngine Server Logs
---

## Introduction
This document outlines the steps to view the WebEngine server logs through Kubernetes.

To view the logs of the WebEngine server, execute the following command:

```bash
kubectl exec -it  dx-deployment-web-engine-0  -n dxns -c core -- /opt/openliberty/wlp/usr/svrcfg/bin/webEngineLogs.sh -monitor yes
```

For continuous monitoring, provide the argument -monitor yes. To simply view the logs without continuous monitoring, use -monitor no or omit the argument altogether.

