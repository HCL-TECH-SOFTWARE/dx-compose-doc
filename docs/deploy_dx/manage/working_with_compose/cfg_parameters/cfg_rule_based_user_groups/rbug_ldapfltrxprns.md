# LDAP search filter expressions

The rules for rule-based user groups are based on the LDAP search filter syntax. You can use these filter expressions to evaluate user attributes and dynamically determine group membership during runtime. For information about the LDAP search filter syntax, refer to [RFC2254 - The String Representation of LDAP Search Filters](http://www.faqs.org/rfcs/rfc2254.html){target="_blank"}.

You can use the following subset of LDAP search filter syntax:

| Operator or element | Symbol | Description |
| :------------------ | :----- | :---------- |
| `AND` operator | `&` | Evaluates multiple conditions together. |
| `OR` operator | `\|` | Evaluates alternative conditions. |
| `NOT` operator | `!` | Negates a condition. |
| Equality comparison | `=` | Compares name and value expressions. |
| Wildcard | `*` | Matches characters at the beginning or end of values in name and value expressions. |

!!!note
    Attributes must not start with an operator or contain equal signs or parentheses.

For example:

| LDAP search filter expression | Description |
| :---------------------------- | :---------- |
| `(uid=testuser)` | Matches all users that have exactly the value `testuser` for the attribute `uid`. |
| `(uid=test*)` | Matches all users that have values for the attribute `uid` that start with `test`. |
| `(!(uid=test*))` | Matches all users that have values for the attribute `uid` that do not start with `test`. |
| `(&(department=1234)(city=Paris))` | Matches all users that have exactly the value `1234` for the attribute `department` and exactly the value `Paris` for the attribute `city`. |
| `(|(department=1234)(department=56*))` | Matches all users that have exactly the value `1234` or a value that starts with `56` for the attribute `department`. |
| `(&(department=12*)(!(department=123*)))` | Matches all users that have a value starting with `12`, but not starting with `123` for the attribute `department`. |

## Validating syntax

When you define or modify a rule base user group, the rule-based user groups adapter validates the syntax for the LDAP search filter expression.

- If you provide an invalid rule, the system returns an error message. However, the system does not check whether the specified attribute names exist in the user configuration. You can verify the configuration by using the code that calls the search filter.

- If you specify an invalid attribute name in a rule, group membership determination fails and logs an error. Existing rules might break if your system attribute configuration changes, such as when an attribute is removed or renamed.

## Mapping attributes

Some LDAP server configurations use default attribute mappings where `mail` maps to `ibm-primaryEmail` and `title` maps to `ibm-jobTitle`. When defining rules, use the mapped attribute names (`ibm-primaryEmail` and `ibm-jobTitle`) instead of the original names (`mail` and `title`) so matches are found. For example, `ibm-primaryEmail=User0000@dx.com`.

## Using wildcards and the `NOT` operator

Rule-based groups evaluate user membership during login to grant access rights. The login process checks group rules against only the authenticating user rather than querying the group roster, preventing large memberships from impacting performance.

This guidance applies to secondary tasks, such as viewing group members in the **Manage Users and Groups** portlet. In UI views, wildcard and `NOT`-based rules can return excessive matches. Configured user registry search limits might limit displayed member lists for very large groups. To estimate match volume before applying these rules in UI views, run a search in the **Manage Users and Groups** portlet.

???+ info "Related information"
    - [RFC2254 - The String Representation of LDAP Search Filters](http://www.faqs.org/rfcs/rfc2254.html){target="_blank"}
