data "aws_caller_identity" "_" {}

module "lambda_create_quote" {
  source  = "../modules/lambda"
  commons = local.commons
  name    = "create_quote"
  envs = {
    TABLE = module.dynamodb_quotes.table.name
  }
  policy_statements = [
    {
      Action : ["dynamodb:PutItem"],
      Effect : "Allow",
      Resource : module.dynamodb_quotes.table.arn
    }
  ]
}

module "lambda_show_quote" {
  source  = "../modules/lambda"
  commons = local.commons
  name    = "show_quote"
  envs = {
    TABLE = module.dynamodb_quotes.table.name
  }
  policy_statements = [
    {
      Action : ["dynamodb:GetItem"],
      Effect : "Allow",
      Resource : module.dynamodb_quotes.table.arn
    }
  ]
}

module "lambda_update_quote" {
  source  = "../modules/lambda"
  commons = local.commons
  name    = "update_quote"
  envs = {
    TABLE = module.dynamodb_quotes.table.name
  }
  policy_statements = [
    {
      Action : ["dynamodb:UpdateItem"],
      Effect : "Allow",
      Resource : module.dynamodb_quotes.table.arn
    }
  ]
}

module "lambda_destroy_quote" {
  source  = "../modules/lambda"
  commons = local.commons
  name    = "destroy_quote"
  envs = {
    TABLE = module.dynamodb_quotes.table.name
  }
  policy_statements = [
    {
      Action : ["dynamodb:DeleteItem"],
      Effect : "Allow",
      Resource : module.dynamodb_quotes.table.arn
    }
  ]
}

module "dynamodb_quotes" {
  source        = "../modules/dynamodb"
  commons       = local.commons
  name          = "quotes"
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
#   stage_name = "v1"
#   body       = file("openapi.yml")
#   integrations = {
#     "POST_/quote"    = module.lambda_quote
#   }
# }

module "apigwv2" {
  source     = "../modules/apigwv2"
  commons    = local.commons
  name       = "trial"
  stage_name = "v1"
  body       = file("openapi.yml")
  integrations = {
    "POST_/quotes"          = module.lambda_create_quote
    "GET_/quotes/{name}"    = module.lambda_show_quote
    "PUT_/quotes/{name}"    = module.lambda_update_quote
    "DELETE_/quotes/{name}" = module.lambda_destroy_quote
  }
}
