data "aws_caller_identity" "_" {}

module "lambda" {
  commons = local.commons
  source  = "../modules/lambda"
  name    = "greet"
}

# module "apigwv2" {
#   commons = local.commons
#   source  = "../modules/apigwv2"
#   name    = "trial"
# }

# module "domain" {
#   source     = "../modules/apigwv2/domain"
#   apigateway = module.apigwv2
#   lambda     = module.lambda
#   route_path = "POST /greet"
# }

module "apigw" {
  commons = local.commons
  source  = "../modules/apigw"
  name    = "trial"
}

module "domain" {
  source      = "../modules/apigw/domain"
  apigateway  = module.apigw
  lambda      = module.lambda
  path_part   = "greet"
  http_method = "POST"
}

module "develop" {
  source     = "../modules/apigw/develop"
  apigateway = module.apigw
  lambda     = module.lambda
}
