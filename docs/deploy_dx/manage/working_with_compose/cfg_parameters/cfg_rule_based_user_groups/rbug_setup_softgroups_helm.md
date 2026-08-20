# Setting up SoftGroups

Rule-based user groups require enabling and configuring the SoftGroups feature. Updating the Helm configuration defines the database connection properties and enables the SoftGroups feature flag for the deployment.

## Updating the Helm configuration

1. Add or update the following section in your `custom-values.yaml` file:

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

2. Apply the configuration with a Helm upgrade:

    ```sh
    helm upgrade <RELEASE_NAME> -n <NAMESPACE> -f custom-values.yaml <HELM_CHART_DIRECTORY>
    ```

    For a complete upgrade workflow, refer to [Upgrading the Helm deployment](../../helm_upgrade_values.md).
