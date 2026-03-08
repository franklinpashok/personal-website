# Document AI module - variable definitions
variable "bucket_name" {
  type        = string
  description = "Globally unique name for the S3 document upload bucket."
}

variable "table_name" {
  type        = string
  description = "Name of the DynamoDB table to store AI results."
  default     = "DocumentAnalysisResults"
}