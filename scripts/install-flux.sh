#!/bin/bash
set -x

ENV=$1
CLUSTER_NAME=$2
GIT_REPO=${3:-https://weaveworks.github.io/flux}
VALUES=${4-deployments/weave-flux/values.yaml}

helm repo add weaveworks ${GIT_REPO}
helm upgrade flux weaveworks/flux --install --namespace admin -f ${VALUES} \
    --set "git.path=k8s/${ENV}\,k8s/${ENV}/${CLUSTER_NAME}\,k8s/common",git.label=${ENV},git.email=flux-${ENV}@hmcts.net,git.user="Flux ${ENV}" \
    --wait