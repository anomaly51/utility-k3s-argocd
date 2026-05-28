# common-app

Reusable Helm chart for application workloads managed by Argo CD.

The chart supports two patterns:

- Values-driven apps: use `image`, `service`, `ingress`, `env`, `externalSecrets`, `persistence`, and related fields.
- Legacy/custom apps: put exact YAML into `rawManifests`. Use image placeholders such as `__IMAGE_backend__`; the chart replaces them from `images.backend.repository` and `images.backend.tag`.

Harbor OCI artifact target:

```bash
helm package charts/common-app
helm push common-app-0.1.0.tgz oci://harbor.api-api-api.com/helm-charts
```

Argo CD should consume it as:

```yaml
repoURL: harbor.api-api-api.com/helm-charts
chart: common-app
targetRevision: 0.1.0
```
