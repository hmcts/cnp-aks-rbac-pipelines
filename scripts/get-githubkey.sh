#!/bin/bash
set -e

VAULT_NAME=$1

az keyvault secret download \
  --file flux_pk \
  --name flux-github-private-key \
  --encoding ascii \
  --vault-name ${VAULT_NAME}

kubectl -n admin delete secret flux-git-deploy || true

kubectl create secret generic flux-git-deploy \
  --from-file=identity=flux_pk \
  --namespace admin

kubectl -n admin delete $(kubectl get pod -o name -l app=flux -n admin)