# ============================================
# SES - Simple Email Service
# ============================================

# Domain identity for SES
resource "aws_ses_domain_identity" "xomify" {
  domain = local.domain_name
}

# DKIM for better deliverability
resource "aws_ses_domain_dkim" "xomify" {
  domain = aws_ses_domain_identity.xomify.domain
}

# Domain verification (you'll need to add these DNS records)
resource "aws_ses_domain_identity_verification" "xomify" {
  domain = aws_ses_domain_identity.xomify.id

  depends_on = [aws_ses_domain_identity.xomify]
}

# Email identity (specific from address)
resource "aws_ses_email_identity" "wrapped" {
  email = var.from_email
}