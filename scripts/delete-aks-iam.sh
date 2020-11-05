#!/bin/bash
set -e

ENVIRONMENT=$1

IFS=$' '
IFS=$'\n'

guids+=("$(jq -r .Virtual_Machine_Contributor_Iam_Guid.value ../templates/vars/aks/$ENVIRONMENT.json) ")
guids+=("$(jq -r .Network_Contributor_Iam_Guid.value ../templates/vars/aks/$ENVIRONMENT.json)")
guids+=("$(jq -r .iam.value.permissions[].guid ../templates/vars/aks/$ENVIRONMENT.json)")
subs=$(jq -r .iam.value.permissions[].subscriptionId ../templates/vars/aks/$ENVIRONMENT.json | uniq)

for sub in ${subs[@]}; 
do

echo "Setting subscription for $sub"
az account set --subscription $sub

for guid in ${guids[@]}; 
do 

ID=$(az role assignment list --all --query "[?name=='$guid'].[id]" -o tsv);
RESOURCEGROUP=$(az role assignment list --all --query "[?name=='$guid'].[resourceGroup]" -o tsv);

echo "Checking IAM Role Assignment for GUID:- $guid on subscription:- $sub in Resource Group:- $RESOURCEGROUP";
if [ -n "${ID}" ];  then

    echo "Deleting IAM Role Assignment for GUID:- $guid on subscription:- $sub in Resource Group:- $RESOURCEGROUP";
    az role assignment delete --ids $ID ;
    
fi

done

done