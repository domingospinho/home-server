#!/bin/bash

#set -

echo -e "\n\n\n\n\n\n\n\n"

REDNUMBER=31
GREENNUMBER=32

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

BOLDGREEN="\e[1;${GREENNUMBER}m"
ITALICRED="\e[3;${REDNUMBER}m"

myExternalIP=$(curl -s ifconfig.me)

echo -e "\nYour external IP address: ${BOLDGREEN}$myExternalIP\e[0m\n"

#echo -e "\n"
read -p "What is the domain you want to add to the hosts file? " domain
#echo -e "\n"

echo -e "\n127.0.0.1        ${RED}$domain\e[0m\n"

#echo -e '\033[1mYOUR_STRINd \033[0m'

function checkStringInFile ()
{
    if grep -q "$1" "$2"
    then
        echo "1"
    else
        echo "0"
    fi
}

exists=$(checkStringInFile "127.0.0.1        $domain" "/etc/hosts")

if [ $exists -eq 1 ]
then
    echo -e "${GREEN}This domain is already in the hosts file\e[0m\n"
else
    echo -e "${RED}This domain is not in the hosts file\e[0m\n"

    echo "127.0.0.1        $domain" >> /etc/hosts

    echo -e "${GREEN}Domain successfully added to hosts file.\e[0m\n"
fi

##apt-get update
##apt-get upgrade
##
##apt-get install git
##
read -p "What email do you want to set for git commits? " gitEmail
read -p "What name do you want to set for git commits? " gitName

echo -e "\n$gitEmail\n"
echo -e "\n$gitName\n"

$(git config --global user.email gitEmail)
git config --global user.name '$gitName'

