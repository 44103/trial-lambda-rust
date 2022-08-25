variable "region" {}

variable "project" {
  description = "project name"
  default     = "trial"
}

variable "service" {
  description = "service name"
  default     = "rust"
}

variable "environment" {
  description = "environment"
  default     = "dev"
}

locals {
  commons = {
    region      = var.region
    project     = var.project
    service     = var.service
    environment = var.environment
    workspace   = terraform.workspace
    account_id  = data.aws_caller_identity._.account_id
  }
}
