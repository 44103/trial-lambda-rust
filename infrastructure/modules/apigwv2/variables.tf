variable "commons" {}
variable "name" {
  description = "resource name"
}

variable "body" {}
variable "stage_name" {}
variable "integrations" {}

locals {
  name = join("_", [
    var.commons.workspace,
    var.name,
    var.commons.service,
    var.commons.project
  ])
  openapi_vars = {
    for k, v in var.integrations :
    join("_", [
      for path in split("/", replace(k, "_", "")) :
      trim(path, "{}")
    ]) => v.function.invoke_arn
  }
  lambda_permissions = {
    for k, v in var.integrations : k => {
      function_name = v.function.function_name
      http_method   = element(split("_", k), 0)
      path_part     = trim(element(split("_", k), 1), "/")
    }
  }
}
