# output "bucket_name" {
#     value = random_string.bucket_name.result
# }

# output "bucket_name" {
#     value = aws_s3_bucket.example
# }

### This outputs the full details of the bucket
output "bucket_name" {
    value = aws_s3_bucket.website_bucket
}

### This outputs the bucket name only, it's an attribute os the s3 resource
output "bucket_name" {
    value = aws_s3_bucket.website_bucket.bucket
}