# Logging and tracing for containers and new services

Log levels and trace strings are set in your `custom-values.yaml` file. [Configure and Access Logs](https://opensource.hcltechsw.com/digital-experience/latest/deployment/manage/container_configuration/troubleshooting/configure_access_helm_logs/){target="_blank"} provides more detail on how to configure logging in Helm amd how to access Kubernetes container logs. 

## Prerequisite

Install and configure Content Composer, Digital Asset Management, and others to your HCL Digital Experience (DX) Compose deployment.

## Trace string format

    The trace strings must use the following format. Any text not in angled brackets ("<>") should not be changed:

    ```
    hcl.logging.<app-name>.client.<severity>.<client-hierarchy>.*=all
    ```

    Replace the text strings in angled bracket placeholders as described in this section.

-   **app-name**

    The application name is configured in the shared settings. The following values are currently in use:

    -   `medialibrary` - for Digital Asset Management (DAM)
    -   `content-ui` - for Content Composer
    
-   **severity**

    This presents the logger severity level. The values used are:

    -   `info`
    -   `debug`

-   **client-hierarchy**

    This specifies the subsections of the client application where tracing can be enabled. It is specified in dot-separated trace strings and is converted to colon-separated trace strings. The exact hierarchy depends on the client application. Examples include:

    -   `app.*`
    -   `app.redux.*`
    -   `app.redux.actions.*`

-   **Example trace strings**

    The following are some examples of full trace strings for Content Composer, DAM, and their results:

    -   `hcl.logging.medialibrary.*=all` - Enables debug message logging for all files in the DAM application user interface source folder app/redux/actions. Specifically, the debug string `client:debug:app:redux:actions:*` is set for the DAM client logger.
    This tracing is enabled either permanently or just for the current HCL DX Compose WebEngine container.

    HCL Digital Experience Compose v9.5 uses the Open Liberty trace facilities to create trace information.

    If you need detailed trace output of Content Composer or DAM to troubleshoot a problem, follow the steps in the succeeding sections.


!!!note
    The following tracing configurations for enabling tracing only apply to client-side logging.
    The Warning **The configured trace state included the following specifications that do not match any loggers currently registered in the server: ''hcl.logging.content-ui.*=all:hcl.logging.medialibrary.*=all:hcl.logging.presentation-designer.*=all'' Ignore this message if the trace specifications ''hcl.logging.content-ui.*=all:hcl.logging.medialibrary.*=all'' are valid.** can be ignored.


## Enabling tracing permanently

1.  Adjust the Helm chart WebEngine trace setting.

    For example, to trace all events, use the following value:

    ```
    hcl.logging.content-ui.*=all 
    hcl.logging.medialibrary.*=all
    hcl.logging.presentation-designer.*=all
    ```

2.  Apply the Helm chart.

## Enabling tracing for the current HCL DX Compose session

1.  Click the **Administration** menu icon. Then, click **Tracing: Gather data about the site**.
2.  Enter any of the following values in the **Append these trace settings** field.

    For example, to trace all events, enter the following value:

    ```
    hcl.logging.content-ui.*=all 
    hcl.logging.medialibrary.*=all
    hcl.logging.presentation-designer.*=all
    ```


After a trace string is added or removed in the Tracing portlet, the DX Compose platform page containing the **Tracing portlet** application must be refreshed in the browser.


## Viewing logs in the browser console using developer tools
You can view the client logs using the developer tools in the web browser. The following image shows an example on how to view the logs of Content Composer.

![View Logs in Web Browser](../../../../../images/View_logs_in_console.png)


!!!important
    Open Liberty consolidates the trace strings list by removing strings that are logically contained within others. For example, if you have a string `x.y.z.*=all` in the list, it disappears when you add `x.y.*=all`

???+ info "Related information"  
    -   [Troubleshooting your Helm deployment](https://opensource.hcltechsw.com/digital-experience/latest/deployment/manage/container_configuration/troubleshooting/helm_troubleshooting/){target="_blank"} 
