#!/bin/bash
set -e

RESOURCE_GROUP_NAME=$1
STORAGE_ACCOUNT_NAME=$2
VAULT_NAME=$3

# Create an azure file share for NeuVector persistent storage
CONNECTION_STRING=$(az storage account show-connection-string -n ${STORAGE_ACCOUNT_NAME} -g ${RESOURCE_GROUP_NAME} --query 'connectionString' -o tsv)
az storage share create --name neuvector-data --quota 1 --connection-string ${CONNECTION_STRING}

az keyvault secret set \
 --vault-name ${VAULT_NAME} \
 --name "sa-connection-string" \
 --value ${CONNECTION_STRING} \
 --description "Infra storage account connection string"