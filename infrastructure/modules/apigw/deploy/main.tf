resource "aws_api_gateway_deployment" "_" {
  rest_api_id = var.apigateway.rest_api.id
  stage_name  = var.stage_name

  triggers = {
    "lambdas" = join("-",
    [for lambda in var.lambdas : "${lambda.function.function_name}_${lambda.function.last_modified}"])
  }
}
