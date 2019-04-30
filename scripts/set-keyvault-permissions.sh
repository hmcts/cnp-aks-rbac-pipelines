#!/bin/bash
set -e

KEYVAULT_NAME=$1
MI_PRINCIPAL_ID=$2        
        
az keyvault set-policy -n ${KEYVAULT_NAME} --object-id ${MI_PRINCIPAL_ID} --secret-permissions get list --certificate-permissions get list --key-permissions get list