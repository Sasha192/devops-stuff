#!/bin/bash

wget -O mvn3.8.3.tar.gz https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
tar -xzvf mvn3.8.3.tar.gz
find . -maxdepth 1 -type d -name '*apache-maven*' -exec mv {} mvn3.8.3 \;
sudo ln -s "$(pwd)/mvn3.8.3/bin/mvn" /usr/bin/mvn
