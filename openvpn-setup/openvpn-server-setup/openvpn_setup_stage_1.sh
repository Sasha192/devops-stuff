#!/bin/bash

CURRENT_DIR="${PWD##*/}"

if [[ ! "${CURRENT_DIR}" == "openvpn-server-setup" ]]
then
  echo "... Please, execute the bash script from its local directory ..."
fi

(. ../standard_functions.sh) \
|| (echo "... # standard_functions were NOT imported ..." && exit 1)

if [[ -z "${UNIQUE_HOST_SHORT_NAME}" ]]; then
  UNIQUE_HOST_SHORT_NAME="server"
fi

if [[ -z "${CA_USER}" ]]; then
  echo_red "... ERROR ..."
  echo "... CA_USER env variable was not specified ..."
  return 1
fi

if [[ -z "${CA_HOST}" ]]; then
  echo_red "... ERROR ..."
  echo "... CA_HOST env variable was not specified ..."
  return 1
fi

if ! command -v sshpass &> /dev/null
then
    echo_red "... <sshpass> could not be found ..."
    exit
fi

if [[ -z "${SCP_PASSWORD}" ]]; then
  echo_red "... ERROR ..."
  echo "... SCP_PASSWORD env variable was not specified ..."
  return 1
fi

echo_red "... #1 OpenVPN installation ..."
(. ./openvpn_stages.sh install_prerequisites) || print_exit
echo_red "... #1 Done ..."

echo_red "... #2 Exporting vars ..."
(. ./openvpn_stages.sh create_vars) || print_exit
echo_red "... #2 Done ..."

echo_red "... #3 PKI creation ..."
(. ./openvpn_stages.sh init_pki) || print_exit
echo_red "... #3 Done ..."

echo_red "... #4 Create certification request and private key ..."
(. ./openvpn_stages.sh certification_request_and_private_key) || print_exit
echo_red "... #4 Done ..."

echo_red "... #5 Sending certification request..."
(. ./openvpn_stages.sh send_certification_request) || print_exit
echo_red "... #5 Done ..."


# clean history
history -c
