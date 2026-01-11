variable "aws_profile" {
  type    = string
  default = "my-personal-sso"
}

variable "role_path" {
  description = "(Optional) Path for the created role, requires `repo` is set."
  type        = string
  default     = "/github-actions/"
}

variable "test" {
  description = "testing"
  type        = string
  default     = ""
}

variable "acm_domain_name" {
  type        = string
  default     = ""
  description = "doamin name"
}

variable "additional_domains" {
  type        = list
  default     = []
  description = "additional aliases"
}
