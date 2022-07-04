#!/bin/bash

set -x

### SETUP JAVA 17
wget -O jdk17.tar.gz https://download.oracle.com/java/17/archive/jdk-17.0.3.1_linux-x64_bin.tar.gz
tar -xzvf jdk17.tar.gz
find . -maxdepth 1 -type d -name '*jdk*' -exec mv {} jdk17 \;
sudo chmod -R 777 "$(pwd)/jdk17/"
sudo ln -sf "$(pwd)/jdk17/" /home/jenkins/common/jdk17

### SETUP MVN 3.8.3
wget -O mvn3.8.3.tar.gz https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
tar -xzvf mvn3.8.3.tar.gz
find . -maxdepth 1 -type d -name '*apache-maven*' -exec mv {} mvn3.8.3 \;
sudo chmod -R 777 "$(pwd)/mvn3.8.3"
sudo ln -sf "$(pwd)/mvn3.8.3/bin/mvn" /usr/bin/mvn
sudo ln -sf "$(pwd)/mvn3.8.3/" /home/jenkins/common/maven
