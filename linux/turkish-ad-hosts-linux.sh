#!/usr/bin/env sh
HOSTS_URL="https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/hosts"
NEW_HOSTS="hosts"
HOSTS_PATH="/etc/"
if [ "$(id -u)" -ne "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi
if nc -zw1 google.com 443; then
    sudo wget -O $NEW_HOSTS $HOSTS_URL
    sudo cp -f $NEW_HOSTS $HOSTS_PATH
    sudo rm $NEW_HOSTS*
else
    echo "This script needs internet connection"
    exit 1
fi