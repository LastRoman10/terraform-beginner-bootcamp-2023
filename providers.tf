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
    endpoint = var.terrarowns_endpoint 
    //"https://terratowns.cloud/api"  
    user_uuid=var.user_uuid
    token=var.terratowns_access_token
  
}


