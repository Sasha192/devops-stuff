#!/bin/bash

sudo kubeadm config images pull

# Initialize the Kubernetes cluster on the control plane node using kubeadm (Note: This is only performed on the Control Plane Node):
sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.21.0

# Set kubectl access:
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Test access to cluster
kubectl get nodes

# Install the Calico Network Add-On -
# On the Control Plane Node, install Calico Networking:
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
kubectl get nodes


