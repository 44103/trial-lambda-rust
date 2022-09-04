data "template_file" "openapi" {
  template = var.body
  vars     = local.openapi_vars
}

resource "aws_api_gateway_rest_api" "_" {
  name = local.name
  body = data.template_file.openapi.rendered
}

resource "aws_api_gateway_deployment" "_" {
  rest_api_id = aws_api_gateway_rest_api._.id
  stage_name  = var.stage_name

  triggers = merge(
    local.openapi_vars,
    { openapi_hash = md5(var.body) }
  )
}

resource "aws_lambda_permission" "apigw" {
  for_each      = local.lambda_permissions
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = join("/", [
    aws_api_gateway_rest_api._.execution_arn,
    "*",
    each.value.http_method,
    each.value.path_part
  ])
}
