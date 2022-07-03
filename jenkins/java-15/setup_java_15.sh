#!/bin/bash

wget -O jdk15.tar.gz https://www.oracle.com/java/technologies/javase/jdk15-archive-downloads.html#license-lightbox
tar -xzvf jdk15.tar.gz
find . -maxdepth 1 -type d -name '*jdk*' -exec mv {} jdk15 \;
sudo ln -s "$(pwd)/jdk15/bin/java" /usr/local/bin/java15
echo JDK_17="$(pwd)/jdk15" >> ~/.bashrc
sudo chmod 777 ./switch-to-java-15.sh
sudo ln -s "$(pwd)/switch-to-java-15.sh" /usr/local/bin/switch-to-java-15
