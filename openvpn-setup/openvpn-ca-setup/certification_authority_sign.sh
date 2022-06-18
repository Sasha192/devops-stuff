#!/bin/bash

CURRENT_DIR="${PWD##*/}"
PREV_PATH="$(pwd)"

if [[ ! "${CURRENT_DIR}" == "openvpn-ca-setup" ]]
then
  echo "... Please, execute the bash script from its local directory ..."
fi

(. ../standard_functions.sh ) || \
(echo "... # ../standard_functions were NOT imported ..." && return 1)

usage() {                                 # Function: Print a help message.
  echo "Usage: $0 [ -c  CERTIFICATE_PATH ] [ -t TYPE: {client, server} ] " 1>&2
}

exit_abnormal() {                         # Function: Exit with error.
  usage
  return 1
}

while getopts ":c:t:" options; do         # Loop: Get the next option;
  case $options in                    #
    c) CERTIFICATE_PATH=$OPTARG
      ;;
    t) TYPE=$OPTARG
    ;;
    :)                                    # If expected argument omitted:
      echo "Error: -$OPTARG requires an argument."
      exit_abnormal                       # Exit abnormally.
      ;;
    *)                                    # If unknown (any other) option:
      exit_abnormal                       # Exit abnormally.
      ;;
  esac
done

if [[ "${#CERTIFICATE_PATH}" -eq 0 ]]; then exit_abnormal ; fi
if [[ "${#TYPE}" -eq 0 ]]; then exit_abnormal ; fi

EASY_RSA_DIR="/home/${USER}/easy-rsa" && \
cd "${EASY_RSA_DIR}" || (echo "Could not pass into ${EASY_RSA_DIR}" && return 1)

CERTIFICATION_NAME=''$(basename "${CERTIFICATE_PATH}" .crt)''

(./easyrsa import-req "${CERTIFICATE_PATH}" "${CERTIFICATION_NAME}" && \
./easyrsa sign-req "${TYPE}" "${CERTIFICATION_NAME}" && \
scp "./pki/issued/${CERTIFICATION_NAME}.crt" /tmp && \
scp "./pki/ca.crt" /tmp) || \
(echo_red "... # Could not sign the CSR ..." && return 1)
cd "${PREV_PATH}" || echo_red "... # Could not pass into the ${PREV_PATH} ..."
echo_red "... Done ..."

