---
id: manage-outbound-connections
title: Managing outbound connections (Ajax Proxy)
---

The configuration of the outbound connections happens in DX Core through ConfigEngine tasks. There are no ConfigEngine tasks when running WebEngine. This topic explains a different technique that you should use to manage outbound connections with WebEngine.

## Using XMLAccess for outbound connections

You can use a specially prepared xmlaccess script to create or delete outbound connections policies. The following samples showcase how you can use an XML script. You can execute the script through an `xmlaccess.sh` script in the Liberty container or through a remote execution using [DXClient](https://opensource.hcltechsw.com/digital-experience/CF223/extend_dx/development_tools/dxclient/){target="_blank"}.

### Sample for policy creation (global)

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

### Sample for policy deletion (global)

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
