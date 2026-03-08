data "aws_iam_policy_document" "gha_boundary_secure" {
  
  # 1. THE ALLOWED CEILING (Matches your current site policy)
  statement {
    sid    = "AllowDevOpsServices"
    effect = "Allow"
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
      "dynamodb:*",
      "bedrock:*",
      "iam:Get*",
      "iam:List*",
      "iam:PassRole"
    ]
    resources = ["*"]
  }

  # 2. ANTI-TAMPERING (Deny deleting/editing this boundary)
  statement {
    sid    = "DenyBoundaryModification"
    effect = "Deny"
    actions = [
      "iam:DeleteRolePermissionsBoundary",
      "iam:DeleteUserPermissionsBoundary",
      "iam:PutRolePermissionsBoundary",
      "iam:PutUserPermissionsBoundary"
    ]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/gha-permissions-boundary"]
  }

  # 3. NO SHADOW ADMINS (Force inheritance on new roles)
  statement {
    sid    = "ForceBoundaryInheritance"
    effect = "Deny"
    actions = ["iam:CreateRole"]
    resources = ["*"]
    condition {
      test     = "StringNotEquals"
      variable = "iam:PermissionsBoundary"
      values   = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/gha-permissions-boundary"]
    }
  }

# ---------------------------------------------------------
  # 4. CRITICAL DENY: Block expensive or sensitive global services
  # ---------------------------------------------------------
  statement {
    sid    = "DenyHighRiskServices"
    effect = "Deny"
    actions = [
      "ec2:*",
      "eks:*",
      "billing:*",
      "aws-portal:*",
      "account:*",
      "organizations:*"
    ]
    resources = ["*"]
  }
}

# Create the separate Boundary Policy resource
resource "aws_iam_policy" "gha_permissions_boundary" {
  name   = "gha-permissions-boundary"
  policy = data.aws_iam_policy_document.gha_boundary_secure.json
}