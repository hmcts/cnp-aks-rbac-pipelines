#!/bin/bash
set -e

BINDING_YAML=${1:-roles/portal-log-reader-role.yaml}

kubectl apply -f ${BINDING_YAML} --validate=false
