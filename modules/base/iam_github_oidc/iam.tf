data "aws_iam_policy_document" "mini-site_policy_statement" {
  statement {
    sid = "FrontendS3access"

    actions = [
      "s3:*",
      "cloudfront:*",
      "ecr:*",
      "lambda:*",
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
#   statement {
#     sid = "ReadWrite"

#     actions = [
#       "ecr:BatchGetImage",
#       "ecr:BatchCheckLayerAvailability",
#       "ecr:GetRepositoryPolicy",
#       "ecr:DescribeRepositories",
#       "ecr:DescribeImages",
#       "ecr:InitiateLayerUpload",
#       "ecr:UploadLayerPart",
#       "ecr:CompleteLayerUpload",
#       "ecr:PutImage",
#     ]
#     resources = ["arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/${var.aws_app_name}/*"]

#     condition {
#       test     = "StringEquals"
#       variable = "aws:ResourceTag/allow-gh-action"

#       values = ["true"]
#     }
#  }
#   statement {
#     sid = "Frontendcloudfront"

#     actions = [
#       "cloudfront:*",
#     ]

#     resources = [var.cloudfront_arn]
#   }
}

resource "aws_iam_role_policy" "mini_site_policy" {
  for_each = module.github_actions_repo

  name = "mini-site-policy"
  role = each.value.role.name

  policy = data.aws_iam_policy_document.mini-site_policy_statement.json
}