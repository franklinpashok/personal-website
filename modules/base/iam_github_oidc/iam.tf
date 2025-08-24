data "aws_iam_policy_document" "mini-site_policy_statement" {
  statement {
    sid = "FrontendS3access"

    actions = [
      "s3:*",
      "cloudfront:*",
      "route53:*",
      "wafv2:*",
      "apigateway:*",
      "lambda:*",
      "logs:*",
      "events:*",
      "acm:*",
      "cloudwatch:*",
      "ecr:*"
    ]

    resources = ["*"]
  }
  statement {
    sid = "GetAuthorizationToken"

    actions = [
      "ecr:GetAuthorizationToken",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "gha_permissions_boundary" {
  name   = "gha-permissions-boundary"
  policy = data.aws_iam_policy_document.mini-site_policy_statement.json
}

resource "aws_iam_role_policy" "mini_site_policy" {
  for_each = module.github_actions_repo

  name = "mini-site-policy"
  role = each.value.role.name

  policy = data.aws_iam_policy_document.mini-site_policy_statement.json
}