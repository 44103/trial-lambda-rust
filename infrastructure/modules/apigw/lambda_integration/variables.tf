variable "commons" {}
variable "name" {
  description = "resource name"
}

variable "apigw" {}
variable "path_part" {
  default = null
}
variable "http_method" {}
variable "envs" {
  description = "environments"
  default     = {}
}
variable "policy_statements" {
  default = []
}

locals {
  name = join("_", [
    var.commons.workspace,
    var.name,
    var.commons.service,
    var.commons.project
  ])
  envs = merge(
    { "TZ" = "Asia/Tokyo" },
    var.envs
  )
  path_part = coalesce(var.path_part, var.name)
}
