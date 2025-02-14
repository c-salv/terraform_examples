variable "elasticsearch_api_key" {
  description = "Elasticsearch API key for authentication"
  type        = string
  sensitive   = true
}

variable "kibana_endpoint" {
  description = "Fleet URL (same as Kibana URL)"
  type        = string
}
