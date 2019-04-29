 #!/bin/bash

RESOURCE_GROUP_NAME=$1
VNET_CIDR=$2
SUBNET_CIDR=$3

if [ -z "${RESOURCE_GROUP_NAME}" ] ; then
  echo "Resource Group name is required." 
  exit 1
fi

if [ -z "${VNET_CIDR}" ] ; then
  echo "VNET CIDR is required." 
  exit 1
fi

if [ -z "${SUBNET_CIDR}" ] ; then
  echo "SUBNET CIDR is required." 
  exit 1
fi

vnet=$(az network vnet list -g ${RESOURCE_GROUP_NAME} --query "[?contains(addressSpace.addressPrefixes, '${VNET_CIDR}')][] | [0]")
if [ -z "$vnet" ] ; then
  echo "Continuing with a brand new infra..."
  exit 0
fi

subnetCandidate=$(echo ${vnet} | jq -e '.subnets | map(select(.addressPrefix == "'${SUBNET_CIDR}'")) | first | select (.!=null)')
if [ -z "$subnetCandidate" ] ; then
  echo "Subnet ${SubnetCIDR} not present in vnet ${VNET_CIDR}"
  exit 1
fi

subnetId=$(echo $subnetCandidate | jq -r ".id")
echo "##vso[task.setvariable variable=aksSubnetId]${subnetId}"

