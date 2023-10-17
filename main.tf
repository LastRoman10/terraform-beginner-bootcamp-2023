## In the terraform block we specify the provider we require

terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}


## In the provider block we specify the configurations for the provider we chose. It's we optional

provider "random" {
  # Configuration options
}


resource "random_string" "bucket_name" {
  length           = 16
  
}

output "random_bucket_name" {
    value = random_string.bucket_name.id
}