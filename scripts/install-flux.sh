#!/bin/bash
set -e

ENV=$1
GIT_REPO=${2:-https://weaveworks.github.io/flux}
VALUES=${3-deployments/weave-flux/values.yaml}

helm repo add weaveworks ${GIT_REPO}
helm upgrade flux weaveworks/flux --install --namespace admin -f ${VALUES} \
    --set "git.path=k8s/${ENV}\,k8s/common",git.label=${ENV},git.email=flux-${ENV}@hmcts.net,git.user="Flux ${ENV}" \
    --wait