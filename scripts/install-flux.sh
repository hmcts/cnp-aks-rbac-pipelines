#!/bin/bash
set -e

CLUSTER_NAME=$1
GIT_REPO=${2:-https://weaveworks.github.io/flux}
VALUES=${3-deployments/weave-flux/values.yaml}

helm repo add weaveworks ${GIT_REPO}
helm upgrade flux weaveworks/flux --install --namespace admin -f ${VALUES} \
    --set "git.path=k8s/${CLUSTER_NAME}\,k8s/common",git.label=${CLUSTER_NAME} \
    --wait