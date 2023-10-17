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

The example below soucres the module locally

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
