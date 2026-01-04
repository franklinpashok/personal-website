output "s3_bucket_id" {
  description = "The name of the bucket."
  value       = module.personal_website.s3_bucket_id
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = module.personal_website.s3_bucket_arn
}

output "s3_bucket_bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com."
  value       = module.personal_website.s3_bucket_bucket_domain_name
}

output "cloudfront_distribution_id" {
  description = "The Arn of the cloudfront distribution"
  value       = module.personal_website.cloudfront_distribution_id
}

output "cloudfront_distribution_arn" {
  description = "The ARN (Amazon Resource Name) for the distribution."
  value       = module.personal_website.cloudfront_distribution_arn
}