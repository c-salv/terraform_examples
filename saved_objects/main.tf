terraform {
  required_providers {
    elasticstack = {
      source = "elastic/elasticstack"
      version = ">= 0.11.13" # Check latest version
    }
  }
}

provider "elasticstack" {
  kibana {
    endpoints = [var.kibana_endpoint]
    api_key = var.elasticsearch_api_key
  }
}

# Import Kibana saved objects dynamically
resource "elasticstack_kibana_import_saved_objects" "import_dashboards" {
  overwrite = true
  file_contents = file(var.saved_objects_file)
  space_id = var.space_id
}


