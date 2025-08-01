# Leader Elector Extension
<!-- status autogenerated section -->
| Status        |           |
| ------------- |-----------|
| Stability     | [alpha]  |
| Distributions | [contrib], [k8s] |
| Issues        | [![Open issues](https://img.shields.io/github/issues-search/open-telemetry/opentelemetry-collector-contrib?query=is%3Aissue%20is%3Aopen%20label%3Aextension%2Fk8sleaderelector%20&label=open&color=orange&logo=opentelemetry)](https://github.com/open-telemetry/opentelemetry-collector-contrib/issues?q=is%3Aopen+is%3Aissue+label%3Aextension%2Fk8sleaderelector) [![Closed issues](https://img.shields.io/github/issues-search/open-telemetry/opentelemetry-collector-contrib?query=is%3Aissue%20is%3Aclosed%20label%3Aextension%2Fk8sleaderelector%20&label=closed&color=blue&logo=opentelemetry)](https://github.com/open-telemetry/opentelemetry-collector-contrib/issues?q=is%3Aclosed+is%3Aissue+label%3Aextension%2Fk8sleaderelector) |
| Code coverage | [![codecov](https://codecov.io/github/open-telemetry/opentelemetry-collector-contrib/graph/main/badge.svg?component=extension_k8s_leader_elector)](https://app.codecov.io/gh/open-telemetry/opentelemetry-collector-contrib/tree/main/?components%5B0%5D=extension_k8s_leader_elector&displayType=list) |
| [Code Owners](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/CONTRIBUTING.md#becoming-a-code-owner)    | [@dmitryax](https://www.github.com/dmitryax), [@rakesh-garimella](https://www.github.com/rakesh-garimella) |

[alpha]: https://github.com/open-telemetry/opentelemetry-collector/blob/main/docs/component-stability.md#alpha
[contrib]: https://github.com/open-telemetry/opentelemetry-collector-releases/tree/main/distributions/otelcol-contrib
[k8s]: https://github.com/open-telemetry/opentelemetry-collector-releases/tree/main/distributions/otelcol-k8s
<!-- end autogenerated section -->

This extension enables OpenTelemetry components to run in HA mode across a Kubernetes cluster. The component that owns the lease becomes the leader and becomes the active instance.


## How It Works

The extension uses k8s.io/client-go/tools/leaderelection to perform leader election. The component that owns the lease becomes the leader and runs the function defined in onStartedLeading. If the leader loses the lease, it runs the function defined in onStoppedLeading, stops its operation, and waits to acquire the lease again.

## Configuration

```yaml
receivers:
  my_awesome_receiver:
    k8s_leader_elector: k8s_leader_elector
extensions:
  k8s_leader_elector:
    auth_type: kubeConfig
    lease_name: foo
    lease_namespace: default

service:
  extensions: [k8s_leader_elector]
  pipelines:
    metrics:
      receivers: [my_awesome_receiver]
```
### Leader Election Configuration
| configuration       | description                                                                   | default value   |
|---------------------|-------------------------------------------------------------------------------|-----------------|
| **auth_type**       | Authorization type to be used (serviceAccount, kubeConfig).                   | none (required) |
| **lease_name**      | The name of the lease object.                                                 | none (required) |
| **lease_namespace** | The namespace of the lease object.                                            | none (required) |
| **lease_duration**  | The duration of the lease.                                                    | 15s             |
| **renew_deadline**  | The deadline for renewing the lease. It must be less than the lease duration. | 10s             |
| **retry_period**    | The period for retrying the leader election.                                  | 2s              |

### Delete the lease object
```shell
kubectl delete leases.coordination.k8s.io -n <namespace> <lease_name>
```

### Suggested RBAC
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: my-lease
  namespace: default
rules:
- apiGroups:
  - coordination.k8s.io
  resources:
  - leases
  verbs:
  - get
  - list
  - watch
  - create
  - update
  - patch
  - delete
```