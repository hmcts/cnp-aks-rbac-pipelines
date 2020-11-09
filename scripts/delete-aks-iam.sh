#!/bin/bash
set -e

ENVIRONMENT=$1
AKSNAME=$2

if [[ $AKSNAME == *"00"* ]]
then
AKSENV="00"
else
AKSENV="01"
fi

IFS=$' '
IFS=$'\n'
guids=()
subs=()
guids+=("$(jq -r .parameters.Virtual_Machine_Contributor_Iam_Guid_$AKSENV.value ../templates/vars/aks/$ENVIRONMENT.json) ")
guids+=("$(jq -r .parameters.Network_Contributor_Iam_Guid_$AKSENV.value ../templates/vars/aks/$ENVIRONMENT.json)")
guids+=("$(jq -r .parameters.iam.value.permissions[].guid_$AKSENV ../templates/vars/aks/$ENVIRONMENT.json)")
subs=$(jq -r .parameters.iam.value.permissions[].subscriptionId ../templates/vars/aks/$ENVIRONMENT.json | uniq)

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