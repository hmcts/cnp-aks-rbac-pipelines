#!/bin/bash
set -ex

ENV=$1
CLUSTER_NAME=$2
VAULT_NAME=$3
ENABLE_HELM_TLS=$4
HELM_REPO=https://charts.fluxcd.io
VALUES=deployments/fluxcd/values.yaml
FLUX_HELM_CRD=https://raw.githubusercontent.com/fluxcd/helm-operator/chart-0.3.0/deploy/flux-helm-release-crd.yaml

helm repo add fluxcd ${HELM_REPO}

if [[ ${ENABLE_HELM_TLS} == true ]]
then
 az keyvault secret download --vault-name ${VAULT_NAME} --encoding ascii --name helm-pki-flux-secret --file helm-client-certs.yaml
 kubectl apply -f helm-client-certs.yaml
 helm_tls_params+=(--tls --tls-verify --tls-ca-cert scripts/ca.cert.pem --tls-cert scripts/helm.cert.pem --tls-key scripts/helm.key.pem  \
       --set tls.enable=true)
fi

kubectl apply -f ${FLUX_HELM_CRD}

helm upgrade flux fluxcd/flux --install --recreate-pods --namespace admin -f ${VALUES} --version 0.15.0 --set image.tag=1.16.0 \
    --set "git.path=k8s/${ENV}/common\,k8s/${ENV}/${CLUSTER_NAME}\,k8s/${ENV}/${CLUSTER_NAME}-overlay\,k8s/common",git.label=${ENV},git.email=flux-${ENV}@hmcts.net,git.user="Flux ${ENV}" \
    "${helm_tls_params[@]}" \
    --wait

helm upgrade helm-operator fluxcd/helm-operator --install --namespace admin   -f  helm/nonprod/helm-operator.yaml --version 0.3.0 --wait "${helm_tls_params[@]}"
