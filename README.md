# sudermanjr charts repo

A collection of [helm](helm.sh) charts that I have written and use.

## Usage

Add the repo with helm.
```
helm repo add sudermanjr https://charts.sudermanjr.com
helm search repo sudermanjr
```

## Charts

### [synapse](/charts/synapse)

This chart is for installing a synapse server for matrix.

Other Reading:
  - [matrix.org](https://matrix.org/)
  - [synapse](https://matrix.org/docs/projects/server/synapse)

### [stress](/charts/stress)

Allows a user to create stress on kubernetes nodes using the linux utility stress.
