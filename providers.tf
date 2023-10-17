## In the terraform block we specify the provider we require


# terraform {
#   cloud {
#     organization = "Pauly_DevOps"

#     workspaces {
#       name = "TerraHouse-Red"
#     }
#   }
# }

## In the provider block we specify the configurations for the provider we chose. It's we optional

terraform {
  required_providers {
    terratowns = {
        source = "local.providers/local/terratowns"
        version = "1.0.0"
    }
  }
}

provider "terratowns" {
    endpoint = "http://localhost:4567/api"  
    user_uuid="e328f4ab-b99f-421c-84c9-4ccea042c7d1" 
    token="9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
  
}