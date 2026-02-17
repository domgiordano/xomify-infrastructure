#**********************
# WAF (via reusable module)
#**********************

# CloudFront WAF
module "waf_cloudfront" {
  source = "git::https://github.com/domgiordano/waf.git?ref=v1.0.0"

  app_name = "${var.app_name}-cloudfront"
  scope    = "CLOUDFRONT"
  tags     = local.standard_tags
}

# API Gateway WAF (with rate limiting)
module "waf_api_gateway" {
  source = "git::https://github.com/domgiordano/waf.git?ref=v1.0.0"

  app_name     = "${var.app_name}-api-gateway"
  scope        = "REGIONAL"
  rate_limit   = 2000
  resource_arn = module.api.stage_arn
  tags         = local.standard_tags
}
