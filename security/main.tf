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
  kibana {
    endpoints = [var.kibana_endpoint]

  }
}


# Create role mappings dynamically
resource "elasticstack_elasticsearch_security_role_mapping" "role_mappings" {
  for_each = var.enta_group_role_map

  name    = each.key
  enabled = true
  roles   = each.value.roles

  rules = jsonencode({
    any = [
      { field = { "realm.name": var.sso_realm_name } },
      { field = { "groups": each.value.group } }
    ]
  })
}

resource "elasticstack_kibana_security_role" "example" {
  name = "sample_role"
  elasticsearch {
    cluster = ["all"]
    indices {
      field_security {
        grant  = ["test"]
        except = []
      }
      names      = ["test"]
      privileges = ["create", "read", "write"]
    }
  }
  kibana {
    base   = ["all"]
    spaces = ["default"]
  }
}