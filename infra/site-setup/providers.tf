terraform { 
  cloud { 
    
    organization = "franklin-org" 

    workspaces { 
      name = "mini-site" 
    } 
  } 
}

provider "aws" {
  region  = "eu-west-1"
  profile = var.aws_profile
}