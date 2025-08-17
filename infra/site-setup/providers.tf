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
  shared_credentials_files  = ["/home/franklin/.aws/config"]
  profile = var.aws_profile
}