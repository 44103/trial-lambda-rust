module "lambda" {
  common_values = local.common_values
  source        = "../modules/lambda"
  name          = "trial"
}

module "apigw" {
  common_values = local.common_values
  source        = "../modules/apigw"
  name          = "trial"
  lambda        = module.lambda
  path_part     = "greet"
}

data "aws_caller_identity" "_" {}
