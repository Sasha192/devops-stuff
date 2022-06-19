#!/bin/bash

USER=$(whoami)
USER_CERT_KEYS_PATH="/home/${USER}/client_cert/keys"
CURRENT_DIR="${PWD##*/}"

if [[ ! "${CURRENT_DIR}" == "openvpn-client-setup" ]]
then
  echo "... Please, execute the bash script from its local directory ..."
fi

(. ../standard_functions.sh ) \
|| (echo "... # ../standard_functions were NOT imported ..." && return 1)

usage() {
  echo "Usage: $0 [ -c CLIENT_NAME ] " 1>&2
}

exit_abnormal() {                         # Function: Exit with error.
  usage
  return 1
}

CLIENT_NAME="${CLIENT_NAME}"

if [[ -z "${CLIENT_NAME}" ]]
then
  echo_red ""
  while getopts "c:" options; do         # Loop: Get the next option;
                                            # use silent error checking;
                                            # options n and t take arguments.
    case "${options}" in                    #
      c)
        CLIENT_NAME=${OPTARG}
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
fi

if ! [[ "${#CLIENT_NAME}" -eq 0 ]]; then
  exit_abnormal
  return 1
fi

sudo mv "/tmp/${CLIENT_NAME}.crt" "${USER_CERT_KEYS_PATH}" || \
(echo_red "... # Could not move client certificates ..." && exit 1)





