# common-app chart

`common-app` is the reusable Helm chart used by workload GitOps repositories.

## Source and artifact locations

The chart source code lives in Git:

```text
utility-k3s-argocd/charts/common-app
```

The packaged chart is published to Harbor as an OCI artifact:

```text
harbor.api-api-api.com/helm-charts/common-app:0.1.0
```

Argo CD applications consume Harbor as the primary chart source and use the
cluster GitOps repository only for app-specific values:

```yaml
sources:
  - repoURL: harbor.api-api-api.com/helm-charts
    chart: common-app
    targetRevision: 0.1.0
    helm:
      releaseName: my-app
      valueFiles:
        - $values/values/my-app.yaml
  - repoURL: https://github.com/anomaly51/workload-1-k3s-argocd.git
    targetRevision: main
    ref: values
```

## Publishing manually

```bash
helm registry login harbor.api-api-api.com
helm package charts/common-app
helm push common-app-0.1.0.tgz oci://harbor.api-api-api.com/helm-charts
```

## Adding a new simple app

Create a new values file in the target cluster GitOps repo:

```yaml
namespace:
  name: my-app

image:
  repository: harbor.api-api-api.com/my-app/api
  tag: main-1-0123456789abcdef0123456789abcdef01234567

service:
  enabled: true
  port: 80
  targetPort: http

ports:
  - name: http
    containerPort: 8000

ingress:
  enabled: true
  host: my-app.api-api-api.com
  tls:
    enabled: true
```

For highly custom or already existing apps, use `rawManifests` and image
placeholders:

```yaml
images:
  backend:
    repository: harbor.api-api-api.com/my-app/backend
    tag: main-1-0123456789abcdef0123456789abcdef01234567

rawManifests: |
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: my-app
  spec:
    template:
      spec:
        containers:
          - name: backend
            image: __IMAGE_backend__
```

The chart replaces `__IMAGE_backend__` with
`images.backend.repository:images.backend.tag`.

## Argo CD Image Updater

For Helm values write-back, use:

```yaml
argocd-image-updater.argoproj.io/image-list: backend=harbor.api-api-api.com/my-app/backend
argocd-image-updater.argoproj.io/backend.allow-tags: regexp:^main-[0-9]+-[a-f0-9]{40}$
argocd-image-updater.argoproj.io/backend.update-strategy: newest-build
argocd-image-updater.argoproj.io/write-back-method: git
argocd-image-updater.argoproj.io/write-back-target: helmvalues:/values/my-app.yaml
argocd-image-updater.argoproj.io/backend.helm.image-name: images.backend.repository
argocd-image-updater.argoproj.io/backend.helm.image-tag: images.backend.tag
```
