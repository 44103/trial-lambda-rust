data "aws_caller_identity" "_" {}

module "lambda" {
  commons = local.commons
  source  = "../modules/lambda"
  name    = "trial"
}

module "apigw" {
  commons   = local.commons
  source    = "../modules/apigw"
  name      = "trial"
  lambda    = module.lambda
  path_part = "greet"
}
