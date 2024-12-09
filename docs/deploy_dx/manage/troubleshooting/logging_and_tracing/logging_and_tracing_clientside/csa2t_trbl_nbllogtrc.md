# Enabling client-side logging and tracing

Modify the custom properties `cc.isDebug` and `cc.traceConfig` in the WP CommonComponentConfigService to enable client-side logging and tracing.

1.  In the Helm chart, set `WP CommonComponentConfigService cc.isDebug=true` and 

2.  Set the value of the property `cc.traceConfig` property for WP CommonComponentConfigService to a value that represents a correctly formatted JavaScript array of strings. Each string in the array is the name of the component that you want to trace. You can use the wildcard character asterisk \(`**\***`\) for multiple matching.

    Example:

    ```
    ["com.ibm.mashups.enabler.*","com.ibm.mashups.builder.model.ContextMenu"]
    ```

    This value adds client-side trace-logging for all components in the namespace `com.ibm.mashups.enabler` and the component `com.ibm.mashups.builder.model.ContextMenu`.

3. Apply the Helm chart.


Examples: To activate all iWidget related logging and tracing, you use the following line:

```
traceConfig: ["com.ibm.mm.iwidget.*"]
```

To set multiple patterns, you separate them by commas like this example:

```
traceConfig: ["com.ibm.mm.iwidget.*", "com.ibm.portal.*", "com.ibm.portal.wps.*"]
```

By alternative, you can also achieve the same result by using scripting tools that WebSphere Application Server provides. For more information, refer to the WebSphere Application Server Help Center under topic *configuring custom properties for resource environment providers by using wsadmin scripting*.

