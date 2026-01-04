module "my_personal_website" {
  source = "../../modules/base/static_site/"

  bucket_name        = "franklinpulltikurthi-personal-website"
  bucket_domain_name = module.my_personal_website.s3_bucket_bucket_domain_name
  acm_domain_name    = data.aws_route53_zone.personal_website.name
  route53_zone_id    = data.aws_route53_zone.personal_website.zone_id
  aws_region         = data.aws_region.current.id
  #web_acl_id         = module.waf_cloudfront.arn

  providers = {
    aws.us-east-1 = aws.us-east-1
  }
}