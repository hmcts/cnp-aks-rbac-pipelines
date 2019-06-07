#!/bin/bash
set -e

RESOURCE_GROUP_NAME=$1
CLUSTER_NAME=$2

az aks delete -g ${RESOURCE_GROUP_NAME} -n ${CLUSTER_NAME} -y