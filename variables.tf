# Global
variable "name" {
  type        = string
  description = "The name of the deployment."
  default     = "longhorn"
}

variable "compartment" {
  type        = string
  description = "The compartment the ressource is deployed with."
}

# Ingress
variable "ingress_dns" {
  type        = string
  description = "The domain name where longhorn should be reachable."
}

variable "ingress_type" {
  type        = string
  description = "The ingress type. Can be either 'traefik', 'istio' or 'none'"
  default     = "none"
}

# Auth
variable "grafana_adminPassword" {
  type        = string
  description = ""
  sensitive   = true
}

variable "grafana_root_url" {
  type        = string
  description = ""
}

variable "grafana_client_id" {
  type        = string
  description = ""
}

variable "grafana_client_secret" {
  type        = string
  description = ""
  sensitive   = true
}

variable "grafana_auth_url" {
  type        = string
  description = ""
}

variable "grafana_token_url" {
  type        = string
  description = ""
}

variable "grafana_api_url" {
  type        = string
  description = ""
}
