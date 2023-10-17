# Terraform Beginner Bootcamp 2023 Week1

## Root Module Structure
Our root module structure is:
```
PROJECT.ROOT
|
. 
├── README.md   		# required for root modules
├── main.tf   		 	# Everything else
├── providers.tf 		# Define the required providers and their respective configurations
├── variables.tf		# Stores the structure of input variables
├── outputs.tf			# Stores the outputs
└── terraform.tfvars	# The data if variables we want to load into our configuration
```
[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure) 

## Terraform Variables

### Terraform Cloud Variables

In terraform cloud we cat set 2 kinds of variables

- Environment variables
- Terraform variables

The former is those you will set in your bash terminal e.g your AWS credentials while the latter
are those you will set in your terraform.tfvars file.

You have the option to set them to be sensitive so their values are not shown in the UI

### Loading Terraform variables

We are use the `var` flag to set an input variable or override a variable set in the
terraform.tfvars file e.g
```sh
terraform plan -var <variable name>='variable value'

terraform plan -var user_uuid='my_user_uuid'
```

terraform plan -var <variable name>='variable value'

### terraform.tfvars

This is the default file where the variables are stored, terraform loads this file
as the default variable file

### var-file flag

This flag is used to specify variable-definition file when running a command
variable definitions file (with a filename ending in either .tfvars or .tfvars.json) may
contain lots of mapped variables and their values. The -var-file flag is used to specify 
the file on the command line

```sh
terraform apply -var-file="testing.tfvars"
```


### auto.tfvars

The auto.tfvars file provides a convenient place to override variable values without specifying them at the command line.

In terraform variables can be set in more than one way, Terraform loads the `.auto.tfvars or *.auto.tfvars.json` when terraform apply or terraform plan command is run, the values of variables set in this takes precedence over the same variables if they are set anywhere else bar on the command line


### Order of terraform variables, which one takes precedence

The order of precedence which Terraform loads variables is in the following order:

- Any -var and -var-file options on the command line, in the order they are provided.
- Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
- The terraform.tfvars.json file, if present.
- The terraform.tfvars file, if present.
- Environment variables

## Dealing with Configuration Drifts

### Terraform State file 

Explore the state file and looked at a scenario where your state file is deleted. The command
`terraform state list` lists all the resources currently in the state file

## Terraform Imports

