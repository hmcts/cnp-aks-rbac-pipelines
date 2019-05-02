#!/bin/bash
set -e

FLUX_GITHUB_FILE=${1}
WORK_FOLDER=${2:-.)}

kubectl -n admin delete secret flux-git-deploy || true
kubectl apply -f ${WORK_FOLDER}/${FLUX_GITHUB_FILE}
kubectl -n admin delete $(kubectl get pod -o name -l app=flux -n admin)