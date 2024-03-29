variable "commons" {}
variable "name" {
  description = "resource name"
}

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
  func_dir = "${path.module}/../../functions/lambda"
  dist_dir = "${local.func_dir}/bootstrap"
}
