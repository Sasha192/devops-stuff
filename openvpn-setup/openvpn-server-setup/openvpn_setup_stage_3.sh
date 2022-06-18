#!/bin/bash

CURRENT_DIR="${PWD##*/}"

if [[ ! "${CURRENT_DIR}" == "openvpn-server-setup" ]]
then
  echo "... Please, execute the bash script from its local directory ..."
fi

(. ../standard_functions.sh) \
|| (echo "... # standard_functions were NOT imported ..." && exit 1)

if [[ -z "${CA_CRT_FILE}" ]]; then
  CA_CRT_FILE="/tmp/ca.crt"
fi

if [[ -z "${SERVER_CRT_FILE}" ]]; then
  SERVER_CRT_FILE="/tmp/server.crt"
fi

function print_exit () {
    echo_red "... The last command was not successful ..."
    echo_red "... Please, check logs ..."
    echo "... Exit ..."
    exit 1
}

# TODO: why it can't be deployed ?
(source standard_functions.sh && \
echo_red "... # standard_functions were imported ...") \
|| (echo "... # standard_functions were NOT imported ..." && exit 1)

echo_red "... #1 mv ca.crt and server.crt files to /etc/openvpn/server"
(sudo mv "${CA_CRT_FILE}" "/etc/openvpn/server/ca.crt" && \
sudo mv "${SERVER_CRT_FILE}" "/etc/openvpn/server/server.crt") || print_exit
echo_red "... #1 Done ..."

# login at the OpenVPN server
# move the 'server.crt' and 'ca.crt' files to /etc/openvpn/server
#
# clean history
history -c
