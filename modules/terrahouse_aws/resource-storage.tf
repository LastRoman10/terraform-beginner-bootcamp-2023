terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

locals {
  files = fileset("${path.root}/public/assets", "*")
}

# Create s3 Bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name

  tags = {
    user_uuid       = var.user_uuid
  
  }
 
}

# Enable s3 static website hosting on s3 bucket created above

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}


# Upload index.html file to bucket above
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html" 
  source = var.index_html_filepath
  content_type = "text/html"
  
  etag = filemd5(var.index_html_filepath)
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output] 
    ignore_changes = [ etag ]
  }
}

# Upload error.html file to bucket above
resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "error.html" 
  source = var.error_html_filepath
  content_type = "text/html"

  etag = filemd5(var.error_html_filepath)
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity 
data "aws_caller_identity" "current" {}

resource "terraform_data" "content_version" {
  input = var.content_version
}




resource "aws_s3_object" "Upload_using_for_each" {
  for_each = local.files

  bucket = aws_s3_bucket.website_bucket.id
  key    = each.value
  source = "${path.root}/public/assets/${each.value}"

  etag = filemd5("${path.root}/public/assets/${each.value}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output] 
    ignore_changes = [ etag ]
  }
}

# ANOTHER WAY TO DO THIS IS BELOW:
# Here you don't need to set the local variable setting the file path, you just give the file path directly
# resource "aws_s3_object" "Upload_using_for_each" {
#   for_each = fileset("${path.root}/public/assets", "*.{jpg,png,gif}") or
#   #for_each = fileset("${path.root}/public/assets", "*") or
    #for_each = fileset("var.assets_path", "*")

#   # bucket = aws_s3_bucket.website_bucket.id
#   # key    = "assets/${each.key}"
#   # source = "${var.assets_path}/${each.key}"
#   # etag = filemd5("${var.assets_path/${each.key}")
#   # lifecycle {
#   #   replace_triggered_by = [terraform_data.content_version.output] 
#   #   ignore_changes = [ etag ]
#   # }
# }
