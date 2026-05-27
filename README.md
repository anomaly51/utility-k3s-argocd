# utility-k3s-argocd

GitOps repository for the utility K3s cluster.

## Layout

- `bootstrap/`: root Argo CD Application.
- `cluster/`: AppProject and Argo CD Application manifests.
- `infrastructure/`: platform controllers and shared cluster configuration.
- `apps/`: utility services hosted by this cluster.
