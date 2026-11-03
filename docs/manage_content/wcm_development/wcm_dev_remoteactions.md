# Using remote actions

Use remote actions to trigger actions in HCL Web Content Manager (WCM).

## Plug-in tags

You can reference remote actions in plug-in tags with the following syntax:

```text
[plugin:RemoteAction action=" " docid=" " 
dialog=" " dialogSize=" " dialogTitle=" " useCurrentContext=" " showInfoMsg=" " ]
```

- `action`: Specifies the remote action to perform.
- `docid`: Specifies the document ID of the target item.
- `useCurrentContext`: Set to `true` to obtain the document ID from the rendering context instead of the `docid` attribute.
- `dialog`: Set to `true` to render the remote action as a URL that redirects the user to a hidden portal page used for inline editing in the Web Content Viewer portlet. When set to true, configure the following nested dialog parameters:
    - `dialogSize`: Defines the width and height of the dialog executing the remote action in the format `width,height`. For example, `dialogSize="200,300"` sets a width of 200 pixels and a height of 300 pixels. If omitted, the dialog calculates its dimensions from the displayed content.
    - `dialogTitle`: Sets the title of the dialog executing the remote action. If omitted, the dialog uses the action name.
    - `showInfoMsg`: Set to `true` to display success and informational messages after the remote action completes. If omitted, defaults to `false` and displays only warning and error messages.

## Portlet URLs

You can append remote actions to the URL of an authoring portlet:

```url
http://[host]/wps/myportal/wcmAuthoring?wcmAuthoringAction=action
```

To support inline editing of content items, append remote actions to the URL of a local Web Content Viewer portlet.

## Custom authoring interfaces

Remote actions do not support building custom authoring interfaces. Remote actions deliver limited functionality and support only plain text without markup in HTML elements. Use the WCM API to build custom authoring interfaces.

!!!note
    A DocumentId identifies each web content item. Retrieve the `docid` value using the `DocumentID.getID()` web content API method. A document ID consists of a document type and a unique ID. Document IDs in the examples represent placeholders, such as `com.ibm.workplace.wcm.api.WCM_Content/ID1`.

## Remote action types

- `new`: Opens a new item form.

    ```text
    [plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_Content" ]
    ```

    Use the following parameters with this action:

    - `type`: Specifies the item type to create. Supported values include:

        - `com.ibm.workplace.wcm.api.WCM_AuthoringTemplate`
        - `com.ibm.workplace.wcm.api.WCM_Category`
        - `com.ibm.workplace.wcm.api.WCM_Content`
        - `com.ibm.workplace.wcm.api.WCM_DateComponent`
        - `com.ibm.workplace.wcm.api.WCM_FileComponent`
        - `com.ibm.workplace.wcm.api.WCM_HTMLComponent`
        - `com.ibm.workplace.wcm.api.WCM_ImageComponent`
        - `com.ibm.workplace.wcm.api.WCM_NumericComponent`
        - `com.ibm.workplace.wcm.api.WCM_PresentationTemplate`
        - `com.ibm.workplace.wcm.api.WCM_RichTextComponent`
        - `com.ibm.workplace.wcm.api.WCM_ShortTextComponent`
        - `com.ibm.workplace.wcm.api.WCM_SiteArea`
        - `com.ibm.workplace.wcm.api.WCM_Taxonomy`
        - `com.ibm.workplace.wcm.api.WCM_TextComponent`
        - `com.ibm.workplace.wcm.api.WCM_Workflow`
        - `com.ibm.workplace.wcm.api.WCM_WorkflowStage`

    - `atid`: Supplies the document ID of the authoring template to use as the default template when creating a content item.

        ```text
        [plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_Content" atid="com.ibm.workplace.wcm.api.WCM_AuthoringTemplate/ID1"]
        ```

    - `pid`: Specifies the document ID of the parent item when creating site areas, content items, or categories.

        ```text
        [plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_Content" pid="com.ibm.workplace.wcm.api.WCM_SiteArea/ID"]
        [plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_SiteArea" pid="com.ibm.workplace.wcm.api.WCM_SiteArea/ID"]
        [plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_Category" pid="com.ibm.workplace.wcm.api.WCM_Taxonomy/ID"]
        ```

    - `position`: Positions a new site area relative to existing site areas. Set to `start` to place the item at the beginning, or `end` to place it at the end. If omitted, the parameter defaults to `start`.

        ```text
        [plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_Content" position="start"]
        [plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_SiteArea" position="end"]
        ```

