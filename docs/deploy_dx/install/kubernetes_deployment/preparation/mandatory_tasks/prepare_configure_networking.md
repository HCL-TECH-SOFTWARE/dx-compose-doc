# Configuring networking

To run HCL Digital Experience (DX) Compose 9.5, including WebEngine and all associated applications, and enable external access to your Kubernetes or Red Hat OpenShift cluster, configure the required networking settings.

## WebEngine host

In a full deployment, the host for both the WebEngine and the other applications are the same.

It is recommended to configure the host before you run the deployment. This is only possible if you know the fully qualified domain name (FQDN) or the IP address that the HAProxy assigns in your deployment beforehand.

If that is the case, define the host using the following syntax:

```yaml
# Networking specific configuration
networking:
  # Networking configuration specific to WebEngine
  webEngine:
    # Host of webEngine, must be specified as a FQDN
    host: "your-dx-instance.whateverdomain.com"
```

If you do not know the hostname beforehand, you can leave it blank and run an additional step later in the installation, which would retrieve the assigned hostname from HAProxy and configure all applications accordingly.

## Configuring Cross Origin Resource Sharing (CORS)

The HCL DX Compose 9.5 Helm chart allows you to configure CORS configuration for all the `addon` to WebEngine applications such as Digital Asset Management (DAM) or Ring API. This allows you to access the APIs provided by those applications in other applications with ease.

You can define a list of allowed hosts for a specific application using the following syntax in your `custom-values.yaml`:

```yaml
# Networking specific configuration
networking:
  # Networking configurations specific to all addon applications
  addon:
    contentComposer:
      # CORS Origin configuration for Content Composer, array of elements
      corsOrigin: 
      - "https://my-different-application.net"
      - "https://the-other-application.com"
```

Refer to the HCL DX Compose 9.5 `values.yaml` detail for all possible applications that can be configured.

## Configuring HAProxy certificate

To allow HAProxy to forward requests to your applications, you must provide a Transport Layer Security (TLS) certificate. HAProxy uses this certificate to terminate TLS connections for traffic entering the Kubernetes or OpenShift cluster from external clients. After terminating the TLS connection, HAProxy forwards the requests to your applications.

1. Create a self-signed certificate:

    !!!note
        It is recommended to use a Certificate Authority (CA)-signed certificate for HAProxy in production environments. However, you can create and use a self-signed certificate for staging or testing environments.

    ```sh
    # Create a private key.
    openssl genrsa -out my-key.pem 2048
                      
    # Create a certificate signed by the previously created private key.
    openssl req -x509 -key my-key.pem -out my-cert.pem -days 365 -subj '/CN=my-cert'
    ```

    These commands generate a key and certificate file that you can use in the next step to create the secret for your deployment.

2. Store the certificate as a secret in your Kubernetes or Red Hat OpenShift cluster:

    !!!note
        Choose any secret name (for example, `dx-tls-cert`), and reference it in the next configuration step. Specify the Kubernetes namespace where you deploy HCL DX Compose 9.5 (for example `digital-experience-compose`).

    ```sh
    # Create a secret named "dx-tls-cert" in the "digital-experience-compose" namespace
    # Reference a previously created certificate and key file, or a CA-signed certificate.
    kubectl create secret tls dx-tls-cert --cert=my-cert.pem --key=my-key.pem -n digital-experience-compose
    ```

3. Update your `custom-values.yaml` file to set `tlsCertSecret` to your secret name so HAProxy can process HTTPS requests (default: `dx-tls-cert`):

    ```yaml
    # Networking specific configuration
    networking:
      # TLS Certificate secret used for haproxy
      tlsCertSecret: "dx-tls-cert"
    ```

    !!! note
        Verify you have entered the correct name.

## Configuring HAProxy networking

HAProxy is deployed with a `LoadBalancer` type service to handle the incoming traffic as well as the SSL offloading for HCL DX. Additionally, the Helm deployment offers adjustability for HAProxy and its services to allow for more flexible deployment and use of custom Ingress controllers.

