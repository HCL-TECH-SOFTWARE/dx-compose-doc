# Taxonomies, categories, and keywords

Taxonomies, categories, and keywords classify content items and determine how menu components display content in HCL Digital Experience (DX) Compose.

## Taxonomies

A taxonomy is the highest-level organizing structure for content classification. It functions as a root container that groups related sets of categories together under a broad domain or subject area. Content items are not assigned directly to a taxonomy. Instead, they are assigned to categories that reside within that taxonomy.

For example, an organization can create a taxonomy named Financial to house all categories related to banking, accounting, and investments.

## Categories

Categories classify content items by subject matter within a taxonomy. They form parent-child hierarchies that determine how menu components display content.

The following hierarchy shows how categories branch under a taxonomy root:

- Financial (Taxonomy)
    - Banking Solutions
    - Interest Rates
        - Personal
        - Business
        - Corporate

Menu components evaluate category relationships by searching upward toward ancestor categories and downward toward descendant categories. Where a category sits in the hierarchy determines which items appear in the navigation. The following scenarios use the Financial hierarchy example to show how menu components return content based on the selected category level.

|Scenario|Example|
|--------|-------|
|Menus based on a top-level category display content tagged with that category or any of its descendants.|A menu based on Financial displays content tagged with Financial, Banking Solutions, Interest Rates, Personal, Business, or Corporate.|
|Menus based on a mid-level category display content tagged with that category, its descendants, or its ancestors.|A menu based on Interest Rates displays content tagged with Financial, Interest Rates, Personal, Business, or Corporate.|
|If you base a menu on a bottom-level category, all content that is profiled with the bottom-level category or its ancestors are returned by the menu.|A menu based on Business displays content tagged with Financial, Interest Rates, or Business.|

## HCLSoftware U learning materials

!!!note
	Access HCLSoftware U resources for free. [Log in](https://hclsoftwareu.hcl-software.com/login-page){target="_blank"} or [Sign up](https://hclsoftwareu.hcl-software.com/hclsoftwareu-signup){target="_blank"} to get started. If you have further questions, [Contact us](https://hclsoftwareu.hcl-software.com/contactus){target="_blank"} or check the [FAQ](https://hclsoftwareu.hcl-software.com/frequently-asked-questions){target="_blank"}.

To learn more details on how to develop with HCL Digital Experience (DX) Web Content, go to the [Web Content Development lesson in the HCL DX for Developers (Intermediate)](https://hclsoftwareu.hcl-software.com/component/axs/?view=sso_config&id=4&forward=https%3A%2F%2Fhclsoftwareu.hcl-software.com%2Fcourses%2Flesson%2F%3Fid%3D3500){target="_blank"} course. You can try it out using the [Web Content Development Lab](https://hclsoftwareu.hcl-software.com/images/Lc4sMQCcN5uxXmL13gSlsxClNTU3Mjc3NTc4MTc2/DS_Academy/DX/Developer/HDX-DEV-200_Web_Content_Development.pdf){target="_blank"} and corresponding [Web Content Development Lab Resources](https://hclsoftwareu.hcl-software.com/images/Lc4sMQCcN5uxXmL13gSlsxClNTU3Mjc3NTc4MTc2/DS_Academy/DX/Developer/HDX-DEV-200_Web_Content_Development_Lab_Resources.zip){target="_blank"}.
