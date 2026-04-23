# SPOTIFY
resource "aws_ssm_parameter" "client_id" {
  name        = "/${var.app_name}/spotify/CLIENT_ID"
  description = "Spotify Web API Client ID"
  type        = "SecureString"
  value       = var.client_id

  lifecycle { ignore_changes = [tags, tags_all] }
}
resource "aws_ssm_parameter" "client_secret" {
  name        = "/${var.app_name}/spotify/CLIENT_SECRET"
  description = "Spotify Web API Client Secret"
  type        = "SecureString"
  value       = var.client_secret

  lifecycle { ignore_changes = [tags, tags_all] }
}

# API
resource "aws_ssm_parameter" "api_secret_key" {
  name        = "/${var.app_name}/api/API_SECRET_KEY"
  description = "API Secret Key"
  type        = "SecureString"
  value       = var.api_secret_key

  lifecycle { ignore_changes = [tags, tags_all] }
}

resource "aws_ssm_parameter" "api_auth_token" {
  name        = "/${var.app_name}/api/API_AUTH_TOKEN"
  description = "API Auth Token"
  type        = "SecureString"
  value       = var.api_access_token

  lifecycle { ignore_changes = [tags, tags_all] }
}

resource "aws_ssm_parameter" "api_id" {
  name        = "/${var.app_name}/api/API_ID"
  description = "API Gateway ID"
  type        = "SecureString"
  value       = module.api.rest_api_id

  lifecycle { ignore_changes = [tags, tags_all] }
}

# APNs (Apple Push Notification service)
resource "aws_ssm_parameter" "apns_auth_key" {
  name        = "/${var.app_name}/apns/AUTH_KEY"
  description = "APNs .p8 signing key contents (PEM)"
  type        = "SecureString"
  value       = var.apns_signing_key_p8

  lifecycle { ignore_changes = [tags, tags_all] }
}

resource "aws_ssm_parameter" "apns_key_id" {
  name        = "/${var.app_name}/apns/KEY_ID"
  description = "APNs auth key ID"
  type        = "SecureString"
  value       = var.apns_key_id

  lifecycle { ignore_changes = [tags, tags_all] }
}

resource "aws_ssm_parameter" "apns_team_id" {
  name        = "/${var.app_name}/apns/TEAM_ID"
  description = "Apple Developer Team ID (APNs iss claim)"
  type        = "SecureString"
  value       = var.apns_team_id

  lifecycle { ignore_changes = [tags, tags_all] }
}

resource "aws_ssm_parameter" "apns_bundle_id" {
  name        = "/${var.app_name}/apns/BUNDLE_ID"
  description = "iOS bundle identifier (apns-topic header)"
  type        = "SecureString"
  value       = var.apns_bundle_id

  lifecycle { ignore_changes = [tags, tags_all] }
}
