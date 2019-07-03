#!/usr/bin/env bash
set -ex

if [ $# -lt 2 ]
  then
    echo "Not enough parameters, pass Azure Personal Access token and Environment Name"
    exit 1
fi
ACCESSTOKEN=$1
ENVNAME=$2
USERNAME=${3:azuredevops}


curl -X GET -s -u ${USERNAME}:${ACCESSTOKEN} "https://dev.azure.com/hmcts/cnp/_apis/distributedtask/variablegroups/?groupName=SBOX-AKS-COMMON&api-version=5.0-preview.1" | jq '.value[0] | del(.createdOn, .modifiedBy , .createdBy, .modifiedOn , .id)' | jq --arg envname ${ENVNAME}-AKS-COMMON '.name=$envname' > ${ENVNAME}-AKS-COMMON.json
curl -X GET -s -u ${USERNAME}:${ACCESSTOKEN} "https://dev.azure.com/hmcts/cnp/_apis/distributedtask/variablegroups/?groupName=SBOX-AKS-Tags&api-version=5.0-preview.1" | jq '.value[0] | del(.createdOn, .modifiedBy , .createdBy, .modifiedOn , .id)' | jq --arg envname ${ENVNAME}-AKS-Tags '.name=$envname' > ${ENVNAME}-AKS-Tags.json
curl -X GET -s -u ${USERNAME}:${ACCESSTOKEN} "https://dev.azure.com/hmcts/cnp/_apis/distributedtask/variablegroups/?groupName=SBOX-AKS-KeyVault&api-version=5.0-preview.1" | jq '.value[0] | del(.createdOn, .modifiedBy , .createdBy, .modifiedOn , .id)' | jq --arg envname ${ENVNAME}-AKS-KeyVault '.name=$envname' > ${ENVNAME}-AKS-KeyVault.json

