#!/bin/bash
set -e

REPOSITORIES_YAML=${1:-templates/repositories.yaml}

kubectl -n admin delete secret flux-helm-repositories || true
kubectl -n admin create secret generic flux-helm-repositories --from-file=${REPOSITORIES_YAML}