## Kubernetes cluster, on an Atomic/Immutable OS such as Fedora Silverblue

- Multi Master, has two master nodes for high availability/failover
- Nginx loadbalancer fronting the two master nodes
- Multi Play playbook, for before and after a restart to facilitate smooth package installs
- Admin Unlock for kubeadm init phase on master nodes and join phases
- Cluster bootstraps two worker nodes

Work in progress, experimenting with Cilium and OTEL

Aim is to improve telemetry, observability and security and learn these well

