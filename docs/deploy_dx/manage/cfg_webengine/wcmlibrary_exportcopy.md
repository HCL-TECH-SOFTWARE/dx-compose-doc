# Exporting and importing a web content library copy

Export a web content library to disk by creating a copy of the library. You can then import the copy into the same server multiple times. Each import creates a new library without affecting existing copies. This approach provides a quick way to create fully populated libraries that you can adapt for other purposes.

## Overview

The system implements copy export and import operations as URL-based data module operations. Before you run these operations, sign in to HCL Digital Experience (DX) or Web Content Manager (WCM) in the same browser session. Use a file transfer utility endpoint to upload and download WCM library files in dynamic subdirectories under a specified root directory on the server.

### Differences between standard and copy import and export

Although copy export and import share many aspects with standard export and import, there are some key differences:

- **Standard import and export:** Preserves the original item IDs. Importing a library onto a server where it already exists updates or overwrites the existing items instead of creating a new library.

- **Copy import and export:** Generates new IDs for all library items during export. This prevents conflicts with existing items, letting you import the same copy multiple times to create independent library clones on the same server.

## Exporting a library copy

Follow these steps to export a copy of a web content library:

1. Use the `dxFileTransfer` endpoint to create a subdirectory on the server to store the exported WCM library `.zip` file. The `dxFileTransfer` endpoint uses `/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/` as the base root transfer directory.

    - **Syntax:**

        ```bash

        curl -u <admin>:<password> -X POST "https://<hostname:port>/<context-root>/dxFileTransfer/dft?action=createDir&subDirectory=<subdirectory-under-the-root-xfer-dir>"
        ```

    - **Example:**

        ```bash
        curl -u myAdmin:myPassword -X POST "https://myserver.hcl.com:443/wps/dxFileTransfer/dft?action=createDir&subDirectory=wcm_library_export"
        ```

2. Create an export URL request to the WCM data module with the following required parameters:

    - `taskType`: The data module task selector for copy export. The value must be `export-copy`.
    - `output.file`: The file system path where the exported library copy is stored as a ZIP file. The path must end with a `.zip` extension, and the parent directory must be writable (for example, `/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_export/webcontent.zip`).
    - `exportLibrary`: The name of the web content library to export. To export multiple libraries in a single operation, separate each library name with a semicolon (for example, `Web Content` or `Web Content;Samples`).

        - **Syntax:**

            ```http
            https://<hostname>/<context-root>/wcm/myconnect?MOD=data&processLibraries=false&taskType=export-copy&exportLibrary=<library-name-or-list>&output.file=<zip-file-path>
            ```

        - **Single library:**

            ```http
            https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=export-copy&exportLibrary=testLibrary&output.file=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_export/testLibrary-copy.zip
            ```

        - **Multiple libraries:**

            ```http
            https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=export-copy&exportLibrary=Web%20Content;Samples&output.file=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_export/libraries-copy.zip
            ```

        !!! note
            - Use `taskType=export-copy` with `output.file` for copy export. The standard export operation uses `taskType=export` and `output.dir`.
            - All library names specified in the `exportLibrary` parameter must exist in WCM. Missing or invalid library names will cause the export operation to fail.

3. Use the `dxFileTransfer` endpoint to download WCM library ZIP file from the server.

    - **Syntax:**

        ```bash
        curl -u <admin>:<password> -o <zip-file-path> "https://<hostname:port>/<context-root>/dxFileTransfer/dft?action=download&subDirectory=<subdirectory-under-the-root-xfer-dir>&file=<zip-file-name>"
        ```

    - **Example:**

        ```bash
        curl -u myAdmin:myPassword -o ./testLibrary-copy.zip  "https://myserver.hcl.com:443/wps/dxFileTransfer/dft?action=download&subDirectory=wcm_library_export&file=testLibrary-copy.zip"
        ```

## Importing a library copy

Follow these steps to import a copy of a web content library:

1. Use the `dxFileTransfer` endpoint to upload a WCM library ZIP file to the server. The `dxFileTransfer` endpoint uses `/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/` as the base root transfer directory.

    **Syntax:**

    ```bash
    curl -u <admin>:<password> -X POST -F "file=@/<zip-file-path>" "https://<hostname:port>/<context-root>/dxFileTransfer/dft?action=upload&unzip=false&deleteZip=false&subDirectory=<subdirectory-under-the-root-xfer-dir>&file=<zip-file-path>"
    ```

