# Document AI module - output definitions
output "s3_bucket_id" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.document_dropzone.id
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  value       = aws_dynamodb_table.ai_results.name
}

output "lambda_role_arn" {
  description = "The ARN of the IAM role created for the Lambda function"
  value       = aws_iam_role.lambda_ai_role.arn
}