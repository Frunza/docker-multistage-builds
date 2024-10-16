#!/bin/sh

# Exit immediately if a simple command exits with a nonzero exit value
set -e

rm -rf terraform/.terraform
rm -f terraform/myLocalFile.yml
rm -f terraform/.terraform.lock.hcl
rm -f terraform/terraform.tfstate
