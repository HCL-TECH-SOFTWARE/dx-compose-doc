---
id: manage-global-settings
title: Managing global settings
---

This topic describes how to change the global settings that are displayed (read only) on the Administration - Settings - Global page in Practitioner Studio.

All these settings are modified by overriding properties using Helm values, as described in [Updating DX properties using Helm values
](../cfg_webengine/update_properties_with_helm.md). The specific properties files, keys and values that you need to override to achieve particular effects are described in the sections below.

## Specifying the default DX Compose language

To change the default language for DX Compose, set the following in your custom Helm values:

```yaml
configuration:
  webEngine:
    propertiesFilesOverrides:
      LocalizerService.properties:
        locale.default.language: “<language code>”
        locale.default.country: “<country code (optional)>”
        locale.default.variant: “<variant (optional)>“
```

## Specifying how to handle portlets that the user is not authorized to view

If a portlet is hidden from a user, you can choose between displaying a message or nothing at all.

To replace the portlet with an informative message, set the following in your custom Helm values:

```yaml
configuration:
  webEngine:
    propertiesFilesOverrides:
      ConfigService.properties:
        portlets.unauthorized.visible: "true"
```

To display nothing at all, set the following in your custom Helm values:

```yaml
configuration:
  webEngine:
    propertiesFilesOverrides:
      ConfigService.properties:
        portlets.unauthorized.visible: “false”
```

## Specifying what users see initially when they log in

After they log in, you can choose for a user to return to the default DX Compose page, to return to the last page of their last visit, or you can allow them to choose.

To always have users return to the default DX Compose page after login (their session will not resume), set the following in your custom Helm values:

```yaml
configuration:
  webEngine:
    propertiesFilesOverrides:
      ConfigService.properties:
        persistent.session.level: "0"
        persistent.session.option: "0"
```

To have users return to the last page of their last visit, set the following in your custom Helm values. This option helps when users need to log back in to complete a previous task, for example if they lose their connection in the middle of a task.

```yaml
configuration:
  webEngine:
    propertiesFilesOverrides:
      ConfigService.properties:
        persistent.session.level: "2"
        persistent.session.option: "0"
```

To give users the choice to determine their initial view after login, set the following in your custom Helm values:

```yaml
configuration:
  webEngine:
    propertiesFilesOverrides:
      ConfigService.properties:
        persistent.session.level: "2"
        persistent.session.option: "1"
```

## Specifying the search engine that opens when users select Find

To add a URL for the search engine that your users use in the portal, set the following in your custom Helm values:

```yaml
configuration:
  webEngine:
    propertiesFilesOverrides:
      ConfigService.properties:
        portlet.url.find: “<URL>“
```

!!!important
    The Search box feature is available in the themes that are supplied with DX Compose. If you want to use your own custom themes, you need to implement the Search box. To do this, include the tag `<portal:find>` in your theme.