[terraform import](https://developer.hashicorp.com/terraform/cli/import)

This is one of the ways to deal with a scenario where the state file is deleted or the case of missing resources.
You can fix missing resources with terraform import

```sh
terraform import aws_s3_bucket.bucket bucket-name
```

Terraform import doesn't work for all cloud resources so you need to check the providers documentation to see which resource supports import

## Terraform Module Structure

[Module](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

It's recommended to place modules in a `module` directory when locally developing modules.

A terraform module usually looks like this"

```sh
tree module/

├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
```

### Module Sources and Passing Input Variables

We created a module and moved all the configurations to the module, How do we reference this module on the top level? you import the module i.e sourcing the module on the top-level main.tf

You can pass in input variables when you import the module, but these variables should already be defined in the module i.e in the module's variable.tf file

Using the `source` we can import the module from various places e.g
- Locally
- Github
- Terraform registry

The example below soucres the module locally in the top level main.tf file

```
module "terrahouse_aws" {
    source = "./modules/terrahouse_aws"
    user_uuid = var.user_uuid
    bucket_name = var.bucket_name
 }
```

### Nested Module
What we have achieved is a nested Module, a module nested within a project, that is why to access the variables in the nested module we had to reference it from the top level's variable.tf file even though the variables are already defined in the module's variables.tf file

The same with outputs, you reference the outputs defined in the nested module's output.tf file at the top level outputs.tf. Kinda like duplicating it

#### Below are examples of both files:

-  nested module's variable.tf file:
```t
output "bucket_name" {
    value = aws_s3_bucket.website_bucket.bucket
}
```

- top level outputs.tf file

```t
output "bucket_name" {
    value = module.terrahouse_aws.bucket_name
}
```

## Working with files in Terraform

### Special Path Variable

There is a special variable in terraform called `path` that allows us to reference path:
- path.module : Get path to the current module
- path.root : Get the path of the root module/root of the project

[special path variable](https://developer.hashicorp.com/terraform/language/expressions/references)

An example of how the `path.root` is used below, it's a terraform configuration to upload an index.html file to a s3 bucket, the `path.root module` is used to specify thw relative path of the index.html file 

```
# Upload index.html file to bucket above

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html" 
  source = "${path.root}/public/index.html"
  etag = filemd5("${path.root}/public/index.html")
}
```

Another way to achieve this is to set the path as a variable.
- You declare the variable in the variable.tf file of the nested module
- You declare the variable in the top-level variable.tf file
- You define the variable in the vairable.tfvars file
- You call the variable when you are importing/sourcing the module in the top-level main.tf file

```
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html" 
  source = var.index_html_filepath
  
  etag = filemd5(var.index_html_filepath)
}
```

### filemd function

filemd is a variant of md5 that hashes the content of a given file rather than a literal string. An example is the `etag` seen below that turns the contents of the index.html file into a hash. If the file is edited and you run `terraform apply` terraform would then be recreate the resource, if you take out the etag in the resource above, it won't matter the number of times you edit the contents of the index.html file,  terraform won't pick it up and recreate the resource as it's state file merely checks for the existence of the resource.

```
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html" 
  source = var.index_html_filepath
  
  etag = filemd5(var.index_html_filepath)
}
```

### Fileexists function

https://developer.hashicorp.com/terraform/language/functions/fileexists

This is a built-in terraform function to check the existence of a file. An example is checking the existence of the index.html file to be uploaded to the s3 bucket.

```
variable "index_html_filepath" {
  type        = string
  
  validation {
    condition     = fileexists(var.index_html_filepath)
    error_message = "The specified index.html file path is not valid"
  }
}

```

## Local Values

A local value assigns a name to an expression, so you can use the name multiple times within a module instead of repeating the expression.
They are alsp useful when we need to transform data into another format and have it referenced as a variable
[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

```tf
locals {
  s3_origin_id = "myS3Origin"
}

```

## Terraform Datasources

This allows us to source data from cloud resources. This is useful when we want to reference cloud resources without importing them

```
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```
[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

## Lifecycle

This controls when a resource gets created, destroyed and updated, in the example below we used the argument `ignore_changes` and gave the value `etag`. Thus whereas before any change to our index.html document is detected by the etag and an update of the document is triggered when we run `terraform apply`, this will not be the case as we added the `lifecycle` command and set the `ignore_changes` argument to `etag`

```
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html" 
  source = var.index_html_filepath
  content_type = "text/html"
  
  etag = filemd5(var.index_html_filepath)
  lifecycle {
    ignore_changes = [ etag ]
  }
}

```

[Lifecycel](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

## Terraform Data

[Terrafrom data](https://developer.hashicorp.com/terraform/language/resources/terraform-data)


Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement. A scenario is explained below where the `terraform data` is used to trigger changes to resources :

- Create the resource `terraform_data` with `input = content_version`

```
resource "terraform_data" "content_version" {
  input = var.content_version
}
```

- Define a variable called content_version in your terraform.tfvars
```
content_version =1
```

- Declare the variable `content_version` in both the modules' `variable.tf` file and the top level `variable.tf` file as shown respectively below

```
variable "content_version" {
  type        = number
 

  validation {
    condition     = var.content_version > 0 && can(regex("^\\d+$", tostring(var.content_version)))
    error_message = "The content version must be a positive integer"
  }
}
```

```
variable "content_version" {
  type        = number
}
```

- Reference the variable when importing the module in the Top level `main.tf` file

```
module "terrahouse_aws" {
    source = "./modules/terrahouse_aws"
    user_uuid = var.user_uuid
    bucket_name = var.bucket_name
    index_html_filepath= var.index_html_filepath 
    error_html_filepath= var.error_html_filepath
    content_version = var.content_version
}
```
- Update the Resource configuration where `terraform_data` will be used to trigger changes

```
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
```
With the confifuration above, changes to the index.html file will not be triggered when you run `terraform apply`, only when you update the `content_version= 2` or a higher number in the `terraform.tfvars` file will terraform update the changes 

## Provisioners

[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

Provisioners allow you to execute commands on compute instances, say you want to do something like `invalidate cache`, terraform doesn't have a particular provision for this, a workaround is to find a way to execute the command locally on your server to invalidate cache or remotely. Provisioners allow you to do this, they allow you execute commands on your `AWS CLI`.

Hashicopr does not recommend you do this, config management tools liks ansible takes care of thid quite easily.

Provisioners can be placed inside a resource so they happen as part of the resource. e.g below:

```tf
resource "aws_cloudfront_distribution" "s3_distribution" {
  # 

  provisioner "local-exec" {
    command = "aws cloudfront create-invalidation --distribution-id ${self.id} --paths '...'"
  }
}

```
But in our case we want the provisioner to be triggered by something else i.e by a trigger in change in the `content_version`

```tf
resource "terraform_data" "invalidate_cache" {
  triggers_replace = terraform.data.content_version.output

  provisioner "local-exec" {
    command << EOT
"aws cloudfront create-invalidation \
--distribution-id ${self.id} \
--paths '...'"
	EOT
  }
}

```

### Local_exec

This will execute the commands locally on the machine running the terraform commands e.g  `terraform plan, terrform apply`

### Remote_exec

This will execute the commands on a server that you target, you will need to provide credentials to access the server though e.g ssh

### File Provisioner

[file provisioner](https://developer.hashicorp.com/terraform/language/resources/provisioners/file)

The file provisioner copies files or directories from the machine running Terraform to the newly created resource. The file provisioner supports both ssh and winrm type connections.

## For each Expressions

[For each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)

Allows us enumerate over complex data types. The `for each` is very useful when you want to create multiples of a terraform resource. Example is seen below where we want to upload multiple files to our s3 bucket. 

The first block of code is the skeleton while the 2nd block is our code that uploads multiple files 

#### Skeleton
```tf
resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"
  acl    = "private"
}

locals {
  files = fileset("path/to/files", "*")
}

resource "aws_s3_bucket_object" "example_object" {
  for_each = local.files

  bucket = aws_s3_bucket.example_bucket.id
  key    = each.value
  source = "path/to/files/${each.value}"
}

```
#### Our code
```tf
locals {
  files = fileset("${path.root}/public/assets", "*")
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
```

#### Pro-Tip
You can set a variable for the assets path (check out how we did same for the variable `content_version` in line 291), check the commented out code in the module's resource-storage.tf file to see how the variable is referenced:

```sh
assets_path= "/workspace/terraform-beginner-bootcamp-2023/public/assets/"
```