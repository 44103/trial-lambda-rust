data "aws_caller_identity" "_" {}

module "lambda" {
  source  = "../modules/lambda"
  commons = local.commons
  name    = "greet"
}

# module "apigwv2" {
#   source  = "../modules/apigwv2"
#   commons = local.commons
#   name    = "trial"
# }

# module "route" {
#   source      = "../modules/apigwv2/route"
#   apigateway  = module.apigwv2
#   lambda      = module.lambda
#   path_part   = "greet"
#   http_method = "POST"
# }

module "apigw" {
  source  = "../modules/apigw"
  commons = local.commons
  name    = "trial"
}

module "route" {
  source      = "../modules/apigw/route"
  apigateway  = module.apigw
  lambda      = module.lambda
  path_part   = "greet"
  http_method = "POST"
}

module "deploy" {
  source     = "../modules/apigw/deploy"
  apigateway = module.apigw
  lambda     = module.lambda
}
