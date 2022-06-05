resource "aws_iam_role" "_" {
  name               = local.name
  assume_role_policy = file("${path.module}/assume_role_policy.json")
}

data "archive_file" "_" {
  type        = "zip"
  source_dir  = "${local.func_dir}/dist"
  output_path = "${local.func_dir}/source.zip"

  depends_on = [
    null_resource.place_dist
  ]
}

resource "aws_lambda_function" "_" {
  function_name    = local.name
  role             = aws_iam_role._.arn
  runtime          = "provided.al2"
  handler          = "bootstrap.is.real.handler"
  timeout          = 10
  filename         = data.archive_file._.output_path
  source_code_hash = data.archive_file._.output_base64sha256

  environment {
    variables = local.envs
  }
}


resource "null_resource" "place_dist" {
  triggers = {
    dist = filesha256("${local.func_dir}/target/x86_64-unknown-linux-musl/release/${var.name}")
  }

  provisioner "local-exec" {
    working_dir = local.func_dir
    interpreter = ["/bin/sh", "-c"]
    command     = <<-EOT
    mkdir -p ./dist
    cp ./target/x86_64-unknown-linux-musl/release/${var.name} ./dist/bootstrap
    EOT
  }
}
