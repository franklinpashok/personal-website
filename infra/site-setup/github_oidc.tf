module "github_oidc_provider" {
    source = "../../modules/base/iam_github_oidc"
    
    aws_app_name = local.app_metadata.name

    github_repos = {
        "mini-site" = {
        github_repo         = "franklinpashok/personal-website"
        github_branches     = ["main"]
        github_environments = ["prd", ]
        role_name           = null
        role_path           = var.role_path
        }
    }
}
