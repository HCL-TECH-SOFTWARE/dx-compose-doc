# Exporting and importing a web content library copy

Export a web content library to disk by creating a copy of the library. You can then import the copy into the same server multiple times. Each import creates a new library without affecting existing copies. This approach provides a quick way to create fully populated libraries that you can adapt for other purposes.

## Overview

Copy export and import are implemented as URL-based data module operations. Before you run these operations, sign in to HCL Digital Experience (DX) or Web Content Manager (WCM) in the same browser session. Use a file transfer utility endpoint to upload and download WCM library files in dynamic subdirectories under a specified root directory on the server. For examples of using `dxFileTransfer`, see the export and import sections. Although copy export and import share many aspects with standard export and import, there are some key differences:

When you export a library as a copy, the system generates new IDs for all items in the library. This prevents conflicts with existing libraries or items when you import the copy into a server that already contains the original library. As a result, you can import the same copy multiple times, creating a new library with each import.

## Export copy

Follow these steps to export a copy of a web content library:

### Create a server subdirectory for the exported WCM library .zip file

Use the `dxFileTransfer` endpoint to create a subdirectory on the server to store the exported WCM library `.zip` file.

   The `dxFileTransfer` endpoint uses the following root transfer directory: `/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/`

   **Example usage**

**curl format**

```bash
curl -u <admin>:<password> -X POST "https://<hostname:port>/wps/dxFileTransfer/dft?action=createDir&subDirectory=<subdirectory-under-the-root-xfer-dir>"
```

 Create export subdirectory on server:  
     ```bash
     curl -u myAdmin:myPassword -X POST "https://myserver.hcl.com:443/wps/dxFileTransfer/dft?action=createDir&subDirectory=wcm_library_export"
     ```
### Create export URL request with required parameters

Create an export URL request to WCM data module with the following parameters:

**Required parameters**

- **taskType**: The data module task selector for copy export.  
  - Value: `export-copy`

- **output.file**: The file system path where the exported library copy is stored as a .zip file. The path must end with a `.zip` extension, and the parent directory must be writable.  
  - Example: `/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_export/webcontent.zip`

- **exportLibrary**: The name of the web content library to export. To export multiple libraries in a single operation, separate each library name with a semicolon (;).  
  - Example: `Web Content` or `Web Content;Samples`

### Example usage

Use the full WCM data module URL format when invoking copy export:

- URL format  
  ```text
  https://<hostname>/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=export-copy&exportLibrary=<library-name-or-list>&output.file=<zip-file-path>
  ```

- Single library  
```text
https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=export-copy&exportLibrary=testLibrary&output.file=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_export/testLibrary-copy.zip
```

- Multiple libraries

```text
https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=export-copy&exportLibrary=Web%20Content;Samples&output.file=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_export/libraries-copy.zip
```

!!! note
    - Use `taskType=export-copy` with `output.file` for copy export. The standard export operation uses `taskType=export` and `output.dir`.
	- All library names specified in the `exportLibrary` parameter must exist in WCM. Missing or invalid library names will cause the export operation to fail with an error.
    
### Download WCM library .zip file using dxFileTransfer

Use the `dxFileTransfer` endpoint to download WCM library `.zip` file from the server.

### Example usage
- curl format

```bash
curl -u <admin>:<password> -o <zip-file-path> "https://<hostname:port>/wps/dxFileTransfer/dft?action=download&subDirectory=<subdirectory-under-the-root-xfer-dir>&file=<zip-file-name>"
```

- Download WCM library `.zip` file from the export subdirectory on the server:  
  ```bash
  curl -u myAdmin:myPassword -o ./testLibrary-copy.zip  "https://myserver.hcl.com:443/wps/dxFileTransfer/dft?action=download&subDirectory=wcm_library_export&file=testLibrary-copy.zip"
  ```

## Import copy

Follow these steps to import a copy of a web content library:

