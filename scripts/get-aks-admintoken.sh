#!/bin/bash

RESOURCE_GROUP_NAME=$1
CLUSTER_NAME=$2

az aks get-credentials --resource-group ${RESOURCE_GROUP_NAME} --name ${CLUSTER_NAME} --admin --overwrite-existing
