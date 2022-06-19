#!/bin/bash

USER=$(whoami)
CURRENT_DIR="${PWD##*/}"
USER_CERT_KEYS_PATH="/home/${USER}/client_cert/keys"
OUTPUT_DIR="./"
BASE_CONFIG="./base.conf"

if [[ ! "${CURRENT_DIR}" == "openvpn-client-setup" ]]
then
  echo "... Please, execute the bash script from its local directory ..."
fi

(. ../standard_functions.sh ) \
|| (echo "... # ../standard_functions were NOT imported ..." && return 1)

usage() {
  echo "Usage: $0 [ -a OPENVPN_SERVER_ADDRESS ] [ -c CLIENT_NAME ]" 1>&2
}

  while getopts ":a:c:" options; do
    case $options in
      c) CLIENT_NAME=$OPTARG
        ;;
      a) OPENVPN_SERVER_ADDRESS=$OPTARG
        ;;
      : | *)
        usage
        return 1
        ;;
    esac
  done

if [[ "${#CLIENT_NAME}" -eq 0 ]]; then
  usage
  return 1
fi
if [[ "${#OPENVPN_SERVER_ADDRESS}" -eq 0 ]]; then
  usage
  return 1
fi


sed -i ''s/OPENVPN_SERVER_PUBLIC_IP/"${OPENVPN_SERVER_ADDRESS}"/g'' ./base.conf

(cat ${BASE_CONFIG} \
    <(echo -e '<ca>') \
    "${USER_CERT_KEYS_PATH}/ca.crt" \
    <(echo -e '</ca>\n<cert>') \
    "${USER_CERT_KEYS_PATH}/$CLIENT_NAME.crt" \
    <(echo -e '</cert>\n<key>') \
    "${USER_CERT_KEYS_PATH}/$CLIENT_NAME.key" \
    <(echo -e '</key>\n<tls-crypt>') \
    "${USER_CERT_KEYS_PATH}/ta.key" \
    <(echo -e '</tls-crypt>') \
    > "${OUTPUT_DIR}/$CLIENT_NAME.ovpn" && \
    echo_red "... ${OUTPUT_DIR}/$CLIENT_NAME.ovpn your client configuration ..." && \
    echo_red "... # Done ...") || \
    (echo_red "... # Some issue occurred ..." && return 1)