- `delete`: Deletes the item specified by `docid`.

    ```text
    [plugin:RemoteAction action="delete" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1"]
    ```

- `edit`: Opens the item specified by `docid` in edit mode.

    ```text
    [plugin:RemoteAction action="edit" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1"]
    ```

- `read`: Opens the item specified by `docid` in read-only mode.

    ```text
    [plugin:RemoteAction action="read" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1"]
    ```

- `openmainview`: Opens a view within an authoring portlet specified by `view`.

    ```text
    [plugin:RemoteAction action="openmainview" view="contentbysitearea"]
    ```

    The `view` parameter supports the following values:

    - `contentbysitearea`
    - `contentbytitle`
    - `myrecent`
    - `mydraft`
    - `mypendingapproval`
    - `mypublished`
    - `myexpired`
    - `mydeleted`
    - `alldraftitems`
    - `allexpireditems`
    - `allpublisheditems`
    - `alldeleteditems`
    - `componentsbytype`

- `move`: Moves the site area or content item specified by `docid` into the parent item specified by `pid`. Specifying only `docid` opens the move dialog in the user interface.

    ```text
    [plugin:RemoteAction action="move" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1"]
    ```

    - `moveDirection`: Moves a content item up or down one position within the parent specified by `pid`. Set to `1` to move the item up or `-1` to move the item down.

        ```text
        [plugin:RemoteAction action="move" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1" pid="com.ibm.workplace.wcm.api.WCM_SiteArea/ID1" moveDirection="1"]
        ```

- `link`: Links the content item specified by `docid` to the parent site area specified by `pid`.

    ```text
    [plugin:RemoteAction action="link" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1" pid="com.ibm.workplace.wcm.api.WCM_SiteArea/ID2"]
    ```

    - `ppath`: Specifies the path to the parent item instead of using `pid` to maintain references across environments with differing document IDs or to specify a path hierarchy for automatic creation.

        ```text
        [plugin:RemoteAction action="link" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1" ppath="library1/sitearea1/sitearea2"]
        ```

    - `autoCreateParent`: Set to `true` to create a parent item automatically. When using this parameter, identify the target parent in `ppath` and specify the source item library in `slibrary`.

        ```text
        [plugin:RemoteAction action="link" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1" autoCreateParent="true" slibrary="libraryname" ppath="library1/sitearea1/sitearea2"]
        ```

    - `slibrary`: Specifies the library that contains the source item. Use this parameter with `autoCreateParent`.

- `copy`: Creates a copy of the item specified by `docid` in the parent item specified by `pid`.

    ```text
    [plugin:RemoteAction action="copy" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1" pid="com.ibm.workplace.wcm.api.WCM_SiteArea/ID2"]
    ```

    Use the following parameters with this action:

    - `ppath`: Specifies the path to the parent item instead of using `pid` to maintain references across environments with differing document IDs or to specify a path hierarchy for automatic creation.

        ```text
        [plugin:RemoteAction action="copy" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1" ppath="library1/sitearea1/sitearea2"]
        ```

    - `autoCreateParent`: Set to `true` to create a new parent item automatically. When using this parameter, specify the existing parent to create the new parent item under in `ppath`, and specify the library that contains the item you are copying in `slibrary`.

        ```text
        [plugin:RemoteAction action="copy" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1" autoCreateParent="true" slibrary="libraryname" ppath="library1/sitearea1/sitearea2"]
        ```

    - `slibrary`: Specifies the library that contains the item you are copying. Use this parameter with `autoCreateParent`.
    - `copyAsDraft`: Set to `true` to restart the workflow on the copy, which defaults the status to draft.
    - `wid`: Specifies the document ID of the workflow to assign to the copy. Assigning a workflow restarts the workflow and sets the item status to draft.

        ```text
        [plugin:RemoteAction action="copy" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1" pid="com.ibm.workplace.wcm.api.WCM_SiteArea/ID2" wid="com.ibm.workplace.wcm.api.WCM_Workflow/ID1"]
        ```

    - `position`: Set to `start` to place the copy as the first child item under the specified parent. If omitted, the parameter defaults to the last child.

