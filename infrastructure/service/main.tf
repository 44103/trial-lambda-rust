data "aws_caller_identity" "_" {}

module "lambda_greet" {
  source  = "../modules/lambda"
  commons = local.commons
  name    = "greet"
}

module "lambda_shortcut" {
  source  = "../modules/lambda"
  commons = local.commons
  name    = "create_shortcut"
  envs = {
    "TABLE" : module.dynamodb.table.name
  }
  policy_statements = [
    {
      Action : [
        "dynamodb:PutItem"
      ],
      Effect : "Allow",
      Resource : module.dynamodb.table.arn
    }
  ]
}

module "dynamodb" {
  source        = "../modules/dynamodb"
  commons       = local.commons
  name          = "shortcuts"
  partition_key = "name"
  attributes = [
    {
      name = "name"
      type = "S"
    }
  ]
}

module "apigw" {
  source     = "../modules/apigw"
  commons    = local.commons
  name       = "trial"
  stage_name = "prod"
  body       = file("openapi.yml")
  integrations = {
    "POST_greet"    = module.lambda_greet
    "POST_shortcut" = module.lambda_shortcut
  }
}

# module "lambda_integration" {
#   source      = "../modules/apigw/lambda_integration"
#   commons     = local.commons
#   name        = "greet"
#   apigw       = module.apigw
#   http_method = "POST"
# }

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

# module "lambda_integration_create_shortcut" {
#   source      = "../modules/apigw/lambda_integration"
#   commons     = local.commons
#   name        = "create_shortcut"
#   apigw       = module.apigw
#   http_method = "POST"
#   path_part   = "shortcut"
#   envs = {
#     "TABLE" : module.dynamodb.table.name
#   }
#   policy_statements = [
#     {
#       Action : [
#         "dynamodb:PutItem"
#       ],
#       Effect : "Allow",
#       Resource : module.dynamodb.table.arn
#     }
#   ]
# }

# module "deploy" {
#   source     = "../modules/apigw/deploy"
#   apigateway = module.apigw
#   lambdas = [
#     module.lambda_integration.lambda,
#     module.lambda_integration_create_shortcut.lambda
#   ]
#   depends_on = [
#     module.lambda_integration,
#     module.lambda_integration_create_shortcut
#   ]
# }

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
