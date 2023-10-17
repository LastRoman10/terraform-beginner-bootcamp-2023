## In the terraform block we specify the provider we require

terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

terraform {
  cloud {
    organization = "Pauly_DevOps"

    workspaces {
      name = "TerraHouse-Red"
    }
  }
}

## In the provider block we specify the configurations for the provider we chose. It's we optional

provider "random" {
  # Configuration options
}


provider "aws" {
  # Configuration options
}
