# HCL WCM Support Tools

Use the HCL Web Content Manager (WCM) Support Tools portlet to investigate and analyze information related to the WCM Java Content Repository (JCR) nodes.

## Overview

The HCL WCM items are stored in the JCR repository against a complex schema of interrelated tables. Each item is represented as a node, which is modeled through a graph of information stored across multiple tables. For this reason, deleting a node is not as simple as removing one row from a table in the database. The interrelated connections among all the tables must be handled; in many cases, the level of logic required is not encoded in any singular SQL command that can be sent to the database.

The HCL WCM Support Tools portlet enables administrators to browse through those nodes and perform various operations directly on the JCR repository through the tool's user interface. This portlet includes tools to view the JCR repository for WCM content, run an XPath query and view results, and directly execute various support JavaServer Pages (JSPs). These tools are often utilized when working with HCL Software Support on a case-by-case basis to gather information specific to customers' environment and content. Using this portlet on the HCL WCM system helps expedite the troubleshooting process.

The WCM Support Tools Portlet is accessible from **Practitioner Studio Menu > Web Content** area.

!!!note
    HCL Software advises customers to work with [HCL Software Support](https://support.hcl-software.com/csm){target="_blank"} to properly use the WCM Support Tools portlet.

## Using the HCL WCM Support Tools portlet

The HCL WCM Support Tools portlet provides an assortment of tools that are useful in troubleshooting content-related issues.

When you open the portlet in the Digital Experience (DX) Compose WebEngine Administration panel, you see links to various support tools in the body. In the footer, you will find the time stamp of when the portlet is accessed, the version of WCM for which portlet is installed, and the build version of the portlet. ![HCL WCM Support Tools portlet](./_img//HCL_WCM_Support_Tools_portlet_95.png)

## Browse Nodes

To analyze the JCR representation of WCM or PZN objects use the Browse Nodes functionality. 
After selecting **Browse Nodes**, you must select a workspace; the default is `ROOTWORKSPACE`, where WCM libraries are stored. The Java content repository is divided into the following hierarchy:

-   **Repository**: Container for workspaces
-   **Workspace**: Container for nodes
-   **Node**: Container for properties
-   **Property**: Attribute of a node

Within the JCR specification, the concept of a workspace is defined to be a container for a collection of nodes. All work in the repository is done by way of a workspace. When a user logs into the repository, the user is given a "ticket", through which a workspace is requested. It is through the workspace that all interaction with the nodes, or content, is performed.

All modifications to nodes within a workspace are transient until a “Save” operation. The workspace “Save” operation persists all changes made to the nodes within the workspace to permanent storage, the database.

Browse Nodes shows the internal structure (JCR) of WCM. Administrators can search the node (WCM item) by UUID. This can help troubleshoot permission-related issues when WCM exceptions contains UUID information. Use the Browse Nodes function by entering UUID/IID of an object, if known, or browse through the JCR hierarchy to find an item.

Browse operations are accessed in the portlet by selecting links, located on the right-hand side of the portlet. WCM library items are stored under **contentRoot** by default. The **filestore** has information about themes, skins, CSS, etc.

You can browse through different types of items and find relevant information like Name, Type, Creation Date, UUID and many more. While browsing through the links, a bread crumb trail of the current path is listed in the portlet at the top.

**Node Locks**: If a node is locked, one should be able to unlock it when the unlock access code is entered. A user name displays in this section next to the item that is locked.

**Node Information**: Node information has three elements:

-   Count children: Displays the total number of children that particular node has.
-   Get IID: Displays the IID (Item ID) of the item.
-   Get References: Provides a list of all references to the item. This list could be potentially long if **recursive** is checked.

**Node Actions**: This section has additional buttons when access codes are enabled. For example, one might be able to **edit** a node or **delete** a node, if so directed by HCL Software Support.

**Search by UUID or IID**: You can search for a node using UUID (normally obtained in logs) or IID:

-   UUID is the external reference
-   IID is internal reference
-   The JCR database tables are linked by IID values
-   IID-to-UUID mapping is in the `ICMSTJCRWSNODES` table

After selecting the **Lookup** button, the details of the item are displayed. For example, “Presentation Templates” is returned from a UUID search, and the full path of its breadcrumb trail is presented.

## Run Xpath Query

The WCM JCR uses XPath to search the node hierarchy. XPath is translated to SQL for the specific underlying DX database installed to the platform. The command Run XPath Query returns the result from JCR by using XPath without WCM manipulation, which can help to isolate a problem (JCR or WCM).

## Generating WCM Search URL

This option helps you generate a WCM Seed List URL to be used within a content source. You can select a type of site for your environment from the four button options: **Stand-alone**, **Cluster**, **Virtual Portal**, or **Virtual Portal with Unique URL**. Note that Administrator access is required to generate a WCM Search URL. <!-- Cluster is really not applicable here but is available in the WebEngine UI so leaving it.>

To generate a WCM Seed List URL, refer to the following steps:

1. Select the type of site that you want to generate a search URL for.

    You can choose from the following options:
    - Stand-alone
    - Cluster
    - Virtual Portal
    - Virtual Portal with Unique URL
  
2. In the **Portal Search Engine WCM Seed List Generator** page, perform the following steps:

    1. Click **Get Libraries** to obtain available WCM libraries.
    2. In the **Get Libraries** dropdown menu, select the WCM Library container of the content you want to crawl. Click **Select**.
    3. Click **Get Site Areas** to obtain available site areas for the selected library.
    4. In the **Get Site Areas** dropdown menu, select the site area you want to crawl.
    5. Click **Generate URL** to get the URL which will crawl the selected library and site area. 


## List types

WCM has defined several JCR nodetypes to represent its data structure. Each nodetype defines the properties and child nodes required for the WCM data object it represents, for example:

-   Content item: `ibmcontentwcm:webContent`
-   Site area: `ibmcontentwcm:siteArea`

When these links are selected, the child types and properties of a node are displayed.

## List workspaces

The workspace is an interface to WCM that is associated with a user, in which items are created, saved, deleted, and searched for:

-   Divisions within the repository:
    -   Stable workspaces: Data is copied
    -   Dynamic workspaces: Data is calculated
    -   Default: `ROOTWORKSPACE`
-   Standard workspaces:
    -   `ROOTWORKSPACE` (All libraries)
    -   jcr:versioning (All versions)
    -   Dynamic workspaces (WCM Drafts, Personalization work)

## Enabling access code

There may be occasions when working with HCL Software Support in which they may provide a specific access code in order to unlock update features within the WCM Support Tools portlet. These access codes are temporary, and should be used only to repair the specific problems as directed by the HCL Support Engineer. Any other updates to the JCR database should be done through either HCL Digital Experience Compose WebEngine administration or WCM Authoring.

After an access code is received (for example, for write_all and enabled), a message like `Write Access Enabled: write_all` appears if the code is valid and accepted. HCL Software Support will provide more information on the specific task required from to work to resolution of your support requirement.


