#!/bin/bash
set -ex

ENV=$1
CLUSTER_NAME=$2
VAULT_NAME=$3
HELM_REPO=https://charts.fluxcd.io
VALUES=deployments/fluxcd/values.yaml
FLUX_HELM_CRD=https://raw.githubusercontent.com/fluxcd/helm-operator/chart-0.7.0/deploy/flux-helm-release-crd.yaml

helm repo add fluxcd ${HELM_REPO}


helm upgrade flux fluxcd/flux --install --namespace admin -f ${VALUES} --version 1.1.0 --set image.tag=1.17.1 \
    --set "git.path=k8s/${ENV}/common\,k8s/${ENV}/${CLUSTER_NAME}\,k8s/${ENV}/${CLUSTER_NAME}-overlay\,k8s/common",git.label=${ENV},git.email=flux-${ENV}@hmcts.net,git.user="Flux ${ENV}" \
    --wait

kubectl apply -f ${FLUX_HELM_CRD}
kubectl -n admin delete secret flux-helm-repositories || true
helm upgrade flux-helm-operator fluxcd/helm-operator --install --namespace admin   -f  deployments/fluxcd/helm-operator-values.yaml --version 0.7.0 --wait
