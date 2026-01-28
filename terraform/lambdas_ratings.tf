locals {
  ratings_lambdas = [
    {
        name = "publish"
        description = "Create / update users rating on a track"
        path_part = "publish"
        http_method = "POST"
    },
    {
        name = "all"
        description = "Get all user's track ratings"
        path_part = "all"
        http_method = "GET"
    },
    {
        name = "track"
        description = "Get a single user's rating for a track"
        path_part = "track"
        http_method = "GET"
    },
    {
        name = "remove"
        description = "Remove a user's rating for a track"
        path_part = "remove"
        http_method = "DELETE"
    },
  ]
}

resource "aws_lambda_function" "ratings" {
  for_each         = { for lambda in local.ratings_lambdas : lambda.name => lambda }
  function_name    = "${var.app_name}-ratings-${each.value.name}"
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

  tags = merge(local.standard_tags, tomap({ "name" = "${var.app_name}-ratings-${each.value.name}", "lambda_type" = "ratings" }))

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