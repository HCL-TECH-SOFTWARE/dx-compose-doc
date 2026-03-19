---
id: enable-content-ai
title: Enabling and disabling WCM content AI analysis
---

This document outlines configurations to enable and disable artificial intelligence (AI) analysis for Web Content Management (WCM) content in a Kubernetes deployment using the `values.yaml` file. You can also configure a content AI provider to be used for AI analysis.

## WCM Content AI configuration 

Refer to the following sample snippet for configuring the Digital Experience (DX) WebEngine server to enable Content AI analysis:

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

To disable Content AI Analysis, refer to the following sample configuration:

```yaml
configuration:
  #Configuration for webEngine
  webEngine:
    contentAI:
      enabled: true
      provider: ""
```

### Content AI configuration parameters 

In the provided configuration, the following parameters are used:

- `className`: Provide the custom AI class name. The default value is `com.hcl.workplace.wcm.restv2.ai.ChatGPTAnalyzerService` if the AI analysis is enabled with provider `OPEN_AI`.
- `enabled`: Set to `true` to enable content AI or to `false` to disable. By default, this parameter is set to `false`.
- `provider`: If content AI is enabled, provide the content AI provider in this parameter. Valid values are `OPEN_AI` and `CUSTOM`.
- `webEngineContentAIProviderAPIKey`: Enter the API key for the AI Provider. The AI provider provides an API key to access its API.
- `customWebEngineContentAISecret`: Provide a secret name that will be used to set the AI API Key.

To create a custom secret, run the following command:

```sh
kubectl create secret generic WEBENGINE_AI_CUSTOM_SECRET --from-literal=apiKey=API_KEY --namespace=NAME_SERVER
```

Replace `API_KEY` and `NAME_SERVER` with the actual values. For example:

```sh
kubectl create secret generic custom-credentials-webengine-ai-secret --from-literal=apiKey=your-API-Key --namespace=dxns
```

!!!note
    If a custom secret is used instead of an API key directly in the `values.yaml` file, then you must create the custom secret using the content AI provider's API key. You must then refer to the secret name in the `customWebEngineContentAISecret` property and leave the `webEngineContentAIProviderAPIKey` blank and vice versa.

### Validation

After updating the `values.yaml` file, perform the following actions:

- If running the server for the first time, refer to [Installing WebEngine](../../install/kubernetes_deployment/install.md).
- If upgrading previous configurations, refer to [Upgrading the Helm deployment](../working_with_compose/helm_upgrade_values.md).

After enabling the Content AI analysis, refer to the steps in [WCM REST V2 AI Analysis API](https://opensource.hcltechsw.com/digital-experience/latest/manage_content/wcm_development/wcm_rest_v2_ai_analysis/){target="_blank"} to call the AI Analyzer APIs of the configured Content AI Provider.

### OPEN_AI provider configuration

If you are using the bundled `OPEN_AI` provider, you can configure its behavior using additional properties in the Helm `values.yaml` file. These must be set in the property overrides for `WCMConfigService.properties`. For example:

```yaml
configuration:
  webEngine:
    propertiesFilesOverrides: 
      WCMConfigService.properties:
        OPENAI_SCHEME: "http"
```

The available properties are:

1. ```OPENAI_MODEL```: The currently supported AI model is ```gpt-4o```. However, AI model can be overriden by overriding this property.
2. ```OPENAI_MAX_TOKENS```: Set a positive integer value for GPT-3 models like ```text-davinci-003```. It specifies the maximum number of tokens that the model can output in its response and defaults to ```256```.
3. ```OPENAI_TEMPERATURE```: Set positive float values ranging from ```0.0``` to ```1.0```. This parameter in OpenAI's GPT-3 API controls the randomness and creativity of the generated text. Higher values produce more diverse and random output. Lower values produce more focused and deterministic output.
4. ```OPENAI_HOST```: The host to connect to for AI calls, defaults to ```api.openai.com```. Configuring this could allow you to connect to a different service that offers an OpenAI-compatible API, such as LiteLLM.
5. ```OPENAI_SCHEME```: The scheme which AI calls will use, defaults to ```https```.
