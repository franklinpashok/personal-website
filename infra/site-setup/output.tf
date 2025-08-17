output "gha_role_arn" {
  value = module.github_oidc_provider.github_actions_repo["mini-site"].role.arn
}