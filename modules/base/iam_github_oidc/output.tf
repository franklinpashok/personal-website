output "gh_action_iam_role" {
  description = "The created role for github actions that can be assumed for the configured repository."
  value       = values(module.github_actions_repo)[*].role
}

output "gh_action_iam_role_permission_boundary" {
  description = "The created role for github actions that can be assumed for the configured repository."
  value       = aws_iam_policy.gha_permissions_boundary
}