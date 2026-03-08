# 1. Package the Python file into a ZIP
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/template/lambda_function.py"
  output_path = "${path.module}/template/lambda_function.zip"
}

# 2. Create the Lambda Function
resource "aws_lambda_function" "doc_processor" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "ProcessAIDocument"
  
  # This uses the worker role you already created in main.tf
  role             = aws_iam_role.lambda_ai_role.arn
  
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  timeout          = 30
  
  # Re-deploys only if the Python code changes
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.ai_results.name
    }
  }
}

# 3. Give S3 permission to wake up the Lambda
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.doc_processor.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.document_dropzone.arn
}

# 4. Create the Event: Tell S3 to trigger Lambda on file upload
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.document_dropzone.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.doc_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}