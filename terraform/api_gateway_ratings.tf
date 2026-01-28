#**********************
# ratings
# /ratings
#**********************

resource "aws_api_gateway_resource" "ratings_resource" {
  path_part   = "ratings"
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
}

# Dynamically create endpoints for ratings lambdas
module "ratings_endpoints" {
  for_each = { for lambda in local.ratings_lambdas : lambda.name => lambda }

  source                  = "./modules/api_gateway"
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  parent_resource_id      = aws_api_gateway_resource.ratings_resource.id
  path_part               = each.value.path_part
  http_method             = each.value.http_method
  allow_methods           = [each.value.http_method, "OPTIONS"]
  allow_headers           = local.api_allow_headers
  integration_type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.ratings[each.key].invoke_arn
  authorization           = "CUSTOM"
  authorizer_id           = aws_api_gateway_authorizer.lambda_authorizer.id
  standard_tags           = local.standard_tags
  allow_origin            = "*"
}

# AWS Permissions /ratings
resource "aws_lambda_permission" "ratings_data_permission" {
  for_each      = { for lambda in local.ratings_lambdas : lambda.name => lambda }
  statement_id  = "Allowratings${title(each.value.name)}Api"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ratings[each.value.name].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*"
}
