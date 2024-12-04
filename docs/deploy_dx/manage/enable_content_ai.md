---
id: enable-content-ai
title: Enable/Disable WCM Content AI Analysis
---

## Introduction
This document outlines configurations to enable/disable  AI analysis for Web Content Management (WCM) content in HCL Digital Experience (DX) in a Kubernetes deployment using the `values.yaml` file. You can also configure a content AI provider to be used for AI analysis.

### Content Composer Configuration in the values.yaml
Below is an example snippet for configuring the DX WebEngine server to enable Content AI. 

```yaml
configuration:
  #Configuration for webEngine
  webEngine:
    contentAI:
      className: com.ai.sample.CustomerAI
      enabled: true
      provider: OPEN_AI
security:
  # Security configuration for webEngine
  webEngine:
      webEngineContentAIProviderAPIKey: ""
      customWebEngineContentAISecret: custom-credentials-webengine-ai-secret
```

Below is an example snippet for configuring the DX WebEngine server to disable Content AI.

```yaml
configuration:
  #Configuration for webEngine
  webEngine:
    contentAI:
      enabled: true
      provider: ""
```

### Content AI Configuration Parameters Explanation

In the above configuration, the following parameters are used:

- **className**: Provide the custom AI class name. Default is "com.hcl.workplace.wcm.restv2.ai.ChatGPTAnalyzerService" if AI analysis is enabled with provider `OPEN_AI`.
- **enabled**: Configure if content AI is enabled/disabled, true for enable and false for disable. Default is false.
- **provider**: Provide content AI provider if content AI is enabled. Valid values are OPEN_AI and CUSTOM.
- **webEngineContentAIProviderAPIKey**: API key for AI Provider. AI provider provides API key to access its API.
- **customWebEngineContentAISecret**: Provide a secret name that will be used to set AI API Key.

```sh
kubectl create secret generic WEBENGINE_AI_CUSTOM_SECRET --from-literal=apiKey=API_KEY --namespace=NAME_SERVER
```
**Note:** Replace `API_KEY` and `NAME_SERVER` with the actual values.

Example:
```sh
kubectl create secret generic custom-credentials-webengine-ai-secret --from-literal=apiKey=your-API-Key --namespace=dxns
```
**Note:** If a custom secret is used instead of an API key directly in the `values.yaml` file, then the custom secret must be created by using the content AI provider's API key. You must then refer to the secret name in the `customWebEngineContentAISecret` property and leave the `webEngineContentAIProviderAPIKey` blank and vice versa.

### Validation

After updating the values.yaml file, if running the server for the first time refer the document for [installation](../install/install.md). If upgrading previous configurations refer the document for [upgrading](./helm_upgrade_values.md).

After enabling the Content AI analysis in DX deployment, use the [WCM REST V2 AI Analysis API](https://opensource.hcltechsw.com/digital-experience/latest/manage_content/wcm_development/wcm_rest_v2_ai_analysis/) to call the AI Analyzer APIs of the configured Content AI Provider.