terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
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
  
  etag = filemd5(var.index_html_filepath)
}

# Upload error.html file to bucket above
resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "error.html" 
  source = var.error_html_filepath

  etag = filemd5(var.error_html_filepath)
}

