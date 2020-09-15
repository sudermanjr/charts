mybb
====
A Helm chart for Mybb

Current chart version is `0.1.0`

Source code can be found [here](https://github.com/sudermanjr/charts/tree/master/charts/mybb)

## Chart Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | 8.6.4 |

## Quickstart

Fire up a [kind](https://github.com/kubernetes-sigs/kind) cluster.

```
kind create cluster
```

Install the chart

```
helm repo add sudermanjr https://charts.sudermanjr.com
kubectl create ns mybb
helm install mybb sudermanjr/mybb --namespace mybb
kubectl -n mybb port-forward svc/mybb 8080:80
```

Now navigate to [http://localhost:8080](http://localhost:8080]

Once you're there, you'll need to connect to the database by navigating the prompts. The defaults for the postgres username and password are shown in the values section below. The 'hostname' will be `mybb-postgresql`

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| fullnameOverride | string | `""` | A template override for fullname |
| image.pullPolicy | string | `"Always"` | The image pull policy. Recommend not changing this. |
| image.repository | string | `"mybb/mybb"` | The Docker repository |
| imagePullSecrets | list | `[]` | A list of pull secrets for private repositories |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths | list | `[]` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` | A template override for "name" |
| nginx.image.repository | string | `"nginx"` | The image to use for the internal nginx server |
| nginx.image.tag | float | `1.17` | The version of nginx container to use |
| nginx.resources | object | `{}` | The resources block for the nginx container |
| nodeSelector | object | `{}` |  |
| podSecurityContext | object | `{}` | The security context to add to the pod |
| postgresql.enabled | string | `"tru"` | If true, installs a sub-chart to run postgresql as a DB |
| postgresql.postgresqlDatabase | string | `"mybb"` | The database name to use on the local postgres DB. Input this in the setup UI for mybb |
| postgresql.postgresqlPassword | string | `"foobar"` | The password to use on the local postgres DB. Input this in the setup UI for mybb |
| postgresql.postgresqlUsername | string | `"mybb"` | The username to use on the local postgres DB. Input this in the setup UI for mybb |
| replicaCount | int | `1` | The number of replicas. Currently only supports one |
| resources | object | `{}` | The resources block for the mybb pod |
| securityContext | object | `{}` | The security context to be used for the container in the pod |
| service.port | int | `80` | The port to use on the service |
| service.type | string | `"ClusterIP"` | The service type for the service |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `nil` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| storageClass | string | `"standard"` | The storage class to use for the persistent volume |
| tolerations | list | `[]` |  |
