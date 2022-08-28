variable "lambda" {}
variable "apigateway" {}
variable "path_part" {}
variable "http_method" {}
variable "parent_id" {
  default = null
}
variable "integration_http_method" {
  default = null
}
