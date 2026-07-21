---
id: manage-global-settings
title: Managing global settings
---

Starting from CF237, the **Global** page under **Administration > Settings** in Practitioner Studio is read-only. To modify global settings, edit the parameters under `configuration.webEngine.propertiesFilesOverrides` in your custom Helm values file. For more information, refer to [Updating DX properties using Helm values](../cfg_webengine/update_properties_with_helm.md).

## Specifying the default DX Compose language

To change the default language for DX Compose, add the language properties to your custom Helm values file:

```yaml
configuration:
  webEngine:
    propertiesFilesOverrides:
      LocalizerService.properties:
        locale.default.language: “<language code>”
        locale.default.country: “<country code (optional)>”
        locale.default.variant: “<variant (optional)>“
```

## Specifying how to handle portlets users are not authorized to view

Configure whether to display a message or hide portlets entirely when users lack permission to view them.

To display an informative message:

```yaml
configuration:
  webEngine:
    propertiesFilesOverrides:
      ConfigService.properties:
        portlets.unauthorized.visible: "true"
```

To hide the portlet entirely:

```yaml
configuration:
  webEngine:
    propertiesFilesOverrides:
      ConfigService.properties:
        portlets.unauthorized.visible: “false”
```

## Specifying landing pages after login

After users log in, you can direct them to the default DX Compose page without resuming their session, return them to the last page visited in their previous session, or allow them to choose their starting view.

To direct users to the default DX Compose page without resuming their session:

```yaml
configuration:
  webEngine:
    propertiesFilesOverrides:
      ConfigService.properties:
        persistent.session.level: "0"
        persistent.session.option: "0"
```

To return users to the last page visited in their previous session:

```yaml
configuration:
  webEngine:
    propertiesFilesOverrides:
      ConfigService.properties:
        persistent.session.level: "2"
        persistent.session.option: "0"
```

To allow users to choose their initial view:

```yaml
configuration:
  webEngine:
    propertiesFilesOverrides:
      ConfigService.properties:
        persistent.session.level: "2"
        persistent.session.option: "1"
```

## Specifying the search engine URL

To configure the search engine URL used when users select **Find**:

```yaml
configuration:
  webEngine:
    propertiesFilesOverrides:
      ConfigService.properties:
        portlet.url.find: “<URL>“
```

!!!important
    The Search box feature is available in default DX Compose themes. To use custom themes, include the `<portal:find>` tag in your custom theme code.
