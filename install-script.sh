#!/usr/bin/env bash
# ##!/bin/bash

# -e option instructs bash to immediately exit if any command [1] has a non-zero exit status
# We do not want users to end up with a partially working install, so we exit the script
# instead of continuing the installation with something broken
set -e

# Trap any errors, then exit
trap abort INT QUIT TERM

echo -e "\n\n\n\n\n\n\n\n"

if [ "$( id -u )" -ne 0 ]; then
    echo -e 'Please run this script as root\n' >&2
    exit 1
fi

REDNUMBER=31
GREENNUMBER=32

INFO="[i]"

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

BOLDGREEN="\e[1;${GREENNUMBER}m"
ITALICRED="\e[3;${REDNUMBER}m"

whoAmI=$(whoami)

printf "\nCurrent User: %s\n" "$whoAmI"

myExternalIP=$(curl -s ifconfig.me)

echo -e "\nYour external IP address: ${BOLDGREEN}$myExternalIP\e[0m\n"

read -p "What is the domain you want to add to the hosts file? " domain

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

read -p "Do you want to install git? (Yes/No) " installGit

if [[ $installGit =~ ^[Yy]$ ]] || [[ $installGit == "Yes" ]] || [[ $installGit == "yes" ]]
then
    apt-get install git
fi

read -ep $'\nWhat operating system user will you use to commit? Press enter to ignore. ' commitsUser

if [ -z "$commitsUser" ]
then
    echo -e "\n${RED}No operating system user for git defined\e[0m\n"
else
    read -p $'\nWhat email do you want to set for git commits? ' gitEmail
    read -p $'\nWhat name do you want to set for git commits? ' gitName

    su $commitsUser -c "git config --global user.email \"$gitEmail\""

    su $commitsUser -c "git config --global user.name \"$gitName\""

    echo -e "\nGit config set at ${GREEN}/home/$commitsUser/.gitconfig\e[0m\n"

    cat /home/$commitsUser/.gitconfig
fi

echo -e "\n"

#printf "  %b Pi-hole DNS (IPv6): %s\\n" "${INFO}" "_____________"

#wget -O basic-install.sh https://install.pi-hole.net
#sudo bash basic-install.sh
