# Extend Web Content Manager

HCL Digital Experience (DX) Compose Web Content Manager (WCM) offers several facilities for developers, which allows you to extend the capabilities of the product.

## What is it For?

APIs provided by HCL DX Compose enable developers to access most of the web content features of HCL DX Compose. This means that they can write applications to manage content from outside of DX Compose, or they can integrate content into their applications. An example of this would be a mobile application built with Volt MX that uses HCL DX Compose web content so that non-technical users can update the content without recompiling the app.

Additionally, developers can extend the capability of HCL DX Compose. Some information about that is given in this section, but other extension points such as [WCM tags](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_authoring/authoring_portlet/content_management_artifacts/tags/) and [custom workflow actions](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_authoring/authoring_portlet/change_management/workflow/workflow_stages_actions/) are described elsewhere.

## Who Should Use It?

This information is primarily aimed at developers who either want to integrate web content or web content capabilities into their applications, or who want to extend HCL DX Compose.

- **[HCL WCM API](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_development/wcm_dev_api/)**  
Using the WCM API to create, delete, move, copy, retrieve, search, and approve items.
- **[Creating custom plug-ins](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_development/wcm_custom_plugin/)**  
A custom plug-in allows you to run tasks. For example, you can create plug-ins to run when a page is rendered, store multi-locale text strings, and run when a file is uploaded.
- **[REST service for WCM](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_development/wcm_rest/)**  
Application developers can use Representational State Transfer (REST) services to work with WCM.
- **[REST service for WCM v2](./wcm_rest_v2.md)**  
You can run V2 APIs for WCM content and artifacts.
- **[Determining the current web content context](./wcm_dev_context.md)**  
Using the WCM Page Content Service, you can determine the current web content context of a portal page or Web Content Viewer portlet.
- **[Creating a custom HTML editor integration](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_development/wcm_dev_custom_html_editor/)**  
You can use custom HTML editors in all HTML fields of the authoring interface or specific HTML elements that are defined in an authoring template. Custom HTML fields are used to integrate third-party editors into the authoring interface.
- **[Creating a custom launch page](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_development/wcm_dev_custom_ui/)**  
You can configure an authoring portlet to use your custom-made launch page instead of the default user interface.
- **[Displaying data from external sources](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_development/wcm_dev_displaying_data/)**  
You can display content from external sources using standard Java tag libraries and a JSP element. Java code that uses standard Java APIs or tag libraries can be used to display and format data from databases, LDAP repositories, or send email.
- **[Taxonomies, categories, and keywords](wcm_dev_profiling_taxonomy_planning.md)**  
Taxonomies, categories, and keywords allow you to control the content displayed in menus.
- **[Using remote actions](wcm_dev_remoteactions.md)**  
Remote actions are used to trigger actions from the HCL WCM application.
- **[Storing translated text in a content item or site area](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_development/wcm_dev_storing_translated_text/)**  
Translated text can be stored in a content item or site area. The translated text can then be referenced in web content tags, or as localized text in web content authoring portlet forms.
- **[Java messaging services for web content](https://help.hcl-software.com/digital-experience/9.5/latest/manage_content/wcm_development/wcm_jms_enable/)**  
WCM supports event notifications such as item state changes, or services starting and stopping. These notifications can be delivered as messages to the Java messaging service.  
- **[Using the AI analyzer API for content](wcm_rest_content_ai_analysis.md)**  
A new WCM REST v2 API is available for sentiment analysis of content, keyword extraction from content, and auto summarization of content element.

## HCLSoftware U learning materials

!!!note
	Access HCLSoftware U resources for free. [Log in](https://hclsoftwareu.hcl-software.com/login-page){target="_blank"} or [Sign up](https://hclsoftwareu.hcl-software.com/hclsoftwareu-signup){target="_blank"} to get started. If you have further questions, [Contact us](https://hclsoftwareu.hcl-software.com/contactus){target="_blank"} or check the [FAQ](https://hclsoftwareu.hcl-software.com/frequently-asked-questions){target="_blank"}.

For an introduction and a demo on how to use Experience API, go to [Experience API](https://hclsoftwareu.hcl-software.com/component/axs/?view=sso_config&id=4&forward=https%3A%2F%2Fhclsoftwareu.hcl-software.com%2Fcourses%2Flesson%2F%3Fid%3D416){target="_blank"}. To try it out yourself, refer to [Experience API Lab](https://hclsoftwareu.hcl-software.com/images/Lc4sMQCcN5uxXmL13gSlsxClNTU3Mjc3NTc4MTc2/DS_Academy/DX/Developer/HDX-DEV-100_Experience_API_for_Beginners.pdf){target="_blank"} and corresponding [Experience API Lab Resources](https://hclsoftwareu.hcl-software.com/images/Lc4sMQCcN5uxXmL13gSlsxClNTU3Mjc3NTc4MTc2/DS_Academy/DX/Developer/HDX-DEV-100_Experience_API_Lab_Resouces.zip).
