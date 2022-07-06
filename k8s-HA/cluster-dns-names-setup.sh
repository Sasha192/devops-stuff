#!/bin/bash

SUBNET_ADDR=192.168.31.0/24
if ! [ $# -eq 0 ]; then
  SUBNET_ADDR=$1
fi
ubuntu_names=$(sudo nmap -sP $SUBNET_ADDR | grep 'ubuntu*' | awk '{print $5, $6}' | tr -d '()')
sudo sed -i.bak '/ubuntu*/d' /etc/hosts
for ubuntu_i in "${ubuntu_names[@]}"; do
 echo -e "$ubuntu_i\n$(sudo cat /etc/hosts)" > /etc/hosts
done

K8S_CONTROL_PLANE_HOST=$(dig ubuntu1 +short)
echo -e "$K8S_CONTROL_PLANE_HOST k8s-control-plane\n$(sudo cat /etc/hosts)" > /etc/hosts

K8S_CONTROL_PLANE_HOST=$(dig ubuntu1 +short)

if [[ $(hostname) =~ ubuntu* ]]; then
  echo -e "127.0.1.1 $(hostname)\n$(sudo cat /etc/hosts)" > /etc/hosts
fi
