output "rest_api" {
  value = aws_api_gateway_rest_api._
}

output "lambda_permission" {
  value = aws_lambda_permission.apigw
}