2. Create an import URL request to WCM data module with the following parameters:

    **Required parameters**

    - `taskType`: The data module task selector for copy import. The value must be `import-copy`.
    - `input.file` or `input.dir`: The source of the library copy to import.
        - `input.file`: The file system path to a ZIP file containing the exported library copy. The path must end with a ZIP extension and must be readable (for example, `/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/webcontent.zip`). To import multiple ZIP files in a single operation, separate each file path with a semicolon
        - `input.dir`: The file system path to a directory that contains the extracted library copy contents (for example, `/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/library_extract`). Only a single directory path is supported. Semicolon-separated values are not allowed.

        !!! warning "Mutually exclusive"
            Specify either `input.file` or `input.dir`. Do not include both parameters in the same request.

    **Optional parameters**

    - `importLibrary`: The names to assign to the imported library copy. If you are importing multiple libraries, separate each name with a semicolon (for example, `Web Content Copy` or `Web Content Copy;Samples Copy`). If you do not specify this parameter, the system preserves the original library names from the source.
    - `library.exportName`: The original exported library names used during the export process. This parameter ensures that new library names specified in `importLibrary` are correctly mapped to the imported libraries, especially when importing multiple libraries. Separate each name with a semicolon (for example, `Web Content;Samples`). This value is automatically derived when possible. However, providing explicit values improves deterministic matching, particularly when the number of `library.exportName` values does not match the number of `importLibrary` values.
        - When `library.exportName` is specified, the import process attempts to match each value in `importLibrary` to the corresponding library in the export using the `library.exportName` mapping. For each mapping position, if the system cannot find the exported name, the import falls back to sequential order.
        - When `library.exportName` is omitted or partially specified, libraries are mapped to import names by their return order from the import operation.

    **Sample import URL requests**

    !!! note
        Use `taskType=import-copy` with either `input.file` or `input.dir` for copy import.

    - **Syntax:**

        ```http
        https://<hostname>/<context-root>/wcm/myconnect?MOD=data&processLibraries=false&taskType=import-copy&input.file=<zip-file-path>&importLibrary=<optional-library-name-or-list>&library.exportName=<optional-exported-name-list>
        ```

    - **Single library from ZIP file without renaming (preserve original name):**

        ```http
        https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import-copy&input.file=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/testLibrary-copy.zip
        ```

    - **Single library from ZIP file with renaming:**

        ```http
        https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import-copy&input.file=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/testLibrary-copy.zip&importLibrary=Web%20Content%20Copy
        ```

    - **Multiple libraries from ZIP file with name mapping:**

        ```http
        https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import-copy&input.file=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/libraries-copy.zip&importLibrary=Web%20Content%20Copy;Samples%20Copy&library.exportName=Web%20Content;Samples
        ```

    - **Import from extracted directory without renaming:**

        ```http
        https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import-copy&input.dir=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/library_extract
        ```

    - **Import from extracted directory with renaming (directory import supports single-library renaming):**

        ```http
        https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import-copy&input.dir=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/library_extract&importLibrary=Web%20Content%20Copy
        ```

## Features

- Export and import library copies using compressed ZIP archives.
- Process multiple libraries in a single operation using semicolon-separated values.
- Rename imported libraries using the `importLibrary` parameter.
- Use `library.exportName` to ensure correct mapping when importing multiple libraries.
- Import library copies from extracted directory structures using `input.dir`.
- Automatically clean up all temporary files after the operation finishes.

## Limitations

- When using `input.dir`, the import operation supports renaming only the first library. For multi-library rename support, use `input.file` with the `importLibrary` and `library.exportName` parameters.
- Custom titles and descriptions are not supported during import. Original values are preserved.
- Custom text provider configurations are not supported during import.
- Explicit locales are not supported during import. The system uses the default locale.

## Validation checks

The system verifies the following requirements before running an operation:

- **Export validation**: All library names listed in `exportLibrary` must exist, or the operation fails.
- **Import validation**:
    - The source path (`input.file` or `input.dir`) must be readable.
    - If `input.file` is specified, the file must be a valid ZIP archive.
    - Empty tokens in parameter lists (for example, `Web Content;;Samples`) are not allowed and will cause an error.
