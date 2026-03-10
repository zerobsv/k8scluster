# Bring the interfaces down first
sudo ip link set cni0 down
sudo ip link set flannel.1 down

# Delete the links
sudo ip link delete cni0
sudo ip link delete flannel.1

# Remove Flannel's subnet environment file
sudo rm -rf /run/flannel/

# Remove CNI configuration filess
sudo rm -rf /etc/cni/net.d/

# Clear the CNI cache
sudo rm -rf /var/lib/cni/

# Restart containerd and Docker
sudo systemctl restart containerd
sudo systemctl restart docker
