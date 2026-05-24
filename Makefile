TERRAFORM_DIR := ./terraform
ANSIBLE_DIR := ./ansible
VAULT_FILE := $(ANSIBLE_DIR)/group_vars/webservers/vault.yml
VAULT_PASSWORD_FILE := $(ANSIBLE_DIR)/vault-key

.PHONY: tf-init tf-apply tf-destroy tf-output secrets ans-generate-vars ans-install-requirements ans-deploy deploy-infra deploy-app deploy vault-edit vault-encrypt vault-decrypt

tf-init:
	terraform -chdir=$(TERRAFORM_DIR) init -backend-config=secrets.backend.tfvars

tf-apply:
	terraform -chdir=$(TERRAFORM_DIR) apply

tf-destroy:
	terraform -chdir=$(TERRAFORM_DIR) destroy

tf-output:
	terraform -chdir=$(TERRAFORM_DIR) output

secrets:
	cp $(TERRAFORM_DIR)/secrets-auto-template.tfvars $(TERRAFORM_DIR)/secrets.auto.tfvars
	cp $(TERRAFORM_DIR)/secrets-backend-template.tfvars $(TERRAFORM_DIR)/secrets.backend.tfvars
	cp $(ANSIBLE_DIR)/templates/vault-key-template $(VAULT_PASSWORD_FILE)

ans-generate-vars:
	test -f $(VAULT_PASSWORD_FILE)
	terraform -chdir=$(TERRAFORM_DIR) output -json | python3 scripts/generate_ansible_files.py --ansible-dir $(ANSIBLE_DIR)
	ansible-vault encrypt $(VAULT_FILE) --vault-password-file $(VAULT_PASSWORD_FILE)

ans-install-requirements:
	$(MAKE) -C $(ANSIBLE_DIR) install-ansible-requirements

ans-deploy:
	$(MAKE) -C $(ANSIBLE_DIR) deploy

deploy-infra: tf-init tf-apply ans-generate-vars

deploy-app: ans-install-requirements ans-deploy

deploy: deploy-infra deploy-app

vault-edit:
	$(MAKE) -C $(ANSIBLE_DIR) vault-edit

vault-encrypt:
	$(MAKE) -C $(ANSIBLE_DIR) vault-encrypt

vault-decrypt:
	$(MAKE) -C $(ANSIBLE_DIR) vault-decrypt
