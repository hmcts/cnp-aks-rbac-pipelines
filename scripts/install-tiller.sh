#!/bin/bash
set -e

CLUSTER_NAME=$1
HELM_VERSION=$2
HISTORY_MAX=${3:-5}
RBAC_CONFIG=${4:-roles/helm-rbac-config.yaml}

kubectl apply -f ${RBAC_CONFIG}
helm init --wait --service-account tiller --tiller-image gcr.io/kubernetes-helm/tiller:v${HELM_VERSION} --history-max=${HISTORY_MAX} --kube-context ${CLUSTER_NAME}-admin
