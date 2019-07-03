#!/usr/bin/env bash
set -e

if [ $# -lt 1 ]
  then
    echo "Azure Personal Access token not passed"
    exit 1
fi
ACCESSTOKEN=$1
USERNAME=${2:azuredevops}


for fileName in /*.json; do

groupName=$(cat ${fileName} | jq -r .name)
groupId=$(curl -s -X GET -u ${USERNAME}:${ACCESSTOKEN} "https://dev.azure.com/hmcts/cnp/_apis/distributedtask/variablegroups/?groupName=${groupName}&api-version=5.0-preview.1" | jq -r "if (.count == 1 ) then .value[0].id else empty end")
    if [[ ${groupId} ]]; then
        echo "Updating ${groupName} variable group"
        curl -s -X PUT -u ${USERNAME}:${ACCESSTOKEN} https://dev.azure.com/hmcts/cnp/_apis/distributedtask/variablegroups/${groupId}?api-version=5.0-preview.1 -d @${fileName} -H "Content-Type: application/json"
    else
        echo "Creating ${groupName} variable group"
        curl -s -X POST -u ${USERNAME}:${ACCESSTOKEN} https://dev.azure.com/hmcts/cnp/_apis/distributedtask/variablegroups?api-version=5.0-preview.1 -d @${fileName} -H "Content-Type: application/json"
    fi
done