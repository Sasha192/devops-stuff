#!/bin/bash

(sudo kubeadm reset && \
sudo rm -rf /opt/cni/bin && \
sudo rm -rf etc/cni/net.d && \
sudo rm -rf ~/.kube/config && \
sudo iptables -F && \
sudo iptables -t nat -F && \
sudo iptables -t mangle -F && \
sudo iptables -X && \
echo "Done") || \
echo "Not Done"

