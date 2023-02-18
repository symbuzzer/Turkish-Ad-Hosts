#!/usr/bin/env sh
HOSTS_URL="https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/hosts"
NEW_HOSTS="hosts"
HOSTS_PATH="/etc"
SCRIPT_URL="https://raw.githubusercontent.com/symbuzzer/Turkish-Ad-Hosts/main/linux/turkish-ad-hosts-linux.sh"
NEW_SCRIPT="turkish-ad-hosts-linux.sh"
STARTUP_PATH="/etc/rc.local"
SCRIPT=$STARTUP_PATH$NEW_SCRIPT
if [ "$(id -u)" -ne "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi
sudo cp -f "$0" $STARTUP_PATH
chmod +x $SCRIPT
sudo wget -q --tries=10 --timeout=20 --spider https://www.avalibeyaz.com
if [[ $? -eq 0 ]]; then
    sudo wget -O $NEW_SCRIPT $SCRIPT_URL
    sudo cp -f $NEW_SCRIPT $STARTUP_PATH
    chmod +x $SCRIPT
    sudo rm $NEW_SCRIPT*
    sudo wget -O $NEW_HOSTS $HOSTS_URL
    sudo cp -f $NEW_HOSTS $HOSTS_PATH
    sudo rm $NEW_HOSTS*
else
    echo "This script needs internet connection"
    exit 1
fi
