data "aws_caller_identity" "_" {}

module "lambda" {
  commons = local.commons
  source  = "../modules/lambda"
  name    = "greet"
}

module "apigw" {
  commons = local.commons
  source  = "../modules/apigw"
  name    = "trial"
}

module "domain" {
  source     = "../modules/apigw/domain"
  apigateway = module.apigw
  lambda     = module.lambda
  route_path = "POST /greet"
}
