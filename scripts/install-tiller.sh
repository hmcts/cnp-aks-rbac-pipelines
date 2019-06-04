#!/bin/bash

CLUSTER_NAME=$1
HELM_VERSION=$2
HISTORY_MAX=${3:-5}
ENABLE_HELM_TLS=$4
RBAC_CONFIG=roles/helm-rbac-config.yaml

kubectl create -f ${RBAC_CONFIG}

if [[ ${ENABLE_HELM_TLS} == true ]]
then
 params+=(--tiller-tls --tiller-tls-cert ./tiller.cert.pem --tiller-tls-key ./tiller.key.pem --tiller-tls-verify --tls-ca-cert ./ca.cert.pem)
fi

helm init --wait --service-account tiller --tiller-image gcr.io/kubernetes-helm/tiller:v${HELM_VERSION} --history-max=${HISTORY_MAX} --kube-context ${CLUSTER_NAME}-admin "${params[@]}"