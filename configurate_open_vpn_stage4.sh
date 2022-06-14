#!/bin/bash


# https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-an-openvpn-server-on-ubuntu-20-04-ru#7-openvpn 

sudo cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz /etc/openvpn/server/
sudo gunzip /etc/openvpn/server/server.conf.gz
