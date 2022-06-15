#!/bin/bash


USER=$(whoami)
USER_CERT_DIR="/home/${USER}/client_cert"
USER_CERT_KEYS_DIR="/home/${USER}/client_cert/keys"
EASY_RSA_DIR="/home/${USER}/easy-rsa"
PREV_DIR=$(pwd)
CLIENT="${CLIENT_NAME}"

RED='\033[0;31m'
NC='\033[0m'

function echo_red () {
   echo -e "${RED}$1${NC}"
   echo -e "\n"
}

if [[ -z "${CLIENT_NAME}" ]]; then
	echo_red "... Error ..."
	echo_red "... Could not find CLIENT_NAME env variable ..."
	return 1
fi


if [ ! -d "${USER_CERT_DIR}" ] 
then
    mkdir "${USER_CERT_DIR}" && \
    chmod -R 700 "${USER_CERT_DIR}"
    check_last
fi


if [ ! -d "${USER_CERT_KEYS_DIR}" ] 
then
    mkdir "${USER_CERT_KEYS_DIR}" && \
    chmod -R 700 "${USER_CERT_KEYS_DIR}"
    check_last
fi


function create_client_cert_req () {

	cd ${EASY_RSA_DIR} && \
	./easyrsa gen-req ${CLIENT} nopass && \
	cp "${EASY_RSA_DIR}/pki/private/${CLIENT}.key" "${USER_CERT_KEYS_DIR}"

}

function check_last () {

	if [ ! $? -eq 0 ]; 
	then
		echo_red "... The last command was not successful ..."
		echo_red "... Please, check logs ..."
		echo "... Exit ..."
		exit 1
	fi

}


echo_red "... #1 Creating the Client Certification Request ..."
create_client_cert_req && \
check_last
echo_red "... Done ..."

echo_red "... #2 Sending the Certification Request ..."
. ./openvpn_stages.sh send_certification_request_from_arg "${EASY_RSA_DIR}/pki/reqs/${CLIENT}.req"
check_last
echo_red "... #2 Done ..."

history -c
