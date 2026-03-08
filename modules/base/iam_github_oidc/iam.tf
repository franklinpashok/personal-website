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
      "ecr:*", 
      "dynamodb:*", # Required for the AI Memory Table
      "bedrock:*", # Required so Terraform can verify Bedrock access
      "iam:Get*",
      "iam:List*",
      "iam:PassRole"

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
  statement {
    sid = "IAMpermissionsforplanandapply"

    actions = [
      "iam:GetRole",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:ListPolicies",
      "iam:ListPolicyVersions",
      "iam:ListOpenIDConnectProviders",
      "iam:GetOpenIDConnectProvider",
      "iam:GetRolePolicy"
    ]

    resources = ["*"]
  }

# =========================================================
  # NEW: Securely scoped PassRole for the AI Worker
  # =========================================================
  statement {
    sid = "AllowPassingSpecificAIWorkerRole"
    actions = [
      "iam:PassRole"
    ]
    
    # SECURITY: Can only pass this exact role. No Admin roles allowed.
    resources = [
      "arn:aws:iam::*:role/serverless_ai_lambda_worker_role"
    ]
    
    # SECURITY: Can only allow to Lambda service.
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "mini_site_policy" {
  for_each = module.github_actions_repo

  name = "mini-site-policy"
  role = each.value.role.name

  policy = data.aws_iam_policy_document.mini-site_policy_statement.json
}