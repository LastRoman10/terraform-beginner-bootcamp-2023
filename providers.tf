## In the terraform block we specify the provider we require

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

# terraform {
#   cloud {
#     organization = "Pauly_DevOps"

#     workspaces {
#       name = "TerraHouse-Red"
#     }
#   }
# }

## In the provider block we specify the configurations for the provider we chose. It's we optional


provider "aws" {
  # Configuration options
}
