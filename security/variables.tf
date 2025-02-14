variable "elasticsearch_api_key" {
  description = "Elasticsearch API key for authentication"
  type        = string
  sensitive   = true
}

variable "elasticsearch_endpoint" {
  description = "Elasticsearch cluster URL"
  type        = string
}

variable "kibana_endpoint" {
  description = "Kibana URL"
  type        = string
  
}

variable "sso_realm_name" {
  description = "Name of the SSO realm"
  type        = string
  default     = "my-sso-entra-id"
}

variable "enta_group_role_map" {
  description = "Mapping of Entra groups to Elasticsearch roles"
  type = map(object({
    group = string
    roles = list(string)
  }))
}
