# Changing the Portal URI in Kubernetes Deployments

HCL Digital Experience (DX) 9.5 consists of multiple applications and services that can be deployed. Depending on your needs, you can change the default portal Uniform Resource Identifier (URI) any time after you install HCL DX to better suit the requirements of your organization.

To change the portal URI in Kubernetes deployments, adjust the `custom-values.yaml` file used for your Helm deployment. Refer to the [Custom value files](https://opensource.hcltechsw.com/digital-experience/latest/deployment/install/container/helm_deployment/preparation/mandatory_tasks/prepare_configuration/#custom-value-files) page for more information.

In the `custom-values.yaml` file, configure the following section:

```yaml
configuration:
  #Configuration for webEngine
  webEngine:
    contextRoot: wps
    home: portal
    personalizedHome: myportal
```

## Additional considerations

The People Service Helm chart cannot automatically detect changes in the parent chart. If you have deployed HCL People Service along with DX Compose, you must adjust the `portletPageContextRoot` in the People Service chart after adjusting the context root of the DX URI to align the two charts.  For example, when you change the `values.yaml` for DX Compose, you need to add the following:

```yaml
peopleservice:
    portletPageContextRoot: /newcontextroot/Practitioner/PeopleService
```

Afterward, perform a [Helm upgrade](../working_with_compose/helm_upgrade_values.md) to apply these new values.