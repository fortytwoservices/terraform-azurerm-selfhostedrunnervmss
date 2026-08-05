.PHONY: docs test

docs:
	terraform-docs -c .terraform-docs.yml .
	cd examples/basic && terraform-docs -c ../.terraform-docs.yml .
	cd examples/advanced && terraform-docs -c ../.terraform-docs.yml .

test:
	terraform init
	terraform test
