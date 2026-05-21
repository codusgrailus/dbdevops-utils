curl --request POST \
  "https://app.harness.io/gateway/pipeline/api/v1/orgs/default/projects/senthilproj01/pipelines/may12simpleapplyusingtemplate/execute" \
  --header "Harness-Account: $TMP_ACCOUNT_ID" \
  --header "x-api-key: $TMP_HARNESS_API_KEY" \
  --header "Content-Type: application/json" \
  --data-raw '{
    "pipelineVariables": [
      {
        "name": "dbschema",
        "type": "String",
        "value": "may12templates"
      },
      {
        "name": "dbinstance",
        "type": "String",
        "value": "may12inst001"
      },
      {
        "name": "applytag",
        "type": "String",
        "value": "release-2026-05-12"
      },
      {
        "name": "k8sconnector",
        "type": "String",
        "value": "senthilk8smay12c1908conn"
      }
    ]
  }'