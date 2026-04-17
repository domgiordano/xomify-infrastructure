## API Gateway IAM for Cloudwatch Logging

data "aws_iam_policy_document" "api_gateway_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "api_gateway_cloudwatch" {
  name               = "${var.app_name}-api_gateway-logs"
  tags               = merge(local.standard_tags, tomap({ "name" = "${var.app_name}-api_gateway-logs" }))
  assume_role_policy = data.aws_iam_policy_document.api_gateway_assume_role.json
}

data "aws_iam_policy_document" "api_gateway_cloudwatch_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "api_gateway_cloudwatch_role_policy" {
  name   = "${var.app_name}-api_gateway_cloudwatch-role-policy"
  role   = aws_iam_role.api_gateway_cloudwatch.id
  policy = data.aws_iam_policy_document.api_gateway_cloudwatch_policy.json
}

# ============================================
# API Gateway -> Authorizer Lambda invoke role
# API Gateway assumes this role to invoke the custom authorizer Lambda.
# Previously we passed the authorizer's Lambda execution role as
# authorizer_credentials, which API Gateway cannot assume (trust policy
# only allows lambda.amazonaws.com). Result: every protected request
# returned HTTP 500 with AUTHORIZER_CONFIGURATION_ERROR.
# ============================================

data "aws_iam_policy_document" "apigw_authorizer_invoke_policy" {
  statement {
    effect    = "Allow"
    actions   = ["lambda:InvokeFunction"]
    resources = [aws_lambda_function.authorizer.arn]
  }
}

resource "aws_iam_role" "apigw_authorizer_invoke" {
  name               = "${var.app_name}-apigw-authorizer-invoke"
  tags               = merge(local.standard_tags, tomap({ "name" = "${var.app_name}-apigw-authorizer-invoke" }))
  assume_role_policy = data.aws_iam_policy_document.api_gateway_assume_role.json
}

resource "aws_iam_role_policy" "apigw_authorizer_invoke" {
  name   = "${var.app_name}-apigw-authorizer-invoke-policy"
  role   = aws_iam_role.apigw_authorizer_invoke.id
  policy = data.aws_iam_policy_document.apigw_authorizer_invoke_policy.json
}
