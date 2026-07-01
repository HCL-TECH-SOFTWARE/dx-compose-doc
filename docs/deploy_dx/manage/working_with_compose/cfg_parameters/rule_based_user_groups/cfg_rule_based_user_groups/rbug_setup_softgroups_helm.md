# Softgroups setup

You must enable and configure the SoftGroups feature in your Helm values before you can use rule-based user groups.

## Update the Helm values file

Add or update the following section in your `custom-values.yaml` file:

```yaml
# SoftGroups Configuration
softGroups:
  # If softgroups enabled for this server: true or false
  enabled: true
  # If enabled, the JNDI name of the DB datasource
  dbJndi: "jdbc/sgdbDS"
  # If enabled, the schema containing the SoftGroup table
  dbSchema: "SoftGroups"
  # If enabled, the DB type of the database containing the softgroups table
  dbType: "DB2"
```

Update these values according to your environment:

- `enabled`: Set to `true` to enable rule-based user groups.
- `dbJndi`: Must match the data source JNDI name configured for the SoftGroups database.
- `dbSchema`: Must match the schema where the `SOFTGROUPS` table was created.
- `dbType`: Set to your database type (for example, `DB2`, `Oracle`, or `SQLServer`).

## Apply the changes

After updating your values file, apply the configuration with a Helm upgrade:

```sh
helm upgrade <RELEASE_NAME> -n <NAMESPACE> -f custom-values.yaml <HELM_CHART_DIRECTORY>
```

For a complete upgrade workflow, see [Upgrading the Helm deployment](../../../helm_upgrade_values.md).
