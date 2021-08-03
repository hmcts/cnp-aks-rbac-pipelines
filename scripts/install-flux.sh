#!/bin/bash
set -ex

ENV=$1
CLUSTER_NAME=$2
VAULT_NAME=$3
HELM_REPO=https://charts.fluxcd.io
VALUES=deployments/fluxcd/values.yaml
FLUX_HELM_CRD=https://raw.githubusercontent.com/fluxcd/helm-operator/chart-1.2.0/deploy/crds.yaml

helm repo add fluxcd ${HELM_REPO}

kubectl apply -f ${FLUX_HELM_CRD}
kubectl -n admin delete secret flux-helm-repositories || true
helm upgrade flux-helm-operator fluxcd/helm-operator --install --namespace admin   -f  deployments/fluxcd/helm-operator-values.yaml --version 1.2.0 --wait


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
namespace: admin
resources:
  - https://raw.githubusercontent.com/hmcts/cnp-flux-config/master/k8s/namespaces/admin/flux/flux.yaml
patchesStrategicMerge:
  - https://raw.githubusercontent.com/hmcts/cnp-flux-config/master/k8s/namespaces/admin/flux/patches/${ENV}/flux.yaml
  - https://raw.githubusercontent.com/hmcts/cnp-flux-config/master/k8s/namespaces/admin/flux/patches/${ENV}/${CLUSTER_NAME}/flux.yaml
EOF
) > "${TMP_DIR}/kustomization.yaml"
# -----------------------------------------------------------

kubectl apply -f https://raw.githubusercontent.com/hmcts/cnp-flux-config/master/k8s/$ENV/common/sealed-secrets/acr-credentials.yaml

./kustomize build ${TMP_DIR} |  kubectl apply -f -

# ------------------------Flux V2----------------------------


FLUX_CONFIG_URL=https://raw.githubusercontent.com/hmcts/cnp-flux-config/master

if [ ${ENV} == "mgmt-sandbox" ]; then
  CLUSTER_ENV="sbox-intsvc"
elif [ ${ENV} == "cftptl" ]; then
  CLUSTER_ENV="ptl-intsvc"
else 
  CLUSTER_ENV=${ENV}
fi

CLUSTER_NAME=$(echo ${CLUSTER_NAME} | cut -d'-' -f 2)

# Install Flux
kubectl apply -f ${FLUX_CONFIG_URL}/apps/flux-system/base/gotk-components.yaml

#Git credentials
kubectl apply -f ${FLUX_CONFIG_URL}/apps/flux-system/${CLUSTER_ENV}/base/git-credentials.yaml

#Create Flux Sync CRDs
kubectl apply -f ${FLUX_CONFIG_URL}/apps/flux-system/base/flux-config-gitrepo.yaml

TMP_DIR=/tmp/flux/${CLUSTER_ENV}/${CLUSTER_NAME}
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
  - ${FLUX_CONFIG_URL}/apps/flux-system/${CLUSTER_ENV}/${CLUSTER_NAME}/kustomize.yaml
EOF
) > "${TMP_DIR}/kustomization.yaml"
# -----------------------------------------------------------

./kustomize build ${TMP_DIR} |  kubectl apply -f -

rm -rf kustomize