#!/bin/bash

#!/bin/bash

CURRENT_DIR="${PWD##*/}"

if [[ ! "${CURRENT_DIR}" == "openvpn-ca-setup" ]]
then
  echo "... Please, execute the bash script from its local directory ..."
fi

(. ../standard_functions.sh ) || \
(echo "... # ../standard_functions were NOT imported ..." && return 1)

echo_red "... #1 Prerequisites Installation ..."
(. ./certification_authority_stages.sh install_prerequisites) || (echo_red "... # Could not execute #1 stage ..." && return 1)
echo_red "... #1 Done ..."

echo_red "... #2 PKI Initialization ..."
(. ./certification_authority_stages.sh init_pki) || (echo_red "... # Could not execute #2 stage ..." && return 1)
echo_red "... #2 Done ..."

echo_red "... #3 CA Creation ..."
(. ./certification_authority_stages.sh create_certification_authority) || (echo_red "... # Could not execute #3 stage ..." && return 1)
echo_red "... #3 Done ..."

echo_red "... #4 Certificates Distribution ..."
(. ./certification_authority_stages.sh distribute_ca) || (echo_red "... # Could not execute #4 stage ..." && return 1)
echo_red "... #4 Done ..."


# clean history
history -c
