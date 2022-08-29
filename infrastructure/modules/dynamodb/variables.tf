variable "commons" {}
variable "name" {}
variable "partition_key" {}
variable "sort_key" {
  default = null
}
variable "attributes" {}
variable "gsi_parameters" {
  default = []
}

locals {
  name = join("_", [
    var.commons.workspace,
    var.name,
    var.commons.service,
    var.commons.project
  ])
}
