sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

# Export the OS and CRI_O version values
export OS_VERSION=xUbuntu_22.04
export CRIO_VERSION=1.26

sudo curl -fsSL https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS_VERSION/Release.key | sudo gpg --dearmor -o /usr/share/keyrings/libcontainers-archive-keyring.gpg

sudo curl -fsSL https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_VERSION/$OS_VERSION/Release.key | sudo gpg --dearmor -o /usr/share/keyrings/libcontainers-crio-archive-keyring.gpg

# we can get the latest release details from https://cri-o.io/

sudo echo "deb [signed-by=/usr/share/keyrings/libcontainers-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS_VERSION/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list

sudo echo "deb [signed-by=/usr/share/keyrings/libcontainers-crio-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_VERSION/$OS_VERSION/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$CRIO_VERSION.list


sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://dl.k8s.io/apt/doc/apt-key.gpg

sudo echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update the repositiries
sudo apt-get update -y
sudo apt-get install cron -y



# Use the same versions to avoid issues with the installation.
sudo apt-get install -y cri-o cri-o-runc crio-tools kubelet=1.28.0-00 kubeadm=1.28.1-00 kubectl=1.28.0-00

# Start the cri-o service
sudo systemctl daemon-reload
sudo systemctl enable crio
sudo systemctl start crio

sudo apt-mark hold cri-o kubelet kubeadm kubectl


cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Disable the swap
sudo swapoff -a
(sudo crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | sudo crontab - || true


sudo kubeadm init --pod-network-cidr=192.168.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "untaint controlplane node"
kubectl taint nodes $(kubectl get nodes -o=jsonpath='{.items[].metadata.name}') node.kubernetes.io/not-ready:NoSchedule-
kubectl taint nodes $(kubectl get nodes -o=jsonpath='{.items[].metadata.name}') node-role.kubernetes.io/control-plane=:NoSchedule-
kubectl get node -o wide



# Use this if you have initialised the cluster with Calico network add on.
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/tigera-operator.yaml

curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/custom-resources.yaml -O

kubectl create -f custom-resources.yaml

git clone https://github.com/mialeevs/kubernetes_installation_crio.git
cd kubernetes_installation_crio/
kubectl apply -f metrics-server.yaml
cd ..
rm -rf kubernetes_installation_crio/
