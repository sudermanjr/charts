synapse
=======
A Helm chart to deploy matrix synapse server. https://github.com/matrix-org/synapse

Current chart version is `0.1.0`

Source code can be found [here](https://github.com/sudermanjr/charts/tree/master/charts/synapse)

## Generating values for keys

You can generate your own keys using the genKeys.sh script here.

```
./genKeys.sh <SERVER_NAME>
```

This will run a synapse docker container locally that generates an example config and all the keys.

## Testing and development

If you have a local cluster (I use [kind](https://github.com/kubernetes-sigs/kind)), then you can install a local version of the chart using a postgres container like so:

```
kubectl create ns synapse
helm upgrade --namespace synapse --install synapse . --set postgres.localDev.enabled=true --set postgres.init.enabled=true
```

This will create a postgres database, initialize the matrix database, and run the synapse server. You can then access it by port-forwarding:

```
kubectl -n synapse port-forward svc/synapse 8080:80
```

Then browse to [http://localhost:8080](http://localhost:8080) in your browser to see the startup page.

## A Warning About Secrets

All secrets (including the server config) are stored as secrets as part of the chart. As of helm 3, all values passed in are also set as secrets. The issue then becomes twofold:

1. You probably keep your values in git, unencrypted. You probably shouldn't in this case because they contain secrets.
1. The secrets must be passed in from an insecure setting, such as your laptop.

I have done my best to balance the ease-of-use and the security when building this chart. There are however much better practices that could be used for handling the secrets for this server. I highly suggest reading more about that before running this in a "production" setting.

In the future, I will look at incorporating a [Vault](https://www.vaultproject.io/) integration with this chart to make it easier to keep these keys in a safe place.

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| fullnameOverride | string | `""` | A template override for "fullname" |
| image.pullPolicy | string | `"Always"` | The image pull policy for all containers. Recommend leaving this as Always |
| image.repository | string | `"matrixdotorg/synapse"` | The docker image repository to use |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | A list of pullsecrets to use everywhere |
| ingress.annotations | object | `{"cert-manager.io/cluster-issuer":"letsencrypt-prod","kubernetes.io/ingress.class":"nginx-ingress"}` | Annotations to add to the synapse server ingress |
| ingress.enabled | bool | `false` | If true, creates an ingress for the synapse server |
| ingress.hosts | list | `[{"host":"matrix.example.com","paths":["/"]}]` | A list of hosts and paths to use for the synapse ingress |
| ingress.tls | list | `[{"hosts":["matrix.example.com"],"secretName":"synapse-tls"}]` | A TLS block for the synapse server ingress |
| macaroonSecretKey | string | `"469535da278b1a340112b7190217efb8ba846476c9abb20e166e7cc4eaf8f413"` | The value for macaroon_secret_key |
| nameOverride | string | `""` | A template override for "name" |
| nodeSelector | object | `{}` | A nodeSelector block to use on all pods in the chart |
| podAnnotations | object | `{}` | Additional annotations to add to the synapse server pod |
| podSecurityContext | object | `{}` | The security context to add to the synapse server pod |
| postgres.cpMax | int | `10` | The cp_max setting in the synapse postgres config |
| postgres.cpMin | int | `5` | The cp_min setting in the synapse postgres config |
| postgres.database | string | `"matrix"` | The database name to use. Must be created, or use postgres.init |
| postgres.enabled | bool | `true` | If true, uses postgres as the database. If false, it is set to sqlite |
| postgres.host | string | `"some-postgres.example.com"` | The host where your postgres server is located. Overriden if postgres.localDev.enabled is used |
| postgres.init.database | string | `"defaultdb"` | The default database on the server. Used for connecting initially |
| postgres.init.enabled | bool | `false` | If true, a helm post-install hook will be used to initialize the database |
| postgres.init.image.repository | string | `"quay.io/sudermanjr/utilities"` | The image to use for the init hook. Must include the psql utility |
| postgres.init.image.tag | string | `"latest"` | The tag to use for the init hook image |
| postgres.init.password | string | `"randomlongpasswordpleasechangeme"` | The password for the postgres.init.user |
| postgres.init.user | string | `"matrix"` | The username to use for initializing the database |
| postgres.localDev.enabled | bool | `false` | If true, will run a postgres container alongside the server for dev purposes |
| postgres.localDev.image.repository | string | `"postgres"` | The image to use for the dev postgres container |
| postgres.localDev.image.tag | int | `12` | THe version of the iamge to use for the dev postgres container |
| postgres.localDev.storageSize | string | `"1Gi"` | The size of the volume to attach for postgres data |
| postgres.password | string | `"randomlongpasswordpleasechangeme"` | The password for postgres.user |
| postgres.port | string | `"5432"` | The port of the postgres server. Overriden if postgres.localDev.enabled is used |
| postgres.user | string | `"matrix"` | The username for synapse to use when connecting to postgres |
| regSharedSecret | string | `"c681fdf2ca739edfe848e24ee93d0c51de7be836bd879c54bc57a007c96d3076"` | The value for registration_shared_secret |
| replicaCount | int | `1` | The number of replicas to run. Currently only one is supported |
| reportStats | string | `"no"` | Set to "yes" or "no", is set as SYNAPSE_REPORT_STATS |
| resources | object | `{}` | A resources block for the synapse server container |
| securityContext | object | `{"allowPrivilegeEscalation":true,"runAsNonRoot":false,"runAsUser":0}` | The security context to be used for the synapse server container. Currently this is required to run as root. |
| serverName | string | `"matrix.example.com"` | The matrix server name to set in SYNAPSE_SERVER_NAME |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` | The service type to use for the synapse server |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| signingKeyB64 | string | `"ZWQyNTUxOSBhX3JOcEogS0lDTHRqOVovL2lWMEZPbVpjR2tKSzArRDY1WFNvcHlJYlBmN3dvVytGNAo="` | The base64 encoded key to mount at /secrets/signing.key |
| storageClass | string | `"standard"` | The storage class to use for the persistent data volume mounted at /data. Also used for localDev postgres if enabled |
| storageSize | string | `"1Gi"` | The size of the persistent volume that is attached to the synapse server for /data |
| tolerations | list | `[]` | A list of tolerations to add to all pods in the chart |
