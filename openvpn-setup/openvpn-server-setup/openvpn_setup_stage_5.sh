#!/bin/bash

# TODO: Make changes to file with patch !!!

# https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-an-openvpn-server-on-ubuntu-20-04-ru#7-openvpn 

# /usr/share/doc/openvpn/examples contains a variety of examples
# of config, .pam, .crt, .key, script files for OpenVPN server customization

CURRENT_DIR="${PWD##*/}"

if [[ ! "${CURRENT_DIR}" == "openvpn-server-setup" ]]
then
  echo "... Please, execute the bash script from its local directory ..."
fi

(. ../standard_functions.sh) \
|| (echo "... # standard_functions were NOT imported ..." && exit 1)

function print_exit () {
    echo_red "... The last command was not successful ..."
    echo_red "... Please, check logs ..."
    echo "... Exit ..."
    exit 1
}

(sudo cp ./server.conf /etc/openvpn/server/server.conf && \
echo_red "... # server.conf unzipped ...") || \
print_exit

# clean history
history -c

