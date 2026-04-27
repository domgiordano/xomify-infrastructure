locals {
  likes_lambdas = [
    {
      name        = "push"
      description = "Persist a user's saved tracks (top-N) pushed from iOS on cold open"
      path_part   = "push"
      http_method = "POST"
    },
    {
      name        = "by-user"
      description = "Friendship-gated paginated read of a user's saved tracks"
      path_part   = "by-user"
      http_method = "GET"
    },
  ]
}

resource "aws_lambda_function" "likes" {
  for_each         = { for lambda in local.likes_lambdas : lambda.name => lambda }
  function_name    = "${var.app_name}-likes-${each.value.name}"
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

  tags = merge(local.standard_tags, tomap({ "name" = "${var.app_name}-likes-${each.value.name}", "lambda_type" = "likes" }))

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
