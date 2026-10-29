# Access web content by using a servlet

You can access content displayed by the Web Content Manager (WCM) servlet by connecting to a URL. Use a servlet-delivered website when you do not need HCL Digital Experience (DX) Compose features, such as authoring tools.

## Accessing a web page by using a servlet

Use the following URL structure to connect to a web page:

```url
http(s)://[HOST]:[PORT]/wps/wcm/connect/[PATH]?srv=
```

Do not use non-ASCII characters in the query string section of URLs or in WCM item names that you plan to call through URLs.

- `[PATH]`: Specifies the path to a site area or content item. Enter this setting for all types of content, including components. For components, enter the path to the site area or content item where the component appears.
- `srv=`: Specifies the service type to invoke:
    - `srv=cmpnt`: Retrieves a component from a component library, site area, or content item. Include the following parameters:
        - `source=`: Specifies the component source location (`library`, `sitearea`, or `content`).
        - `cmpntname=<componentname>`: Specifies the name of the component to retrieve.
    - `srv=page`: Retrieves a content item. Because `srv=page` is the default value, you can omit it from the URL.
        - `presentationtemplate=<library>/<presentationtemplatename>`: Specifies the presentation template used to display the content.

## Servlet URL examples

- Connect to content by using the base URL structure:

    ```url
    # Syntax
    http(s)://[HOST]:[PORT]/wps/wcm/connect/[PATH]

    # Example
    https://host/wps/wcm/connect/sitearea/content
    ```

- Define a presentation template in the query string to display content:

    ```url
    # Syntax
    http(s)://[HOST]:[PORT]/wps/wcm/connect/[PATH]
    ?presentationtemplate=[libraryname/presentationtemplatename]

    # Example
    https://host/wps/wcm/connect/sitearea/content?presentationtemplate=library/presentationtemplate
    ```

- Retrieve a component stored in a library:

    ```url
    # Syntax
    http(s)://[HOST]:[PORT]/wps/wcm/connect/[PATH]
    ?srv=cmpnt&source=library&cmpntname=[componentname]

    # Example
    https://host/wps/wcm/connect/sitearea/content?srv=cmpnt&source=library&cmpntname=component
    ```

- Retrieve a component associated with a content item:

    ```url
    # Syntax
    http(s)://[HOST]:[PORT]/wps/wcm/connect/[PATH]
    ?srv=cmpnt&source=content&cmpntname=[componentname]

    # Example
    https://host/wps/wcm/connect/sitearea/content?srv=cmpnt&source=content&cmpntname=component
    ```

## Applying custom caching and expiration parameters

Like any other URL request made to a WCM server, you can add custom caching and expiration parameters to a request.

For example:

```url
http(s)://[HOST]:[PORT]/wps/wcm/connect/[PATH]?CACHE=SITE&EXPIRES=REL+9000s
```

In this configuration, the content retrieved by this URL is saved in the basic site cache and expires after 9,000 seconds (two and a half hours).

## HCLSoftware U learning materials

!!!note
	Access HCLSoftware U resources for free. [Log in](https://hclsoftwareu.hcl-software.com/login-page){target="_blank"} or [Sign up](https://hclsoftwareu.hcl-software.com/hclsoftwareu-signup){target="_blank"} to get started. If you have further questions, [Contact us](https://hclsoftwareu.hcl-software.com/contactus){target="_blank"} or check the [FAQ](https://hclsoftwareu.hcl-software.com/frequently-asked-questions){target="_blank"}.

To learn how to get started with the development aspects of HCL Digital Experience (DX) Web Content, go to the [Web Content Development lesson in the HCL Digital Experience for Developers (Beginners)](https://hclsoftwareu.hcl-software.com/component/axs/?view=sso_config&id=4&forward=https%3A%2F%2Fhclsoftwareu.hcl-software.com%2Fcourses%2Flesson%2F%3Fid%3D414 ){target="_blank"} course. You can try it out using the [Web Content Development Lab](https://hclsoftwareu.hcl-software.com/images/Lc4sMQCcN5uxXmL13gSlsxClNTU3Mjc3NTc4MTc2/DS_Academy/DX/Developer/HDX-DEV-100_Web_Content_Development.pdf){target="_blank"} and corresponding [Web Content Development Lab Resources](https://hclsoftwareu.hcl-software.com/images/Lc4sMQCcN5uxXmL13gSlsxClNTU3Mjc3NTc4MTc2/DS_Academy/DX/Developer/HDX-DEV-100_Web_Content_Development_Lab_Resources.zip){target="_blank"}.
