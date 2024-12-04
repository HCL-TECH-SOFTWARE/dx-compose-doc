---
id: dxclient
title: Supported DXClient operations
---
This topic enumerates the DXClient functionalities supported by Digital Experience (DX) Compose. 


| Artifact                                      | Command                          |
|-----------------------------------------------|-----------------------------------|
| **Script Application**                        | `dxclient deploy-scriptapplication pull`  |
|                                               | `dxclient deploy-scriptapplication push`  |
|                                               | `dxclient undeploy-scriptapplication`  |
| **XML Access**                                | `dxclient xmlaccess`               |
| **Themes Artifacts (WebDAV based)**           | `dxclient deploy-theme`             |
| **Web Content Syndicators and Subscribers**   | `dxclient manage-syndicator`        |
|                                               | `dxclient manage-syndicator get-syndication-report` |
|                                               | `dxclient manage-subscriber`      |
|                                               | `dxclient create-syndication-relation` |
| **Import WCM**                                | `dxclient mls-import`               |
| **Export WCM**                                | `dxclient mls-export`               | 
| **Credential Vault Slot**                     | `dxclient create-credential-vault`  |
| **Virtual Portals**                           | `dxclient manage-virtual-portal export` |
|                                               | `dxclient manage-virtual-portal import` |
| **Personalization Rules**                     | `dxclient pzn-export`               |
| **LiveSync**                                  | `dxclient livesync pull-theme`      |
|                                               | `dxclient livesync push-theme`      |
|                                               | `dxclient livesync pull-wcm-design-library` |
|                                               | `dxclient livesync push-wcm-design-library` |
| **DAM**                                       | **DAM Schemas**                   |
|                                               | `dxclient list-dam-schemas`         |
|                                               | `dxclient delete-dam-schema`        |
|                                               | **DAM EXIM**                      |
|                                               | `dxclient manage-dam-assets export-assets` |
|                                               | `dxclient manage-dam-assets validate-assets` |
|                                               | `dxclient manage-dam-assets import-assets` | 
|                                               | **Staging DAM to Rendering Environments** |
|                                               | `dxclient manage-dam-staging trigger-staging` |
|                                               | `dxclient manage-dam-staging get-all-subscribers` |
|                                               | `dxclient manage-dam-staging register-dam-subscriber` | 
|                                               | `dxclient manage-dam-staging deregister-dam-subscriber` | 
|                                               | `dxclient manage-dam-staging find-staging-mismatch` | 
|                                               | `dxclient manage-dam-stagingget-staging-mismatch-report` |
|                                               | `dxclient manage-dam-staging start-staging-resync` |  
|                                               | `dxclient manage-dam-staging delete-staging-mismatch` |

All other DXClient operations are not supported at this time.
