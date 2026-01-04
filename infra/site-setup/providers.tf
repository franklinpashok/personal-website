terraform {
  cloud {

    organization = "franklin-org"

    workspaces {
      name = "mini-site"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
  #profile = var.aws_profile
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}