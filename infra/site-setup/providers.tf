terraform { 
  cloud { 
    
    organization = "franklin-org" 

    workspaces { 
      name = "mini-site" 
    } 
  } 
}