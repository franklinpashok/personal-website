data "aws_route53_zone" "selected" {
  name         = "franklinpulltikurthi.com"
  private_zone = false
}

data "aws_region" "current" {}