#!/bin/bash
set -ex

ENV=$1
CLUSTER_NAME=$2
VAULT_NAME=$3
HELM_REPO=https://charts.fluxcd.io
VALUES=deployments/fluxcd/values.yaml
FLUX_HELM_CRD=https://raw.githubusercontent.com/fluxcd/helm-operator/chart-1.1.0/deploy/crds.yaml

helm repo add fluxcd ${HELM_REPO}

kubectl apply -f ${FLUX_HELM_CRD}
kubectl -n admin delete secret flux-helm-repositories || true
helm upgrade flux-helm-operator fluxcd/helm-operator --install --namespace admin   -f  deployments/fluxcd/helm-operator-values.yaml --version 1.1.0 --wait


#Install kustomize
curl -s "https://raw.githubusercontent.com/\
kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
TMP_DIR=/tmp/flux/${ENV}/${CLUSTER_NAME}
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

kubectl apply -f https://raw.githubusercontent.com/hmcts/cnp-flux-config/master/k8s/$ENV/sealed-secrets/acr-credentials.yaml

./kustomize build ${TMP_DIR} |  kubectl apply -f -