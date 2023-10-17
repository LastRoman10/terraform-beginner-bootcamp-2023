output "bucket_name" {
    value = aws_s3_bucket.website_bucket.bucket
}

output "s3_website_endpoint" {
    value = aws_s3_bucket_website_configuration.static_website.website_endpoint
}

output "cloudfront_url" {
    value = aws_cloudfront_distribution.s3_distribution.domain_name
}