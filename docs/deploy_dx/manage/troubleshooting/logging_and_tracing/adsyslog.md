# System event logging

The system event logging facility of HCL Digital Experience (DX) Compose enables the recording of information about the operation of the WebEngine container.

Event logs provide administrators with information about important or abnormal events, especially errors that occur during the operation of the product. In addition, event logs gather debugging information that helps [HCL Software Support](https://support.hcl-software.com/csm){target="_blank"} to resolve problems.

HCL WebEngine provides two types of logging: [logging of messages](#message-logging) and logging of debugging messages called [traces](#trace-logging).

For information about how to use log files and a list of trace logger strings, refer to [Viewing WebEngine server logs](../../logging_webengine.md).

## Message logging

Messages for HCL WebEngine are logged in the following files:

-   `SystemOut.log`

    This file contains information that is useful to monitor the health of the HCL WebEngine server and all running processes.

-   `messages.log`

    This file contains all messages that are written or captured by the logging component. All messages that are written to this file contain additional information such as the message timestamp and the ID of the thread that wrote the message. This file is suitable for automated log analysis. This file does not contain messages that are written directly by the Java Virtual Machine (JVM) process.

-   `trace.log`

    This file is created only if you enable trace. It contains all the content of the `messages.log` file and any enabled trace content. This file does not contain messages that are written directly by the JVM process.


You can find the log files for HCL WebEngine, including `SystemOut.log` and `trace.log`, in the following directory: `/opt/openliberty/wlp/usr/servers/defaultServer/logs`.

## Trace logging

HCL WebEngine provides the logging of debugging messages called traces. These traces are useful for fixing problems. However, to save system resources, they are turned off by default.

You can set traces for different durations:

-   **Temporary**

    You can set traces for a temporary period by using the administration portlet **Enable Tracing**. To set traces by using the portlet, complete the following steps:

    1.  Log in as the administrator.
    2.  Click the **Administration menu** icon. Then, click **Tracing: Gather data about the site**. The Enable Tracing portlet appears.
    3.  Click **Site Administration > Advanced Administration > Tracing: Gather data about the site**. The Enable Tracing portlet appears.
    4.  Enter the required trace string in the **Append these trace settings:** field. For example, this string can be `com.ibm.wps.command.credentialvault.*=finest`.
    5.  Click the **Add** icon. **Enable Tracing** updates the **Current trace settings** field.
    !!!note
                Restarting HCL WebEngine removes traces that were set by using the Enable Tracing Administration portlet.

    To disable tracing, use either of the following methods:

    -   Select the current trace settings under **Current trace settings:** and click the **Remove** icon. For example, the current setting can be `com.ibm.wps.command.credentialvault.*=finest`.
    -   Enter the trace string `*=info` in the **Append these trace settings:** field and click the **Add** icon. This trace string overwrites all settings that are listed under **Current trace settings:** and resets it to the default.
-   **Extended**

    To enable trace settings for a longer period, that is, for more than one session, enable trace through the Helm chart. 

## Changing the language used in the log file

Changing the language in the log file is not supported at this time.

## Log file format

See the Open Liberty document on log formats: [Open Liberty Log Format](https://openliberty.io/docs/latest/log-trace-configuration.html#log_formats)