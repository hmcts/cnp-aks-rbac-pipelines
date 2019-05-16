#!/bin/bash

RESOURCE_GROUP_NAME=$1
VNET_CIDR=$2
PRIMARY_SUBNET_CIDR=$3
SECONDARY_SUBNET_CIDR=$4  

if [ -z "${RESOURCE_GROUP_NAME}" ] ; then
  echo "Resource Group name is required." 
  exit 1
fi

if [ -z "${VNET_CIDR}" ] ; then
  echo "VNET CIDR is required." 
  exit 1
fi

if [ -z "${PRIMARY_SUBNET_CIDR}" ] ; then
  echo "PRIMARY SUBNET CIDR is required." 
  exit 1
fi

if [ -z "${SECONDARY_SUBNET_CIDR}" ] ; then
  echo "SECONDARY SUBNET CIDR is required." 
  exit 1
fi

vnet=$(az network vnet list -g ${RESOURCE_GROUP_NAME} --query "[?contains(addressSpace.addressPrefixes, '${VNET_CIDR}')][] | [0]")
if [ -z "$vnet" ] ; then
  echo "Continuing with a brand new infra..."
  exit 0
fi

primarySubnetCandidate=$(echo ${vnet} | jq -e '.subnets | map(select(.addressPrefix == "'${PRIMARY_SUBNET_CIDR}'")) | first | select (.!=null)')
if [ -z "$primarySubnetCandidate" ] ; then
  echo "Primary Subnet ${PRIMARY_SUBNET_CIDR} not present in vnet ${VNET_CIDR}"
  exit 1
fi

primarySubnetCandidate=$(echo ${vnet} | jq -e '.subnets | map(select(.addressPrefix == "'${PRIMARY_SUBNET_CIDR}'")) | first | select (.!=null)')
if [ -z "$primarySubnetCandidate" ] ; then
  echo "Primary Subnet ${PRIMARY_SUBNET_CIDR} not present in vnet ${VNET_CIDR}"
  exit 1
else
  primarySubnetId=$(echo $primarySubnetCandidate | jq -r ".id")
  echo "##vso[task.setvariable variable=aksPrimarySubnetId]${primarySubnetId}"
fi

secondarySubnetCandidate=$(echo ${vnet} | jq -e '.subnets | map(select(.addressPrefix == "'${SECONDARY_SUBNET_CIDR}'")) | first | select (.!=null)')
if [ -z "$secondarySubnetCandidate" ] ; then
  echo "Secondary Subnet ${SECONDARY_SUBNET_CIDR} not present in vnet ${VNET_CIDR}"
  exit 1
else
  secondarySubnetId=$(echo $secondarySubnetCandidate | jq -r ".id")
  echo "##vso[task.setvariable variable=aksSecondarySubnetId]${secondarySubnetId}"
fi
