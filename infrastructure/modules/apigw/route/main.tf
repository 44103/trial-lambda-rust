resource "aws_api_gateway_resource" "_" {
  path_part   = var.path_part
  parent_id   = coalesce(var.parent_id, var.apigateway.rest_api.root_resource_id)
  rest_api_id = var.apigateway.rest_api.id
}

resource "aws_api_gateway_method" "_" {
  rest_api_id   = var.apigateway.rest_api.id
  resource_id   = aws_api_gateway_resource._.id
  http_method   = var.http_method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "_" {
  rest_api_id             = var.apigateway.rest_api.id
  resource_id             = aws_api_gateway_resource._.id
  http_method             = aws_api_gateway_method._.http_method
  integration_http_method = coalesce(var.integration_http_method, var.http_method)
  type                    = "AWS_PROXY"
  uri                     = var.lambda.function.invoke_arn
}

resource "aws_lambda_permission" "apigw" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda.function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = join("/", [
    var.apigateway.rest_api.execution_arn,
    "*",
    var.http_method,
    var.path_part
  ])
}
