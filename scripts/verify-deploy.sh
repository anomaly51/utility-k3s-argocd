#!/usr/bin/env bash
set -euo pipefail

KUBECONFIG_PATH="${KUBECONFIG:-/Users/nekoneki/.kube/configs/utility-k3s.yaml}"
KUBECTL=(kubectl --kubeconfig "$KUBECONFIG_PATH")
failed=0

echo "== Nodes"
"${KUBECTL[@]}" get nodes
if "${KUBECTL[@]}" get nodes --no-headers | awk '$2 != "Ready" { found=1 } END { exit found ? 0 : 1 }'; then
  echo "ERROR: at least one node is not Ready" >&2
  failed=1
fi

echo "== Argo CD applications"
"${KUBECTL[@]}" -n argocd get applications.argoproj.io \
  -o custom-columns=NAME:.metadata.name,SYNC:.status.sync.status,HEALTH:.status.health.status,REVISION:.status.sync.revision
if "${KUBECTL[@]}" -n argocd get applications.argoproj.io --no-headers | awk '$2 != "Synced" || $3 != "Healthy" { found=1 } END { exit found ? 0 : 1 }'; then
  echo "ERROR: at least one Argo CD application is not Synced/Healthy" >&2
  failed=1
fi

if "${KUBECTL[@]}" get crd imageupdaters.argocd-image-updater.argoproj.io >/dev/null 2>&1; then
  echo "== Argo CD Image Updater"
  "${KUBECTL[@]}" -n argocd get imageupdaters.argocd-image-updater.argoproj.io
fi

exit "$failed"
