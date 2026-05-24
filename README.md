# DevOps for Developers Project 77

[![Actions Status](https://github.com/kekby/devops-for-developers-project-77/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/kekby/devops-for-developers-project-77/actions)

## Deployed Application

Redmine: https://example.com

## Description

The project provisions infrastructure in Yandex Cloud with Terraform and deploys Redmine to two application servers with Ansible. The application is available through an Application Load Balancer. PostgreSQL is provided by Yandex Managed Service for PostgreSQL, and Datadog is used for monitoring.

## Requirements

- Terraform
- Ansible
- Python 3
- make
- Yandex Cloud account and API token
- S3-compatible Yandex Object Storage bucket for Terraform remote state
- Datadog API key and application key
- Domain name delegated to Yandex Cloud DNS
- SSH public key on the local machine

## Project Structure

- `terraform/` - Terraform configuration for cloud infrastructure
- `ansible/` - Ansible playbook, roles requirements, templates, group variables
- `ansible/playbook.yml` - main Ansible playbook
- `Makefile` - commands for infrastructure and application deployment

## Prepare Configuration

Create local secret files from templates:

```bash
make secrets
```

Fill Terraform backend settings in `terraform/secrets.backend.tfvars`:

```hcl
bucket            = "your remote state bucket"
access_key        = "your object storage access key"
secret_key        = "your object storage secret key"
dynamodb_endpoint = "your lockbox endpoint"
dynamodb_table    = "your lock table"
```

Fill Terraform secret variables in `terraform/secrets.auto.tfvars`:

```hcl
yc_token        = "your yandex cloud token"
yc_folder_id    = "your yandex cloud folder id"
db_name         = "redmine"
db_user         = "redmine"
db_password     = "your database password"
datadog_api_key = "your datadog api key"
datadog_app_key = "your datadog app key"
datadog_api_url = "https://api.datadoghq.eu/"
```

Update public settings in `terraform/config.auto.tfvars`:

```hcl
yc_zone           = "ru-central1-d"
yc_os_image_id    = "fd8498pb5smsd5ch4gid"
local_ssh_path    = "~/.ssh/id_ed25519.pub"
vm_admin_username = "poweruser"
domain_address    = "example.com"
```

Put the Ansible Vault password into `ansible/vault-key`. The generated file `ansible/group_vars/webservers/vault.yml` contains sensitive data and is encrypted automatically by `make ans-generate-vars`.

Local files with secrets, generated inventory, Terraform state, and Vault password are ignored by Git.

## Deploy Infrastructure

Initialize Terraform:

```bash
make tf-init
```

Apply Terraform configuration:

```bash
make tf-apply
```

Generate Ansible inventory and encrypted variables from Terraform outputs:

```bash
make ans-generate-vars
```

The command creates:

- `ansible/inventory.ini`
- encrypted `ansible/group_vars/webservers/vault.yml`

## Deploy Application

Install Ansible role dependencies:

```bash
make ans-install-requirements
```

Run the playbook:

```bash
make ans-deploy
```

Full deployment can be started with one command after the secret files are filled:

```bash
make deploy
```

## Useful Commands

Show Terraform outputs:

```bash
make tf-output
```

Edit encrypted Ansible variables:

```bash
make vault-edit
```

Destroy cloud infrastructure:

```bash
make tf-destroy
```
