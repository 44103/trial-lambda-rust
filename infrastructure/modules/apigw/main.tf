resource "aws_api_gateway_rest_api" "_" {
  name = local.name
}

resource "aws_api_gateway_resource" "_" {
  path_part   = var.path_part
  parent_id   = aws_api_gateway_rest_api._.root_resource_id
  rest_api_id = aws_api_gateway_rest_api._.id
}