- `approve`: Approves the item specified by `docid` in a workflow.

    ```text
    [plugin:RemoteAction action="approve" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1"]
    ```

- `decline`: Declines the item specified by `docid` in a workflow.

    ```text
    [plugin:RemoteAction action="decline" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1"]
    ```

- `saveandapprove`: Approves the item specified by `docid` in a workflow when the item is open in edit mode within the same session.

    ```text
    [plugin:RemoteAction action="saveandapprove" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1"]
    [plugin:RemoteAction action="saveandapprove" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1" isdraft="true"]
    ```

- `previousstage`: Moves the item specified by `docid` to the previous stage in a workflow.

    ```text
    [plugin:RemoteAction action="previousstage" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1"]
    ```

- `viewversions`: Opens the versions dialog for the item specified by `docid`.

    ```text
    [plugin:RemoteAction action="viewversions" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1"]
    ```

- `viewhistory`: Opens the history dialog for the item specified by `docid`.

    ```text
    [plugin:RemoteAction action="viewhistory" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1"]
    ```

## Populating fields when creating or editing content

When you use the `new` or `edit` action with content items, you can add data to fields in the content item by using parameters in the tag or URL.

You can use the following parameters to populate fields when you create or edit content:

- `wcmfield.content.name=`
- `wcmfield.content.title=`
- `wcmfield.content.description=`
- `wcmfield.content.authors=`
- `wcmfield.content.owners=`
- `wcmfield.content.publishDate=`
- `wcmfield.content.expiryDate=`
- `wcmfield.content.generalDateOne=`
- `wcmfield.content.generalDateTwo=`
- `wcmfield.content.workflow=`
- `wcmfield.content.categories=`
- `wcmfield.content.keywords=`
- `wcmfield.element.elementname=`

!!! note
    - Use `wcmfield.content.workflow=` only when creating content.
    - Replace `elementname` with the name of the element you are populating. The element parameter can only be used with the following element types: text, HTML, rich text, option selection, user selection, date and time, number, JSP, link, and component reference.

### Populating user fields

When you populate fields with user IDs, use the following format:

```text
[plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_Content" wcmfield.content.authors="uid=usera,cn=cn-name,dc=dc-name"]
```

### Populating workflow and category fields

When you populate workflow and category fields, use the document IDs as the values:

```text
[plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_Content" wcmfield.content.workflow="ID1"]
[plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_Content" wcmfield.content.categories="ID1"]
```

### Populating date fields

When you populate date fields, use the US English date format. You can specify a date and time, or only a date. If you specify only a date, the time defaults to 12:00:00 AM.

```text
[plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_Content" wcmfield.content.generalDateOne="Feb 14, 2008 12:53:03 PM"]
[plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_Content" wcmfield.content.generalDateOne="Feb 14, 2008"]
```

The date and time use the server time zone, not the time zone of the user's computer.

### Populating JSP elements

When you populate a JSP element, specify the path to the JSP file:

```text
[plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_Content" wcmfield.element.jspelementname="/wps/wcm/jsp/html/example.jsp"]
```

### Populating component reference elements

When you populate a component reference element, specify the component to reference:

```text
[plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_Content" wcmfield.element.mycompref.type="com.aptrix.pluto.cmpnt.NavigatorCmpnt" wcmfield.element.mycompref.id="e4bdf10042d0769698ccbeb0e25cc973"]
```

### Populating option selection elements

When you populate an option selection element, specify each selection option:

```text
[plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_Content" wcmfield.element.elementname="AA" wcmfield.element.elementname="BB"]
```

### Populating user selection elements

When you populate a user selection element, specify each user:

