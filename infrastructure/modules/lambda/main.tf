resource "aws_iam_role" "_" {
  name               = local.name
  assume_role_policy = file("${path.module}/assume_role_policy.json")
}

data "archive_file" "_" {
  type        = "zip"
  source_dir  = "${local.func_dir}/dist"
  output_path = "${local.func_dir}/source.zip"

  depends_on = [
    null_resource.lambda_ecr_image_builder
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

  # environment {
  #   variables = local.envs
  # }
}


resource "null_resource" "lambda_ecr_image_builder" {
  triggers = {
    # docker_file     = filesha256("${local.func_dir}/Dockerfile")
    # cargo_file      = filesha256("${local.func_dir}/Cargo.toml")
    # cargo_lock_file = filesha256("${local.func_dir}/Cargo.lock")
    src_dir         = sha256(join("", [for f in fileset("${local.func_dir}/src", "**") : filesha256("${local.func_dir}/src/${f}")]))
    dist = filesha256("${local.func_dir}/target/x86_64-unknown-linux-musl/release/${var.name}")
  }

  provisioner "local-exec" {
    working_dir = local.func_dir
    interpreter = ["/bin/sh", "-c"]
    # command     = <<-EOT
    #   aws ecr get-login-password --region ${var.common_values.region} | docker login --username AWS --password-stdin ${var.common_values.account_id}.dkr.ecr.${var.common_values.region}.amazonaws.com
    #   docker image build -t --build-arg binary=${var.name} .
    #   docker push ${aws_ecr_repository._.repository_url}:latest
    # EOT
    command     = <<-EOT
    mkdir -p ./dist
    cp ./target/x86_64-unknown-linux-musl/release/${var.name} ./dist/bootstrap
    EOT
  }
}

# data "aws_ecr_image" "_" {
#   depends_on = [
#     null_resource.lambda_ecr_image_builder
#   ]

#   repository_name = local.ecr_repository_name
#   image_tag       = "latest"
# }
