#!/usr/bin/env bash

set -ex

if [ $# -lt 1 ]
  then
    echo "Not enough arguments supplied, pass UserName and Azure Personal Access token"
    exit 1
fi
ACCESSTOKEN=$1
ENDPOINTNAME=$2
USERNAME=${3:azuredevops}

echo $(curl -X GET -s -u ${USERNAME}:${ACCESSTOKEN}  "https://dev.azure.com/hmcts/cnp/_apis/serviceendpoint/endpoints?api-version=5.0-preview.2") | jq -r '.value | .[]'  | jq --arg test ${ENDPOINTNAME} 'select(.name == $test)'
