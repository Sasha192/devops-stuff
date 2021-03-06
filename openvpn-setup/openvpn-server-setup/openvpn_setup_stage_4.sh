#!/bin/bash

# pre-shared key configuration
# https://build.openvpn.net/doxygen/group__tls__crypt.html#details

# В качестве дополнительного уровня безопасности мы добавим 
# дополнительный общий секретный ключ, который будет использовать
# сервер и все клиенты, с помощью директивы OpenVPN tls-crypt.
# Эта опция используется, чтобы «затемнить» сертификат TLS, используемый, 
# когда сервер и клиент первоначально подключаются друг к другу.
# Также она используется сервером OpenVPN для выполнения быстрых проверок
# входящих пакетов: если пакет подписан с помощью предварительно 
# предоставленного ключа, сервер обрабатывает его, если подпись отсутствует, 
# сервер понимает, что пакет получен из непроверенного источника, 
# и может отклонить его, не выполняя дополнительную работу по расшифровке.



# Эта опция поможет убедиться, что ваш сервер OpenVPN 
# может справляться с неудостоверенным трафиком,
# сканированием портов и DoS-атаками, которые могут
# связывать ресурсы сервера. Она также затрудняет выявление
# сетевого трафика OpenVPN.

CURRENT_DIR="${PWD##*/}"

if [[ ! "${CURRENT_DIR}" == "openvpn-server-setup" ]]
then
  echo "... Please, execute the bash script from its local directory ..."
fi

(. ../standard_functions.sh) \
|| (echo "... # standard_functions were NOT imported ..." && exit 1)

function print_exit () {
    echo_red "... The last command was not successful ..."
    echo_red "... Please, check logs ..."
    echo "... Exit ..."
    exit 1
}

echo_red "... #1 Generation static pre-shared keys ..."
. ./openvpn_stages.sh pre_shared_keys_configuration || print_exit
echo_red "... #1 Done ..."


# После получения этих файлов на сервере OpenVPN
# вы можете переходить к созданию клиентских сертификатов
# и файлов ключей для ваших пользователей,
# которые вы будете использовать для подключения к VPN.

# clean history
history -c



