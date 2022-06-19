#!/bin/bash

USER=$(whoami)
export USER_CERT_PATH="/home/${USER}/client_cert"
export USER_CERT_KEYS_PATH="/home/${USER}/client_cert/keys"
export EASY_RSA_DIR="/home/${USER}/easy-rsa"

CA_USER="${CA_USER}"
CA_HOST="${CA_HOST}"
SCP_PASSWORD=${SCP_PASSWORD}

CURRENT_DIR="${PWD##*/}"
PREV_PATH="$(pwd)"

if [[ ! "${CURRENT_DIR}" == "openvpn-client-setup" ]]
then
  echo "... Please, execute the bash script from its local directory ..."
fi

(. ../standard_functions.sh ) || \
(echo "... # ../standard_functions were NOT imported ..." && return 1)

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
    return 1
fi

if [[ -z "${SCP_PASSWORD}" ]]; then
  echo_red "... ERROR ..."
  echo "... SCP_PASSWORD env variable was not specified ..."
  return 1
fi

function print_exit () {
    echo_red "... The last command was not successful ..."
    echo_red "... Please, check logs ..."
    echo "... Exit ..."
    return 1
}

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

function download_certificates () {

  CLIENT_NAME=$1
	(sshpass -p "${SCP_PASSWORD}" scp -o StrictHostKeyChecking=no "${CA_USER}"@"${CA_HOST}":/tmp/server.crt ''/tmp/"$CLIENT_NAME".crt'' && \
  sshpass -p "${SCP_PASSWORD}" scp -o StrictHostKeyChecking=no "${CA_USER}"@"${CA_HOST}":/tmp/ca.crt /tmp/ca.crt) || \
	(echo "... Could not execute download_certificates ..." && exit 1)

}

echo_red "... Downloading certificates ..."
(download_certificates "$CLIENT_NAME") || (echo_red "... # Error, please look into logs ..." && return 1)
echo_red "... Done ..."


# clean history
history -c
