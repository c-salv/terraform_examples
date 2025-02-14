terraform {
  required_providers {
    elasticstack = {
      source = "elastic/elasticstack"
      version = "0.11.7" # There's a bug with v0.11.13 with "elasticstack_fleet_integration_policy"
      # https://github.com/elastic/terraform-provider-elasticstack/issues/999
    }
  }
}

provider "elasticstack" {
  fleet {
    api_key = var.elasticsearch_api_key
    endpoint = var.kibana_endpoint
  }
}


/* resource "elasticstack_fleet_integration" "sample" {
  name    = "azure"
  version = "1.22.0"
  force   = true
} */

// An agent policy to hold the integration policy.
resource "elasticstack_fleet_agent_policy" "sample" {
  name            = "TF Agent Policy"
  namespace       = "default"
  description     = "A TF agent policy"
  monitor_logs    = false
  monitor_metrics = false
  skip_destroy    = false
}

// The integration policy.
resource "elasticstack_fleet_integration_policy" "sample" {
  name                = "tf-eventhub" # go to https://<kibana_endpoint>/api/fleet/epm/packages to see integration names
  namespace           = "default"
  description         = "A sample integration policy"
  agent_policy_id     = elasticstack_fleet_agent_policy.sample.policy_id
  integration_name    = "azure"
  integration_version = "1.22.0"
  vars_json = jsonencode({
    "eventhub": "eventhubname",
    "connection_string": "connectionstring",
    "consumer_group": "$Default",
    "storage_account": "storageaccount",
    "storage_account_key": "sc_key"
  })

  input { # Use the Kibana UI and Preview API requesr to get inputs
    input_id = "eventhub-azure-eventhub"
    enabled = true
    streams_json = jsonencode({
        "azure.eventhub": {
          "enabled": true,
          "vars": {
            "parse_message": false,
            "preserve_original_event": false,
            "data_stream.dataset": "azure.eventhub",
            "tags": [
              "azure-eventhub",
              "forwarded"
            ],
            "sanitize_newlines": false,
            "sanitize_singlequotes": false
          }
        }
    })
  }
  depends_on = [
    elasticstack_fleet_agent_policy.sample
  ]
}