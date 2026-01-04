variable "aws_region" {
  default     = "ap-southeast-1"
  type        = string
  description = "AWS region"
}

variable "bucket_name" {
  description = "S3 bucket name for static site"
  type        = string
  default     = ""
}

variable "bucket_domain_name" {
  description = "S3 bucket domain name for static site"
  type        = string
  default     = ""
}

variable "acm_domain_name" {
  type        = string
  default     = ""
  description = "S3 bucket domain name for static site"
}

variable "web_acl_id" {
  description = "A unique identifier that specifies the AWS WAF web ACL, if any, to associate with this distribution. To specify a web ACL created using the latest version of AWS WAF (WAFv2), use the ACL ARN, for example aws_wafv2_web_acl.example.arn. To specify a web ACL created using AWS WAF Classic, use the ACL ID, for example aws_waf_web_acl.example.id. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned."
  type        = string
  default     = ""
}

# variable "domain_prefix" {
#   type        = string
#   default     = ""
#   description = "domain name for static site"
# }

variable "route53_zone_id" {
  description = "Zone ID for the manual Route53 zone"
  type        = string
  default     = ""
}