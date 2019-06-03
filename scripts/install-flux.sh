#!/bin/bash
set -ex

ENV=$1
CLUSTER_NAME=$2
VAULT_NAME=$3
ENABLE_HELM_TLS=${4:false}
GIT_REPO=${5:-https://weaveworks.github.io/flux}
VALUES=${6-deployments/weave-flux/values.yaml}

helm repo add weaveworks ${GIT_REPO}

if [[ ${ENABLE_HELM_TLS} == true ]]
then
 az keyvault secret download --vault-name ${VAULT_NAME} --encoding ascii --name helm-pki-flux-secret --file helm-client-certs.yaml
 kubectl apply -f helm-client-certs.yaml
 params+=(--tls --tls-verify --tls-ca-cert ca.cert.pem --tls-cert helm.cert.pem --tls-key helm.key.pem  --set helmOperator.tls.caContent="$(cat ca.cert.pem)" )
fi

helm upgrade flux weaveworks/flux --install --namespace admin -f ${VALUES} \
    --set "git.path=k8s/${ENV}/common\,k8s/${ENV}/${CLUSTER_NAME}\,k8s/common",git.label=${ENV},git.email=flux-${ENV}@hmcts.net,git.user="Flux ${ENV}" \
    "${params[@]}"
    --wait