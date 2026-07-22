# Configuring rule-based user groups

The SoftGroups feature in HCL Digital Experience (DX) Compose lets you define dynamic portal user groups, also known as rule-based user groups. These resources are defined by a unique group name, a Lightweight Directory Access Protocol (LDAP) search filter rule expression, and an optional description. DX Compose handles rule-based user groups as standard portal user groups that reside in a special base distinguished name within the user realm hierarchy.

Administrators can create, define, update, or delete these groups through the Portal User Management Architecture (PUMA) in HCL DX, similar to other groups. You can use these groups to assign security role mappings, portal access permissions, or visibility rules. The feature automatically determines correct user membership during runtime.

Implementing rule-based user groups provides two distinct architectural benefits:

- The feature lets you define and assemble dynamic portal user groups based on LDAP search filter expressions applied to user attributes.
- The system persists these groups in the portal database rather than the main portal user repository, which removes the need to enter them into the LDAP directory.

## Features

You can perform the following actions with rule-based user groups:

- Define a rule-based user group and validate the rule syntax.
- Modify the rule or description of an existing rule-based user group and validate the syntax.
- Search for rule-based user groups based on the group name.
- Resolve the rule-based user group membership for particular users during runtime.
- Display the members of a particular rule-based user group.
- Delete an existing rule-based user group.

    !!!note "Notes"
        - Displaying the members of a rule-based user group can impact portal performance. Perform this operation only to verify the resulting set of members after defining a group.
        - Rule-based user groups can contain only individual users, not groups.
        - After defining a rule-based user group, you cannot change the unique group name.

To install rule-based user groups on DX Compose, you must set up a database and configure rule-based groups.

- **[Setting up the database](../cfg_rule_based_user_groups/rbug_db_setup.md)**  
Learn how to create the database table used to store group definitions, LDAP search filter rules, and group properties.
- **[Configuring the database source](../cfg_rule_based_user_groups/rbug_dsrc_cfg.md)**  
Learn how to configure the Java data source that the rule-based user groups adapter uses to communicate with the database.
- **[Setting up SoftGroups](../cfg_rule_based_user_groups/rbug_setup_softgroups_helm.md)**  
Learn how to enable and configure the SoftGroups feature.
- **[Deploying the SoftGroups portlet](../cfg_rule_based_user_groups/rbug_portlet.md)**  
Learn how to deploy the SoftGroups portlet to define and manage the rule-based groups.
- **[LDAP search filter expressions](../cfg_rule_based_user_groups/rbug_ldapfltrxprns.md)**  
Learn how to use the LDAP search filter syntax for these rules.
