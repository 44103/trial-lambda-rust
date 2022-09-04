data "template_file" "openapi" {
  template = var.body
  vars     = local.openapi_vars
}

resource "aws_apigatewayv2_api" "_" {
  name          = local.name
  protocol_type = "HTTP"
  body          = data.template_file.openapi.rendered
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

resource "aws_lambda_permission" "apigw" {
  for_each      = local.lambda_permissions
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = join("/", [
    aws_apigatewayv2_api._.execution_arn,
    "*",
    each.value.http_method,
    each.value.path_part
  ])
}

resource "aws_cloudwatch_log_group" "_" {
  name = "/aws/apigateway/${local.name}"
}
