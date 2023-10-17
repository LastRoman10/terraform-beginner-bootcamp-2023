locals {
  s3_origin_id = "myS3Origin"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control
resource "aws_cloudfront_origin_access_control" "default" {
  name  = "OAC ${var.bucket_name}"
  description= "OAC for cloudfront for ${var.bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "static website hosting for ${var.bucket_name}"
  default_root_object = "index.html"


  # aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    user_uuid= var.user_uuid
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy

resource "aws_s3_bucket_policy" "bucket_policy_for_cloudfront" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsonencode({
     "Version"= "2012-10-17",
    "Statement"= {
        "Sid"= "AllowCloudFrontServicePrincipalReadOnly",
        "Effect"= "Allow",
        "Principal"= {
            "Service"= "cloudfront.amazonaws.com"
        },
        "Action"= "s3:GetObject",
        "Resource"= "arn:aws:s3:::${aws_s3_bucket.website_bucket.id}/*",
        "Condition"= {
            "StringEquals"= {
                "AWS:SourceArn"= "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id }"
            }
        }
    }
    
  })
}

# https://developer.hashicorp.com/terraform/language/expressions/strings

resource "terraform_data" "invalidate_cache" {
  triggers_replace = terraform_data.content_version.output

  provisioner "local-exec" {
    command = <<EOT
aws cloudfront create-invalidation \
--distribution-id ${aws_cloudfront_distribution.s3_distribution} \
--paths '/*'
	  EOT
  }
}
 