---
id: webengine-directory-structure
title: WebEngine Directory Structure
---

This document provides a detailed overview of the directory structure within the WebEngine container and its associated sidecar container for logs. It includes paths to various configuration files, logs, and other critical directories.

## WebEngine container

### WebEngine Server path
The root directory for the WebEngine server is located at:
```
/opt/openliberty/wlp
```

### Server configurations files path
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
Custom configuration files can be placed in the following directory:
```
/opt/openliberty/wlp/usr/servers/defaultServer/customization
```

### Configuration overrides
Configuration override files can be placed in the following directory. 
```
/opt/openliberty/wlp/usr/servers/defaultServer/configDropins/overrides
```
For more details, refer to the document on [configuration changes using overrides](./configuration_changes_using_overrides.md).

### Properties overrides
Override files for properties can be placed in the following directory:
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
Custom secrets are stored in subfolders under the following directory.
```
/mnt/customSecrets/
```
For more details, refer to the document on [using custom secrets in WebEngine](./custom_secrets.md)

## Side car container for logs

### SystemOut Log
The main log file for system output is located at:
```
/var/logs/SystemOut.log
```

### Trace Log
The trace log file is located at:
```
/var/logs/trace.log
```

This structure ensures that all configuration files, logs, and custom settings are organized and easily accessible within the WebEngine and its sidecar container.
