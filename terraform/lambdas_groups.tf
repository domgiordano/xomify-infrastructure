locals {
  groups_lambdas = [
    {
      name        = "list"
      description = "Get user's groups list"
      path_part   = "list"
      http_method = "GET"
    },
    {
      name        = "info"
      description = "Get single group with members and songs"
      path_part   = "info"
      http_method = "GET"
    },
    {
      name        = "create"
      description = "Create a new group"
      path_part   = "create"
      http_method = "POST"
    },
    {
      name        = "update"
      description = "Update group details"
      path_part   = "update"
      http_method = "PUT"
    },
    {
      name        = "remove"
      description = "Delete a group (admin only)"
      path_part   = "remove"
      http_method = "DELETE"
    },
    {
      name        = "add-member"
      description = "Add a member to group"
      path_part   = "add-member"
      http_method = "POST"
    },
    {
      name        = "remove-member"
      description = "Remove a member from group"
      path_part   = "remove-member"
      http_method = "DELETE"
    },
    {
      name        = "leave"
      description = "Leave a group"
      path_part   = "leave"
      http_method = "POST"
    },
    {
      name        = "add-song"
      description = "Add a song to group (with track data)"
      path_part   = "add-song"
      http_method = "POST"
    },
    {
      name        = "add-song-url"
      description = "Add a song by Spotify URL"
      path_part   = "add-song-url"
      http_method = "POST"
    },
    {
      name        = "remove-song"
      description = "Remove a song from group"
      path_part   = "remove-song"
      http_method = "DELETE"
    },
    {
      name        = "song-status"
      description = "Update user's status on a song"
      path_part   = "song-status"
      http_method = "PUT"
    },
    {
      name        = "mark-all-listened"
      description = "Mark all songs as listened for user"
      path_part   = "mark-all-listened"
      http_method = "POST"
    },
  ]
}

resource "aws_lambda_function" "groups" {
  for_each         = { for lambda in local.groups_lambdas : lambda.name => lambda }
  function_name    = "${var.app_name}-groups-${each.value.name}"
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

  tags = merge(local.standard_tags, tomap({ "name" = "${var.app_name}-groups-${each.value.name}", "lambda_type" = "groups" }))

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