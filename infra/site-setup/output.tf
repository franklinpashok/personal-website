output "gha_role_arn" {
  value = module.github_oidc_provider["mini-site"].role.arn
}

output "website_certificate_arn" {
  description = "The ARN of the SSL Certificate for the website"
  value       = module.my_personal_website.acm_certificate_arn
}

output "website_validation_check" {
  description = "Status of the ACM Validation"
  value       = module.my_personal_website.acm_validation_status
}