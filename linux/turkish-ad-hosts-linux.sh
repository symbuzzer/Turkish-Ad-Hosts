#!/usr/bin/env sh
HOSTS_URL="https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/hosts"
NEW_HOSTS="hosts"
HOSTS_PATH="/etc/hosts"
if [ "$(id -u)" -ne "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi
sudo cp "$0" "/etc/profile.d/"
sudo wget -q --tries=10 --timeout=20 --spider https://www.avalibeyaz.com
if [[ $? -eq 0 ]]; then
    sudo wget -O $NEW_HOSTS $HOSTS_URL
    sudo cp -v $NEW_HOSTS $HOSTS_PATH
    sudo rm $NEW_HOSTS*
else
    echo "This script needs internet conneciton"
    exit 1
fi
