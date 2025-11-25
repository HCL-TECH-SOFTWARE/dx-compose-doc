---
id: customize_webengine_image
title: Customizing the HCL DX Compose WebEngine image with custom scripts
---

This topic provides the steps to build a customized HCL Digital Experience (DX) Compose WebEngine image with custom scripts for use in HCL DX Compose deployments.

## Adding custom script plugins

Starting with CF230, you can extend WebEngine functionality by adding custom shell scripts to designated plugin directories in the container. These scripts can run during container startup or during Cumulative Fix (CF) updates.

### Custom script directories

The WebEngine container includes the following directories for customer-provided scripts:

- `/opt/openliberty/wlp/usr/svrcfg/bin/customer/startup`: Scripts in this directory run during container startup.
- `/opt/openliberty/wlp/usr/svrcfg/bin/customer/update`: Scripts in this directory run during CF updates (for example, when updating from CF229 to CF230).

!!! important
    Only scripts placed directly in these two directories will be automatically scanned and executed. You can place helper scripts in any subdirectory and call them from your startup or update scripts, but they won't be executed automatically. Sample subdirectories include the following:

    - `/opt/openliberty/wlp/usr/svrcfg/bin/customer/startup/helpers/`
    - `/opt/openliberty/wlp/usr/svrcfg/bin/customer/update/helpers/`
    - `/opt/openliberty/wlp/usr/svrcfg/bin/customer/helpers/`

### Adding custom scripts to your image

To add custom scripts to your image, create a Dockerfile that builds upon an official HCL DX Compose WebEngine image. Include your custom scripts in the appropriate directories:

    <pre>
        ```
        # Dockerfile contents:

        FROM oci://hclcr.io/dx-compose/hcl-dx-deployment/webengine:CF230_20250724-1642_34573

        # Copy custom startup scripts to be automatically executed
        COPY --chown=dx_user:dx_users ./startup-script1.sh /opt/openliberty/wlp/usr/svrcfg/bin/customer/startup/
        COPY --chown=dx_user:dx_users ./startup-script2.sh /opt/openliberty/wlp/usr/svrcfg/bin/customer/startup/

        # Copy custom update scripts to be automatically executed
        COPY --chown=dx_user:dx_users ./update-script.sh /opt/openliberty/wlp/usr/svrcfg/bin/customer/update/

        # Helper scripts can be placed in any subdirectory - these won't be auto-executed
        COPY --chown=dx_user:dx_users ./helpers/ /opt/openliberty/wlp/usr/svrcfg/bin/customer/helpers/
        # Or in subdirectories under startup/update
        COPY --chown=dx_user:dx_users ./startup-helpers/ /opt/openliberty/wlp/usr/svrcfg/bin/customer/startup/helpers/     

        # Make all scripts executable
        RUN chmod -R +x /opt/openliberty/wlp/usr/svrcfg/bin/customer/
        ```
    </pre>

### Script execution behavior

When adding custom scripts to your customized version of the WebEngine image, it's important to understand how and when they execute:

#### Execution order and flow

- Startup scripts in the `/opt/openliberty/wlp/usr/svrcfg/bin/customer/startup` directory run during container startup, after all core WebEngine configuration tasks are completed and just before the WebEngine server starts.
- Update scripts in the `/opt/openliberty/wlp/usr/svrcfg/bin/customer/update` directory run during CF updates, after product update tasks are completed.
- The container executes scripts in lexicographical order by filename. If you need a specific execution order, consider adding zero-padded numeric prefixes to filenames (for example, `01-first.sh`, `02-second.sh`, `10-third.sh`) to ensure correct sorting.
- Each script is executed separately. The system will continue executing subsequent scripts even if a previous script fails. There is no built-in dependency management between scripts.

#### Script capabilities and limitations

- Scripts can start and stop the Liberty server using the available functions in utility scripts, but you should perform this with caution. The WebEngine container manages the server lifecycle, and custom scripts that interfere with this management may cause unexpected behavior.
- Scripts primarily modify configuration files, update database entries, and perform other configuration tasks.
- Scripts must implement their own error handling and logging. If a script encounters an error, subsequent scripts will still be executed. The container does not provide additional error handling around custom scripts.
- If your scripts have dependencies (for example, database access), ensure they include appropriate validation and error handling. Failure of one script will not prevent other scripts from running.
- Design scripts to complete in a reasonable timeframe and use system resources efficiently. Avoid long-running operations in startup scripts.

#### Intended use cases

Custom scripts are primarily intended for:

- Applying configuration changes specific to your environment
- Setting up connections to external systems
- Implementing custom validation or monitoring logic
- Extending WebEngine with configuration that can't be accomplished through standard configuration mechanisms

Custom scripts are not intended for:

- Installing third-party servers or services within the container
- Performing heavy workloads that would significantly delay container startup
- Replacing core WebEngine functionality
- Running persistent background processes

!!! note
    While the custom script support provides flexibility to perform a wide range of actions, it is recommended to use this feature primarily for lightweight, configuration-related tasks. Using scripts beyond the intended scope may impact startup time, container stability, or product supportability.

