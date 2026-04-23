locals {
  domain_name     = "${var.app_name}${var.domain_suffix}"
  api_domain_name = "api.${local.domain_name}"

  # Get the AWS account id
  web_app_account_id = data.aws_caller_identity.web_app_account.account_id

  # Standard tags for all resources
  standard_tags = {
    "source"      = "terraform"
    "app_name"    = var.app_name
    "environment" = var.environment
    "owner"       = var.owner
  }

  # Lambda environment variables
  lambda_variables = {
    APP_NAME                         = var.app_name
    DYNAMODB_KMS_ALIAS               = aws_kms_alias.dynamodb.name
    USERS_TABLE_NAME                 = aws_dynamodb_table.users.id
    WRAPPED_HISTORY_TABLE_NAME       = aws_dynamodb_table.wrapped_history.id
    RELEASE_RADAR_HISTORY_TABLE_NAME = aws_dynamodb_table.release_radar_history.id
    FRIENDSHIPS_TABLE_NAME           = aws_dynamodb_table.friendships.id
    GROUPS_TABLE_NAME                = aws_dynamodb_table.groups.id
    GROUP_MEMBERS_TABLE_NAME         = aws_dynamodb_table.group_members.id
    GROUP_TRACKS_TABLE_NAME          = aws_dynamodb_table.group_tracks.id
    TRACK_RATINGS_TABLE_NAME         = aws_dynamodb_table.track_ratings.id
    SHARES_TABLE_NAME                = aws_dynamodb_table.shares.id
    SHARE_INTERACTIONS_TABLE_NAME    = aws_dynamodb_table.share_interactions.id
    INVITES_TABLE_NAME               = aws_dynamodb_table.invites.id
    DEVICE_TOKENS_TABLE_NAME         = aws_dynamodb_table.device_tokens.id
    NOTIFICATIONS_SEND_FUNCTION_NAME = "${var.app_name}-notifications-send"
    APNS_AUTH_KEY_PARAM              = aws_ssm_parameter.apns_auth_key.name
    APNS_KEY_ID_PARAM                = aws_ssm_parameter.apns_key_id.name
    APNS_TEAM_ID_PARAM               = aws_ssm_parameter.apns_team_id.name
    APNS_BUNDLE_ID_PARAM             = aws_ssm_parameter.apns_bundle_id.name
    AWS_ACCOUNT_ID                   = data.aws_caller_identity.web_app_account.account_id
    FROM_EMAIL                       = var.from_email
  }

  # API Gateway allowed headers
  api_allow_headers = [
    "Authorization",
    "Content-Type",
    "X-Amz-Date",
    "X-Amz-Security-Token",
    "X-Api-Key",
    "Origin",
    "Accept",
    "Access-Control-Allow-Origin",
    "Accept-Language"
  ]
}
