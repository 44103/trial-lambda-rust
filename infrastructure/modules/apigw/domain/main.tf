resource "aws_api_gateway_method" "_" {
  rest_api_id   = var.apigateway.rest_api.id
  resource_id   = var.apigateway.resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "_" {
  rest_api_id             = var.apigateway.rest_api.id
  resource_id             = var.apigateway.resource.id
  http_method             = aws_api_gateway_method._.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda.invoke_arn
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.apigateway.rest_api.execution_arn}/*/${aws_api_gateway_method._.http_method}${var.apigateway.resource.path}"
}
