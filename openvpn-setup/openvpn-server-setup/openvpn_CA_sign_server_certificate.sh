#!/bin/bash


usage() {                                 # Function: Print a help message.
  echo "Usage: $0 [ -c CERTIFICATE_PATH ] [ -t TYPE: {client, server} ] " 1>&2
}

exit_abnormal() {                         # Function: Exit with error.
  usage
  exit 1
}

CERTIFICATE_PATH=""
TYPE=""

while getopts "c:t:" options; do         # Loop: Get the next option;
                                          # use silent error checking;
                                          # options n and t take arguments.
  case "${options}" in                    #
    c)
      CERTIFICATE_PATH=${OPTARG}
      ;;
    t)
      TYPE=${OPTARG}
      if ! [[ "${TYPE}" =~ ^(client|server)$ ]]; then exit_abnormal ; fi
    ;;
    :)                                    # If expected argument omitted:
      echo "Error: -${OPTARG} requires an argument."
      exit_abnormal                       # Exit abnormally.
      ;;
    *)                                    # If unknown (any other) option:
      exit_abnormal                       # Exit abnormally.
      ;;
  esac
done

if ! [[ "${#CERTIFICATE_PATH}" -eq 0 ]]; then exit_abnormal ; fi
if ! [[ "${#TYPE}" -eq 0 ]]; then exit_abnormal ; fi

EASY_RSA_DIR="/home/${USER}/easy-rsa"
cd "${EASY_RSA_DIR}" || (echo "Could not pass into ${EASY_RSA_DIR}" && exit 1)

CERTIFICATION_NAME="$(basename ${CERTIFICATE_PATH} .crt)"

# csr importing
./easyrsa import-req "${CERTIFICATE_PATH}" "${CERTIFICATION_NAME}"

# csr signing
./easyrsa sign-req ${TYPE} "${CERTIFICATION_NAME}" && \
echo_red
scp "./pki/issued/${CERTIFICATION_NAME}.crt" /tmp
scp "./pki/ca.crt" /tmp


# login at the OpenVPN server
# move the 'server.crt' and 'ca.crt' files to /etc/openvpn/server
#
