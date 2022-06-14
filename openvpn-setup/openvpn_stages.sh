
#
#set -x


USER=$(whoami)
EASY_RSA_DIR="/home/${USER}/easy-rsa"
PREV_DIR=$(pwd)



UNIQUE_HOST_SHORT_NAME="${UNIQUE_HOST_SHORT_NAME}"
CA_USER=${CA_USER}
CA_HOST=${CA_HOST}
SCP_PASSWORD=${SCP_PASSWORD}


if [[ -z "${UNIQUE_HOST_SHORT_NAME}" ]]; then
	UNIQUE_HOST_SHORT_NAME="server"
fi

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


# stage 1
function install () {


	sudo apt update && \
	sudo apt install openvpn easy-rsa && \
	mkdir $EASY_RSA_DIR && \
	ln -s /usr/share/easy-rsa/* $EASY_RSA_DIR && \
	sudo chown ${whoami} $EASY_RSA_DIR && \
	chmod 700 $EASY_RSA_DIR

}


# stage 2
function create_vars () {


	cd $EASY_RSA_DIR && \
	touch vars && \
	echo "set_var EASYRSA_ALGO \"ec\"" | tee vars && \
	echo "set_var EASYRSA_DIGEST \"sha512\"" | tee -a vars && \

}

#stage 3
function init_pki () {

	cd $EASY_RSA_DIR && \
	./easyrsa init-pki

}

#stage 4
function certification_request_and_private_key () {

	# https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-an-openvpn-server-on-ubuntu-20-04-ru#3-openvpn

	export EASYRSA_BATCH=1 && \
	cd $EASY_RSA_DIR && \
	./easyrsa gen-req ${UNIQUE_HOST_SHORT_NAME} nopass && \
	sudo cp "${EASY_RSA_DIR}/pki/private/${UNIQUE_HOST_SHORT_NAME}.key /etc/openvpn/server/" && \



}

# stage 5
function send_certification_request () {


	sshpass -p "${SCP_PASSWORD}" scp "${EASY_RSA_DIR}/pki/reqs/${UNIQUE_HOST_SHORT_NAME}.req" "${CA_USER}"@"${CA_HOST}":/tmp

}

function send_certification_request_from_arg () {


	sshpass -p "${SCP_PASSWORD}" scp $1 "${CA_USER}"@"${CA_HOST}":/tmp	


}


# stage 6: pre-shared-keys
function pre_shared_keys_configuration () {


	cd ${EASY_RSA_DIR} && \
	openvpn --genkey --secret ta.key && \
	sudo cp ${EASY_RSA_DIR}/ta.key /etc/openvpn/server

}



$1 "${@:2}"
check_last_else "cd ${PREV_DIR}"
cd ${PREV_DIR}



#
#set +x