data "aws_route53_zone" "personal_website" {
  name         = "franklinpulltikurthi.com"
  private_zone = false
}

data "aws_region" "current" {}