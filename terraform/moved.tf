# Moved blocks to migrate resources into modules without recreation.
# Safe to delete this file after a successful apply.

#############################
# S3
#############################

moved {
  from = aws_s3_bucket.web_app
  to   = module.web.aws_s3_bucket.site
}

moved {
  from = aws_s3_bucket_ownership_controls.web_app
  to   = module.web.aws_s3_bucket_ownership_controls.site
}

moved {
  from = aws_s3_bucket_public_access_block.web_app
  to   = module.web.aws_s3_bucket_public_access_block.site
}

moved {
  from = aws_s3_bucket_versioning.web_app
  to   = module.web.aws_s3_bucket_versioning.site
}

moved {
  from = aws_s3_bucket_server_side_encryption_configuration.web_app
  to   = module.web.aws_s3_bucket_server_side_encryption_configuration.site
}

moved {
  from = aws_s3_bucket_lifecycle_configuration.web_app
  to   = module.web.aws_s3_bucket_lifecycle_configuration.site
}

moved {
  from = aws_s3_bucket_policy.web_app
  to   = module.web.aws_s3_bucket_policy.site
}

#############################
# CloudFront
#############################

moved {
  from = aws_cloudfront_origin_access_control.web_app
  to   = module.web.aws_cloudfront_origin_access_control.site
}

moved {
  from = aws_cloudfront_distribution.web_app
  to   = module.web.aws_cloudfront_distribution.site
}

moved {
  from = aws_cloudfront_response_headers_policy.web_app
  to   = module.web.aws_cloudfront_response_headers_policy.site
}

#############################
# ACM
#############################

moved {
  from = aws_acm_certificate.web_app
  to   = module.web.aws_acm_certificate.cert
}

moved {
  from = aws_acm_certificate_validation.web_app_validate
  to   = module.web.aws_acm_certificate_validation.cert
}

#############################
# Route53 (site A record)
#############################

moved {
  from = aws_route53_record.web_app
  to   = module.web.aws_route53_record.site
}

#############################
# WAF
#############################

moved {
  from = aws_wafv2_web_acl.cloudfront_waf_web_acl
  to   = module.waf_cloudfront.aws_wafv2_web_acl.acl
}

moved {
  from = aws_wafv2_web_acl.waf_api_gateway_acl
  to   = module.waf_api_gateway.aws_wafv2_web_acl.acl
}

moved {
  from = aws_wafv2_web_acl_association.api_gateway_association
  to   = aws_wafv2_web_acl_association.api_gateway
}

#############################
# API Gateway Domain (moved into module)
#############################

moved {
  from = aws_api_gateway_domain_name.api_gateway_domain
  to   = module.api.aws_api_gateway_domain_name.domain[0]
}

moved {
  from = aws_api_gateway_base_path_mapping.api_mapping
  to   = module.api.aws_api_gateway_base_path_mapping.mapping[0]
}
