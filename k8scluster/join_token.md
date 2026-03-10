sudo kubeadm init --control-plane-endpoint "192.168.141.131:6443" --pod-network-cidr="192.168.0.0/16" --upload-certs

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