1. Use the `dxFileTransfer` endpoint to upload a WCM library `.zip` file to the server.

	The `dxFileTransfer` endpoint uses the following base root transfer directory:  
	`/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/`

	**Example usage**

	-  curl format
 ```bash
 curl -u <admin>:<password> -X POST -F "file=@/<zip-file-path>" "https://<hostname:port>/wps/dxFileTransfer/dft?action=upload&unzip=false&deleteZip=false&subDirectory=<subdirectory-under-the-root-xfer-dir>&file=<zip-file-path>"
 ```

2. Create an import URL request to WCM data module with the following parameters:

	**Required parameters**

	- **taskType**: The data module task selector for copy import.
  	- Value: `import-copy`

	- **input.file** or **input.dir**: The source of the library copy to import.

	- **input.file**: The file system path to a `.zip` file containing the exported library copy. The path must end with a `.zip` extension and must be readable.  
    	Example: `/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/webcontent.zip`  
	 To import multiple `.zip` files in a single operation, separate each file path with a semicolon (;).
  
	- **input.dir**: The file system path to a directory that contains the extracted library copy contents. Only a single directory path is supported. Semicolon-separated values are not allowed.
    	Example: `/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/library_extract`

!!! warning "Mutually exclusive"
    Specify either `input.file` or `input.dir`, but not both.

### Optional parameters

- **importLibrary**: The name(s) to assign to the imported library copy. If you are importing multiple libraries, separate each name with a semicolon (;). If not specified, the original library names from the source are preserved.  
  - Example: `Web Content Copy` or `Web Content Copy;Samples Copy`.

- **library.exportName**: The original exported library names used during the export process. This parameter ensures that new library names specified in `importLibrary` are correctly mapped to the imported libraries, especially when importing multiple libraries.  
  - This value is automatically derived when possible. However, providing explicit values improves deterministic matching, particularly when the number of `library.exportName` values does not match the number of `importLibrary` values.  
  - Example: `Web Content;Samples`
  
**"Mapping behavior"**
When `library.exportName` is specified:

- The import process attempts to match each value in `importLibrary` to the corresponding library in the export using the `library.exportName` mapping
- For each mapping position, if the exported name cannot be found, the import falls back to sequential order
      
When `library.exportName` is omitted or partial:

- Libraries are mapped to import names by their return order from the import operation

### Example usage

Use the full WCM data module URL format when invoking copy import:

- URL format  
  ```text
  https://<hostname>/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import-copy&input.file=<zip-file-path>&importLibrary=<optional-library-name-or-list>&library.exportName=<optional-exported-name-list>
  ```

#### Single library from ZIP file

- Import without renaming (preserve original name)

```text
https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import-copy&input.file=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/testLibrary-copy.zip
```

- Import with renaming

```text
https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import-copy&input.file=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/testLibrary-copy.zip&importLibrary=Web%20Content%20Copy
```

#### Multiple libraries from ZIP file with name mapping

- Import multiple libraries with renaming and export name specification

```text
https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import-copy&input.file=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/libraries-copy.zip&importLibrary=Web%20Content%20Copy;Samples%20Copy&library.exportName=Web%20Content;Samples
```

#### Import from extracted directory

- Import from directory without renaming  
  ```text
  https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import-copy&input.dir=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/library_extract
  ```

- Import from directory with renaming (directory import supports single-library renaming)  
  ```text
  https://myserver.hcl.com/wps/wcm/myconnect?MOD=data&processLibraries=false&taskType=import-copy&input.dir=/opt/openliberty/wlp/usr/servers/defaultServer/dxFileTransfers/wcm_library_import/library_extract&importLibrary=Web%20Content%20Copy
  ```

!!! note
    Use `taskType=import-copy` with either `input.file` or `input.dir` for copy import.

## Features and limitations

### Supported features

- **ZIP-based export/import**: Export and import library copies to/from compressed ZIP archives
- **Multi-library operations**: Export and import multiple libraries in a single operation using     semicolon-separated values
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

- **Export validation**: All library names in `exportLibrary` are verified to exist before the export begins. If any library is not found, the operation fails .
- **Import validation**: 
  - The source path (`input.file` or `input.dir`) must be readable
  - If `input.file` is specified, the file must be a valid ZIP archive
  - Empty tokens in parameter lists (e.g., `Web Content;;Samples`) are not allowed and will cause an error
