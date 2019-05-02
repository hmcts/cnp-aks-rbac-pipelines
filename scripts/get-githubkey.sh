#!/bin/bash
set -e

FLUX_GITHUB_FILE=${1}
TEMP_FOLDER=${2:-$(Agent.TempDirectory)}

kubectl -n admin delete secret flux-git-deploy || true
kubectl apply -f ${TEMP_FOLDER}/${FLUX_GITHUB_FILE}
kubectl -n admin delete $(kubectl get pod -o name -l app=flux -n admin)