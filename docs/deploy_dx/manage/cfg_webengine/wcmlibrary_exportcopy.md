# Exporting and importing a web content library copy

You can export the contents of a web content library to disk by creating a copy of the web content library. By working with an exported copy, you can import the copied library into the same web content server multiple times, resulting in a new library after each import without affecting previous copies. This is a quick way of creating new libraries that are fully populated with web content that you can easily adapt for other purposes.

## Overview

The copy export and import are implemented as URL-based data module operations. You must log in first to HCL DX or WCM in the same browser before running the command.

A file transfer utility endpoint can be used for uploading and downloading the WCM library files in dynamic subdirectories on the server under a specified root directory. Example usage of dxFileTransfer can be found in the export and import sections below.

Although many aspects are the same for the standard export and import and the copy export and import, there are some important differences:

- When you export a library as a copy, new IDs are generated for all items in the library. This ensures that there are no conflicts with existing libraries or items when you import the copy into a web content server that already contains the original library. In this way, you can run multiple imports to the same web content server, resulting in a new library for each import.

## Export copy

Follow these steps to export a copy of a web content library:

1. Use the dxFileTransfer endpoint to create a subdirectory on the server that will contain the exported WCM library zip file

!!! note
    The dxFileTransfer endpoint uses a base root transfer directory location:
      `/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/`

### Example usage

- curl format:
  - `curl -u <admin>:<password> -X POST "https://<hostname:port>/wps/dxFileTransfer/dft?action=createDir&subDirectory=<subdirectory-under-the-root-xfer-dir>`

- Create export subdirectory on server
  - `curl -u myAdmin:myPassword -X POST "https://myserver.hcl.com:443/wps/dxFileTransfer/dft?action=createDir&subDirectory=wcm_library_export"`

2. Create an export URL request to the WCM data module with the following parameters:

### Required parameters

- **taskType**: The data module task selector for copy export.
  - Value: `export-copy`

- **output.file**: The file system path where the exported library copy will be stored as a ZIP file. Must end with `.zip` extension. The parent directory must be writable.
  - Example: `/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_export/webcontent.zip`

- **exportLibrary**: The name of the web content library to export. To export multiple libraries in a single operation, separate each library name with a semi-colon (`;`). 
  - Example: `Web Content` or `Web Content;Samples`

### Example usage

Use the full WCM data module URL format when invoking copy export:

- URL format:
  - `https://<hostname>/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=export-copy&exportLibrary=<library-name-or-list>&output.file=<zip-file-path>`

- Single library:
  - `https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=export-copy&exportLibrary=testLibrary&output.file=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_export/testLibrary-copy.zip`

- Multiple libraries:
  - `https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=export-copy&exportLibrary=Web%20Content;Samples&output.file=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_export/libraries-copy.zip`

!!! note
    Use `taskType=export-copy` with `output.file` for copy export. The standard export operation uses `taskType=export` and `output.dir`.

!!! note
    All library names specified in the `exportLibrary` parameter must exist in the web content manager. Missing or invalid library names will cause the export operation to fail with an error.

3. Use the dxFileTransfer endpoint to download the WCM library zip file from the server

### Example usage

- curl format:
  - `curl -u <admin>:<password> -X POST -F "file=@/<zip-file-path>" "https://<hostname:port>/wps/dxFileTransfer/dft?action=upload&unzip=false&deleteZip=false&subDirectory=wcm_library_import&file=<zip-file-path>`

- Download WCM library zip file from export subdirectory on server
  - `curl -u myAdmin:myPassword -X POST "https://myserver.hcl.com:443/wps/dxFileTransfer/dft?action=download&subDirectory=wcm_library_export&file=testLibrary-copy.zip"`


## Import copy

Follow these steps to import a copy of a web content library:

1. Use the dxFileTransfer endpoint to upload a WCM library zip file to the server

!!! note
    The dxFileTransfer endpoint uses a base root transfer directory location:
      `/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/`

### Example usage

- curl format:
  - `curl -u <admin>:<password> -X POST -F "file=@/<zip-file-path>" "https://<hostname:port>/wps/dxFileTransfer/dft?action=upload&unzip=false&deleteZip=false&subDirectory=<subdirectory-under-the-root-xfer-dir>&file=<zip-file-path>`

2. Create an import URL request to the WCM data module with the following parameters:

### Required parameters

