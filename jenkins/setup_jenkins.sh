#!/bin/bash

### 1 Installation
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins

# JENKINS_HOME;
mkdir -p "/home/jenkins"
sudo chown jenkins:jenkins "/home/jenkins"
sudo usermod -d "/home/jenkins" jenkins
sudo ln -sf "/home/jenkins" /var/lib/jenkins
sudo chown jenkins /var/lib/jenkins

sudo su jenkins
cd
echo "$(pwd)"
echo "$USER"

### 2 Run Jenkins
#sudo systemctl restart jenkins.service
#sudo systemctl enable jenkins.service



### 3 initialAdminSecret
#sudo cat /var/lib/jenkins/secrets/initialAdminPassword
