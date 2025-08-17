terraform { 
  cloud { 
    
    organization = "franklin-org" 

    workspaces { 
      name = "mini-site" 
    } 
  } 
}

provider "aws" {
  region  = "eu-central-1"
  profile = var.aws_profile
}