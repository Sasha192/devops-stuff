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

# 7. Join the Worker Nodes to the Cluster
# In the Control Plane Node, create the token and copy the kubeadm join command (NOTE:The join command can also be found in the output from kubeadm init command):
# kubeadm token create --print-join-command

#8. In both Worker Nodes, paste the kubeadm join command to join the cluster:
# sudo kubeadm join <join command from previous command>

#9. In the Control Plane Node, view cluster status (Note: You may have to wait a few moments to allow the cluster to become ready):
# kubectl get nodes


