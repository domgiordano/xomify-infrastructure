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
