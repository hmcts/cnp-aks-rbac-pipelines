#!/bin/bash
set -e

CLUSTER_NAME=$1
RESOURCE_GROUP_NAME=$2

az aks disable-addons -a kube-dashboard --name ${CLUSTER_NAME} --resource-group ${RESOURCE_GROUP_NAME} --no-wait