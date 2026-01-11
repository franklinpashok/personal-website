# 1. Create the Validation Record in your Manual Zone We iterate over the validation options output by the inner ACM module.
resource "aws_route53_record" "validation" {
  provider = aws.us-east-1
  for_each = {
    for dvo in aws_acm_certificate.personal_website.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53_zone_id
}

# Create the Alias record in Route53
resource "aws_route53_record" "website_alias" {
  provider = aws.us-east-1 # Use the provider that has access to Route53

  zone_id = var.route53_zone_id
  name    = var.acm_domain_name
  type    = "A" # IPv4 Alias

  alias {
    # Reference the outputs from the module
    name                   = module.personal_website.cloudfront_distribution_domain_name
    zone_id                = module.personal_website.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = false
  }
}

# The WWW record
resource "aws_route53_record" "www" {
  zone_id = var.route53_zone_id
  name    = "www.franklinpulltikurthi.com"
  type    = "A"

  alias {
    # Reference the module outputs here
    name                   = module.personal_website.cloudfront_distribution_domain_name
    zone_id                = module.personal_website.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = false
  }
}