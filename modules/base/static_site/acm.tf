# 1. Create Cert
resource "aws_acm_certificate" "personal_website" {
  provider          = aws.us-east-1
  domain_name       = var.acm_domain_name
  validation_method = "DNS"
  subject_alternative_names = ["www.franklinpulltikurthi.com"]
  lifecycle {
    create_before_destroy = true
  }
}

# 2. Tell Terraform to Wait for Validation. This resource will pause the 'apply' until AWS confirms the cert is valid.
resource "aws_acm_certificate_validation" "personal_website" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.personal_website.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
