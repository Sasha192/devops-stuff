
#
#set -x


USER=$(whoami)
EASY_RSA_DIR="/home/${USER}/easy-rsa"
PREV_DIR=$(pwd)

. ../standard_functions.sh \
|| (echo "... # standard_functions were NOT imported ..." && exit 1)

UNIQUE_HOST_SHORT_NAME="${UNIQUE_HOST_SHORT_NAME}"
CA_USER=${CA_USER}
CA_HOST=${CA_HOST}
SCP_PASSWORD=${SCP_PASSWORD}


if [[ -z "${UNIQUE_HOST_SHORT_NAME}" ]]; then
	UNIQUE_HOST_SHORT_NAME="server"
fi


# step 1
function install_prerequisites () {

	(sudo apt update && \
	sudo apt install openvpn easy-rsa && \
	mkdir "$EASY_RSA_DIR" && \
	ln -s /usr/share/easy-rsa/* $EASY_RSA_DIR && \
	sudo chown "$(whoami)" "$EASY_RSA_DIR" && \
	chmod 700 "$EASY_RSA_DIR") ||
	print_exit

}


# step 2
function create_vars () {


	(cd "$EASY_RSA_DIR" && \
	touch vars && \
	echo "set_var EASYRSA_ALGO \"ec\"" | tee vars && \
	echo "set_var EASYRSA_DIGEST \"sha512\"" | tee -a vars) ||
	print_exit

}

#step 3
function init_pki () {

	(cd "$EASY_RSA_DIR" && \
	./easyrsa init-pki) ||
	print_exit

}

#step 4
function certification_request_and_private_key () {

  # EASYRSA_BATCH=1, that is silent mode
	(export EASYRSA_BATCH=1 && \
	cd "${EASY_RSA_DIR}" && \
	./easyrsa gen-req "${UNIQUE_HOST_SHORT_NAME}" nopass && \
	sudo cp "${EASY_RSA_DIR}/pki/private/${UNIQUE_HOST_SHORT_NAME}.key" "/etc/openvpn/server/${UNIQUE_HOST_SHORT_NAME}.key") || \
	print_exit

}

# step 5
function send_certification_request () {

	(sshpass -p "${SCP_PASSWORD}" scp -o StrictHostKeyChecking=no "${EASY_RSA_DIR}/pki/reqs/${UNIQUE_HOST_SHORT_NAME}.req" "${CA_USER}"@"${CA_HOST}":/tmp/${UNIQUE_HOST_SHORT_NAME}.req && \
	sshpass -p "${SCP_PASSWORD}" ssh -o StrictHostKeyChecking=no "${CA_USER}"@"${CA_HOST}" "chmod -R 777 /tmp/${UNIQUE_HOST_SHORT_NAME}.req") || \
	(echo "... Could not execute send_certification_request ..." && exit 1)

}

function download_certificates () {

	(sshpass -p "${SCP_PASSWORD}" scp -o StrictHostKeyChecking=no "${CA_USER}"@"${CA_HOST}":/tmp/server.crt /tmp/${UNIQUE_HOST_SHORT_NAME}.crt && \
  sshpass -p "${SCP_PASSWORD}" scp -o StrictHostKeyChecking=no "${CA_USER}"@"${CA_HOST}":/tmp/ca.crt /tmp/ca.crt) || \
	(echo "... Could not execute download_certificates ..." && exit 1)

}

function send_certification_request_from_arg () {

	sshpass -p "${SCP_PASSWORD}" scp -o StrictHostKeyChecking=no "$1" "${CA_USER}"@"${CA_HOST}":/tmp ||
	print_exit

}

# step 6: pre-shared-keys
function pre_shared_keys_configuration () {

	(cd "${EASY_RSA_DIR}" && \
	openvpn --genkey --secret ta.key && \
	sudo cp "${EASY_RSA_DIR}/ta.key" /etc/openvpn/server) ||
	print_exit

}



($1 "${@:2}" || check_last_else "cd ${PREV_DIR}")
cd "${PREV_DIR}" || (echo "Could not pass into ${PREV_DIR}" && exit 1)

# clean history
history -c

#
#set +x
