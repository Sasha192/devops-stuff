#!/bin/bash

set -x

sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
apt-cache policy docker-ce

### run docker without sudo
sudo usermod -aG docker "jenkins"
sudo ln -sf "$(which docker)" /home/jenkins/common/docker
sudo -u jenkins docker run hello-world

set +x

# clean history
history -c
