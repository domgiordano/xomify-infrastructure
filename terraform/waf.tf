#**********************
# WAF (via reusable module)
#**********************

# CloudFront WAF
module "waf_cloudfront" {
  source = "git::https://github.com/domgiordano/waf.git?ref=v1.1.0"

  app_name = "${var.app_name}-cloudfront"
  scope    = "CLOUDFRONT"
  tags     = local.standard_tags
}

# API Gateway WAF (with rate limiting)
module "waf_api_gateway" {
  source = "git::https://github.com/domgiordano/waf.git?ref=v1.1.0"

  app_name   = "${var.app_name}-api-gateway"
  scope      = "REGIONAL"
  rate_limit = 2000
  tags       = local.standard_tags
}

# Associate WAF with API Gateway stage (separate to avoid unknown count)
resource "aws_wafv2_web_acl_association" "api_gateway" {
  web_acl_arn  = module.waf_api_gateway.web_acl_arn
  resource_arn = module.api.stage_arn
}
