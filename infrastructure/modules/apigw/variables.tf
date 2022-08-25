variable "commons" {}

variable "name" {
  description = "resource name"
}
variable "lambda" {
  type = map(string)
}

variable "path_part" {}

variable "stage_name" {
  default = "prod"
}

locals {
  name = join("_", [
    var.commons.workspace,
    var.name,
    var.commons.service,
    var.commons.project
    ])
}
