locals {
  release_radar_lambdas = [
    {
        name = "history"
        description = "Get user's release radar history"
        path_part = "history"
        http_method = "GET"
    },
    {
        name = "check"
        description = "Check user's release radar enrollment status"
        path_part = "check"
        http_method = "GET"
    },
  ]
}

resource "aws_lambda_function" "release_radar" {
  for_each         = { for lambda in local.release_radar_lambdas : lambda.name => lambda }
  function_name    = "${var.app_name}-release-radar-${each.value.name}"
  description      = each.value.description
  filename         = "./templates/lambda_stub.zip"
  source_code_hash = filebase64sha256("./templates/lambda_stub.zip")
  handler          = "handler.handler"
  layers           = [aws_lambda_layer_version.lambda_layer.arn]
  runtime          = var.lambda_runtime
  memory_size      = var.lambda_memory_size
  timeout          = var.lambda_timeout
  role             = aws_iam_role.lambda_role.arn

  environment {
    variables = local.lambda_variables
  }

  tracing_config {
    mode = var.lambda_trace_mode
  }

  tags = merge(local.standard_tags, tomap({ "name" = "${var.app_name}-release-radar-${each.value.name}", "lambda_type" = "release-radar" }))

  lifecycle {
    ignore_changes = [
      description,
      filename,
      source_code_hash,
      layers
    ]
  }

  depends_on = [
    aws_iam_role_policy.lambda_role_policy,
    aws_iam_role.lambda_role
  ]
}