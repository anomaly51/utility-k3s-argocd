# utility-k3s GitOps

This repository owns the GitOps configuration for the utility K3s cluster.

## Central Vault Ownership

HashiCorp Vault is a singleton platform service and is deployed only in the
utility cluster through `utility-apps/vault`.

The utility cluster is the source of truth for shared and cluster-specific
secrets. Other clusters must not deploy their own Vault instances for the same
platform data. They consume the centralized Vault through External Secrets
`ClusterSecretStore` resources rendered by `utility-apps/vault-store`.

Use these Vault access patterns:

- Utility cluster in-cluster access:
  `http://vault.vault.svc.cluster.local:8200`.
- Other clusters external access:
  `https://vault.api-api-api.com`.
- Shared secrets live under `shared/*`.
- Cluster-specific secrets live under a cluster prefix, for example
  `utility/*` or `workload-1/*`.

This keeps secret ownership centralized while allowing each workload cluster to
reuse the same shared credentials, such as Cloudflare DNS and Harbor pull
secrets, through its own `vault-store` release.

_Update marker:_ repository layout unchanged; this is a harmless no-op edit for
CI validation.
