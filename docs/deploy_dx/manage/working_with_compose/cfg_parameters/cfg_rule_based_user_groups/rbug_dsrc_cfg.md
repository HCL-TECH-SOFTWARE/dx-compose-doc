# Configuring the database source

The rule-based user groups adapter uses a Java data source to communicate with the database that contains the table for rule-based groups.

To configure the database source:

1. Define a data source that references the required JDBC driver and points to the database that contains the groups table.
2. Configure the rule-based user groups adapter with the JNDI name of the data source.

For detailed configuration instructions, refer to [Configuring a data source](https://openliberty.io/docs/latest/relational-database-connections-JDBC.html#data){target="_blank"}.
