module "github_actions_oidc_provider" {
  source  = "philips-labs/github-oidc/aws//modules/provider"
  version = "~> 0.8.1"
}

module "github_actions_repo" {
  source  = "philips-labs/github-oidc/aws"
  version = "~> 0.8.1"

  for_each = var.github_repos

  openid_connect_provider_arn = module.github_actions_oidc_provider.openid_connect_provider.arn
  repo                        = each.value.github_repo
  role_name                   = each.value.role_name
  role_path                   = each.value.role_path
  role_permissions_boundary   = each.value.role_permissions_boundary
  default_conditions          = ["allow_environment", "allow_main"]
  github_environments         = each.value.github_environments
  

  conditions = (length(each.value.github_branches) != 0) ? [
    {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = concat([for branch in each.value.github_branches : "repo:${each.value.github_repo}:ref:refs/heads/${branch}"], ["repo:${each.value.github_repo}:pull_request"])
    },
  ] : []
}