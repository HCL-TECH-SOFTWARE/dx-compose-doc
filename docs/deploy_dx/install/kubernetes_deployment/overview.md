# Deploying using Helm

!!!important "Before deployment, see the following resources first."
    * [Kubernetes deployment](../kubernetes_deployment/containers_overview.md) for an understanding of the capabilities, deployment structures, configuration and scaling options available for HCL DX Compose.
    * [Containerization requirements and limitations](../kubernetes_deployment/containers_requirements_limits.md) for an understanding of the requirements, including capacity planning, and current limitations for an HCL Digital Experience Compose deployment using Helm.

HCL DX Compose is designed to run on any Certified Kubernetes platform with some conditions. See the [system requirements for Kubernetes platforms](../kubernetes_deployment/kubernetes_runtime.md) for more information.

This section provides administrators with instructions to deploy HCL Digital Experience Compose to supported Kubernetes platforms. This includes preparation, installation, and uninstallation of the deployments using Helm.

**Before you begin:** Refer to the latest HCL DX Compose Update image files list provided in the [Container image list](../kubernetes_deployment/image_list.md) topic.

!!!important
    To prevent a possible Kubernetes deployment failure in Kubernetes versions 1.28 and 1.29, it may be required to run the command `modprobe br_netfilter` before running `kubeadm init`. This is a potential solution to avoid a networking bridge/iptables issue.


``` mermaid
flowchart TD
  accTitle: Steps in DX Compose Helm installation.
  accDescr: Flowchart showing the mandatory and optional steps in DX Compose Helm installation.

  A([Start])
  B1[Configure Helm Repository];
  B2[Load the Images];
  C[/Mandatory or Optional Tasks/];
  D[Prepare Namespace];
  E[Setup Custom Configuration];
  G[Configure Networking];
  H[Configure Certificate];
  I[Optional tasks];
  J[Install DX Compose]

  A --> B1;
  B1 --> B2;
  B2 --> C;
  C --> |Mandatory| D;
  D --> E;
  E --> G;
  G --> H;
  H --> J;
  C ----> |Optional| I;
  I --> J;

  click B2 "../preparation/get_the_code/prepare_load_images/"
  click D "../preparation/mandatory_tasks/prepare_namespace/"
  click E "../preparation/mandatory_tasks/prepare_configuration/"
  click G "../preparation/mandatory_tasks/prepare_configure_networking/"
  click H "../preparation/mandatory_tasks/prepare_ingress_certificate/"
  click I "../preparation/optional_tasks/optional_internal_networking/"
  click J "../install/"





```

<!-- Original Lists
  A([Start])
  B1[Configure Helm Repository];
  B2[Load the Images];
  C[/Mandatory or Optional Tasks/];
  D[Prepare Namespace];
  E[Setup Custom Configuration];
  F[Setup Persistent Volumes];
  G[Configure Networking];
  H[Configure Certificate];
  I[Optional tasks];
  J[Install DX]

  A --\> B1;
  B1 --\> B2;
  B2 --\> C;
  C --\> |Mandatory| D;
  D --\> E;
  E --\> F;
  F --\> G;
  G --\> H;
  H --\> J;
  C ----\> |Optional| I;
  I --\> J;

  click B1 "../preparation/get_the_code/configure_harbor_helm_repo/"
  click B2 "../preparation/get_the_code/prepare_load_images/"
  click D "../preparation/mandatory_tasks/prepare_namespace/"
  click E "../preparation/mandatory_tasks/prepare_configuration/"
  click F "../preparation/mandatory_tasks/prepare_persistent_volume_claims/"
  click G "../preparation/mandatory_tasks/prepare_configure_networking/"
  click H "../preparation/mandatory_tasks/prepare_ingress_certificate/"
  click I "../preparation/optional_tasks/optional_internal_networking/"
  click J "../helm_install_commands/"
-->

## HCLSoftware U learning materials

For an introduction and a demo on DX deployment, go to [Deployment for Beginners](https://hclsoftwareu.hcl-software.com/component/axs/?view=sso_config&id=4&forward=https%3A%2F%2Fhclsoftwareu.hcl-software.com%2Fcourses%2Flesson%2F%3Fid%3D1479){target="_blank"}. Several deployment options are provided in the course.

To learn how to do a traditional installation, go to [Deployment for Intermediate Users](https://hclsoftwareu.hcl-software.com/component/axs/?view=sso_config&id=4&forward=https%3A%2F%2Fhclsoftwareu.hcl-software.com%2Fcourses%2Flesson%2F%3Fid%3D3086){target="_blank"}. In this course, you will also learn about additional installation tasks that apply to both container-based and traditional deployments using the Configuration Wizard, DXClient, ConfigEngine, and more. You can try it out using the [Deployment Lab](https://hclsoftwareu.hcl-software.com/images/Lc4sMQCcN5uxXmL13gSlsxClNTU3Mjc3NTc4MTc2/DS_Academy/DX/Administrator/HDX-ADM-200_Deployment_Lab.pdf){target="_blank"} and corresponding [Deployment Lab Resources](https://hclsoftwareu.hcl-software.com/images/Lc4sMQCcN5uxXmL13gSlsxClNTU3Mjc3NTc4MTc2/DS_Academy/DX/Administrator/HDX-ADM-200_Deployment_Lab_Resources.zip){target="_blank"}.

To learn how to manage multiple DX sites, go to [Multi-Site Management](https://hclsoftwareu.hcl-software.com/component/axs/?view=sso_config&id=4&forward=https%3A%2F%2Fhclsoftwareu.hcl-software.com%2Fcourses%2Flesson%2F%3Fid%3D3086){target="_blank"}. In this course, you will learn when and how to create and manage base, true, and virtual portals in which you may run one or more DX sites. You can also try it out using the [Multi-Site Management Lab](https://hclsoftwareu.hcl-software.com/images/Lc4sMQCcN5uxXmL13gSlsxClNTU3Mjc3NTc4MTc2/DS_Academy/DX/Administrator/HDX-ADM-200_Multi-Site_Management_Lab.pdf){target="_blank"}.

For an introduction and a demo on DX staging, go to [Staging for Beginners](https://hclsoftwareu.hcl-software.com/component/axs/?view=sso_config&id=4&forward=https%3A%2F%2Fhclsoftwareu.hcl-software.com%2Fcourses%2Flesson%2F%3Fid%3D505){target="_blank"}.

To learn how to use staging tools such as DXClient, Syndication, XMLAccess, ReleaseBuilder/Solution Installer, and ConfigEngine, go to [Staging for Intermediate Users](https://hclsoftwareu.hcl-software.com/component/axs/?view=sso_config&id=4&forward=https%3A%2F%2Fhclsoftwareu.hcl-software.com%2Fcourses%2Flesson%2F%3Fid%3D3328){target="_blank"}. You can try it out using the [Staging Lab for Intermediate Users](https://hclsoftwareu.hcl-software.com/images/Lc4sMQCcN5uxXmL13gSlsxClNTU3Mjc3NTc4MTc2/DS_Academy/DX/Administrator/HDX-ADM-200_Staging_Lab.pdf){target="_blank"} and corresponding [Staging Lab Resources](https://hclsoftwareu.hcl-software.com/images/Lc4sMQCcN5uxXmL13gSlsxClNTU3Mjc3NTc4MTc2/DS_Academy/DX/Administrator/HDX-ADM-200_Staging_Lab_Resources.zip){target="_blank"}.
