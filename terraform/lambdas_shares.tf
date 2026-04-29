locals {
  shares_lambdas = [
    {
      name        = "create"
      description = "Create a new share"
      path_part   = "create"
      http_method = "POST"
    },
    {
      name        = "feed"
      description = "Get the merged feed of shares from user and accepted friends"
      path_part   = "feed"
      http_method = "GET"
    },
    {
      name        = "react"
      description = "React to a share (like/love/fire/etc or toggle off)"
      path_part   = "react"
      http_method = "POST"
    },
    {
      name        = "listened"
      description = "Mark one or more shares as listened by the caller (queue / play now)"
      path_part   = "listened"
      http_method = "POST"
    },
    {
      name        = "delete"
      description = "Delete a share by id (owner only)"
      path_part   = "delete"
      http_method = "DELETE"
    },
    {
      name        = "user"
      description = "List shares authored by a specific user"
      path_part   = "user"
      http_method = "GET"
    },
    {
      name        = "detail"
      description = "Full detail view for a single share (listeners + friend ratings)"
      path_part   = "detail"
      http_method = "GET"
    },
    {
      name        = "comments-create"
      description = "Create a comment on a share"
      path_part   = "comments-create"
      http_method = "POST"
    },
    {
      name        = "comments-list"
      description = "List comments on a share"
      path_part   = "comments-list"
      http_method = "GET"
    },
    {
      name        = "comments-delete"
      description = "Delete a comment on a share (author only)"
      path_part   = "comments-delete"
      http_method = "DELETE"
    },
    {
      name        = "reactions-toggle"
      description = "Toggle a reaction (emoji) on a share for the caller"
      path_part   = "reactions-toggle"
      http_method = "POST"
    },
    {
      name        = "reactions-list"
      description = "List reactions on a share"
      path_part   = "reactions-list"
      http_method = "GET"
    },
  ]
}

resource "aws_lambda_function" "shares" {
  for_each         = { for lambda in local.shares_lambdas : lambda.name => lambda }
  function_name    = "${var.app_name}-shares-${each.value.name}"
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

  tags = merge(local.standard_tags, tomap({ "name" = "${var.app_name}-shares-${each.value.name}", "lambda_type" = "shares" }))

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
