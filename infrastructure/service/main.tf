data "aws_caller_identity" "_" {}

module "apigw" {
  source  = "../modules/apigw"
  commons = local.commons
  name    = "trial"
}

module "lambda_integration" {
  source      = "../modules/apigw/lambda_integration"
  commons     = local.commons
  name        = "greet"
  apigw       = module.apigw
  http_method = "POST"
}

# module "lambda" {
#   source  = "../modules/lambda"
#   commons = local.commons
#   name    = "greet"
# }

# module "route" {
#   source      = "../modules/apigw/route"
#   apigateway  = module.apigw
#   lambda      = module.lambda
#   path_part   = "greet"
#   http_method = "POST"
# }

module "deploy" {
  source     = "../modules/apigw/deploy"
  apigateway = module.apigw
  lambda     = module.lambda_integration.lambda
  depends_on = [
    module.lambda_integration
  ]
}

# module "apigwv2" {
#   source  = "../modules/apigwv2"
#   commons = local.commons
#   name    = "trial"
# }

# module "lambda_integration" {
#   source      = "../modules/apigwv2/lambda_integration"
#   commons     = local.commons
#   name        = "greet"
#   apigw       = module.apigwv2
#   http_method = "POST"
# }

# module "route" {
#   source      = "../modules/apigwv2/route"
#   apigateway  = module.apigwv2
#   lambda      = module.lambda
#   path_part   = "greet"
#   http_method = "POST"
# }
