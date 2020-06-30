#!/usr/bin/env sh

VAULT_NAME=$1
DYNATRACE_INSTANCE=$2

DYNATRACE_CLUSTERROLE_BINDING=roles/dynatrace-cluster-role-binding.yaml

K8S_API_URL=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
CLUSTER_NAME=$(kubectl config view --minify -o jsonpath='{.clusters[0].name}')

BEARER_TOKEN=$(kubectl get secret $(kubectl get sa dynatrace-monitoring \
  -o jsonpath='{.secrets[0].name}' -n monitoring) -o jsonpath='{.data.token}' \
  -n monitoring | base64 --decode)

API_TOKEN=$(az keyvault secret show \
  --name dynatrace-cluster-registration-token-london-${DYNATRACE_INSTANCE} \
  --vault-name "${VAULT_NAME}" \
  --query value -o tsv)

kubectl apply -f ${DYNATRACE_CLUSTERROLE_BINDING}

generate_kubernetes_credentials() {
  cat <<EOF
    {
      "label": "cft-$CLUSTER_NAME",
      "endpointUrl": "$K8S_API_URL",
      "workloadIntegrationEnabled": true,
      "authToken": "$BEARER_TOKEN",
      "certificateCheckEnabled": false
    }
EOF
}

curl --request POST \
  --url "https://$DYNATRACE_INSTANCE.live.dynatrace.com/api/config/v1/kubernetes/credentials" \
  --data "$(generate_kubernetes_credentials)" \
  --header 'Content-type: application/json' \
  --header 'Authorization: Api-Token '"$API_TOKEN"''
