data "aws_route53_zone" "personal_website" {
  name         = var.acm_domain_name
  private_zone = false
}

data "aws_region" "current" {}