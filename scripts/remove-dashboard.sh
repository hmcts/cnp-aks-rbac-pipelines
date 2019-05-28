#!/bin/bash
set -e

# disabled due to: https://github.com/Azure/AKS/issues/786
#kubectl --namespace kube-system delete deployment kubernetes-dashboard
#kubectl --namespace  kube-system delete svc kubernetes-dashboard