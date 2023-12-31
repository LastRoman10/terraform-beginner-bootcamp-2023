module "terrahouse_aws" {
    source = "./modules/terrahouse_aws"
    user_uuid = var.user_uuid
    bucket_name = var.bucket_name
    index_html_filepath= var.index_html_filepath 
    error_html_filepath= var.error_html_filepath
    content_version = var.content_version
}

resource "terratowns_home" "home" {
  name = "How to play Arcanum in 2023"
  description = <<DESCRIPTION
Arcanum is a game from 2001 that shipped with alot of bugs.
Modders have removed all the originals making this game really fun
to play (despite that old look graphics). This is my guide that will
show you how to play arcanum without spoiling the plot.
DESCRIPTION
  domain_name = module.terrahouse_aws.cloudfront_url
  # domain_name = "4esrgbv.cloudfront.net"
  town = "missingo"
  content_version = 1
}

