variable "lambda" {}
variable "apigateway" {}
variable "path_part" {}
variable "http_method" {}

locals {
  route_path = "${var.http_method} /${var.path_part}"
}
