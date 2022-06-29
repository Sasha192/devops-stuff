#!/bin/bash


#1. Upgrade apt packages
sudo apt-get update

#2. Install Docker Engine
sudo apt-get install -y docker.io

#3. Install Support packages
sudo apt-get install -y apt-transport-https curl

#4. Retrieve the key for the Kubernetes repo and add it to your key manager
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

#5. Add the kubernetes repo to your system
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

#6. Install the three pieces you’ll need, kubeadm, kubelet, and kubectl
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

#7. Create the actual cluster
kubeadm init --pod-network-cidr=10.8.1.0/24

#8. Install the Calico network plugin
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

#9. Untaint the master so that it will be available for scheduling workloads
kubectl taint nodes --all node-role.kubernetes.io/master-

#10. Get Cluster Nodes
kubectl get nodes

