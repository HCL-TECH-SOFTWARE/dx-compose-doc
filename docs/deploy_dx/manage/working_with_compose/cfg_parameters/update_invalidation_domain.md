---
title: Changing the domain or schema for the dynacache invalidation table in the database 
---

HCL Digital Experience (DX) Compose relies heavily on a type of hash map called a `dynacache`. A `dynacache` is an instance of the Java object `com.ibm.websphere.cache.DistributedMap`.

A `dynacache` is a cluster-aware hash map. When a `dynacache` instance changes on one cluster member in a WebSphere Application Server cluster, all other cluster members are automatically notified of the change.

In Kubernetes, there is no concept of an OpenLiberty cluster. HCL DX Compose instances run as non-clustered Open Liberty instances. However, the system requires that Dynacaches in one pod detect value changes occurring in another pod. This synchronization is managed through the `INVALIDATION_TABLE` in the database.


By default, the `INVALIDATION_TABLE` resides in the `RELEASE` domain or schema. In some deployments, it may be preferable to store this table in one of the other domains, such as `JCR`, `COMMUNITY`, or `CUSTOMIZATION`.

You can change the domain or schema of this table by overriding a property in the `ConfigService.properties` file. Apply the change by running a Helm upgrade.

AA sample override file named `invalidationDomain.yaml` is provided in the `/native-kube/install-hcl-dx-deployment/invalidationDomain` directory. Details about how to use this sample file are provided below.

# How DX Compose Determines the Location of Invalidation Table

HCL DX Compose examines the `ConfigService.properties` file in the `dx-deployment-web-engine` pod. It retrieves the value of the custom property `db.cache.invalidation.domain` and uses that value as the domain or schema for the `INVALIDATION_TABLE` for all DX Compose code that uses a dynacache.

The default domain or schema for this table is `RELEASE`. This default value is also found in the helm chart `values.yaml` as `invalidationDomain: RELEASE`. 

# Changing the Domain/Schema of the Invalidation Table`
Changing the Domain/Schema of the invalidation table from the default of `RELEASE` involves two steps:

1. Update the value of `invalidationDomain` in the sample file `invalidationDomain.yaml`.
2. Run `helm upgrade` after changing the value. Assuming you have your specific helm values in a file called `install-deploy-values.yaml`, the helm upgrade command might be this:

```
helm upgrade -n dxns -f install-deploy-values.yaml -f invalidationDomain/invalidationDomain.yaml dx-deployment ./install-hcl-dx-deployment
```
- `dxns` is the namespace for this deployment.  
- `install-deploy-values.yaml` is the YAML file containing all other DX Compose configurations.  
- `invalidationDomain/invalidationDomain.yaml` is the YAML file that specifies the new location of the invalidation table.
`- `dx-deployment` is the name of the DX deployment.  
- `install-hcl-dx-deployment` is the directory that contains the Helm chart(s).

!!! note
    The command includes two `-f` parameters. You must include both the base YAML file and the YAML file that contains the configuration override for the invalidation parameter.

Running the `helm upgrade` command will delete the pod(s) and restart the portal pod with the updated domain/schema.

Consult the page [Upgrading Helm Deployment](../../../install/kubernetes_deployment/update_helm_deployment.md) for more details on doing a `helm upgrade`.

