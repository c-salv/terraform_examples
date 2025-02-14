variable "elasticsearch_api_key" {
  description = "Elasticsearch API key for authentication"
  type        = string
  sensitive   = true
}

variable "kibana_endpoint" {
  description = "Kibana URL"
  type        = string
  
}

variable "saved_objects_file" {
  description = "Path to the saved objects JSON file"
  type        = string
  default     = "saved_objects.ndjson"
}

variable "space_id" {
  description = "Space ID to import the saved objects"
  type        = string
  default     = "default"
  
}