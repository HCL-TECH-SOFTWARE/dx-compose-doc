# HCL WebEngine runtime logs

If tracing is enabled, HCL Digital Experience (DX) Compose WebEngine generates a log file during run time that contains messages and trace information.

The default runtime log file is shown:

/opt/openliberty/wlp/usr/servers/defaultServer/logs/trace.log

See the topic [System event logging](adsyslog.md) for details on how to configure logging and for information on the grammar of the "trace string" configuration key.

The following information describes trace loggers for particular situations and problem symptoms. Enabling the trace loggers can slow down HCL WebEngine.

!!!note
    If there are problems with portal administration portlets, the error is not caused by the portlet code itself, but by the underlying function for which the portlet provides the UI. Therefore, the portlet trace strings are not listed here. If there are issues with these portlets, provide the trace strings of the underlying function. If you need traces or logs for portlets, you can learn how to obtain them from HCL Support.

## Access control

-   **When to use**

    Enable this tracer if you want permissions for resources to be explained in detail, need to verify the correctness of a permission, or need to isolate a defect in access control.


-   **Trace string**

    ```
    com.ibm.wps.ac.*=all
    ```

-   **Additional comments**

    The traces are easier to evaluate while HCL WebEngine usage is low.

    **Important:** Enabling this logger creates large log files.


## Authentication

-   **When to use**

    Enable this tracer if you want to debug login, logout, and impersonation issues.

-   **Trace string**

    ```
    com.ibm.wps.services.puma.*=all:   
    com.ibm.wps.puma.*=all:  
    com.ibm.wps.auth.*=all: 
    com.ibm.wps.sso.*=all: 
    com.ibm.wps.um.*=all: 
    com.ibm.wps.services.authentication.*=all
    ```


## Command

-   **When to use**

    Use to turn on all command trace loggers.


-   **Trace string**

    ```
    com.ibm.wps.commands.*=all
    ```


## Layout model

-   **When to use**

    Enable these messages if you want to get more information on how pages are constructed, if you need to verify page lists that are displayed on HCL WebEngine for correctness, or if you must isolate an error in the HCL WebEngine aggregation component.


-   **Trace string**

    ```
    com.ibm.wps.model.*=all: 
    com.ibm.wps.composition.*=all
    ```


-   **Additional comments**

    The traces are easier to evaluate while HCL WebEngine usage is low.

    **Important:** Enabling this logger creates large log files.


## Credential vault

-   **When to use**

    Investigate issues with the credential retrieval or storage from the vault.

-   **Trace string**

    ```
    com.ibm.wps.sso.credentialvault.*=all:   
    com.ibm.wps.command.credentialvault.*=all:   
    com.ibm.wps.portletservice.credentialvault.*=all:  
    com.ibm.wps.services.credentialvault.*=all:  
    com.ibm.portal.portlet.service.credentialvault.*=all
    ```


## Database

-   **When to use**

    Use to deal with generated SQL statements and the internal flow in the HCL WebEngine database layer.


-   **Trace string**

    ```
    com.ibm.wps.datastore.*=all:   
    com.ibm.wps.services.datastore.*=all
    ```


-   **Additional comments**

    **Important:** Enabling this logger creates large log files.


## Engine

-   **When to use**

    Use to enable all engine trace loggers.


-   **Trace string**

    ```
    com.ibm.wps.engine.*=all
    ```


## General

-   **Trace string**

    ```
    com.ibm.wps.*=all
    ```

    !!!note
            If you want to use general tracing but do not want render times to be displayed for such portlets, you must selectively disable tracing by using the following trace string:
            
             ```
             com.ibm.wps.pe.PortletRenderTimeLoggingHelper=info
             ```

## Mail Service

-   **When to use**

    Use to diagnose problems with the Mail Service.


-   **Trace string**

    ```
    com.ibm.wps.services.mail.*=all   
    ```


## Mapping URLs

-   **When to use**

    Use to diagnose problems with the user-defined mappings of URLs.


-   **Trace string**

    ```
    com.ibm.wps.mappingurl.*=all:   
    com.ibm.wps.command.mappingurl.*=all
    ```


## Personalization

