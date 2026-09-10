# Core Editor Documentation for DX Compose Help Center

## Description

**What does this PR do?**

Adds Core Editor documentation to the DX Compose Help Center. Core Editor is a new Rich Text Editor (RTE) option available in both the WCM Authoring Portlet and Site Manager inplace editing. This PR introduces:

- CF238 What's New entry for Core Editor with a link to the full configuration page in DX Cloud Native docs
- CF238 Helm values updates entry (`incubator.configuration.coreEditor.enabled`, `.default`)

**Why is it needed?**

Core Editor is shipping in CF238 as a new RTE option. The What's New entry announces the feature and links to the DX Cloud Native docs for detailed configuration instructions.

**Any relevant context or background?**

- The What's New entry links to the DX Cloud Native docs for detailed configuration, supported features, and known limitations
- Core Editor Helm values are under the `incubator` namespace

## Checklist

- [x] I have updated relevant documentation in `docs/` or elsewhere as needed
- [x] I have checked that the documentation builds
- [x] I have checked spelling, grammar, capitalization, and other style rules
- [x] I have fixed any broken links in the pages that I have amended

## Additional Notes

**Files changed (2):**

| File | Action | Description |
|------|--------|-------------|
| `cf238.md` | Updated | Added Core Editor What's New entry with link to DX Cloud Native docs |
| `dx_helm_values_updates.md` | Updated | Added Core Editor Helm values to CF238 section |

**What's New entries:** I have added the Core Editor entries to the What's New page and Helm values updates page. Please feel free to refactor or reorganize them as needed to align with the final CF238 release content.

**Link to DX Cloud Native docs:** The What's New entry links to `https://pages.git.cwp.pnp-hcl.com/CWPdoc/dx-mkdocs/in-progress/manage_content/wcm_configuration/cfg_webcontent_auth_env/wcm_config_core_editor/` for the full Core Editor configuration page, following the existing pattern for cross-repo documentation links in this site.
