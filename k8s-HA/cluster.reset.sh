#!/bin/bash

(sudo kubeadm reset && \
sudo iptables -F && \
sudo iptables -t nat -F && \
sudo iptables -t mangle -F && \
sudo iptables -X && \
echo "Done") || \
echo "Not Done"

