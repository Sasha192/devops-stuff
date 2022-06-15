#!/bin/bash

# TODO: make echo_green, echo_yellow and make all scripts:
#  - use echo_red only for error logging
#  - use echo_green for success logging
#  - use echo_yellow for info logging

function echo_red () {
   RED='\033[0;31m'
   NC='\033[0m'
   echo -e "${RED}$1${NC}"
   echo -e "\n"
}

function print_exit () {
    echo_red "... The last command was not successful ..."
    echo_red "... Please, check logs ..."
    echo "... Exit ..."
    exit 1
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
    bash -c "${ELSE_CMD}"
		echo "... Exit ..."
		exit 1
	fi

}


