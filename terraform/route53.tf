# Hosted Zone Data Source

data "aws_route53_zone" "web_zone" {
  private_zone = false
  zone_id      = "Z029755811OS3QFPFETU7"
}
