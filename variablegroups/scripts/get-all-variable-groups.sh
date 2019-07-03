#!/usr/bin/env bash

set -ex

if [ $# -lt 1 ]
  then
    echo "Not enough arguments supplied, pass UserName and Azure Personal Access token"
    exit 1
fi
ACCESSTOKEN=$1
USERNAME=${2:azuredevops}

groupList=$(curl -X GET -s -u ${USERNAME}:${ACCESSTOKEN} "https://dev.azure.com/hmcts/cnp/_apis/distributedtask/variablegroups/?api-version=5.0-preview.1" | jq -r '.value[] | .name' )


for group in ${groupList} ; do

curl -X GET -s -u ${USERNAME}:${ACCESSTOKEN} "https://dev.azure.com/hmcts/cnp/_apis/distributedtask/variablegroups/?groupName=${group}&api-version=5.0-preview.1" | jq -r .value[0] > ${group}.json
echo "Updated ${group}"
done
