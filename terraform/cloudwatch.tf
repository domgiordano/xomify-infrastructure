
## DYNAMODB
resource "aws_cloudwatch_log_group" "users_db_log_group" {
    name = aws_dynamodb_table.users.id
    retention_in_days = 14
    tags = merge(local.standard_tags, tomap({ "name"= "${var.app_name}-users"}))
}

resource "aws_cloudwatch_log_group" "wrapped_history_db_log_group" {
    name = aws_dynamodb_table.wrapped_history.id
    retention_in_days = 14
    tags = merge(local.standard_tags, tomap({ "name"= "${var.app_name}-wrapped-history"}))
}

resource "aws_cloudwatch_log_group" "release_radar_history_db_log_group" {
    name = aws_dynamodb_table.release_radar_history.id
    retention_in_days = 14
    tags = merge(local.standard_tags, tomap({ "name"= "${var.app_name}-release-radar-history"}))
}

## APIGW
resource "aws_cloudwatch_log_group" "api_log_group" {
    name = aws_api_gateway_rest_api.api_gateway.id
    retention_in_days = 14
    tags = merge(local.standard_tags, tomap({ "name"= "${var.app_name}-APIGW-Access-Logs"}))
}

## CRON JOB - WRAPPED
resource "aws_cloudwatch_event_rule" "wrapped_schedule" {
  name        ="${var.app_name}-wrapped-schedule"
  description = "Trigger Wrapped Lambda function on the first day of every month"
  schedule_expression = "cron(0 4 1 * ? *)"  # Runs at 4AM UTC on the first day of every month
}

resource "aws_cloudwatch_event_target" "wrapped_target" {
  rule      = aws_cloudwatch_event_rule.wrapped_schedule.name
  target_id = "${var.app_name}-wrapped-target-id"
  arn       = aws_lambda_function.wrapped.arn
}

## CRON JOB - RELEASE RADAR
resource "aws_cloudwatch_event_rule" "release_radar_schedule" {
  name        ="${var.app_name}-release-radar-schedule"
  description = "Trigger Release Radar Lambda function on every Friday at 12PM UTC"
  schedule_expression = "cron(0 12 ? * FRI *)"  # Runs at 12PM UTC (8AM Eastern) on every Friday
}

resource "aws_cloudwatch_event_target" "release_radar_target" {
  rule      = aws_cloudwatch_event_rule.release_radar_schedule.name
  target_id = "${var.app_name}-release-radar-target-id"
  arn       = aws_lambda_function.release_radar.arn
}

## CRON JOB - WRAPPED EMAIL
resource "aws_cloudwatch_event_rule" "wrapped_email_schedule" {
  name        ="${var.app_name}-wrapped-email-schedule"
  description = "Trigger Wrapped Email Lambda function on the first day of every month at 12PM UTC"
  schedule_expression = "cron(0 12 1 * ? *)"  # Runs at 12PM UTC (8AM Eastern) on the first day of every month
}

resource "aws_cloudwatch_event_target" "wrapped_email_target" {
  rule      = aws_cloudwatch_event_rule.wrapped_email_schedule.name
  target_id = "${var.app_name}-wrapped-email-target-id"
  arn       = aws_lambda_function.wrapped_email.arn
}

## CRON JOB - RELEASE RADAR EMAIL
resource "aws_cloudwatch_event_rule" "release_radar_email_schedule" {
  name        ="${var.app_name}-release-radar-email-schedule"
  description = "Trigger Release Radar Email Lambda function on every Friday at 12PM UTC"
  schedule_expression = "cron(15 12 ? * FRI *)"  # Runs at 12:15 PM UTC (8:15 AM Eastern) on every Friday
}

resource "aws_cloudwatch_event_target" "release_radar_email_target" {
  rule      = aws_cloudwatch_event_rule.release_radar_email_schedule.name
  target_id = "${var.app_name}-release-radar-email-target-id"
  arn       = aws_lambda_function.release_radar_email.arn
}