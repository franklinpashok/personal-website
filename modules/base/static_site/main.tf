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