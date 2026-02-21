## API Gateway Account (account-level singleton)

resource "aws_api_gateway_account" "api_gateway_account" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_cloudwatch.arn
}

#**********************
# API Gateway (via reusable module)
#**********************

locals {
  # Build endpoint lists with invoke_arn baked in
  user_endpoints = [
    for l in local.user_lambdas : {
      name        = l.name
      path_part   = l.path_part
      http_method = l.http_method
      invoke_arn  = aws_lambda_function.user[l.name].invoke_arn
    }
  ]

  wrapped_endpoints = [
    for l in local.wrapped_lambdas : {
      name        = l.name
      path_part   = l.path_part
      http_method = l.http_method
      invoke_arn  = aws_lambda_function.wrapped[l.name].invoke_arn
    }
  ]

  friends_endpoints = [
    for l in local.friends_lambdas : {
      name        = l.name
      path_part   = l.path_part
      http_method = l.http_method
      invoke_arn  = aws_lambda_function.friends[l.name].invoke_arn
    }
  ]

  groups_endpoints = [
    for l in local.groups_lambdas : {
      name        = l.name
      path_part   = l.path_part
      http_method = l.http_method
      invoke_arn  = aws_lambda_function.groups[l.name].invoke_arn
    }
  ]

  ratings_endpoints = [
    for l in local.ratings_lambdas : {
      name        = l.name
      path_part   = l.path_part
      http_method = l.http_method
      invoke_arn  = aws_lambda_function.ratings[l.name].invoke_arn
    }
  ]

  release_radar_endpoints = [
    for l in local.release_radar_lambdas : {
      name        = l.name
      path_part   = l.path_part
      http_method = l.http_method
      invoke_arn  = aws_lambda_function.release_radar[l.name].invoke_arn
    }
  ]
}

module "api" {
  source = "git::https://github.com/domgiordano/api-gateway-service.git?ref=v2.2.0"

  app_name              = var.app_name
  stage_name            = "dev"
  authorizer_invoke_arn = aws_lambda_function.authorizer.invoke_arn
  authorizer_role_arn   = aws_iam_role.lambda_role.arn
  tags                  = local.standard_tags
  allow_headers         = local.api_allow_headers
  allow_origin          = "*"

  # Custom domain
  domain_name     = local.api_domain_name
  certificate_arn = aws_acm_certificate_validation.api.certificate_arn

  services = {
    user          = { path_prefix = "user", endpoints = local.user_endpoints }
    wrapped       = { path_prefix = "wrapped", endpoints = local.wrapped_endpoints }
    friends       = { path_prefix = "friends", endpoints = local.friends_endpoints }
    groups        = { path_prefix = "groups", endpoints = local.groups_endpoints }
    ratings       = { path_prefix = "ratings", endpoints = local.ratings_endpoints }
    release-radar = { path_prefix = "release-radar", endpoints = local.release_radar_endpoints }
  }
}
