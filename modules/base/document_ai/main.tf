# Document AI module - main configuration
# 1. S3 Dropzone (Private)
resource "aws_s3_bucket" "document_dropzone" {
  bucket        = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "secure_dropzone" {
  bucket                  = aws_s3_bucket.document_dropzone.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 2. DynamoDB Table (Memory)
resource "aws_dynamodb_table" "ai_results" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "DocumentId"

  attribute {
    name = "DocumentId"
    type = "S"
  }
}

# 3. Lambda Worker Role & Permissions
resource "aws_iam_role" "lambda_ai_role" {
  # MUST start with "serverless_ai_" to pass the OIDC security boundary
  name = "serverless_ai_lambda_worker_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "lambda_ai_policy" {
  name = "serverless_ai_worker_permissions"
  role = aws_iam_role.lambda_ai_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:GetObject"]
        Resource = "${aws_s3_bucket.document_dropzone.arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = aws_s3_bucket.document_dropzone.arn
      },
      {
        Effect = "Allow"
        Action = ["dynamodb:PutItem"]
        Resource = aws_dynamodb_table.ai_results.arn
      },
      {
        Effect = "Allow"
        Action = ["bedrock:InvokeModel", "bedrock:Converse"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup", 
          "logs:CreateLogStream", 
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}