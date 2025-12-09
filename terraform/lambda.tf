resource "aws_lambda_function" "wrapped" {

  function_name     = "${var.app_name}-wrapped"
  filename          = "./templates/lambda_stub.zip"
  source_code_hash  = filebase64sha256("./templates/lambda_stub.zip")
  handler           = "handler.handler"
  layers            = [aws_lambda_layer_version.lambda_layer.arn]
  runtime           = var.lambda_runtime
  memory_size       = 1024
  timeout           = 900
  role              = aws_iam_role.lambda_role.arn
  environment {
    variables = local.lambda_variables
  }

  tags = merge(local.standard_tags, tomap({"name" = "${var.app_name}-wrapped"}))



  tracing_config {
    mode = var.lambda_trace_mode
  }



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

resource "aws_lambda_permission" "chron_job" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.wrapped.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.wrapped_schedule.arn
}

resource "aws_lambda_function" "release_radar" {

  function_name     = "${var.app_name}-release-radar"
  filename          = "./templates/lambda_stub.zip"
  source_code_hash  = filebase64sha256("./templates/lambda_stub.zip")
  handler           = "handler.handler"
  layers            = [aws_lambda_layer_version.lambda_layer.arn]
  runtime           = var.lambda_runtime
  memory_size       = 1024
  timeout           = 900
  role              = aws_iam_role.lambda_role.arn
  environment {
    variables = local.lambda_variables
  }

  tags = merge(local.standard_tags, tomap({"name" = "${var.app_name}-release-radar"}))



  tracing_config {
    mode = var.lambda_trace_mode
  }



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

resource "aws_lambda_permission" "release_radar" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.release_radar.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.release_radar_schedule.arn
}

resource "aws_lambda_function" "update_user_table" {

  function_name     = "${var.app_name}-update-user-table"
  filename          = "./templates/lambda_stub.zip"
  source_code_hash  = filebase64sha256("./templates/lambda_stub.zip")
  handler           = "handler.handler"
  layers            = [aws_lambda_layer_version.lambda_layer.arn]
  runtime           = var.lambda_runtime
  memory_size       = 1024
  timeout           = 900
  role              = aws_iam_role.lambda_role.arn
  environment {
    variables = local.lambda_variables
  }

  tags = merge(local.standard_tags, tomap({"name" = "${var.app_name}-update-user-table"}))



  tracing_config {
    mode = var.lambda_trace_mode
  }



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