#!/bin/bash

USER=$(whoami)
USER_CERT_KEYS_PATH="/home/${USER}/client_cert/keys"
CURRENT_DIR="${PWD##*/}"

if [[ ! "${CURRENT_DIR}" == "openvpn-client-setup" ]]
then
  echo "... Please, execute the bash script from its local directory ..."
fi

(. ../standard_functions.sh ) \
|| (echo "... # ../standard_functions were NOT imported ..." && return 1)

usage() {
  echo "Usage: $0 [ -c CLIENT_NAME ] " 1>&2
}

while getopts ":c:" options; do

    case $options in
      c) CLIENT_NAME=$OPTARG
        ;;
      : | *)
        usage
        return 1
        ;;
    esac
done

if [[ "${#CLIENT_NAME}" -eq 0 ]]
then
  usage
  return 1
fi

( sudo mv "/tmp/${CLIENT_NAME}.crt" "${USER_CERT_KEYS_PATH}" && \
sudo mv  "/tmp/ca.crt" "${USER_CERT_KEYS_PATH}" )|| \
(echo_red "... # Could not move client certificates ..." && exit 1)





