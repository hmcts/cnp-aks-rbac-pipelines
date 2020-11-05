#!/bin/bash
set -e

GUIDS_LIST=$1
SUBSCRIPTIONS_LIST=$2

IFS=","
guids=(${GUIDS_LIST})
subs=(${SUBSCRIPTIONS_LIST})

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
    az role assignment delete --ids $ID;
    
fi

done

done