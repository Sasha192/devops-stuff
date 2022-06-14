#!/bin/bash

EASY_RSA_DIR="/home/${USER}/easy-rsa"


cd ${EASY_RSA_DIR}

# first import the certification request
./easyrsa import-req /tmp/server.req server

# sign server
./easyrsa sign-req server UNIQUE_SHORT_FILE_NAME
# sign client
./easyrsa sign-req client UNIQUE_SHORT_FILE_NAME

scp pki/issued/server.crt sammy@your_vpn_server_ip:/tmp
scp pki/ca.crt sammy@your_vpn_server_ip:/tmp


# login at the OpenVPN server
# move the 'server.crt' and 'ca.crt' files to /etc/openvpn/server
# 