### Script guidelines and restrictions

When creating custom scripts, follow these guidelines:

- Ensure scripts are executable. In your Dockerfile, run a `chmod +x` command against any copied script files.
- Place scripts directly in the designated directories. Only scripts in the designated directories are executed by the container.
- Ensure script filenames end with `.sh` and do not begin with a dot (hidden files are ignored).
- Consider adding zero-padded numeric prefixes to filenames. Scripts are processed in lexicographical order.
- For shared logic, use the documented `safe_source` function to include utility scripts:

    ```bash
    # In your custom script
    source /opt/openliberty/wlp/usr/svrcfg/scripts/utility.sh
    safe_source "/opt/openliberty/wlp/usr/svrcfg/bin/common-utility/another_utility.sh"
    ```

- Do not modify or directly reference any scripts in the product feature directories.
- For WebEngine utilities, only use documented utility functions from the `common-utility` directory. These are described in the `README.md` file in that directory and in the individual script files.
- Create and use your own helper functions in any subdirectories of the `customer` directory.
- Include appropriate error handling in your scripts, especially if they have external dependencies.
- Use the `abort_container` function to stop container startup if your script detects a critical failure that requires immediate attention.

### Using abort_container for critical failures

Starting with CF232, custom scripts can use the `abort_container` function to immediately stop container startup when a critical failure is detected. This is useful when your script identifies a condition that makes it unsafe or impossible to continue, such as missing required configuration, unavailable external dependencies, or failed validation checks.

#### When to use abort_container

Use `abort_container` in situations where:

- Required configuration files or environment variables are missing
- Essential external services (databases, APIs) are unreachable
- Critical validation checks fail
- Required resources or permissions are not available
- Data integrity issues are detected that would prevent normal operation

#### Syntax

```bash
abort_container "Your error message describing the critical failure"
```

When `abort_container` is called:

1. The error message is logged with a `CRITICAL ERROR` prefix
2. A marker file is created to signal the failure to the container orchestration
3. The script exits immediately with a non-zero status code
4. The container startup process is halted

#### Example usage

```bash
#!/bin/bash
source /opt/openliberty/wlp/usr/svrcfg/scripts/utility.sh

log_message_customer "Validating required configuration"

# Check for required environment variable
if [ -z "$REQUIRED_API_KEY" ]; then
    abort_container "REQUIRED_API_KEY environment variable is not set. Cannot proceed with startup."
fi

# Check external service availability
if ! curl -s -f "http://external-service/health" > /dev/null; then
    abort_container "External service at http://external-service is not accessible. Cannot proceed with startup."
fi

# Check database connectivity
if ! /opt/openliberty/wlp/usr/svrcfg/scripts/db/test_connection.sh; then
    abort_container "Database connection test failed. Verify database configuration and network connectivity."
fi

log_message_customer "All validation checks passed"
```

!!! warning
    Use `abort_container` only for truly critical failures. For non-critical issues, log a warning and allow the container to start. Overuse of `abort_container` may prevent legitimate startups and complicate troubleshooting.

## Enabling the customized WebEngine image in DX Compose

Follow these steps to deploy your customized WebEngine image in your HCL DX Compose deployment:

1. Upload your customized WebEngine image to the repository used for your HCL DX Compose deployment using the following command:

    ```sh
    docker push <my_custom_repository>/webengine:<my_custom_tag>
    ```

    For more information see [Load images to your own repository](../../install/kubernetes_deployment/preparation/get_the_code/prepare_load_images.md#loading-images).

2. Fetch the current configuration values from the running Helm release to ensure you preserve existing settings while adding the new image tag value and configuration. Run the following command:

    ```sh
    helm get values dx-deployment -n dxns -o yaml -a > custom-values-all.yaml
    ```

    Replace `dx-deployment` with your Helm release name and `dxns` with your namespace if they differ. This command saves the current values to a file named `custom-values-all.yaml`.

3. In the `custom-values-all.yaml` file, modify the following section to upgrade your image:

    ```yaml
    images:
      tags:
        webEngine: my_custom_tag
    ```

4. Use the following `helm upgrade` command to apply the updated configuration. Include both the base values file and the modified `custom-values-all.yaml` file.

    ```sh
    helm -n dxns upgrade dx-deployment ./install-hcl-dx-deployment/ -f install-deploy-values.yaml -f custom-values-all.yaml
    ```

    - Replace `dxns` with your namespace, and adjust the paths to `install-hcl-dx-deployment` and the values files (`install-deploy-values.yaml` and `custom-values-all.yaml`) according to your environment.
    - The `-f` flags specify the base configuration (`install-deploy-values.yaml`) and the updated configuration (`custom-values-all.yaml`).

    For more information, see [Upgrading the Helm deployment](../working_with_compose/helm_upgrade_values.md).

Once the upgrade is successfully applied, your custom startup scripts will execute in DX Compose.

???+ info "Related information"
    - [Managing the Liberty Status table in custom scripts](custom_liberty_status.md)