-   **Trace string**

    ```
    com.ibm.websphere.personalization.*=all: 
    com.ibm.dm.pzn.ui.*=all
    ```


## Portlet container

-   **Trace string**

    ```
    com.ibm.wps.pe.pc.*=all:   
    org.apache.jetspeed.portlet.Portlet=all:  
    javax.portlet.Portlet=all
    ```


## Portlet environment

-   **Trace string**

    ```
    com.ibm.wps.pe.ext.*=all:   
    com.ibm.wps.pe.factory.*=all:   
    com.ibm.wps.pe.om.*=all:   
    com.ibm.wps.pe.util.*=all
    ```


## Portlet Load Monitoring

-   **When to use**

    Use to diagnose problems with Portlet Load Monitoring \(PLM\).


-   **Trace string**

    ```
    com.ibm.wps.pe.pc.waspc.plm.*=all:
    com.ibm.wps.command.plm.*=all 
    ```


## Deployment

-   **Trace string**

    ```
    com.ibm.wps.pe.mgr.*=all:   
    com.ibm.wps.services.deployment.*=all:   
    com.ibm.wps.command.applications.*=all:   
    com.ibm.wps.command.portlets.*=all
    ```


## Portlets

-   **When to use**

    Use to diagnose problems with portlets.


-   **Trace string**

    ```
    com.ibm.wps.portlets.*=all:   
    org.apache.jetspeed.portlet.PortletLog=all
    ```

-   **Additional comments**

    Enables tracing for all portlets. Therefore, place the suspect portlet on a separate page for testing.


## Services: EventBroker

-   **Trace string**

    ```
    com.ibm.wps.services.registry.EventHandlerRegistry=all:   
    com.ibm.wps.services.events.*=all
    ```


## Services: Finder

-   **When to use**

    Use for debugging the resolution of file names.

-   **Trace string**

    ```
    com.ibm.wps.services.finder.*=all
    ```


## Services: Loader

-   **When to use**

    Use to trace the dynamic class loading that is done by this service.

-   **Trace string**

    ```
    com.ibm.wps.services.ServiceManager=all
    ```


## ServicesNaming

-   **When to use**

    Use to debug the lookup of objects by the naming service.

-   **Trace string**

    ```
    com.ibm.wps.services.naming.*=all
    ```


## ServicesNavigator

-   **When to use**

    Use to diagnose problems with parts of page aggregation and display.

-   **Trace string**

    ```
    com.ibm.wps.services.navigator.*=all
    ```


## ServicesRegistry

-   **When to use**

    Use to view the policies of the internal portlet object caching and watch it reload its content.

-   **Trace string**

    ```
    com.ibm.wps.services.registry.*=all
    ```


## Services

-   **When to use**

    Use for turning on tracing for all services.

-   **Trace string**

    ```
    com.ibm.wps.services.*=all
    ```


## SSO

-   **When to use**

    Use to turn on all single sign-on (SSO) tracer loggers.

-   **Trace string**

    ```
    com.ibm.wps.sso.*=all
    ```

-   **Additional comments**

    Use this logger if errors occur when you use the Security Vault task on the Security page of the Administration pages.


## WSRP administration

-   **When to use**

    Use to diagnose problems that occur during the administration of Web Services for Remote Portlets \(WSRP\) with HCL WebEngine.

-   **Trace string**

    ```
    com.ibm.wps.command.wsrp.*=all:  
    com.ibm.wps.wsrp.cmd.*=all
    ```


## WSRP Consumer

-   **When to use**

    Use to diagnose problems that occur during the use of WSRP with HCL WebEngine as a Consumer.

-   **Trace string**

    ```
    com.ibm.wps.wsrp.consumer.*=all
    ```


## WSRP Producer

-   **When to use**

    Use to diagnose problems that occur during the use of WSRP with HCL WebEngine as a Producer.

-   **Trace string**

    ```
    com.ibm.wps.wsrp.producer.*=all 
    ```


## XML configuration interface

-   **When to use**

    Use to diagnose problems with the XML import/export of HCL WebEngine configurations.

-   **Trace string**

    ```
    com.ibm.wps.command.xml.*=all
    ```



