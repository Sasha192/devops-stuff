#!/bin/bash

### https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-an-openvpn-server-on-ubuntu-20-04-ru#6

### Network configuration


# insert "net.ipv4.ip_forward = 1"
# to the /etc/sysctl.conf
# save it 
# sudo sysctl -p

# Теперь ваш сервер OpenVPN сможет перенаправлять входящий
# трафик из одного сетевого устройства на другое

# Это необходимо для того, чтобы  OpenVPN Сервер превратить в роутер.
# Он будет открыт для OpenVPN клиентов
# Как jumphost



### Firewall configuration


# digitalocean.com/community/tutorials/how-to-set-up-and-configure-an-openvpn-server-on-ubuntu-20-04-ru#9

USER_CERT_DIR="/home/${USER}/client_cert"

RED='\033[0;31m'
NC='\033[0m'

function echo_red () {
   echo -e "${RED}$1${NC}"
   echo -e "\n"
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

function create_client_configuration_infra () {


	if [ ! -d "${USER_CERT_DIR}" ]
	then
		mkdir "${USER_CERT_DIR}"
	fi

	if [ ! -d "${USER_CERT_DIR}/files" ]
	then
		mkdir "${USER_CERT_DIR}/files"
	fi

	cp \
	/usr/share/doc/openvpn/examples/sample-config-files/client.conf \
	"${USER_CERT_DIR}/base.conf"


}

echo_red "... #1 Started ..."
create_client_configuration_infra
check_last
echo_red "... #1 Done"
echo "... Please, do the "


# https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-an-openvpn-server-on-ubuntu-20-04-ru#11