```text
[plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_Content" wcmfield.element.elementname="uid=wpsadmin,o=defaultWimFileBasedRealm" wcmfield.element.elementname="uid=wpsadmin2,o=defaultWimFileBasedRealm"]
```

### Populating link elements

When you populate a link element, you can use the following parameters:

- `wcmfield.element.elementname.type`: Specifies the type of item to link to. Supported values are `content`, `link`, `resource`, and `external`.
- `wcmfield.element.elementname.id`: Specifies the ID of the item to link to.
- `wcmfield.element.elementname.externalReference`: Specifies the URL to link to when `type` is `external`.
- `wcmfield.element.elementname.useReferenceLinkText`: Set to `true` to use the name of the linked item as the link text.
- `wcmfield.element.elementname.linkImage`: Specifies the ID of the image component to display as the link.
- `wcmfield.element.elementname.linkText`: Specifies the text of the link.
- `wcmfield.element.elementname.linkDescription`: Specifies the description of the link.
- `wcmfield.element.elementname.linkTarget`: Specifies the target of the link. Supported values include `_blank`, `_parent`, `_self`, `_top`, and `targetname`.

The following examples show how to link to each type of item:

- Link to a content item:

```text
[plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_Content" wcmfield.element.elementname.type="content" wcmfield.element.elementname.id="contentID"]
```

- Link to a link component:

    ```text
    [plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_Content" wcmfield.element.elementname.type="link" wcmfield.element.elementname.id="linkcomponentID"]
    ```

- Link to an image or file resource component:

    ```text
    [plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_Content" wcmfield.element.elementname.type="resource" wcmfield.element.elementname.id="componentID"]
    ```

- Link to a URL:

    ```text
    [plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_Content" wcmfield.element.elementname.type="external" wcmfield.element.elementname.externalReference="myurl"]
    ```

## Saving content

You can add the following save parameters to a remote action tag:

- `wcmfield.autosave`: Set to `true` to save the item in the background without displaying it to users.

    ```text
    wcmfield.autosave="true"
    ```

- `wcmfield.saveValidate`: Set to `true` to display warning and error messages that result from the autosave. Set to `false` to suppress the messages. If omitted this parameter defaults to `true`.

    ```text
    wcmfield.saveValidate="false"
    ```

## Adding comments to the item history

When creating items that use a workflow with "Enter comment on approval" set to `true`, you can add a comment to the item history by adding `comment="comment text"` to the tag or URL. For example:

```text
[plugin:RemoteAction action="edit" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1" createDraft="true" comment="comment text"]
```

## Examples

Each example shows the remote action as a plug-in tag and as a URL.

### Opening item views

To open the versions view for an item:

- Tag: `[plugin:RemoteAction action="viewversions" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1"]`
- URL: `http://<host>/wps/myportal/wcmAuthoring?wcmAuthoringAction=viewversions&docid=com.ibm.workplace.wcm.api.WCM_Content/ID1`

To open the history view for an item:

- Tag: `[plugin:RemoteAction action="viewhistory" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1"]`
- URL: `http://<host>/wps/myportal/wcmAuthoring?wcmAuthoringAction=viewhistory&docid=com.ibm.workplace.wcm.api.WCM_Content/ID1`

To open a content item in read mode:

- Tag: `[plugin:RemoteAction action="read" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1"]`
- URL: `http://<host>/wps/myportal/wcmAuthoring?wcmAuthoringAction=read&docid=com.ibm.workplace.wcm.api.WCM_Content/ID1`

To open a content item in edit mode:

- Tag: `[plugin:RemoteAction action="edit" &docid=com.ibm.workplace.wcm.api.WCM_Content/ID1]`
- URL: `http://<host>/wps/myportal/wcmAuthoring?wcmAuthoringAction=edit&docid=com.ibm.workplace.wcm.api.WCM_Content/ID1`

### Moving items

To move a content item up:

- Tag: `[plugin:RemoteAction action="move" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1" moveDirection="1" pid="com.ibm.workplace.wcm.api.WCM_SiteArea/ID1"]`
- URL: `http://<host>/wps/myportal/wcmAuthoring?wcmAuthoringAction=move&docid=com.ibm.workplace.wcm.api.WCM_Content/ID1&moveDirection=1&pid=com.ibm.workplace.wcm.api.WCM_SiteArea/ID1`

