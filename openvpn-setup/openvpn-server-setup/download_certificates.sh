#!/bin/bash

CURRENT_DIR="${PWD##*/}"

if [[ ! "${CURRENT_DIR}" == "openvpn-server-setup" ]]
then
  echo "... Please, execute the bash script from its local directory ..."
fi

(. ../standard_functions.sh) || \
(echo "... # standard_functions were NOT imported ..." && exit )

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

echo_red "... Downloading certificates ..."
(. ./openvpn_stages.sh download_certificates) || (echo_red "... # Error, please look into logs ..." && return 1)
echo_red "... Done ..."


# clean history
history -c
