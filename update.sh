#!/bin/bash

set -e

terraform destroy -target=azurerm_storage_blob.code-blob -auto-approve
./zip.sh
terraform apply -auto-approve
