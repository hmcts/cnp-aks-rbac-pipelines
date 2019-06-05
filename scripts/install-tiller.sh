#!/bin/bash

CLUSTER_NAME=$1
HELM_VERSION=$2
HISTORY_MAX=${3:-5}
ENABLE_HELM_TLS=$4
RBAC_CONFIG=roles/helm-rbac-config.yaml
#added for debugging
ls -lash
kubectl create -f ${RBAC_CONFIG}

#resetting tiller before installing it again
helm reset --force || helm reset --force --tls --tls-ca-cert scripts/ca.cert.pem --tls-cert scripts/helm.cert.pem --tls-key scripts/helm.key.pem || true

#adding sleep for init to work just after a reset
sleep 5s
if [[ ${ENABLE_HELM_TLS} == true ]]
then
 helm_tls_params+=(--tiller-tls --tiller-tls-cert scripts/tiller.cert.pem --tiller-tls-key scripts/tiller.key.pem --tiller-tls-verify --tls-ca-cert scripts/ca.cert.pem)
fi

helm init --wait --service-account tiller --tiller-image gcr.io/kubernetes-helm/tiller:v${HELM_VERSION} --history-max=${HISTORY_MAX} --kube-context ${CLUSTER_NAME}-admin "${helm_tls_params[@]}"
