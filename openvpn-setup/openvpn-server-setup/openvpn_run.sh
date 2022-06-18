#!/bin/bash


### Run OpenVPN Server

sudo systemctl -f enable openvpn-server@server.service && \
sudo systemctl start openvpn-server@server.service && \
sudo systemctl status openvpn-server@server.service && \
echo "... OpenVPN Server was started ..."
