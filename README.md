# Terraform Beginner Bootcamp 2023

## Semantic Versioning
This Project will utilize semantic versioning for it's tagging
[semver.org](https://semver.org/)

The General Format:

**MAJOR.MINOR.PATCH**, e.g `1.0.1`

- **MAJOR** version when you make incompatible 
- **MINOR** version when you add functionality in a backward compatible manner

## Install the Terraform CLI

### Considerations to the terraform CLI changes

The terraform installation commands have been updated to reflect the more recent commands and solve the issue of incomplete installation as a result of prompts for user inputs.  

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

## Refactoring into Bash scripts

The updated Terraform CLI installation commands were refactored into a bash script. 
- This will improve efficiency 
- Allow portability for other projects 
- Keep the ([.gitpod.yml](.gitpod.yml)) file clean and tidy.

The bash script is located at: [./bin/install_terraform_cli](./bin/install_terraform_cli)

### Linux Permissions Considerations

We need to make the script executable at the user mode, use the command:

```sh
sudo chmod 744 ./bin/install_terraform_cli
```
[Linux Permissions](https://en.wikipedia.org/wiki/Chmod)

### Gitpod Lifecycle (Before, Init, Command)

In the [.gitpod.yml](.gitpod.yml) file, we need to be careful when choosing which one of them to use, for example when `init` is used the commands will not rerun for an existing workspace, it `init` only runs the command for new workspaces consequently we edited the [.gitpod.yml](.gitpod.yml) and changed `init` to `Before`

[Gitpod workspaces documentation](https://www.gitpod.io/docs/configure/workspaces/tasks)



## Working with Env Vars

We can list out all Environmental Variables (Env Vars) using `env` command

#### Setting and Unsetting Env Vars

- In the terminal we can set an env var using `export HELLO='world'`

- In the terminal we can unset an env var using `unset HELLO`

- We can set an env var temporarily when just running a command eg. below:

```sh
HELLO='world' ./bin/print_hello_message
```
OR 

```sh
PROJECT_ROOT='/workspace/terraform-beginner-bootcamp-2023' ./bin/install_terraform_cli
```

#### Within a bash script we can set an env var without writing export eg.

```sh
#!/usr/bin/env bash
 
HELLO='world'

echo $HELLO
```

OR

```sh
#!/usr/bin/env bash
 
PROJECT_ROOT='/workspace/terraform-beginner-bootcamp-2023'

echo $PROJECT_ROOT

cd $PROJECT_ROOT

install ansible -y
```

#### You can also just use the `export` command to set the env var in the current terminal

```sh
export PROJECT_ROOT='/workspace/terraform-beginner-bootcamp-2023'
```

### Printing Env Vars

We can print an env var using `echo $HELLO` OR `echo $PROJECT_ROOT`

### Scoping of Env Vars

When you open a new bash terminal in VScode, this terminal is not aware of other
env vars set in another terminal.

If you want env vars to persist across all future bash terminals then you need to 
set the env vars in your bash profile

#### Persisting Env Vars in Gitpod

We can persist env vars in gitpod by storing them in Gitpod Secrets Storage

```sh
gp env HELLO='world'
```

The command above sends the env var to gitpod secrets. 

All future workspaces launched will set the env vars for all bash terminals in those
workspaces

You can also set env vars in the `.gitpod.yml` but this can only contain non-sensitive env-vars 


### AWS CLI Installation

The bash script [./bin/install_aws_cli](./bin/install_aws_cli) installs AWS CLI

[Getting Started with AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[AWS Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

You need to add your aaws crendentials, first go to AWS, create a user with admin privilges and create access keys. 

The configure your credentials as global env variables eg below:

```sh
gp env AWS_ACCESS_KEY_ID='AKIAIOSFODNN7EXAMPLE'
gp env AWS_SECRET_ACCESS_KEY='wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
gp env AWS_DEFAULT_REGION='us-west-2'
```

We can check if our AWS credentials is configured correctly using the comand below

```sh
aws sts get-caller-identity
```
If it is configured correctly you should get a json payload output like the one below:

```sh
{
    "UserId": "ANSJNJHWNDJNLSMC",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::12345678910:user/terraform"
}
```
## Terraform Baiscs

### Terraform Registry

Terraform sources it's providers and modules from the Terraform Registry which  is located at [registry.terraform.io](https://registry.terraform.io/)
 
- **Providers** is an interface to APIs that will allow you to create resources in terraform

- **Modules** are a way to make large amount of terraform, reusuable on the go, portable and sharable.


#### Terraform Init

We run terraform init at the start of a new project to download the necessary binaries for the  terraform providers required by the project

#### Terraform Plan

`terraform plan`

This will generate out a changeset about the state of our infrastructure and what will be changed. 

A changeset is a file that basically says this is your current state and here is what will be changed according to your instructions

We can output this changeset ie. "plan" to be passed to an apply, but often you canjust ignore outputting

#### Terraform Apply

`terraform apply`

This will run a plan and pass the changeset to be executed by terraform. Apply should prompt 
Yes or No.

Use `terraform apply --auto-approve` to bypass the prompt

#### Terraform Destroy

`terraform destroy`

This will destroy all the resources mapped in the state file.

### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers or modules 
that will be used by the project

The terraform Lock File **should be commited** to your version control system

### Terraform State Files


`.terraform.tfstate` contain information about the current state of your infrastructure.

This file **should not be commited** to your VCS as it contains sensitive data.

Losing this file means you won't know the state of your infrastructure 


`.terraform.tfstate.backup` is the previous state file state

### Terraform Directory

`.terraform` directory contains binaries of terraform providers

#### Issues with terraform cloud login and the gitpod workspace

Running `terraform login` does not work as expected in the gitpod VSCODE browser, you won't be able to generate an auth token. it returns the error

```sh
│ Error: Failed to retrieve token: interrupted
```

To solve this you have to manually generate the token here:

[Generate Token](https://app.terraform.io/app/settings/tokens?source=terraform-login)

Then create this file to store the token in the following directory:

`touch /home/gitpod/.terraform.d/credentials.tfrc.json`

Open the file created above

`open /home/gitpod/.terraform.d/credentials.tfrc.json`

Paste the following code inside the file, replace "YOUR_API_TOKEN" with the token you generated

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR_API_TOKEN"
    }
  }
}
```

Then Run `terraform init` and `terraform login` to successfully migrate your state file to Terraform cloud

The process above has been automated using a bash script [generate_tfrc_credentials](./bin/generate_tfrc_credentials)

#### Bash Script to SET alias tf='terraform'

Wrote a bash script with chatgpt that creates an alias `tf` for the command `terraform`