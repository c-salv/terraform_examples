terraform {
  required_providers {
    elasticstack = {
      source = "elastic/elasticstack"
      version = ">= 0.11.13" # Check latest version
    }
  }
}

provider "elasticstack" {
  elasticsearch {
    api_key = var.elasticsearch_api_key
    endpoints = [var.elasticsearch_endpoint]
  }
}


resource "elasticstack_elasticsearch_index_lifecycle" "tf_policy" {
  name = "tf_policy"

  hot {
    min_age = "1h"
    set_priority {
      priority = 0
    }
    rollover {
      max_age = "1d"
    }
    readonly {}
  }

  warm {
    min_age = "0ms"
    set_priority {
      priority = 10
    }
    readonly {}
    allocate {
      exclude = jsonencode({
        box_type = "hot"
      })
      number_of_replicas    = 1
      total_shards_per_node = 200
    }
  }

  delete {
    min_age = "2d"
    delete {}
  }
}


resource "elasticstack_elasticsearch_index_template" "my_data_stream_template" {
  name = "tf_logs"

  index_patterns = ["tf*"]
  data_stream {}
  template {
    settings = jsonencode({
      "lifecycle.name" = "tf_policy"
    })
  }
}

resource "elasticstack_elasticsearch_data_stream" "my_data_stream" {
  name = "tf_logs-0001"

  depends_on = [
    elasticstack_elasticsearch_index_template.my_data_stream_template
  ]
}