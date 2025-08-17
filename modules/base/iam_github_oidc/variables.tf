variable "github_repos" {
  description = "GitHub repositories to grant access to assume a role via OIDC."
  type = map(
    object({
      github_repo         = string
      github_branches     = list(string)
      github_environments = list(string)
      # Custom Role name. It will autocreate based on repo if not provided
      role_name = string
      role_path = string
    })
  )
}

variable "aws_app_name" {
  description = "App name given from local variables"
  type        = string
}