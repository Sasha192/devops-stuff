#!/bin/bash


USER=$(whoami)
EASY_RSA_DIR="/home/${USER}/easy-rsa"
PREV_DIR=$(pwd)

RED='\033[0;31m'
NC='\033[0m'

function echo_red () {
   echo -e "${RED}$1${NC}"
   echo -e "\n"
}

function check_last_else () {

	ELSE_CMD="echo"
	if [ -z "$1" ]
	then
	    ELSE_CMD="$1"
	fi

	if [ ! $? -eq 0 ]; 
	then
		echo_red "... The last command was not successful ..."
		echo_red "... Please, check logs ..."
		echo_red "... Executing the last ELSE_CMD ..."
		$(ELSE_CMD)
		echo "... Exit ..."
		exit 1
	fi

}

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
		mkdir ${EASY_RSA_DIR}
		ln -s /usr/share/easy-rsa/* ${EASY_RSA_DIR}
		chmod -R 700 ${EASY_RSA_DIR}
	fi
}

# stage 2
function init_pki () {

	check_easy_rsa_else_exit
	cd ${EASY_RSA_DIR}
	./easyrsa init-pki

}

# stage 3
function certification_authority () {

	check_easy_rsa_else_exit
	cd ${EASY_RSA_DIR}

	read -e -p "What's your country ?:" -i "Ukraine" EASYRSA_REQ_COUNTRY
	read -e -p "What's your province ?:" -i "Chernihiv" EASYRSA_REQ_PROVINCE
	read -e -p "What's your city ?:" -i "Chernihiv" EASYRSA_REQ_CITY
	read -e -p "What's your organistation ?:" -i "37WP" EASYRSA_REQ_ORG
	read -e -p "What's your email ?:" -i "sasha192.bunin@gmail.com" EASYRSA_REQ_EMAIL
	read -e -p "What's your organisational unit ?:" -i "Ukraine" EASYRSA_REQ_OU


	# interactive part
	echo -n "What's your country ?: "
	read -r EASYRSA_REQ_COUNTRY
	EASYRSA_REQ_COUNTRY=${EASYRSA_REQ_COUNTRY:Ukraine}

	echo -n "What's your province ?: "
	read -r EASYRSA_REQ_PROVINCE
	EASYRSA_REQ_PROVINCE=${EASYRSA_REQ_PROVINCE:Chernihiv}

	echo -n "What's your city ?: "
	read -r EASYRSA_REQ_CITY

	echo -n "What's your organistation ?: "
	read -r EASYRSA_REQ_ORG

	echo -n "What's your email ?: "
	read -r EASYRSA_REQ_EMAIL

	echo -n "What's your organisational unit ?: "
	read -r EASYRSA_REQ_OU

}





$1 "${@:2}"
check_last_else "cd ${PREV_DIR}"
cd ${PREV_DIR}


