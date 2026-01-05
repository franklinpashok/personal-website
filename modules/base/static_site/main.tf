module "personal_website" {
  source  = "SPHTech-Platform/s3-cloudfront-static-site/aws"
  version = "1.0.1"

  bucket_name = var.bucket_name
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = ""
        sse_algorithm     = "AES256"
      }
    }
  }

  origin = {
    origin_access_control = {
      domain_name           = var.bucket_domain_name
      origin_access_control = "s3" # key in `origin_access_control`
      origin_shield = {
        enabled              = true
        origin_shield_region = var.aws_region
      }
    }
  }

  create_associate_function = var.create_associate_function

  domains = {
    mypersonalwebsite = {
      domain              = var.acm_domain_name
      create_acm_record   = false
      create_alias_record = false
      include_in_acm      = true
    }
  }

  create_certificate           = false
  existing_acm_certificate_arn = aws_acm_certificate_validation.personal_website.certificate_arn

  providers = {
    aws.us-east-1 = aws.us-east-1
  }

  web_acl_id = var.web_acl_id

  #Addition s3 policy if required to add to the existing policy deployed by module
  #policy = data.aws_iam_policy_document.s3_policy_thecarsexpo.json

}

# 1. Create Cert
resource "aws_acm_certificate" "personal_website" {
  provider          = aws.us-east-1
  domain_name       = var.acm_domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

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

# 2. Tell Terraform to Wait for Validation. This resource will pause the 'apply' until AWS confirms the cert is valid.
resource "aws_acm_certificate_validation" "personal_website" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.personal_website.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
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