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

## In the provider block we specify the configurations for the provider we chose. It's we optional

provider "random" {
  # Configuration options
}


provider "aws" {
  # Configuration options
}



resource "random_string" "bucket_name" {
  lower = true
  upper = false
  length  = 16
  special = false
  
}

resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.result
 
}

output "random_bucket_name" {
    value = random_string.bucket_name.result
}

