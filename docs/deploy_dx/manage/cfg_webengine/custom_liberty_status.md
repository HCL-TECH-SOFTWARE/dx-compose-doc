---
id: custom_liberty_status
title: CLiberty Status Table Management in custom script
---

The `custom_liberty_status.sh` script provides a simple interface for managing customer-specific key‑value pairs in the `LIBERTY_STATUS` table in the release schema. Customers can include and call this script from their custom startup or update scripts.

Usage:

```bash
/opt/openliberty/wlp/usr/svrcfg/bin/customer/custom_liberty_status.sh <operation> [key] [value]
```

Operations:

- `create` - Create a new key-value pair
- `read` - Read all values or a specific key
- `update` - Update a key with a new value
- `delete` - Delete a specific key

Examples:

```bash
# Create a new key-value pair
./custom_liberty_status.sh create MyKey MyValue

# Read a specific key
./custom_liberty_status.sh read MyKey

# Read all customer keys
./custom_liberty_status.sh read

# Update an existing key
./custom_liberty_status.sh update MyKey NewValue

# Delete a key
./custom_liberty_status.sh delete MyKey
```

All custom keys are automatically prefixed with `cust_` to prevent access to system values.

Place the script in your customer plugin directory (for example, `/opt/openliberty/wlp/usr/svrcfg/bin/customer/`) and make sure it is executable. When calling this from custom startup scripts, use the documented `safe_source` pattern and follow the script guidelines described in `customize_webengine_image.md`.

**Note:** For step-by-step instructions on adding these scripts to a custom WebEngine image, see the guide: [Customizing the HCL DX Compose WebEngine image with custom scripts](./customize_webengine_image.md). This explains how to copy your startup/update scripts into the image and make them executable so they run automatically at container startup or during CF updates.
