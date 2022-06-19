#!/bin/bash

### creates CSR and sends to the CA

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

EASY_RSA_DIR="/home/${USER}/easy-rsa" && \
cd "${EASY_RSA_DIR}" || (echo_red "Could not pass into ${EASY_RSA_DIR}" && exit 1)

if [ ! -d "${USER_CERT_PATH}" ]
then
    (mkdir "${USER_CERT_PATH}" && \
    chmod -R 700 "${USER_CERT_PATH}") ||
    echo_red "... # Could not create ${USER_CERT_KEYS_PATH} DIR"
fi


if [ ! -d "${USER_CERT_KEYS_PATH}" ]
then
    (mkdir "${USER_CERT_KEYS_PATH}" && \
    chmod -R 700 "${USER_CERT_KEYS_PATH}") ||
    echo_red "... # Could not create ${USER_CERT_KEYS_PATH} DIR"
fi


function create_client_cert_req () {

	(cd "${EASY_RSA_DIR}" && \
	./easyrsa gen-req "$1" nopass && \
	cp "${EASY_RSA_DIR}/pki/private/$1.key" "${USER_CERT_KEYS_PATH}") || \
	return 1

}

function send_certification_request () {

  CRT_FILE_NAME=$(basename "$1")
	(sshpass -p "${SCP_PASSWORD}" scp "$1" "${CA_USER}"@"${CA_HOST}":''/tmp/"$CRT_FILE_NAME"'' && \
	sshpass -p "${SCP_PASSWORD}" ssh -o StrictHostKeyChecking=no "${CA_USER}"@"${CA_HOST}" '' chmod -R 777 /tmp/"$CRT_FILE_NAME" '')|| \
	return 1


}


echo_red "... #1 Creating the Client Certification Request ..."
create_client_cert_req "$CLIENT_NAME" || \
(echo_red "... # Could not create client_cert ..." && exit 1)
echo_red "... #1 Done ..."

echo_red "... #2 Sending the Certification Request ..."
(send_certification_request "${EASY_RSA_DIR}/pki/reqs/$CLIENT_NAME.req") || \
(echo_red "... # Could not send client_cert for signing ..." && return 1)
echo_red "... #2 Done ..."

cd "$PREV_PATH"

history -c