To move a site area down:

- Tag: `[plugin:RemoteAction action="move" docid="com.ibm.workplace.wcm.api.WCM_SiteArea/ID1" "moveDirection="-1" pid="com.ibm.workplace.wcm.api.WCM_SiteArea/ID1"]`
- URL: `http://<host>/wps/myportal/wcmAuthoring?wcmAuthoringAction=move&docid=com.ibm.workplace.wcm.api.WCM_SiteArea/ID1&moveDirection=-1&pid=com.ibm.workplace.wcm.api.WCM_SiteArea/ID1`

### Creating items

To create a content item with the title `newcontent`:

- Tag: `[plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_Content" wcmfield.content.title="newcontent"]`
- URL: `http://<host>/wps/myportal/wcmAuthoring?wcmAuthoringAction=new&type=com.ibm.workplace.wcm.api.WCM_Content&wcmfield.content.title=newcontent`

To create a content item, set the name, and use autosave to save the content (no dialog opens):

!!!note
    The authoring template that the content item uses must have a workflow preselected.

- Tag: `[plugin:RemoteAction action="new" type="com.ibm.workplace.wcm.api.WCM_Content" atid="com.ibm.workplace.wcm.api.WCM_AuthoringTemplate/ID1" pid="com.ibm.workplace.wcm.api.WCM_SiteArea/ID2" wcmfield.content.name="newcontent" wcmfield.autosave="true" wcmfield.saveValidate="true"]`
- URL: `http://<host>/wps/myportal/wcmAuthoring?wcmAuthoringAction=new&type=com.ibm.workplace.wcm.api.WCM_Content&atid=com.ibm.workplace.wcm.api.WCM_AuthoringTemplate/ID1&pid=com.ibm.workplace.wcm.api.WCM_SiteArea/ID2&wcmfield.content.name=newcontent&wcmfield.autosave=true&wcmfield.saveValidate=true`

### Editing items

To open a content item in edit mode and change the keywords automatically:

- Tag: `[plugin:RemoteAction action="edit" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1" wcmfield.content.keywords="keyword1" wcmfield.content.keywords="keyword2"]`
- URL: `http://<host>/wps/myportal/wcmAuthoring?wcmAuthoringAction=edit&docid=com.ibm.workplace.wcm.api.WCM_Content/ID1&wcmfield.content.keywords=keyword1&wcmfield.content.keywords=keyword2`

To edit a content item, change the keywords, and use autosave to save the content (no dialog opens):

- Tag: `[plugin:RemoteAction action="edit" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1" wcmfield.content.keywords="keyword1" wcmfield.content.keywords="keyword2" wcmfield.autosave="true"]`
- URL: `http://<host>/wps/myportal/wcmAuthoring?wcmAuthoringAction=edit&docid=com.ibm.workplace.wcm.api.WCM_Content/ID1&wcmfield.content.keywords=keyword1&wcmfield.content.keywords=keyword2&wcmfield.autosave=true`

To edit a content item, save it automatically, and suppress validation messages:

- Tag: `[plugin:RemoteAction action="edit" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1" wcmfield.content.keywords="keyword1" wcmfield.autosave="true" wcmfield.saveValidate="false"]`
- URL: `http://<host>/wps/myportal/wcmAuthoring?wcmAuthoringAction=edit&docid=com.ibm.workplace.wcm.api.WCM_Content/ID1&wcmfield.content.keywords=keyword1&wcmfield.autosave=true&wcmfield.saveValidate=false`

To edit a content item, create a draft, and set the history log comment:

- Tag: `[plugin:RemoteAction action="edit" docid="com.ibm.workplace.wcm.api.WCM_Content/ID1" createDraft="true" comment="comment"]`
- URL: `http://<host>/wps/myportal/wcmAuthoring?wcmAuthoringAction=edit&docid=com.ibm.workplace.wcm.api.WCM_Content/ID1&createDraft=true&comment=comment`
