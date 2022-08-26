data "aws_caller_identity" "_" {}

module "lambda" {
  commons = local.commons
  source  = "../modules/lambda"
  name    = "greet"
}

module "apigwv2" {
  commons = local.commons
  source  = "../modules/apigwv2"
  name    = "trial"
}

module "domain" {
  source     = "../modules/apigwv2/domain"
  apigateway = module.apigwv2
  lambda     = module.lambda
  route_path = "POST /greet"
}
