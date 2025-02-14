variable "elasticsearch_api_key" {
  description = "Elasticsearch API key for authentication"
  type        = string
  sensitive   = true
}

variable "elasticsearch_endpoint" {
  description = "Elasticsearch cluster URL"
  type        = string
}
