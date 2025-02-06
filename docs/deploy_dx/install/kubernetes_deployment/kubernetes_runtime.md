# Kubernetes runtime

View the latest Kubernetes versions and platforms tested and supported by specific HCL Digital Experience (DX) Compose 9.5 Kubernetes deployments.

For best results, customers should remain up-to-date on the latest HCL DX Compose and Kubernetes releases and be aware that HCL DX Compose provides all fixes on the latest release. Customers might be asked to upgrade to the latest HCL DX Compose release to assist with problem determination.

## Kubernetes platform support policy

HCL DX Compose is designed to run on any [Certified Kubernetes platform](https://www.cncf.io/certification/software-conformance){target="_blank"}, provided that the following statements are true:

* The Kubernetes platform is hosted on x86-64 hardware.
* The Kubernetes platform is officially supported by [Helm](https://helm.sh/docs/topics/kubernetes_distros/){target="_blank"}.

HCL tests DX Compose against a range of Kubernetes platforms that are regularly reviewed and updated with the intent of staying as up-to-date as possible. HCL does not test with every platform vendor or with every Kubernetes version, but HCL aims to cover a representative sample of popular Kubernetes implementations. See [Table 1](#table-1-tested-kubernetes-platforms-on-full-container-deployment) for the list of Kubernetes platforms that HCL tested with.

### Table 1: Tested Kubernetes platforms on full container deployment

Table 1 lists the Kubernetes platforms that HCL tested and supports. This is provided for information only.

|Kubernetes platforms on full deployments|
|--------------|
|- Amazon EKS<br/> - Google GKE <br/> - Microsoft Azure AKS <br/> - Red Hat OpenShift <br/> - Amazon EKS / AWS EC2<br/> - Red Hat OpenShift on AWS / AWS EC2|

## Kubernetes version support policy

Table 2 lists the Kubernetes versions that HCL tested and supports in HCL DX Compose releases.

* Platform providers might release previews of upcoming Kubernetes versions. However, HCL does not provide support for those versions.
* If you encounter an issue on an unsupported or untested Kubernetes version, you might be asked to install a supported level product.

### Table 2: Tested and supported Kubernetes versions

This table provides information about the Kubernetes versions that are tested and supported by HCL DX Compose releases.
Review your chosen Kubernetes platform and ensure that it supports the following Kubernetes versions:

<!-- Note: As per L2/L3, only keep three latest releases and delete older ones -->

|CF Level|Kubernetes versions|
|--------------|-----------------|
|CF225| Kubernetes 1.31<br/>Kubernetes 1.30<br/>Kubernetes 1.29<br/>Kubernetes 1.28<br/>Kubernetes 1.27<br/>Kubernetes 1.26<br/>|
|CF224| Kubernetes 1.31<br/>Kubernetes 1.30<br/>Kubernetes 1.29<br/>Kubernetes 1.28<br/>Kubernetes 1.27<br/>Kubernetes 1.26<br/>|

!!!important
    To prevent a possible Kubernetes deployment failure in Kubernetes versions 1.28 and 1.29, it may be required to run the command `modprobe br_netfilter` before running `kubeadm init`. This is a potential solution to avoid a networking bridge/iptables issue.
