# Cron Lambda Deployment

## Overview

Cron lambdas are initially deployed with a stub (`templates/lambda_stub.zip`). Terraform manages the infrastructure (function definition, IAM, CloudWatch Event rules) but **not** the application code after initial creation. The `lifecycle.ignore_changes` block prevents Terraform from overwriting deployed code.

## Cron Functions

| Function | Schedule | Description |
|----------|----------|-------------|
| `xomify-cron-wrapped` | 1st of month, 4 AM UTC | Monthly wrapped generation |
| `xomify-cron-release-radar` | Saturdays, 11 AM UTC | Weekly release radar generation |
| `xomify-cron-wrapped-email` | 1st of month, 12 PM UTC | Monthly wrapped email send |
| `xomify-cron-release-radar-email` | Saturdays, 12 PM UTC | Weekly release radar email send |

## Deploying Code Updates

### Via AWS CLI

```bash
# Package your lambda code
cd /path/to/lambda/source
zip -r function.zip .

# Deploy to a specific cron lambda
aws lambda update-function-code \
  --function-name xomify-cron-wrapped \
  --zip-file fileb://function.zip \
  --region us-east-1

# Deploy the shared layer (if dependencies changed)
aws lambda publish-layer-version \
  --layer-name xomify-shared-packages \
  --zip-file fileb://layer.zip \
  --compatible-runtimes python3.12 \
  --region us-east-1

# Update function to use new layer version
aws lambda update-function-configuration \
  --function-name xomify-cron-wrapped \
  --layers arn:aws:lambda:us-east-1:ACCOUNT_ID:layer:xomify-shared-packages:VERSION
```

### Deploy All Cron Lambdas

```bash
FUNCTIONS=(
  "xomify-cron-wrapped"
  "xomify-cron-release-radar"
  "xomify-cron-wrapped-email"
  "xomify-cron-release-radar-email"
)

for fn in "${FUNCTIONS[@]}"; do
  echo "Deploying $fn..."
  aws lambda update-function-code \
    --function-name "$fn" \
    --zip-file fileb://function.zip \
    --region us-east-1
done
```

## Testing a Cron Lambda

```bash
# Invoke manually (dry run)
aws lambda invoke \
  --function-name xomify-cron-wrapped \
  --payload '{}' \
  --region us-east-1 \
  /tmp/response.json

cat /tmp/response.json
```

## Why Terraform Doesn't Deploy Code

The `lifecycle.ignore_changes` block in `lambdas_cron.tf` excludes `filename`, `source_code_hash`, and `layers` from Terraform's change detection. This prevents `terraform apply` from reverting deployed code back to the stub. Terraform manages the infrastructure envelope (IAM, triggers, config); application code is deployed separately via AWS CLI or CI.

## Future Improvement

Consider adding a GitHub Actions workflow to automate cron lambda deployments when code changes are pushed to a `lambda/` directory. This would replace the manual AWS CLI process.
