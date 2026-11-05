# Storing translated text in a content item or site area

You can store translated text in a content item or site area and reference it in web content tags or as localized text in web content authoring portlet forms.

## Creating the content item or site area to store the translated text

To configure a content item or site area as a text provider:

1. Create a content item or site area.
2. In the profile settings of the content item or site area, add `ibm.wcm.TextProvider` as a keyword.
3. For each language that your site uses, create a text element. Enter the language code for the language in the name field of each text element. For a list of codes, refer to [Supported languages](https://help.hcl-software.com/digital-experience/9.5/latest/deployment/manage/portal_admin_tools/language_support/).

    !!!note
        When rendering, if the requested language doesn't exist in the list of elements, the first element is used as the default language.

4. In each text element, enter the translated text in the format `keyname=translated-text`. You can add as many key names as you need to each text element. For example:

    ```text
    keyname1=translated text
    keyname2=translated text
    keyname3=translated text
    ```

    - Use the same key names for each language.
    - The list of key names and translated text uses the [Java Properties File Format](https://docs.oracle.com/javase/7/docs/api/java/util/Properties.html#load%28java.io.Reader%29){target="_blank"}.

## Selecting the translated text in a web content authoring portlet form

In the authoring portlet, you can reference stored keys to populate form fields with localized text. Fields that support localized text display a **Localizations** link next to the field title.

To select translated text for a field:

1. Select **Localizations**.
2. Select the content item or site area that stores your translated text.
3. Select a key name.

## Rendering translated text in a web content tag

Use the `Localize` plug-in tag to render translated text:

```text
[Plugin:Localize key="" provider=""]
```

- `key`: Specifies the name of the key to display.
- `provider`: Specifies the name path or item ID to the content item or site area that stores the translated text. For example: `[Plugin:Localize key="keyname2" provider="library/sitearea/contentitem"]`.

If you move or rename a content item, site area, or parent item, name path references break. To prevent broken references, specify the item ID instead of the name path:

```text
[Plugin:Localize provider="[Element key='Text Provider Name' format='id']" key="keyname2"]
```

For more information about the `Localize` plug-in, refer to **Text Provider plug-in** in [Content plug-ins](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_authoring/authoring_portlet/content_management_artifacts/tags/creating_plugin_tag/content_plugins/).

## Setting a default localized item in a web content tag

If you use the `Localize` plug-in tag more than once with the same localized item in a component design or presentation template design, specify the name path to the default localized item in one tag:

```text
[Plugin:Localize defaultProvider="library/sitearea/contentitem"]
```

`defaultProvider`: Specifies the name path to the localized item to use when a tag omits the `provider` parameter.

In the tags that follow the default provider tag, you can omit the `provider` parameter:

```text
[Plugin:Localize defaultProvider="library/sitearea/contentitem"]
[Plugin:Localize key="key1"]
[Plugin:Localize key="key2"]
[Plugin:Localize key="key3"]

```

The default provider applies in all presentation template designs and component designs, including component designs that you include by using tags, such as a component tag.

To remove the default provider, set `defaultProvider` to an empty value:

```text
[Plugin:Localize defaultProvider=""]
```

## Replacing placeholder values in translated text

Use the `param.n` parameter in the `Localize` plug-in tag to specify the value that replaces placeholder `{n}` in translated text, where `n` is the zero-based numeric index of the placeholder.

For example, if a content item at `library/sitearea/contentitem` contains the following key with placeholders:

```text
keyname_with_replacement=Welcome {0} to the website of {1}
```

The following tag specifies replacement values for `{0}` and `{1}`:

```text
[Plugin:Localize key="keyname_with_replacement" provider="library/sitearea/contentitem" param.0="Fred" param.1="Mary"]
```

The tag renders the following text:

```text
Welcome Fred to the web site of Mary
```

## Hiding a localized item from the authoring interface

To hide a localized item from the Localizations list in the authoring interface, add a text element named `isShownInAuthoringUI` and set its value to `false`.

You can still reference the hidden item in plug-in tags.
