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
