#!/bin/bash
set -e

kubectl --namespace kube-system delete deployment kubernetes-dashboard
kubectl --namespace  kube-system delete svc kubernetes-dashboard