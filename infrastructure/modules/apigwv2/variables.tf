variable "commons" {}

variable "name" {
  description = "resource name"
}
variable "stage_name" {
  default = "$default"
}

locals {
  name = join("_", [
    var.commons.workspace,
    var.name,
    var.commons.service,
    var.commons.project
  ])
}
