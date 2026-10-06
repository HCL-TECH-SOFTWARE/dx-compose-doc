# Importing personalization rules programmatically

If you have a file of rules exported from a DX Classic or DX Compose environment you can import it via an HTTP request to the provided `pznpublish` endpoint.

## Personalization file import endpoint usage

Use the `pznpublish/pznpublishtarget` endpoint to upload the file:

    - **Syntax:**

        ```bash
        curl -u <admin-user>:<admin-password> -X POST --header "Content-Type: application/octet-stream;charset=UTF8" --data-binary "@/<path-to-file>" "https://<host>/<context-root>/pznpublish/pznpublishtarget?svCmd=publishImport&tWrk=<workspace>&oid=<username>&tgtPth=<target-path>"
        ```

    - **Example:**

        ```bash
        curl -u user:password -X POST --header "Content-Type: application/octet-stream;charset=UTF8" --data-binary "@/path/to/file/import.nodes" "https://myserver.example.com/wps/pznpublish/pznpublishtarget?svCmd=publishImport&tWrk=ROOTWORKSPACE&oid=wpsadmin&tgtPth=/"
        ```

The following URL parameters are required:

    - `svCmd`: The publish operation. The value should always be `publishImport`.
    - `tWrk`: The workspace into which to import. The value will typically be `ROOTWORKSPACE`.
    - `oid`: The owner ID for the imported rules.
    - `tgtPth`: The target path into which to import the nodes from the file. It should always start with a forward slash ('/') and a slash on its own means a destination of the root folder.

The command returns an XML fragment which, on a succesful import, will be:

    `<response><task state="target_committed"/></response>`