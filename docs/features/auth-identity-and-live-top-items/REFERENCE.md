# Reference: Auth Identity Hardening + Live `/user/top-items`

This repo (`xomify-infrastructure`) is part of a **5-repo epic**. The canonical plan lives at:

**`/Users/dom/Code/xomify-backend/docs/features/auth-identity-and-live-top-items/PLAN.md`**

Read that doc for full context. This file is a pointer + a list of sub-features that touch THIS repo.

## Sub-features in this repo

- **(0a-infra) `auth-login-route-and-lambda-resources`** — Bump `api-gateway-service` module ref to v2.3.0 in `terraform/api_gateway.tf`. Add `auth_login` lambda Terraform resource (mirror `lambdas_user.tf` patterns). Add `/auth/login` route to the appropriate `services` block with `authorization = "NONE"` (the new per-endpoint override). IAM policy for SSM secret read. CloudWatch log group.

- **(0b-infra) `authorizer-redeploy-with-claims`** — Ship the dual-mode authorizer change (claims-in-context + legacy-token shim) to AWS. May be a no-op Terraform change if deploy is artifact-driven via xomify-backend's CI; verify and update `lambda_authorizer.tf` if needed (e.g. `source_code_hash` bump).

- **(2a-infra) `top-items-cache-table-and-route`** — Add `TOP_ITEMS_CACHE` DDB table in `terraform/dynamodb.tf` (PK `email`, native TTL on `ttl` attr). Add `user_top_items` lambda resource in `terraform/lambdas_user.tf`. Add `/user/top-items` endpoint to the `user` service block (default `authorization = "CUSTOM"`). Env var `TOP_ITEMS_CACHE_TABLE_NAME`. IAM grants `GetItem` + `PutItem` on the new table.

## Hard prerequisite from another repo

- **(0-pre) `module-per-endpoint-auth-override`** ships in `api-gateway-service` first (release v2.3.0). Without it, this repo cannot expose a public `/auth/login` route — the current module applies `var.authorization` uniformly to every endpoint.

## Affected repos (full epic)

1. `xomify-backend` (Python lambdas) — canonical plan owner
2. `xomify-frontend` (Angular)
3. `xomify-ios` (Swift)
4. `xomify-infrastructure` (Terraform) — **this repo**
5. `api-gateway-service` (external Terraform module) — published from a separate GitHub repo, not locally cloned

## Status

Per-sub-feature status is tracked on **XomBoard (GitHub Project #2)** via per-repo issues. The canonical plan doc is the source of truth for design and dependencies.
