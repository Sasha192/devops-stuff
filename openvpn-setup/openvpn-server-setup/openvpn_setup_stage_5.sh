#!/bin/bash

# TODO: Make changes to file with patch !!!

# https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-an-openvpn-server-on-ubuntu-20-04-ru#7-openvpn 

# /usr/share/doc/openvpn/examples contains a variety of examples
# of config, .pam, .crt, .key, script files for OpenVPN server customization

(source ../standard_functions.sh && \
echo_red "... # ../standard_functions were imported ...") \
|| (echo "... # ../standard_functions were NOT imported ..." && exit 1)

sudo cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz ./ && \
sudo gunzip /etc/openvpn/server/server.conf.gz && \
echo_red "... # server.conf unzipped ..." ||
print_exit

# setup the ta.key
sed -e '/tls-auth.*/ s/^;*/;/' -i /etc/openvpn/server/server.conf && \
sed '/^tls-auth.*/a tls-crypt ta.key' -i /etc/openvpn/server/server.conf && \
echo_red "... #1 ta.key was set up ..." || \
print_exit

# GCM is more secure, than CBC
# Mihir Bellare, Joe Kilian та Phillip Rogaway. “The Security of Cipher Block Chaining”
# Mihir Bellare та Chanathip Namprempre. “Authenticated Encryption: Relations among Notions and Analysis of the Generic Composition Paradigm”
# https://security.stackexchange.com/questions/184305/why-would-i-ever-use-aes-256-cbc-if-aes-256-gcm-is-more-secure
sed -e '/cipher.*/ s/^;*/;/' -i /etc/openvpn/server/server.conf && \
sed -e '/^;cipher.*/a cipher AES-256-GCM' -i /etc/openvpn/server/server.conf && \
echo_red "... #2 cipher AES-256-GCM was set up ..." || \
print_exit

# setup the authentication code function
sed -e '/^cipher/a auth SHA256' -i /etc/openvpn/server/server.conf && \
echo_red "... #3 auth SHA256 was set up ..." || \
print_exit

# disable Diffie-Hellman
# until this moment, we already set up the EC parameters
sed -e '/^dh.*/ s/^;*/;/' -i /etc/openvpn/server/server.conf && \
sed -e '/^;dh.*/a dh none' -i /etc/openvpn/server/server.conf && \
echo_red "... #4 Diffie-Hellman was disabled ..." || \
print_exit

# run OpenVPN Server as nobody
sed '/user nobody/s/^;//' -i /etc/openvpn/server/server.conf && \
sed '/group nogroup/s/^;//' -i /etc/openvpn/server/server.conf && \
echo_red "... #5 run OpenVPN Server as nobody was set up  ..." || \
print_exit
