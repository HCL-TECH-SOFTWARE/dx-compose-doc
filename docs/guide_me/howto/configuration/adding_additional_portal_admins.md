# How to add additional portal administrators in DX Compose

## Applies to  

> HCL Digital Experience 9.5 and higher  

## Introduction  

There might be use-cases when using HCL DX Compose for which it is needed to add additional portal administrators. This article provide detailed steps to add those additional administrators to the DX Compose runtime.  

## Instructions  

!!!note
    It is suggested to specify a separate user group for portal administrators, instead of adding single users as portal administrators. With that it is easier to maintain such users.

To add additional administrators into HCL DX Compose, refer to the following steps:  

1. Specify a separate portal administration group in your user repository. Independent, if the user group is specified on LDAP or in a file based repository.

    For reference, please check: [Managing users and groups in DX Compose](../../../deploy_dx/manage//working_with_compose/cfg_parameters/manage_users_groups_liberty.md){target="_blank"}

2. Login to the DX Compose Portal with the current administrator role (default: wpsadmin).

3. In the DX Compose Portal navigate to `Administration > Security > Users and Groups` and verify that the new portal administrator group (for example the group portaladmins) is available and that the group contain the expected users as members that you want to add as portal administrators.

4. Navigate to `Practitioner Studio > Administration > Security > Resource Permissions > Virtual Resources`.

5. Search in the Resource Permissions list for the Resource `PORTAL`. (The resource might be located on a different page then the first page of the list).

6. Click to the `Assign Access` icon.

7. Click to the `Edit Role` icon for the role `Administrator`.  

8. Click to the `Add` button.  

9. Search and add the new portal administration group that you have specified in your user repository. This will grant administrative access to the Release domain.

10. In the Portal menu navigate to `Web Content > Web Content Libraries`

11. Click to the button `Set Access on Root`

12. Click to the `Edit Role` icon for the role `Administrator`.  

13. Click to the `Add` button.  

14. Search and add the new portal administration group that you have specified in your user repository. This will grant administrative access to the JCR domain.  

15. Click to the `OK` button and make sure that the group is added.  

16. In the breadcrumb menu click to `Resources` and then to the `Apply` button to save the changes.  

17. Logout from Portal

18. Login into the Portal as one of the new portal administrators and test the changes.  
