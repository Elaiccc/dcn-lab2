#!/bin/bash
# Ziyi Liu - DCN Lab 2. Deploy only to an EXISTING authorized lab cluster.
set -euo pipefail
if [ "$#" -ne 2 ]; then
  printf 'Usage: bash deploy_cloud.sh DOCKERHUB_USERNAME CLOUD_CONTEXT\n'
  exit 1
fi
lab_user="$1"
lab_context="$2"
[[ "$lab_user" =~ ^[a-z0-9][a-z0-9_-]{2,30}$ ]] || { printf 'Invalid Docker Hub username\n'; exit 1; }
[[ -n "$lab_context" && "$lab_context" != -* ]] || { printf 'Invalid context\n'; exit 1; }
case "$lab_context" in minikube|dcn-lab2|docker-desktop|kind-*) printf 'This is a local context. Supply an existing cloud lab context.\n'; exit 1;; esac
lab_dir="$(cd "$(dirname "$0")" && pwd)"
command -v kubectl >/dev/null 2>&1 || { printf 'Install kubectl first.\n'; exit 1; }
kubectl --context="$lab_context" cluster-info
printf 'Target: %s, namespace: dcn-lab2, image: %s/sample-time-app:latest\n' "$lab_context" "$lab_user"
read -r -p 'Type DEPLOY to deploy to this cloud lab cluster: ' lab_confirmation
[ "$lab_confirmation" = DEPLOY ] || exit 0
lab_kube() { kubectl --context="$lab_context" "$@"; }
lab_kube create namespace dcn-lab2 --dry-run=client -o yaml | lab_kube apply -f -
sed "s|DOCKERHUB_USERNAME|$lab_user|g" "$lab_dir/k8s/deployment.yaml" | lab_kube apply -f -
lab_kube apply -f "$lab_dir/k8s/service.yaml"
lab_kube -n dcn-lab2 rollout status deployment/sample-time-app --timeout=180s
lab_kube -n dcn-lab2 get deployment,pods,services -o wide
lab_kube get nodes -o wide
printf 'Next: visit http://NODE_EXTERNAL_IP:NODEPORT/time when your lab firewall allows it.\n'
printf 'Record the real address, response, and cloud provider. A port-forward is a separate access method.\n'
