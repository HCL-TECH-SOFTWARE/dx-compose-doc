---
id: logging-webengine
title: Viewing WebEngine server logs
---

This document provides the steps to view the WebEngine server logs through Kubernetes.

To view the logs of the WebEngine server, run the following command:

```bash
kubectl exec -it <RELEASE-NAME>-web-engine-0 -n <NAMESPACE> -c web-engine -- /opt/openliberty/wlp/usr/svrcfg/bin/webEngineLogs.sh -monitor yes
```

For example:

```bash
kubectl exec -it  dx-deployment-web-engine-0  -n dxns -c web-engine -- /opt/openliberty/wlp/usr/svrcfg/bin/webEngineLogs.sh -monitor yes
```

For continuous monitoring, add the argument `-monitor yes`. To just view the logs without continuous monitoring, use `-monitor no` or omit the argument altogether.