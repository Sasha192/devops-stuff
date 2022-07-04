#!/bin/bash

### 1 Setting Up
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins

# JENKINS_HOME;
export JENKINS_HOME="/home/jenkins" && \
mkdir -p "/home/jenkins" && \
sudo chown jenkins:jenkins "/home/jenkins" && \
sudo usermod -d "/home/jenkins" jenkins && \
sudo cp -prv /var/lib/jenkins /home/jenkins/ && \
sudo rm -rf /var/lib/jenkins && \
sudo ln -sf "/home/jenkins" /var/lib/jenkins && \
sudo chown jenkins:jenkins /var/lib/jenkins

### SETUP COMMON LIBRARIES
sudo mkdir -p /home/jenkins/common && \
sudo chown jenkins:jenkins /home/jenkins/common && \
sudo chmod -R 777 /home/jenkins/common

### 2 Run Jenkins
sudo systemctl restart jenkins.service
sudo systemctl enable jenkins.service

### 3 initialAdminSecret
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
