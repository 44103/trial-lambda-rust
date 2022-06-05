variable "common_values" {}

variable "name" {
  description = "リソース名"
}

variable "envs" {
  description = "lambdaで使用する環境変数"
  default     = {}
}

locals {
  name = join("_", [
    var.common_values.workspace,
    var.name,
    var.common_values.service,
    var.common_values.project
    ])
  envs = merge(
    { "TZ" = "Asia/Tokyo" },
    var.envs
  )
  func_dir = "${path.module}/../../functions/${var.name}"
  dist_dir = "${local.func_dir}/bootstrap"
}
