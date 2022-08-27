resource "aws_apigatewayv2_integration" "_" {
  api_id                 = var.apigateway.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.lambda.arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "_" {
  api_id    = var.apigateway.id
  route_key = var.route_path
  target    = "integrations/${aws_apigatewayv2_integration._.id}"
}

resource "aws_lambda_permission" "_" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.apigateway.execution_arn}/*/${var.method}"
}
