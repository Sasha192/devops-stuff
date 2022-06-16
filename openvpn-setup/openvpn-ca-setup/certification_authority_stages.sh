#!/bin/bash

CURRENT_DIR="${PWD##*/}"

if [[ ! "${CURRENT_DIR}" == "openvpn-ca-setup" ]]
then
  echo "... Please, execute the bash script from its local directory ..."
fi

USER=$(whoami)
EASY_RSA_DIR="/home/${USER}/easy-rsa"
PREV_DIR=$(pwd)

(source ../standard_functions.sh && \
echo_red "... # ../standard_functions were imported ...") \
|| (echo "... # ../standard_functions were NOT imported ..." && exit 1)

function check_easy_rsa_else_exit () {

	if [ ! -d "${EASY_RSA_DIR}" ]
	then 
		echo_red "... ${EASY_RSA_DIR} is not exist ..."
		echo_red "... Exit ..."
		exit 1
	fi

}

# stage 1
function install_prerequisites () {
	sudo apt update && \
	sudo apt install easy-rsa
	if [ ! -d "${EASY_RSA_DIR}" ]
	then 
		mkdir "${EASY_RSA_DIR}" && \
		ln -s /usr/share/easy-rsa/* "${EASY_RSA_DIR}" && \
		chmod -R 700 "${EASY_RSA_DIR}"
	fi
}

# stage 2
function init_pki () {

	check_easy_rsa_else_exit && \
	cd "${EASY_RSA_DIR}" && \
	./easyrsa init-pki

}

# stage 3
function create_certification_authority () {

	check_easy_rsa_else_exit && cd "${EASY_RSA_DIR}" || \
	(echo_red "... # Could not pass into the ${EASY_RSA_DIR} ..." && exit 1)

	read -r -e -p "What's your country ?:" -i "Ukraine" EASYRSA_REQ_COUNTRY
	read -r -e -p "What's your province ?:" -i "Chernihiv" EASYRSA_REQ_PROVINCE
	read -r -e -p "What's your city ?:" -i "Chernihiv" EASYRSA_REQ_CITY
	read -r -e -p "What's your organisation ?:" -i "37WP" EASYRSA_REQ_ORG
	read -r -e -p "What's your email ?:" -i "sasha192.bunin@gmail.com" EASYRSA_REQ_EMAIL
	read -r -e -p "What's your organisational unit ?:" -i "Ukraine" EASYRSA_REQ_OU

	EASYRSA_ALGO="ec"
	EASYRSA_DIGEST="sha512"

cat <<EOF >> vars
set_var EASYRSA_REQ_COUNTRY    "${EASYRSA_REQ_COUNTRY}"
set_var EASYRSA_REQ_PROVINCE   "${EASYRSA_REQ_PROVINCE}"
set_var EASYRSA_REQ_CITY       "${EASYRSA_REQ_CITY}"
set_var EASYRSA_REQ_ORG        "${EASYRSA_REQ_ORG}"
set_var EASYRSA_REQ_EMAIL      "${EASYRSA_REQ_EMAIL}"
set_var EASYRSA_REQ_OU         "${EASYRSA_REQ_OU}"
set_var EASYRSA_ALGO           "${EASYRSA_ALGO}"
set_var EASYRSA_DIGEST         "${EASYRSA_DIGEST}"
EOF

  ./easyrsa build-ca nopass

}


#stage 4
function distribute_ca () {


  # send the ca.crt to the /tmp directory
  CA_FILE="${EASY_RSA_DIR}/pki/ca.crt"
  cd "${EASY_RSA_DIR}" || (echo "Could not pass into ${EASY_RSA_DIR}" && exit 1)
  if [[ ! -f "${CA_FILE}" ]]; then
    echo_red "Certificate ${CA_FILE} does not exist. Please, check previous stages" && \
    exit 1
  fi

  cp "${CA_FILE}" /tmp/ca.crt && \
  check_last_else "echo \"Could not save ca.crt\""

  CA_UPDATED=0
  # Ubuntu, Debian
  if command -v update-ca-certificates &> /dev/null
  then
      echo_red "... 'update-ca-certificates' tool found ..." && \
      sudo cp /tmp/ca.crt /usr/local/share/ca-certificates/ && \
      sudo update-ca-certificates && \
      CA_UPDATED=1
  fi

  # CentOS, Fedora, RedHat
  if [ ${CA_UPDATED} == 0 ]
  then
    if command -v update-ca-trust &> /dev/null
    then
        echo_red "... 'update-ca-certificates' tool found ..." && \
        sudo cp /tmp/ca.crt /etc/pki/ca-trust/source/anchors/ && \
        sudo update-ca-trust && \
        CA_UPDATED=1
    fi
  fi

  # CHECK
  if [ ${CA_UPDATED} == 0 ]
  then
    echo_red "... Could not update certificates ..." && \
    exit 1
  fi

}

$1 "${@:2}"
check_last_else "cd ${PREV_DIR}"
cd "${PREV_DIR}"


