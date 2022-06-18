#!/bin/bash

USER=$(whoami)
EASY_RSA_DIR="/home/${USER}/easy-rsa"
CURRENT_DIR="${PWD##*/}"

if [[ ! "${CURRENT_DIR}" == "openvpn-server-setup" ]]
then
  echo "... Please, execute the bash script from its local directory ..."
fi

(. ../standard_functions.sh ) \
|| (echo "... # standard_functions were NOT imported ..." && return 1)

function print_exit () {
    echo_red "... The last command was not successful ..."
    echo_red "... Please, check logs ..."
    echo "... Exit ..."
    return 1
}

USER_CERT_INFRA="/home/${USER}/client_cert"

function create_client_configuration_infra () {

	if [ ! -d "${USER_CERT_INFRA}" ]
	then
		mkdir "${USER_CERT_INFRA}" || \
		(echo_red "... # Could not create ${USER_CERT_INFRA} directory" && \
		print_exit)
	fi

	if [ ! -d "${USER_CERT_INFRA}/keys" ]
	then
		mkdir "${USER_CERT_INFRA}/keys" || \
		(echo_red "... # Could not create ${USER_CERT_INFRA}/keys directory" && \
		print_exit)
	fi

	sudo cp "${EASY_RSA_DIR}/ta.key" "${USER_CERT_INFRA}" && \
  sudo cp /etc/openvpn/server/ca.crt "${USER_CERT_INFRA}" && \
  sudo chown -R "${USER}" "${USER_CERT_INFRA}"


}

echo_red "... #1 Started ..."
create_client_configuration_infra || (echo_red "... Could not Client Configuration Infrastructure ..." && return 1)
echo_red "... #1 Done"


# https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-an-openvpn-server-on-ubuntu-20-04-ru#11
