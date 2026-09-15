---
id: webengine-directory-structure
title: WebEngine directory structure
---

This topic provides the directory structure within the WebEngine container and its associated sidecar container for logs. This includes paths to various configuration files, logs, and other critical directories.

## WebEngine container

### WebEngine server path

The root directory for the WebEngine server is located at:
```
/opt/openliberty/wlp
```

### Server configuration files path

Configuration files for the WebEngine server, such as `server.xml`, `jvm.options`, `server.env`, are stored in the following directory:

```
/opt/openliberty/wlp/usr/servers/defaultServer/
```

### Log folder

Log files for tracing and informational purposes are stored in the following directory:
```
/opt/openliberty/wlp/usr/servers/defaultServer/logs/
```

### Customization

You can store custom configuration files in the following directory:
```
/opt/openliberty/wlp/usr/servers/defaultServer/customization
```

### Configuration overrides

You can store configuration override files in the following directory: 
```
/opt/openliberty/wlp/usr/servers/defaultServer/configDropins/overrides
```

For more details, refer to [DX WebEngine configuration changes using overrides](./configuration_changes_using_overrides.md).

### Properties overrides

You can store the override files for properties in the following directory:

```
/opt/openliberty/wlp/usr/servers/defaultServer/properties-overrides
```

### Properties

Service configuration properties are stored in the following directory:
```
/opt/openliberty/wlp/usr/servers/defaultServer/resources/dxconfig/config/services
```

### Database properties

Database properties are stored in the following directory:
```
/opt/openliberty/wlp/usr/svrcfg/properties/
```

### Custom secrets

Custom secrets are stored in subfolders under the following directory:

```
/mnt/customSecrets/
```

For more details, refer to [Using custom secrets in WebEngine](../working_with_compose/custom_secrets.md).

### Custom certificates

Custom certificates are stored in subfolders under the following directory:

```
/mnt/certs
```

For more details, refer to [Using custom Certificates in WebEngine](../working_with_compose/custom_certificates.md).

## Sidecar container for logs

### SystemOut log

The main log file for system output is located in the following directory:
```
/var/logs/SystemOut.log
```

### Trace log

The trace log file is located in the following directory:
```
/var/logs/trace.log
```

This structure ensures that all configuration files, logs, and custom settings are organized accessible within the WebEngine and its sidecar container.

## HCLSoftware U learning materials

!!!note
	Access HCLSoftware U resources for free. [Log in](https://hclsoftwareu.hcl-software.com/login-page){target="_blank"} or [Sign up](https://hclsoftwareu.hcl-software.com/hclsoftwareu-signup){target="_blank"} to get started. If you have further questions, [Contact us](https://hclsoftwareu.hcl-software.com/contactus){target="_blank"} or check the [FAQ](https://hclsoftwareu.hcl-software.com/frequently-asked-questions){target="_blank"}.


To learn how to do a traditional installation, go to [Deployment for Intermediate Users](https://hclsoftwareu.hcl-software.com/component/axs/?view=sso_config&id=4&forward=https%3A%2F%2Fhclsoftwareu.hcl-software.com%2Fcourses%2Flesson%2F%3Fid%3D3086){target="_blank"}. In this course, you will also learn about additional installation tasks that apply to both container-based and traditional deployments using the Configuration Wizard, DXClient, ConfigEngine, and more. You can try it out using the [Deployment Lab](https://hclsoftwareu.hcl-software.com/images/Lc4sMQCcN5uxXmL13gSlsxClNTU3Mjc3NTc4MTc2/DS_Academy/DX/Administrator/HDX-ADM-200_Deployment_Lab.pdf){target="_blank"} and corresponding [Deployment Lab Resources](https://hclsoftwareu.hcl-software.com/images/Lc4sMQCcN5uxXmL13gSlsxClNTU3Mjc3NTc4MTc2/DS_Academy/DX/Administrator/HDX-ADM-200_Deployment_Lab_Resources.zip){target="_blank"}.