.PHONY: all init test fmt validate clean

all: init fmt validate test

init:
	terraform init

test:
	terraform test

fmt:
	terraform fmt -recursive

validate:
	terraform validate

clean:
	rm -rf .terraform .terraform.lock.hcl
