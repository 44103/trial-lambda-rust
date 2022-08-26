resource "aws_apigatewayv2_api" "_" {
  name          = local.name
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "_" {
  api_id      = aws_apigatewayv2_api._.id
  name        = var.stage_name
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group._.arn
    format = jsonencode({
      requestId : "$context.requestId",
      extendedRequestId : "$context.extendedRequestId",
      ip : "$context.identity.sourceIp",
      caller : "$context.identity.caller",
      user : "$context.identity.user",
      requestTime : "$context.requestTime",
      httpMethod : "$context.httpMethod",
      resourcePath : "$context.resourcePath",
      status : "$context.status",
      protocol : "$context.protocol",
      responseLength : "$context.responseLength"
    })
  }
}

resource "aws_cloudwatch_log_group" "_" {
  name = "/aws/apigateway/${local.name}"
}
