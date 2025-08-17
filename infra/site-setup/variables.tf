variable "aws_profile" {
  type    = string
  default = "my-personal-sso"
}

variable "role_path" {
  description = "(Optional) Path for the created role, requires `repo` is set."
  type        = string
  default     = "/github-actions/"
}