|Parameter|Description| Type | Default value|
|---------|-----------|-------------|------|
|`ssl` { width="20%" }  |Enable or disable SSL offloading in HAProxy. Depending on this setting, HAProxy handles either `HTTP` or `HTTPS` traffic. { width="40%" } | Boolean { width="20%" }| `true` { width="20%" }|
|`serviceType`|Defines the Kubernetes [`ServiceType`](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types){target="blank"} of the HAProxy service. Supported ServiceType includes `LoadBalancer`, `ClusterIP` and `NodePort` | `LoadBalancer` \| `ClusterIP` \| `NodePort` |`LoadBalancer`|
|`servicePort`|This value is used to select the port exposed by the HAProxy service. Defaults to port `443` if `ssl` is set to `true`, otherwise, port `80` is used. | Number |`null`|
|`serviceNodePort`|This value is used to select the node port exposed by the HAProxy service. Defaults to a port selected by Kubernetes if no value is set. | Number |`null`|
|`strictTransportSecurity.enabled`|This value is used for HTTP Strict Transport Security (HSTS) to determine if it should be `enabled`. When enabled, this value requires SSL in DX or any proxy in front of the SSL. | Boolean |`true`|
|`strictTransportSecurity.maxAge`|This value is used to set for how long the browser should remember the HSTS rule | Number |`31536000`|
|`strictTransportSecurity.includeSubDomains`|If this optional parameter is specified, this rule applies to all of the site's subdomains as well. | Boolean |`false`|
|`strictTransportSecurity.preload`|See [Preloading Strict Transport Security](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security#preloading_strict_transport_security){target="blank"} for details. When using preload, the max-age directive must be at least 31536000 (1 year), and the includeSubDomains directive must be present. This parameter is not part of the HSTS specification. For more information, see [Strict-Transport-Security HTTP Response Header Field](https://www.rfc-editor.org/rfc/rfc6797#section-6.1){target="blank"}. | Boolean |`false`|
|`sessionCookieName`|This parameter does not directly change the cookie name. Instead, you must set this value if the cookie name is changed in the [console](https://help.hcl-software.com/digital-experience/9.5/latest/deployment/manage/config_portal_behavior/http_sessn_cookie/){target="blank"}.| String |`JSESSIONID`|

!!!note
    If `ssl` is set to `true`, HAProxy uses the certificate that is supplied as a secret in `networking.tlsCertSecret`.

```yaml
networking:
  # Networking configurations specific to HAProxy
  haproxy:
    # Configuration to enable/disable ssl offloading in HAProxy
    ssl: true
    # Configuration to set the service type for the HAProxy service. Supported values are "ClusterIP", "LoadBalancer", and "NodePort"
    serviceType: "LoadBalancer"
    # Configuration to set the port exposed by the HAProxy Service. If the port is not set, then port 80 is used if SSL offloading is disabled, and port 443 if SSL offloading is enabled.
    servicePort:
    # Only applies for the "NodePort" serviceType. Configuration to set the NodePort exposed by the HAProxy service. If this is not set, a port is automatically selected by Kubernetes
    serviceNodePort:
    # HTTP Strict Transport Security(HSTS)
    strictTransportSecurity:
      enabled: true
      maxAge: 31536000
      includeSubDomains: false
      preload: false
    # Set cookie value for session affinity in HAProxy configuration for DX applications that require session affinity (e.g. HAProxy)
    sessionCookieName: "JSESSIONID"
```
  
This configuration is helpful if you want to use a custom Ingress controller to expose the service. HAProxy remains active to receive traffic routed from the Ingress controller.

## Using annotations to control the HAProxy service behavior for different cloud providers

The Helm chart allows you to add annotations to the HAProxy service to control the behavior of the service for different cloud providers. You can use this to configure the service to use a specific type of load balancer or to configure other settings specific to the cloud provider. You can add annotations in your `custom-values.yaml` as described [in the Annotations documentation](../optional_tasks/optional_labels_annotations.md#annotations).

Examples for such annotations are in an non-exhaustive list. Refer to the documentation provided by your cloud provider for more information:

- [Amazon Elastic Kubernetes Service - Use Service Annotations to configure Network Load Balancers](https://docs.aws.amazon.com/eks/latest/userguide/auto-configure-nlb.html){target="_blank"}
- [Google Kubernetes Engine - LoadBalancer Service parameters](https://cloud.google.com/kubernetes-engine/docs/concepts/service-load-balancer-parameters){target="_blank"}
- [Azure Kubernetes Service - LoadBalancer annotations](https://cloud-provider-azure.sigs.k8s.io/topics/loadbalancer/#loadbalancer-annotations){target="_blank"}

### OpenShift Passthrough

A `Route` resource must be created manually when required as part of a deployment to OpenShift.

#### Creating the route resource manually

If you want to deploy OpenShift manually using `Routes`, you need to create a `.yaml` file like below and any changes required can be made in that. To apply those changes in the OpenShift cluster, you can run `kubectl apply` and specify its namespace and location.
For more information, refer to the [OpenShift Route Configuration](https://docs.openshift.com/container-platform/latest/networking/routes/route-configuration.html){target="blank"} documentation.

In some versions of OpenShift, sticky sessions for passthrough `Routes` are enabled in OpenShift using the source (IP) as identifier by default. To make sure traffic gets forwarded to all DX Compose HAProxy Pods even when another proxy is used in front of it, the `Route` should be annotated as shown in the example below. Refer to the [OpenShift documentation](https://docs.openshift.com/container-platform/latest/networking/routes/route-configuration.html){target="blank"} to select the appropriate value for your deployment.

```yaml
apiVersion: "route.openshift.io/v1"
kind: "Route"
metadata:
  annotations:
    # By default, OpenShift applies load balancing and sticky sessions are routed to the same Pod depending on the source IP.
    # This should be disabled to leverage all DX Compose HAProxy Pods when another proxy is used in front of DX Compose.
    haproxy.router.openshift.io/balance: roundrobin
  name: "<helm-deployment-name>-passthrough"
spec:
  port:
    targetPort: "haproxy"
  tls:
    insecureEdgeTerminationPolicy: "Redirect"
    termination: "passthrough"
  to:
    kind: "Service"
    name: "<helm-deployment-name>-haproxy"
    weight: 100
  wildcardPolicy: "None"
```

`<helm-deployment-name>` must be replaced with the name of the deployed Helm release.

## Configuring Content-Security-Policy frame options

The HCL DX Compose 9.5 Helm chart allows you to configure **[Content-Security-Policy: frame-ancestors](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/frame-ancestors){target="blank"}** for DX WebEngine and all other components, such as DAM or Ring API.

Setting `cspFrameAncestorsEnabled` to true adds `content-security-policy: frame-ancestor 'self'` headers to the responses, enabling you to frame DX and other add-on applications.

There is also an option to specify allowed URLs that can frame your application using the `cspFrameAncestorAllowedSourceURLs` property. Using this property is a way to mitigate clickjacking attacks. For more information, see: [Clickjacking Defense Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Clickjacking_Defense_Cheat_Sheet.html){target="blank"}.

You can define a list of allowed URLs for a specific application using the following syntax in your `custom-values.yaml`. This example uses `contentComposer`, but the same applies for other applications:

```yaml
# Networking specific configuration
networking:
  # Networking configurations specific to all addon applications
  addon:
    contentComposer:
      # Enables/Disables CSP frame-ancestor header
      # Note: 'self' is always added when this is enabled to enable DX Compose internal features
      # see: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/frame-ancestors
      cspFrameAncestorsEnabled: false
      # Add list of allowed source URLS to the the CSP frame-ancestor header this will only reflect if cspFrameAncestorsEnabled is set to true
      # Example:
      # cspFrameAncestorsAllowedSourceURLs:
      #   - 'https://example.com'
      # This would result to the following response header:
      # content-security-policy: frame-ancestors 'self' https://example.com
      cspFrameAncestorsAllowedSourceURLs: []        
```

Refer to the HCL DX Compose 9.5 `values.yaml` detail for all possible applications that you can configure.

## Configuring SameSite Cookie Attribute

The HCL DX Compose 9.5 Helm chart allows you to configure **[SameSite Cookie Attribute](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite){target="blank"}** for DX WebEngine. This configuration sets the `WASReqURL` Cookie Attributes `Secure` and `SameSite`.

!!!note
    This should only be set in an HTTPS environment to prevent unwanted behaviors.

You can define the SameSite value in your `custom-values.yaml`:

```yaml
# Networking specific configuration
networking:
  webEngine:
    # None, Lax, Strict, or empty string
    # Setting this to an empty string would not add the SameSite attribute for WASReqURL cookie
    # Note: This should only be set in an HTTPS environment to prevent unwanted behaviours
    cookieSameSiteAttribute: ""
```

Refer to the HCL DX Compose 9.5 `values.yaml` detail for all possible applications that can be configured.

## HAProxy custom headers

The HCL DX 9.5 Helm chart allows you to configure custom HTTP headers in the HAProxy configuration. You can both add new headers and remove existing headers from responses generated by HAProxy.

### Adding custom headers

You can add custom HTTP headers to all responses from HAProxy using the `customHeader` property. This is useful for implementing security best practices or adding specific information to responses.

Each header entry supports the following properties:

- `name`: The name of the HTTP header to be added
- `value`: The value that should be set for the header

Example configuration in your `custom-values.yaml` file:

```yaml
networking:
  haproxy:
    customHeader:
      - name: X-Content-Type-Options
        value: nosniff
      - name: Referrer-Policy
        value: no-referrer
```

### Removing headers

You can specify header names that should be removed from HAProxy responses using the `deleteHeader` property. This is useful for removing headers that might reveal internal information or that you do not wish to forward.

Example configuration in your `custom-values.yaml` file:

```yaml
networking:
  haproxy:
    deleteHeader:
      - X-Powered-By
```
