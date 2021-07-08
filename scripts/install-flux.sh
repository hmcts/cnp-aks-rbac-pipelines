#!/bin/bash
set -ex


CLUSTER_ENV=$1
CLUSTER_FULLNAME=$2
FLUX_CONFIG_URL=https://raw.githubusercontent.com/hmcts/cnp-flux-config/master

if [ ${CLUSTER_ENV}=="mgmt-sandbox" ]; then
  ENV="sbox-intsvc"
else 
  ENV=${CLUSTER_ENV}
fi

CLUSTER_NAME=echo ${CLUSTER_FULLNAME} | cut -d'-' -f 2

# Install Flux
kubectl apply -f ${FLUX_CONFIG_URL}/apps/flux-system/base/gotk-components.yaml

#Git credentials
kubectl apply -f ${FLUX_CONFIG_URL}/apps/flux-system/${ENV}/base/git-credentials.yaml

#Create Flux Sync CRDs
kubectl apply -f ${FLUX_CONFIG_URL}/apps/flux-system/base/flux-config-gitrepo.yaml

#Install kustomize
curl -s "https://raw.githubusercontent.com/\
kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
TMP_DIR=/tmp/flux/${ENV}/${CLUSTER_NAME}
mkdir -p $TMP_DIR
# -----------------------------------------------------------
(
cat <<EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: flux-system
resources:
  - ${FLUX_CONFIG_URL}/apps/flux-system/base/kustomize.yaml
patchesStrategicMerge:
  - ${FLUX_CONFIG_URL}/apps/flux-system/${ENV}/${CLUSTER_NAME}/kustomize.yaml
EOF
) > "${TMP_DIR}/kustomization.yaml"
# -----------------------------------------------------------

./kustomize build ${TMP_DIR} |  kubectl apply -f -

rm -rf kustomize