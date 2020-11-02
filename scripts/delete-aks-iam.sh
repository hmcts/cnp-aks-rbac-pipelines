#!/bin/bash
set -e

GUIDS_LIST=$1
SUBSCRIPTIONS_LIST=$2

IFS=","
guids=(${GUIDS_LIST})

IFS=","
subs=(${SUBSCRIPTIONS_LIST})


for sub in ${subs[@]}; 
do
echo "Setting subscription for $sub"
az account set --subscription $sub

for guid in ${guids[@]}; 
do 

ID=$(az role assignment list --all --query "[?name=='$guid'].[principalId]" -o tsv);
SCOPE=$(az role assignment list --all --query "[?name=='$guid'].[scope]" -o tsv);
RESOURCEGROUP=$(az role assignment list --all --query "[?name=='$guid'].[resourceGroup]" -o tsv);

if [ -n "${ID}" ];  then

    echo "Deleting IAM Role Assignment for GUID:- $guid on subscription:- $sub in Resource Group:- $RESOURCEGROUP";
    az role assignment delete --assignee $ID --scope $SCOPE;
fi

done

done