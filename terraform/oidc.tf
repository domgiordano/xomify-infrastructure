# =============================================================================
# OIDC Authentication: Terraform Cloud → AWS
# =============================================================================
#
# This project uses OIDC (OpenID Connect) to authenticate Terraform Cloud
# with AWS, eliminating the need for static IAM access keys.
#
# ── Manual AWS Setup Required ────────────────────────────────────────────────
#
# 1. Create an IAM OIDC Identity Provider:
#    - Provider URL: https://app.terraform.io
#    - Audience:     aws.workload.identity
#
# 2. Create an IAM Role with the following trust policy:
#
#    {
#      "Version": "2012-10-17",
#      "Statement": [
#        {
#          "Effect": "Allow",
#          "Principal": {
#            "Federated": "arn:aws:iam::<ACCOUNT_ID>:oidc-provider/app.terraform.io"
#          },
#          "Action": "sts:AssumeRoleWithWebIdentity",
#          "Condition": {
#            "StringEquals": {
#              "app.terraform.io:aud": "aws.workload.identity"
#            },
#            "StringLike": {
#              "app.terraform.io:sub": "organization:Domjgiordano:project:*:workspace:angular-spotify-infrastructure:run_phase:*"
#            }
#          }
#        }
#      ]
#    }
#
#    Attach the necessary IAM policies to this role (same permissions the
#    static IAM user previously had).
#
# 3. In Terraform Cloud workspace "angular-spotify-infrastructure":
#    - Remove variables: access_key, secret_key
#    - Add variable:     aws_role_arn = arn:aws:iam::<ACCOUNT_ID>:role/<ROLE_NAME>
#    - Add env variable: TFC_AWS_PROVIDER_AUTH = true
#    - Add env variable: TFC_AWS_RUN_ROLE_ARN  = arn:aws:iam::<ACCOUNT_ID>:role/<ROLE_NAME>
#
# Reference: https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/aws-configuration
# =============================================================================
