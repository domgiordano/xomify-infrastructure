
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

resource "aws_cloudwatch_log_group" "friendships_db_log_group" {
    name = aws_dynamodb_table.friendships.id
    retention_in_days = 14
    tags = merge(local.standard_tags, tomap({ "name"= "${var.app_name}-friendships"}))
}

resource "aws_cloudwatch_log_group" "groups_db_log_group" {
    name = aws_dynamodb_table.groups.id
    retention_in_days = 14
    tags = merge(local.standard_tags, tomap({ "name"= "${var.app_name}-groups"}))
}

resource "aws_cloudwatch_log_group" "group_members_db_log_group" {
    name = aws_dynamodb_table.group_members.id
    retention_in_days = 14
    tags = merge(local.standard_tags, tomap({ "name"= "${var.app_name}-group-members"}))
}

resource "aws_cloudwatch_log_group" "group_tracks_db_log_group" {
    name = aws_dynamodb_table.group_tracks.id
    retention_in_days = 14
    tags = merge(local.standard_tags, tomap({ "name"= "${var.app_name}-group-tracks"}))
}

resource "aws_cloudwatch_log_group" "track_ratings_db_log_group" {
    name = aws_dynamodb_table.track_ratings.id
    retention_in_days = 14
    tags = merge(local.standard_tags, tomap({ "name"= "${var.app_name}-track-ratings"}))
}


## APIGW
resource "aws_cloudwatch_log_group" "api_log_group" {
    name = aws_api_gateway_rest_api.api_gateway.id
    retention_in_days = 14
    tags = merge(local.standard_tags, tomap({ "name"= "${var.app_name}-APIGW-Access-Logs"}))
}