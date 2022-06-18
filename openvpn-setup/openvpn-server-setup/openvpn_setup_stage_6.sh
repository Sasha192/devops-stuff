#!/bin/bash

CURRENT_DIR="${PWD##*/}"

if [[ ! "${CURRENT_DIR}" == "openvpn-server-setup" ]]
then
  echo "... Please, execute the bash script from its local directory ..."
fi

(. ../standard_functions.sh) \
|| (echo "... # standard_functions were NOT imported ..." && exit 1)

if [ "$(id -u)" -ne 0 ]
then
  echo_red "... Please run as root ..."
  return 1
fi

function print_exit () {
    echo_red "... The last command was not successful ..."
    echo_red "... Please, check logs ..."
    echo "... Exit ..."
    exit 1
}

# setting up traffic forwarding:

echo_red "... #1 setting up traffic forwarding ..."

if [[ ! -f "/etc/sysctl.conf" ]]
then
  echo_red "... Could not find /etc/sysctl.conf ..."
  return 1
fi

echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf && \
sysctl -p && \
echo_red "... #1 Done ..." && \
echo_red "... Please, check that ip_forward works by yourself ..." ||
return 1


# setting up firewall:

echo_red "... #2 setting up firewall ..."

if ! command -v ufw &> /dev/null
then
    echo_red "... ufw could not be found ..."
    return
fi

INTERFACE=$(ip route list default | awk '{ print $5 }')

cat <<EOF >> patch.before.rules
# START OPENVPN RULES
# NAT table rules
*nat
:POSTROUTING ACCEPT [0:0]
# Allow traffic from OpenVPN client to ${INTERFACE}
-A POSTROUTING -s 10.8.0.0/8 -o ${INTERFACE} -j MASQUERADE
COMMIT
# END OPENVPN RULES
EOF

if [[ ! -f "./patch.before.rules" ]]
then
  echo_red "... patch.before.rules file was not created ..."
  echo_red "... please, check rights ..."
  return 1
fi

(echo "$(cat patch.before.rules /etc/ufw/before.rules)" > /etc/ufw/before.rules) && \
echo_red "... # allowed traffic from OpenVPN client to ${INTERFACE} ..."

(sed -i -e '/DEFAULT_FORWARD_POLICY=/ s/=.*/="ACCEPT"/' /etc/default/ufw && \
echo_red "... ACCEPT forward policy was set up ...") || \
(echo_red "... # Could not ACCEPT forward policy ..." && return 1)

(ufw allow 1194/udp && \
ufw allow OpenSSH) && \
echo_red "... # allowed 1194/udp and OpenSSH ..." || \
(echo_red "... # Could not allow udp and OpenSSH on ufw  ..." && return 1)

(ufw disable && \
ufw enable) ||
echo_red "... Could not restart ufw ..." && \
return 1

# clean history
history -c
