sudo kubeadm init --control-plane-endpoint "192.168.141.131:6443" --pod-network-cidr="192.168.0.0/16" --upload-certs


You can now join any number of control-plane nodes running the following command on each as root:

  sudo kubeadm join 192.168.141.131:6443 --token m65mjb.7mzndni1elf5qsdv \
	--discovery-token-ca-cert-hash sha256:4c818fad409fb34463abf84210254171043672ac83882eb62a506f502184ef3f \
	--control-plane --certificate-key d03102dd2064df03316d7d94c3e8ce87392057ff3232d9f65c357c4f5702e603 \
    --ignore-preflight-errors=EtcdCheckSync
    --ignore-preflight-errors=DirAvailable--var-lib-etcd --v=5

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

Then you can join any number of worker nodes by running the following on each as root:

sudo kubeadm join 192.168.141.131:6443 --token m65mjb.7mzndni1elf5qsdv \
	--discovery-token-ca-cert-hash sha256:4c818fad409fb34463abf84210254171043672ac83882eb62a506f502184ef3f 


On master node, stop the kubelet and add these lines to the etcd manifest:

sudo systemctl stop kubelet

- --heartbeat-interval=500
- --election-timeout=5000


Mounted /var/lib/etcd as tmpfs on master-02:

sudo mount -t tmpfs -o size=512M tmpfs /var/lib/etcd


Slow join in phases for master-02:

Try:
  sudo kubeadm join 192.168.141.131:6443 --token m65mjb.7mzndni1elf5qsdv \
	--discovery-token-ca-cert-hash sha256:4c818fad409fb34463abf84210254171043672ac83882eb62a506f502184ef3f \
	--control-plane --certificate-key 634e7be2d389aaeb6c502cfaf4be527288286babcd64a9befe9680a944363808 \
    --ignore-preflight-errors=DirAvailable--var-lib-etcd --v=5

Will fail with promote a member only in sync with leader

First do a worker join:

sudo kubeadm join 192.168.141.131:6443 --token m65mjb.7mzndni1elf5qsdv \
--discovery-token-ca-cert-hash sha256:4c818fad409fb34463abf84210254171043672ac83882eb62a506f502184ef3f --ignore-preflight-errors=all

Refresh the certificate key:

sudo kubeadm init phase upload-certs --upload-certs

Then join in phases:

sudo kubeadm join phase control-plane-prepare download-certs --control-plane --certificate-key 41bfbbb3970f327010944c30f4606a9b0118da1a55e7ae9eca81b6370c55a46b --discovery-token-ca-cert-hash sha256:4c818fad409fb34463abf84210254171043672ac83882eb62a506f502184ef3f --token m65mjb.7mzndni1elf5qsdv 192.168.141.131:6443

sudo kubeadm join phase control-plane-prepare certs --control-plane --discovery-token-ca-cert-hash sha256:4c818fad409fb34463abf84210254171043672ac83882eb62a506f502184ef3f --token m65mjb.7mzndni1elf5qsdv 192.168.141.131:6443

sudo kubeadm join phase control-plane-prepare kubeconfig --control-plane --discovery-token-ca-cert-hash sha256:4c818fad409fb34463abf84210254171043672ac83882eb62a506f502184ef3f --token m65mjb.7mzndni1elf5qsdv 192.168.141.131:6443

sudo kubeadm join phase control-plane-join etcd --control-plane

sudo kubeadm join phase control-plane-join all --control-plane


Promote the etcd master-02 member manually:

etcdctl member list
etcdctl member promote <ID>


sudo kubeadm join phase control-plane-join update-status --control-plane

sudo kubeadm join phase control-plane-join mark-control-plane --control-plane


Reset the process:

sudo rm -rf /etc/kubernetes/pki/etcd /var/lib/etcd/
sudo rm -rf /etc/kubernetes/pki/etcd /var/lib/etcd/*

sudo kubeadm reset -f


Fixed by re-running firewall command on both master nodes:
sudo firewall-cmd --permanent --add-port=2379/tcp
sudo firewall-cmd --permanent --add-port=2380/tcp
sudo firewall-cmd --reload

sudo firewall-cmd --runtime-to-permanent

Then member promote:
$ etcdctl member list -w=table
+------------------+---------+-----------+------------------------------+------------------------------+------------+
|        ID        | STATUS  |   NAME    |          PEER ADDRS          |         CLIENT ADDRS         | IS LEARNER |
+------------------+---------+-----------+------------------------------+------------------------------+------------+
| 8cb69880a85cc819 | started | master-01 | https://192.168.141.131:2380 | https://192.168.141.131:2379 |      false |
| f0fa59b2e001f75d | started | master-02 | https://192.168.141.133:2380 | https://192.168.141.133:2379 |       true |
+------------------+---------+-----------+------------------------------+------------------------------+------------+
zerobsv@master-01:~$ etcdctl member promote f0fa59b2e001f75d
Member f0fa59b2e001f75d promoted in cluster a9a7169cc048dca4
zerobsv@master-01:~$ etcdctl member list -w=table
+------------------+---------+-----------+------------------------------+------------------------------+------------+
|        ID        | STATUS  |   NAME    |          PEER ADDRS          |         CLIENT ADDRS         | IS LEARNER |
+------------------+---------+-----------+------------------------------+------------------------------+------------+
| 8cb69880a85cc819 | started | master-01 | https://192.168.141.131:2380 | https://192.168.141.131:2379 |      false |
| f0fa59b2e001f75d | started | master-02 | https://192.168.141.133:2380 | https://192.168.141.133:2379 |      false |
+------------------+---------+-----------+------------------------------+------------------------------+------------+

$ kubectl get nodes
NAME        STATUS   ROLES           AGE     VERSION
master-01   Ready    control-plane   78m     v1.35.0
master-02   Ready    control-plane   7m48s   v1.35.0
worker-01   Ready    <none>          74m     v1.35.0

Automate this:

You can now join any number of control-plane nodes running the following command on each as root:

sudo kubeadm join 192.168.141.131:6443 --token 6k34ev.jgmd610bcsbcp0vz \
	--discovery-token-ca-cert-hash sha256:5e9296ec6b0074748e926461545097c6f2a90162df21d48e98124fc55a3b53e0 \
	--control-plane --certificate-key 10ad02797c8ddd5716c1e71946ee00a1110ec94ce90f0173e043a8c276b1e24c

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

Then you can join any number of worker nodes by running the following on each as root:

sudo kubeadm join 192.168.141.131:6443 --token 6k34ev.jgmd610bcsbcp0vz \
	--discovery-token-ca-cert-hash sha256:5e9296ec6b0074748e926461545097c6f2a90162df21d48e98124fc55a3b53e0 
