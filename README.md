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

## Gitpod Lifecycle (Before, Init, Command)

In the [.gitpod.yml](.gitpod.yml) file, we need to be careful when choosing which one of them to use, for example when `init` is used the commands will not rerun for an existing workspace, it `init` only runs the command for new workspaces consequently we edited the [.gitpod.yml](.gitpod.yml) and changed `init` to `Before`

[Gitpod workspaces documentation](https://www.gitpod.io/docs/configure/workspaces/tasks)
