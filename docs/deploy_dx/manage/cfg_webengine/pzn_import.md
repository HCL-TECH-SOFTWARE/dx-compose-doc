# Importing personalization rules programmatically

Personalization rules exported from an environment can be published directly to a target workspace using an HTTP request. This article describes how to import personalization rules using the `pznpublish` endpoint in HCL Digital Experience (DX).

## Importing personalization rules

To import personalization rules, perform the following steps:

1. Open a terminal or command-line interface.
2. Run the `curl` command to upload your personalization file to the `pznpublishtarget` endpoint:

    ```bash
    curl -u <admin-user>:<admin-password> -X POST --header "Content-Type: application/octet-stream;charset=UTF8" --data-binary "@/<path-to-file>" "https://<host>/<context-root>/pznpublish/pznpublishtarget?svCmd=publishImport&tWrk=<workspace>&oid=<username>&tgtPth=<target-path>"
    ```

    For example:

    ```bash
    curl -u user:password -X POST --header "Content-Type: application/octet-stream;charset=UTF8" --data-binary "@/path/to/file/import.nodes" "https://myserver.example.com/wps/pznpublish/pznpublishtarget?svCmd=publishImport&tWrk=ROOTWORKSPACE&oid=wpsadmin&tgtPth=/"
    ```

    - `svCmd`: The publish operation. Set this value to `publishImport`.
    - `tWrk`: The target workspace for the import. This value is typically set to `ROOTWORKSPACE`.
    - `oid`: The owner ID for the imported rules.
    - `tgtPth`: The destination path for the imported nodes. This value must start with a forward slash (`/`). Use a single slash (`/`) to import to the root folder.

    If the import is successful, the endpoint returns the following XML response:

    ```xml
    <response><task state="target_committed"/></response>
    ```

    This response indicates the `publishImport` task has finished executing and the target state has been successfully committed to your HCL DX environment.