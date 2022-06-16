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

(source ../standard_functions.sh && \
echo_red "... # ../standard_functions were imported ...") \
|| (echo "... # ../standard_functions were NOT imported ..." && exit 1)

usage() {
  echo "Usage: $0 [ -a OPENVPN_SERVER_ADDRESS ] [ -c CLIENT_NAME ] OR CLIENT_NAME env variable" 1>&2
}

exit_abnormal() {                         # Function: Exit with error.
  usage
  exit 1
}

CLIENT_NAME="${CLIENT_NAME}"
OPENVPN_SERVER_ADDRESS=""


  echo_red ""
  while getopts "a:c" options; do         # Loop: Get the next option;
                                            # use silent error checking;
                                            # options n and t take arguments.
    case "${options}" in                    #
      c)
        CLIENT_NAME=${OPTARG}
        ;;
      a)
        OPENVPN_SERVER_ADDRESS=${OPTARG}
        ;;
      :)                                    # If expected argument omitted:
        echo "Error: -${OPTARG} requires an argument."
        exit_abnormal                       # Exit abnormally.
        ;;
      *)                                    # If unknown (any other) option:
        exit_abnormal                       # Exit abnormally.
        ;;
    esac
  done

if ! [[ "${#CLIENT_NAME}" -eq 0 ]]; then exit_abnormal ; fi
if ! [[ "${#OPENVPN_SERVER_ADDRESS}" -eq 0 ]]; then exit_abnormal ; fi


sed -i ''s/OPENVPN_SERVER_PUBLIC_IP/"${OPENVPN_SERVER_ADDRESS}"/g'' ./base.conf

(cat ${BASE_CONFIG} \
    <(echo -e '<ca>') \
    "${USER_CERT_KEYS_PATH}/ca.crt" \
    <(echo -e '</ca>\n<cert>') \
    "${USER_CERT_KEYS_PATH}/${CLIENT_NAME}.crt" \
    <(echo -e '</cert>\n<key>') \
    "${USER_CERT_KEYS_PATH}/${CLIENT_NAME}.key" \
    <(echo -e '</key>\n<tls-crypt>') \
    "${USER_CERT_KEYS_PATH}/ta.key" \
    <(echo -e '</tls-crypt>') \
    > "${OUTPUT_DIR}/${CLIENT_NAME}.ovpn" && \
    echo_red "... # Done ...") || \
    (echo_red "... # Some issue occurred ..." && exit 1)






