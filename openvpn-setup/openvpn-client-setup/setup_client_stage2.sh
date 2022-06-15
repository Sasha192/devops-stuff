#!/bin/bash

# we' ve already got our client certificate 
# let's put it into the dir:
# client1.crt file to the USER_CERT_KEYS_DIR="/home/${USER}/client_cert/keys"
# cp ~/easy-rsa/ta.key ~/client-configs/keys/
# sudo cp /etc/openvpn/server/ca.crt ~/client-configs/keys/
# 
# 
# скопировать ta.key, ca.crt в папку с ~/client_cert/keys
#

USER=$(whoami)
USER_CERT_DIR="/home/${USER}/client_cert"
USER_CERT_KEYS_DIR="/home/${USER}/client_cert/keys"
EASY_RSA_DIR="/home/${USER}/easy-rsa"
PREV_DIR=$(pwd)
CLIENT="${CLIENT_NAME}"




