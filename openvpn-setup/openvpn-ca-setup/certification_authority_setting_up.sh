#!/bin/bash

#!/bin/bash

CURRENT_DIR="${PWD##*/}"

if [[ ! "${CURRENT_DIR}" == "openvpn-ca-setup" ]]
then
  echo "... Please, execute the bash script from its local directory ..."
fi

(source ../standard_functions.sh && \
echo_red "... # ../standard_functions were imported ...") \
|| (echo "... # ../standard_functions were NOT imported ..." && exit 1)

echo_red "... #1 Prerequisites Installation ..."
(. ./certification_authority_stages.sh install_prerequisites) || print_exit
echo_red "... #1 Done ..."

echo_red "... #2 PKI Initialization ..."
(. ./certification_authority_stages.sh init_pki) || print_exit
echo_red "... #2 Done ..."

echo_red "... #3 CA Creation ..."
(. ./certification_authority_stages.sh create_certification_authority) || print_exit
echo_red "... #3 Done ..."

echo_red "... #4 Certificates Distribution ..."
(. ./certification_authority_stages.sh distribute_ca) || print_exit
echo_red "... #4 Done ..."


# clean history
history -c
