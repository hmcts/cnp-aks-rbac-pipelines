#!/bin/bash
set -e

NAMESPACES=${1:-deployments/namespaces.yaml}
kubectl apply -f ${NAMESPACES}