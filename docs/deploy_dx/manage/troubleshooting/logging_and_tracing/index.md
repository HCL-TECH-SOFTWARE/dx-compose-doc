# Logging and tracing

If you are experiencing a problem, you can enable tracing and then re-create the problem to capture more log information.

Refer to the MustGather data collection lists used in troubleshooting various problems in HCL Digital Experience (DX) Compose. Collecting MustGather data early, even before you open a PMR, helps HCL Software Support determine whether:

-   Symptoms match known problems \(rediscovery\).
-   A non-defect problem can be identified and resolved.
-   A defect identifies a workaround to reduce severity.
-   Locating the root cause can speed development of a code fix.

You can enable logging and tracing for software that is included with HCL DX Compose. Enabling tracing makes log output more verbose. For example, you can enable tracing within Open Liberty to obtain information about application servers and other processes.

You can use the information gathered to help solve problems or to report an issue to [HCL Software Support](https://support.hcl-software.com/csm){target="_blank"}.

## Common HCL DX Compose tracing questions

-   **How do I turn on HCL Digital Experience Compose trace logging?**

    See [Trace logging](adsyslog.md#tra_log) for information.


-   **What are the different trace settings and where are they logged?**

    See [WebEngine runtime logs](run_logs.md) for information.


-   **How do I change the location of my logs?**

    See [Changing the log file name and location](adsyslog.md#log_loc) for information.


-   **[HCL WebEngine runtime logs](run_logs.md)**  
If tracing is enabled, HCL Digital Experience WebEngine generates a log file during run time that contains messages and trace information.
-   **[Verbosegc in Java VM logs](verbosegc.md)**  
Verbose garbage collection \(verbosegc\) logging is often required when tuning and debugging many issues, and has negligible impact on system performance.
-   **[Open Liberty tracing and log files](open_liberty_logs.md)**  
Use Open Liberty log files and tracing to troubleshoot problems with HCL WebEngine.
-   **[System event logging](adsyslog.md)**  
The system event logging facility of HCL Digital Experience enables the recording of information about the operation of HCL WebEngine.
-   **[HCL Web Content Manager tracing](/wcm_logs.md)**  
Enable the use of Open Liberty trace facilities to create trace information for Web Content Manager. This tracing can be enabled either permanently or for just the current HCL Digital Experience Compose session.
-   **[Logging and tracing for containers and new services](logging_tracing_containers_and_new_services.md)**  
The following table outlines the tracing options that are used to capture logging and tracing for HCL Digital Experience Compose container-based services with container update CF181 and later releases.
-   **[Logging and tracing client side rendering](../logging_and_tracing/logging_and_tracing_clientside)**  
Learn the how to enable client side logging and tracing of your HCL Digital Experience pages.
