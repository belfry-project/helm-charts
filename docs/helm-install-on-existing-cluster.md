# Helm Install on existing cluster

For those that wish to use [Helm](https://helm.sh/) to install the awx-operator to an existing K8s cluster:

The helm chart is generated from the `helm-chart` Makefile section using the starter files in `.helm/starter`. Consult [the documentation](https://github.com/belfry-project/helm-charts/blob/main/README.md) on how to customize the AWX resource with your own values.

```bash
$ helm repo add belfry https://belfry-project.github.io/helm-charts/
"belfry" has been added to your repositories

$ helm repo update

$ helm search repo belfry/belfry-operator
NAME                      CHART VERSION   APP VERSION   DESCRIPTION
belfry/belfry-operator    1.0.0           1.0.0         Helm chart for the Belfry operator, which deploys and manages Belfry on Kubernetes

$ helm install -n awx --create-namespace belfry-operator belfry/belfry-operator --version 1.0.0
```

The chart version is the Belfry release it installs: chart `1.0.0` deploys `ghcr.io/belfry-project/belfry-operator:1.0.0`, which deploys Belfry `1.0.0`. Release candidates (`1.0.0-rc.1`) are Helm pre-releases: pass `--devel` to `helm search`, and `--version 1.0.0-rc.1` to `helm install`.

On `main`, `.helm/starter/Chart.yaml` stays at version `0.1.0` with appVersion `main` (the operator's development build). The release workflow sets both to the release tag, generates the chart from belfry-operator at that tag and publishes it; see `.github/workflows/release.yml`.
