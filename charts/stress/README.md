# stress

A Helm chart for Stress

## Required Values

Set the `stressCmd` to a command that you might run with stress, such as `stress -c 1`.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| daemonset.enabled | bool | `false` | If True, will be run as a daemonset. Not recommended to set true along with deployment.enabled |
| deployment.enabled | bool | `true` | If true, will be deployed as a deployment. Not recommended to set true along with daemonset.enabled |
| deployment.replicaCount | int | `1` | The number of replicas to run. Only affects deployments. |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"Always"` | The pullPolicy. Usually best set to Always |
| image.repository | string | `"ubuntu"` | The image repository. Probably don't change this unless you know what's going on here. |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{"fsGroup":0}` | This is intentionally insecure in order to accomodate how this chart runs. |
| resources | object | `{}` | How you set this will largely depend on how you want to use this chart. |
| securityContext | object | `{"readOnlyRootFilesystem":false,"runAsGroup":0,"runAsNonRoot":false,"runAsUser":0}` | This is intentionally insecure in order to accomodate how this chart runs. |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| stressCmd | string | `"stress --help"` | The stress command to run, with all of the flags. Try stress -c 1 |
| tolerations | list | `[]` |  |
