#!/bin/bash

wget -O jdk17.tar.gz https://download.oracle.com/java/17/archive/jdk-17.0.3.1_linux-x64_bin.tar.gz
tar -xzvf jdk17.tar.gz
find . -maxdepth 1 -type d -name '*jdk*' -exec mv {} jdk17 \;
sudo ln -s "$(pwd)/jdk17/bin/java" /usr/local/bin/java17
echo JDK_17="$(pwd)/jdk17" >> ~/.bashrc
sudo chmod 777 ./switch-to-java-17.sh
sudo ln -s "$(pwd)/switch-to-java-17.sh" /usr/local/bin/switch-java-17
