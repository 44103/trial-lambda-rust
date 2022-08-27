module "lambda" {
  source  = "../../lambda"
  commons = var.commons
  name    = var.name
  envs    = var.envs
}

module "route" {
  source      = "../route"
  apigateway  = var.apigw
  lambda      = module.lambda
  path_part   = local.path_part
  http_method = var.http_method
}
