resource "aws_api_gateway_deployment" "_" {
  rest_api_id = var.apigateway.rest_api.id
  stage_name  = var.stage_name

  triggers = {
    "lambda" = var.lambda.last_modified
  }
}
