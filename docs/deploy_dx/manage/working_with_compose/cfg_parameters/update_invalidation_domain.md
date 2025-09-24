---
title: Change the domain/schema for `dynacache` invalidation table in the database
---
# Introduction
HCL DX Compose relies heavily on a type of hashmap known as a `dynacache`. A  dynacache is an instance of the Java object `DistributedMap` or `com.ibm.websphere.cache.DistributedMap` if one prefers the fully qualified class name.

A dynacache is merely a cluster aware HashMap. That means that if a particular instance of a dynacache changes (say on one cluster member in a WebSphere Application Server cluster), all other cluster members are made aware of that change.

However, in Kubernetes, there are no Open Liberty clusters. All DX Compose instances are running as non-clustered Open Liberty instances. But the dynacaches in these instances need to know if a dynacache in a particular DX Compose instance changes a dynacache value. In Kubernetes, this is achieved thru the use a database table named `INVALIDATION_TABLE`. 

By default, the database INVALIDATION_TABLE resides in the the `RELEASE` domain/schema. However, there may be use cases whereby this table would be better stored in one of the other 3 domain/schemas (e.g. `JCR`, `COMMUNITY` or `CUSTOMIZATION`). Changing the location of this table can (only) be achieved via a properties override in the ConfigService.properties file. This is done via a helm upgrade.

A sample over ride file named `invalidationDomain.yaml` is provided in the directory `/native-kube/install-hcl-dx-deployment/invalidationDomain`. Details on the use of this sample file are included below.



# How DX Compose Determines the Location of Invalidation Table
HCL DX Compose will examine the file `ConfigService.properties` in the dx-deployment-web-engine pod. It will retrieve the value for the custom property `db.cache.invalidation.domain`. It will use that value as the domain/schema for the invalidation table in all DX Compose code using a dynacache.

As mentioned in the introduction, the default domain/schema for this table is `RELEASE`. This default value is also found in the helm chart `values.yaml` as `invalidationDomain: RELEASE`.

# Changing the Domain/Schema of the Invalidation Table
Changing the Domain/Schema of the invalidation table from the default of `RELEASE` involves two steps:

1. Update the value of `invalidationDomain` in the sample file `invalidationDomain.yaml`.
2. Run `helm upgrade` after changing the value. Assuming you have your specific helm values in a file called `install-deploy-values.yaml`, the helm upgrade command might be this:

```
helm upgrade -n dxns -f install-deploy-values.yaml -f ./invalidationDomain/invalidationDomain.yaml dx-deployment ./install-hcl-dx-deployment
```
where `dxns` is the name space for this deployment, `install-deploy-values.yaml` is the yaml file with the change, `dx-deployment` is the DX deployment value and `install-hcl-dx-deployment` is the directory containing the helm chart.

Note that there are two `-f` parameters in the command. You must include the `base` yaml along with the yaml which includes the configuration override for the invalidation parameter in the command.

Running the `helm upgrade` command will delete the pod(s) and restart the portal pod with the updated domain/schema.

Consult the page [Upgrading Helm Deployment](../../../install/kubernetes_deployment/update_helm_deployment.md) for more details on doing a `helm upgrade`.

