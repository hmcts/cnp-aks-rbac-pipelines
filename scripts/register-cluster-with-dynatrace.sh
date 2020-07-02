#!/usr/bin/env sh

VAULT_NAME=$1
DYNATRACE_INSTANCE=$2

DYNATRACE_CLUSTERROLE_BINDING=roles/dynatrace-cluster-role-binding.yaml

error_exit()
{
	echo "$1" 1>&2
	exit 1
}

if kubectl config current-context; then
  K8S_API_URL=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
  CLUSTER_NAME=$(kubectl config view --minify -o jsonpath='{.clusters[0].name}')
else
  error_exit "context not set!! Aborting."
fi

BEARER_TOKEN=$(kubectl get secret $(kubectl get sa dynatrace-monitoring \
  -o jsonpath='{.secrets[0].name}' -n monitoring) -o jsonpath='{.data.token}' \
  -n monitoring | base64 --decode)

API_KEY=$(az keyvault secret show \
  --name dynatrace-api-key-${DYNATRACE_INSTANCE} \
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

DT_CLUSTER_OLDID=`curl --request GET \
  --url "https://$DYNATRACE_INSTANCE.live.dynatrace.com/api/config/v1/kubernetes/credentials" \
  --header 'Authorization: Api-Token '"$API_KEY"'' | jq .values[] | jq -r 'select(.name=="cft-'${CLUSTER_NAME}'").id'`

if [ -n "${DT_CLUSTER_OLDID}" ]; then
  echo "Dynatrace old registration ID found for $CLUSTER_NAME. This will be deleted.."
  curl --request DELETE \
    --url "https://$DYNATRACE_INSTANCE.live.dynatrace.com/api/config/v1/kubernetes/credentials/${DT_CLUSTER_OLDID}" \
    --header 'Authorization: Api-Token '"$API_KEY"''
fi

echo "Initiating Dynatrace registration.."
curl --request POST \
  --url "https://$DYNATRACE_INSTANCE.live.dynatrace.com/api/config/v1/kubernetes/credentials" \
  --data "$(generate_kubernetes_credentials)" \
  --header 'Content-type: application/json' \
  --header 'Authorization: Api-Token '"$API_KEY"''
