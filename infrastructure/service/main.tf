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

# module "apigw" {
#   source     = "../modules/apigw"
#   commons    = local.commons
#   name       = "trial"
#   stage_name = "prod"
#   body       = file("openapi.yml")
#   integrations = {
#     "POST_greet"    = module.lambda_greet
#     "POST_shortcut" = module.lambda_shortcut
#   }
# }

module "apigwv2" {
  source     = "../modules/apigwv2"
  commons    = local.commons
  name       = "trial"
  stage_name = "prod"
  body       = file("openapi.yml")
  integrations = {
    "POST_greet"    = module.lambda_greet
    "POST_shortcut" = module.lambda_shortcut
  }
}
