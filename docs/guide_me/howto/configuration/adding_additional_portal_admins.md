# How to add new portal administrators in DX Compose

## Applies to  

> HCL Digital Experience 9.5 and higher  

## Introduction  

This document provides detailed steps on how to add new administrators to the HCL Digital Experience (DX) Compose runtime.

## Instructions  

!!!note
    Specify a separate user group for portal administrators instead of adding single users for easier maintenance.

Refer to the following steps to add new administrators into HCL DX Compose:  

1. Specify a separate portal administration group in your user repository. Independent, if the user group is specified on LDAP or in a file based repository. For more information, refer to [Managing users and groups in DX Compose](../../../deploy_dx/manage//working_with_compose/cfg_parameters/manage_users_groups_liberty.md).{target="_blank"} <!--what does the 

2. Login to the DX Compose portal with the current administrator role (default: `wpsadmin`).

3. Click **Open applications menu** then go to **Administration > Security > Users and Groups**.

4. Verify that the new portal administrator group (for example, `portaladmins`) is available and contains the expected users you want to add as administrators.

5. Go to **Administration > Security > Resource Permissions > Virtual Resources**.

6. Locate the **PORTAL** resource then click the **Assign Access** icon.

7. Click the **Edit Role** icon for the **Administrator** role.

8. Click **Add**.  

9. Select the checkbox for the new portal administration group you specified in your user repository then click **OK**. This will grant the group administrative access to the Release domain.

10. Go to **Resources** then click **Apply > OK** to save the changes.

11. Go to **Web Content > Web Content Libraries**.

12. Click **Set Access on Root**.

13. Click the **Edit Role** icon for the **Administrator** role.

14. Click **Add**.

15. Search and add the new portal administration group that you have specified in your user repository then click **OK**. This will grant administrative access to the Java Content Repository (JCR) domain.  

16. Go to **Resources** then click **Apply > OK** to save the changes.  

17. Log out of HCL DX Compose, then log in as one of the new portal administrators to test the changes.
