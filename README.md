# pagoPA platform

This repo template allows you to create a repo for your project pipelines

## How to use this template

You need to create before in infra this resources:

* vm agent
* key vault

You need to add to the key vault at least this secrets:

* azure-devops-github-ro-TOKEN
* azure-devops-github-pr-TOKEN
* azure-devops-github-EMAIL
* azure-devops-github-USERNAME
* le-private-key-json
* le-regr-json

## Github bot

Use your github bot to generate the token to interact with your repo.

And don't forgot to associate to your repo as ADMIN, without this is impossibile to use the pipelines

## Change values in this files

Change the values in this files

### azure-devops/.env/prod-backend.ini

Put the name of your production subscription

### azure-devops/.env/terraform.tfvars

Change the project prefix and the names of your subscriptions

### azure-devops/.env/(app | iac)_state.tfvars

Change the information about the state, changed the `prefix` with the prefix of your project used into the infra project.
(e.g. selc or dvopla)

## terraform.sh

To be able to launch terraform scripts you can use the script called `terraform.sh`

To launch the app pipelines use

```sh
sh terraform.sh apply app
```

To launch the iac pipelines use

```sh
sh terraform.sh apply iac
```

## Precommit check

Check your code before commit.

<https://github.com/antonbabenko/pre-commit-terraform#how-to-install>

```sh
pre-commit run -a
```

## Terraform lock.hcl

We have both developers who work with your Terraform configuration on their Linux, macOS or Windows workstations and automated systems that apply the configuration while running on Linux.
<https://www.terraform.io/docs/cli/commands/providers/lock.html#specifying-target-platforms>

So we need to specify this in terraform lock providers:

```sh
terraform init

rm .terraform.lock.hcl

terraform providers lock \
  -platform=windows_amd64 \
  -platform=darwin_amd64 \
  -platform=darwin_arm64 \
  -platform=linux_amd64
```
