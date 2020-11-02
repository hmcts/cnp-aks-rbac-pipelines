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

az account set --subscription $sub

for guid in ${guids[@]}; 
do 

NAME=$(az role assignment list --all --query "[?name=='$guid'].[principalName]" -o tsv);
SCOPE=$(az role assignment list --all --query "[?name=='$guid'].[scope]" -o tsv);
RESOURCEGROUP=$(az role assignment list --all --query "[?name=='$guid'].[resourceGroup]" -o tsv);

if [ -n "${NAME}" ];  then
    # echo "JAIL is set to the empty string in $sub"
    echo "Deleting IAM Role Assignment for GUID:- $guid on subscription:- $sub in Resource Group:- $RESOURCEGROUP";
    az role assignment delete --assignee $NAME --scope $SCOPE;
fi

done

done