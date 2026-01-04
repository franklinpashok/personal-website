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

  domains = {
    mypersonalwebsite = {
      domain              = var.acm_domain_name
      create_acm_record   = false
      create_alias_record = false
      include_in_acm      = true
    }
  }

  providers = {
    aws.us-east-1 = aws.us-east-1
  }

  web_acl_id = var.web_acl_id

  #Addition s3 policy if required to add to the existing policy deployed by module
  #policy = data.aws_iam_policy_document.s3_policy_thecarsexpo.json

}

# 1. Create the Validation Record in your Manual Zone
# We iterate over the validation options output by the inner ACM module.
resource "aws_route53_record" "validation" {
  provider = aws.us-east-1
  # We loop through the domain validation options provided by the module output
  for_each = {
    for validation in module.personal_website.acm_certificate_domain_validation_options : validation.domain_name => {
      name   = validation.resource_record_name
      record = validation.resource_record_value
      type   = validation.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53_zone_id
}

# 2. Tell Terraform to Wait for Validation
# This resource will pause the 'apply' until AWS confirms the cert is valid.
resource "aws_acm_certificate_validation" "this" {
  provider = aws.us-east-1

  # Reference the ARN from the module
  certificate_arn = module.personal_website.acm_certificate_arn
  
  # Wait for the specific records we just created
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}