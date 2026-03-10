sudo firewall-cmd --zone=public --permanent --add-port=6443/tcp
sudo firewall-cmd --zone=public --permanent --add-port=2379/tcp
sudo firewall-cmd --zone=public --permanent --add-port=2380/tcp
sudo firewall-cmd --zone=public --permanent --add-port=10250/tcp
sudo firewall-cmd --zone=public --permanent --add-port=10256/tcp
sudo firewall-cmd --zone=public --permanent --add-port=10257/tcp
sudo firewall-cmd --zone=public --permanent --add-port=10259/tcp

# Flannel vxlan
sudo firewall-cmd --permanent --add-port=8472/udp

sudo firewall-cmd --zone=public --permanent --add-service=http
sudo firewall-cmd --zone=public --permanent --add-service=https

sudo firewall-cmd --runtime-to-permanent
sudo firewall-cmd --reload
