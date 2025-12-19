variable "app_name" {
  description = "The name for the application."
  type        = string
  default     = "xomify"
}

variable "access_key" {
  description = "AWS access key."
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "AWS secret key."
  type        = string
  sensitive   = true
}

variable "client_id" {
  description = "Spotify Web API Client ID"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Spotify Web API Client Secret"
  type        = string
  sensitive   = true
}

variable "api_access_token" {
  description = "API access token"
  type        = string
  sensitive   = true
}

variable "api_secret_key" {
  description = "API Secret Key for FE / BE to use"
  type        = string
  sensitive   = true
}

variable "domain_suffix" {
  description = "Suffix for the domain of the app."
  type        = string
  default     = ".com"
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

# CloudFront Variables
variable "cloudfront_origin_id" {
  description = "Unique origin id for cloudfront distribution"
  type        = string
  default     = "xomifyWeb"
}

variable "cloudfront_origin_path" {
  description = "Optional element for cloudfront distribution that causes CloudFront to request your content from a directory in your Amazon S3 bucket."
  type        = string
  default     = ""
}

variable "us_canada_only" {
  description = "If a georestriction should be placed on the distribution to only provide access to the US and Canada"
  type        = bool
  default     = true
}

variable "custom_error_response_page_path" {
  description = "Custom error response page path for SPA routing."
  type        = string
  default     = "/index.html"
}

variable "retain_on_delete" {
  description = "Disables the distribution instead of deleting it when destroying the resource through Terraform."
  type        = bool
  default     = false
}

variable "minimum_tls_version" {
  description = "Minimum TLS version for CloudFront"
  type        = string
  default     = "TLSv1.2_2018"
}

variable "enable_cloudfront_cache" {
  description = "This variable controls the cloudfront cache. Setting this to false will set the default_ttl and max_ttl values to zero"
  type        = bool
  default     = true
}

# Lambda Variables
variable "lambda_runtime" {
  description = "Runtime for Lambda functions"
  type        = string
  default     = "python3.10"
}

variable "lambda_trace_mode" {
  description = "X-Ray tracing mode for Lambda"
  type        = string
  default     = "Active"
}

variable "lambda_memory_size" {
  description = "Memory size for Lambda functions in MB"
  type        = number
  default     = 1024
}

variable "lambda_timeout" {
  description = "Timeout for Lambda functions in seconds"
  type        = number
  default     = 900
}

# Email Service
variable "from_email" {
  description = "Email address to send from"
  type        = string
  default     = "noreply@xomify.com"
}

