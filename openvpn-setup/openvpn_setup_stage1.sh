#!/bin/bash

if [[ -z "${UNIQUE_HOST_SHORT_NAME}" ]]; then
  UNIQUE_HOST_SHORT_NAME="server"
  return 1
fi

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
    exit
fi

if [[ -z "${SCP_PASSWORD}" ]]; then
  echo_red "... ERROR ..."
  echo "... SCP_PASSWORD env variable was not specified ..."
  return 1
fi

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

echo_red "... #1 OpenVPN installation ..."
. ./openvpn_stages.sh install
check_last_else
echo_red "... #1 Done ..."

echo_red "... #2 Exporting vars ..."
. ./openvpn_stages.sh create_vars
check_last_else
echo_red "... #2 Done ..."

echo_red "... #3 PKI creation ..."
. ./openvpn_stages.sh init_pki
check_last_else
echo_red "... #3 Done ..."

echo_red "... #4 Create certification request and private key ..."
. ./openvpn_stages.sh certification_request_and_private_key
check_last_else
echo_red "... #4 Done ..."

echo_red "... #5 Sending certification request..."
. ./openvpn_stages.sh send_certification_request
check_last_else
echo_red "... #5 Done ..."


history -c
