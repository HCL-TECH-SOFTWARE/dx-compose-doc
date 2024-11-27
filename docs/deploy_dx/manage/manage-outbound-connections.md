---
id: manage-outbound-connections
title: Manage Outbound Connections (Ajax Proxy)
---

## Introduction

The configuration of the outbound connections happens in DX Core via ConfigEngine tasks. When running with WebEngine as there are no ConfigEngine tasks a different technique explained in this document should be used.

## Leverage XMLAccess for Outbound Connections Configuration

You can use a specially prepared xmlaccess script to create or delete outbound connections policies. The samples below showcase the usage of a xml script. The script can be executed via xmlaccess.sh script in the Liberty container or remote execution with dxclient.

Sample for policy creation (global):
```
<?xml version="1.0" encoding="UTF-8"?>
<request type="update" version="8.0.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="ProxyConfig_1.0.0.xsd">
    <proxy-config-data type="global">
        <data action="delete"><![CDATA[<?xml version="1.0" encoding="UTF-8"?>
  
<proxy-rules xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.ibm.com/xmlns/prod/sw/http/outbound/proxy-config/2.0">
    <policy active="true" url="https://replacme.hcl.com/*" name="myservice">
        <actions>
            <method>GET</method>
            <method>HEAD</method>
        </actions>
    </policy>
</proxy-rules>]]></data>
    </proxy-config-data>
</request>
```

Sample for policy deletion (global):
```
<?xml version="1.0" encoding="UTF-8"?>
<request type="update" version="8.0.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="ProxyConfig_1.0.0.xsd">
    <proxy-config-data type="global">
        <data action="create"><![CDATA[<?xml version="1.0" encoding="UTF-8"?>
  
<proxy-rules xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.ibm.com/xmlns/prod/sw/http/outbound/proxy-config/2.0">
    <policy active="true" url="https://replacme.hcl.com/*" name="myservice">
        <actions>
            <method>GET</method>
            <method>HEAD</method>
        </actions>
    </policy>
</proxy-rules>]]></data>
    </proxy-config-data>
</request>
```