- **taskType**: The data module task selector for copy import.
  - Value: `import-copy`

- **input.file** or **input.dir**: The source of the library copy to import.
  - **input.file**: The file system path to a ZIP file containing the exported library copy. Must end with `.zip` extension and must be readable.
    - Example: `/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/webcontent.zip`
    - To import multiple ZIP files in a single operation, separate each file path with a semi-colon (`;`).
  
  - **input.dir**: The file system path to a directory containing the extracted library copy contents. A single directory path is supported (no semi-colon separation).
    - Example: `/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/library_extract`

  !!! warning "Mutually exclusive"
      Specify exactly one of `input.file` or `input.dir`, but not both.

### Optional parameters

- **importLibrary**: The name(s) to assign to the imported library copy. If you are importing multiple libraries, separate each name with a semi-colon (`;`). If not specified, the original library names from the source are preserved.
  - Example: `Web Content Copy` or `Web Content Copy;Samples Copy`

- **library.exportName**: The original exported library names used during the export process. This parameter enables the import process to correctly map the new library names specified in `importLibrary` to the correct imported libraries, particularly when importing multiple libraries at one time.
  - This property is automatically derived when possible, but providing explicit values improves deterministic matching, especially when the count of `library.exportName` values does not match the count of `importLibrary` values.
  - Example: `Web Content;Samples`
  
  !!! note "Mapping behavior"
      When `library.exportName` is provided:
      - The import process attempts to match each value in `importLibrary` to the corresponding library in the export using the `library.exportName` mapping
      - For each mapping position, if the exported name cannot be found, the import falls back to sequential order
      
      When `library.exportName` is omitted or partial:
      - Libraries are mapped to import names by their return order from the import operation

### Example usage

Use the full WCM data module URL format when invoking copy import:

- URL format:
  - `https://<hostname>/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import-copy&input.file=<zip-file-path>&importLibrary=<optional-library-name-or-list>&library.exportName=<optional-exported-name-list>`

#### Single library from ZIP file

- Import without renaming (preserve original name):
  - `https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import-copy&input.file=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/testLibrary-copy.zip`

- Import with renaming:
  - `https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import-copy&input.file=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/testLibrary-copy.zip&importLibrary=Web%20Content%20Copy`

#### Multiple libraries from ZIP file with name mapping

- Import multiple libraries with renaming and export name specification:
  - `https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import-copy&input.file=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/libraries-copy.zip&importLibrary=Web%20Content%20Copy;Samples%20Copy&library.exportName=Web%20Content;Samples`

#### Import from extracted directory

- Import from directory without renaming:
  - `https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import-copy&input.dir=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/library_extract`

- Import from directory with renaming (directory import supports single library renaming):
  - `https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import-copy&input.dir=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/library_extract&importLibrary=Web%20Content%20Copy`

!!! note
    Use `taskType=import-copy` with either `input.file` or `input.dir` for copy import.

## Features and limitations

### Supported features

- **ZIP-based export/import**: Export and import library copies to/from compressed ZIP archives
- **Multi-library operations**: Export and import multiple libraries in a single operation using semi-colon separation
- **Library name mapping**: Rename imported libraries using the `importLibrary` parameter
- **Export name tracking**: Use `library.exportName` to ensure correct mapping when importing multiple libraries
- **Directory extraction support**: Import library copies from extracted directory structures via `input.dir`
- **Temporary file management**: All temporary files are automatically cleaned up on success or failure

### Current limitations

- **Directory import**: When using `input.dir`, the import operation supports renaming only the first library. For multi-library rename support, use `input.file` (ZIP) with `importLibrary` and `library.exportName` parameters.
- **Library title/description**: The current implementation does not support customization of library title or description during import; the original titles and descriptions are preserved on import.
- **Text provider configuration**: The current implementation does not support custom text provider configuration during import.
- **Locale specification**: The current implementation does not support explicit locale specification during import; the system default is used.

## Error handling

The export and import operations perform validation before execution:

- **Export validation**: All library names in `exportLibrary` are verified to exist before the export begins. If any library is not found, the operation fails immediately.
- **Import validation**: 
  - The source path (`input.file` or `input.dir`) must be readable
  - If `input.file` is specified, the file must be a valid ZIP archive
  - Empty tokens in parameter lists (e.g., `Web Content;;Samples`) are not allowed and will cause an error
