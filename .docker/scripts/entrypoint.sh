#!/usr/bin/bash

mkdir -p /dev/net

# create tun device
if [ ! -c /dev/net/tun ]; then
    echo "Creating tun device"
    mknod /dev/net/tun c 10 200
fi


if [[ $(find /app/etc/db -type f | wc -l) -eq 0 || ! -f "/app/etc/as.conf" ]]; then
    echo "Installing openvpn-as for the first time"
    ASCONFIG='DELETE\nyes\nyes\n1\nsecp384r1\nsecp384r1\n943\n9443\nyes\nyes\nyes\nno\nadmin\nAdmin@123\nAdmin@123\n\n'
    apt-get update && \
    apt-get install --no-install-recommends -y \
        openvpn-as && \
    rm -rf /var/lib/apt/lists/*
    echo "Stopping openvpn-as now; will start again later after configuring"
    kill $(ps aux | grep openvpnas | grep -v "\-\-color" | awk '{print $2}') > /dev/null 2>&1
    CONFINPUT=$ASCONFIG
    printf  "${CONFINPUT}" | /usr/local/openvpn_as/bin/ovpn-init
    echo "Stopping openvpn-as now; will start again later after configuring"
    kill $(ps aux | grep openvpnas | grep -v "\-\-color" | awk '{print $2}') > /dev/null 2>&1
    /usr/local/openvpn_as/scripts/openvpnas
    
    if [ -z "$INTERFACE" ]; then
        SET_INTERFACE="eth0"
    else
        SET_INTERFACE=$INTERFACE
    fi
    /usr/local/openvpn_as/scripts/sacli --key "admin_ui.https.ip_address" --value "$SET_INTERFACE" ConfigPut
    /usr/local/openvpn_as/scripts/sacli --key "cs.https.ip_address" --value "$SET_INTERFACE" ConfigPut
    /usr/local/openvpn_as/scripts/sacli --key "vpn.daemon.0.listen.ip_address" --value "$SET_INTERFACE" ConfigPut
    /usr/local/openvpn_as/scripts/sacli --key "vpn.daemon.0.server.ip_address" --value "$SET_INTERFACE" ConfigPut

    HOST=$(curl -s ifconfig.me)
    /usr/local/openvpn_as/scripts/sacli --key "host.name" --value "$HOST" ConfigPut
    /usr/local/openvpn_as/scripts/sacli Stop > /dev/null
    kill $(ps aux | grep openvpnas | grep -v "\-\-color" | awk '{print $2}') > /dev/null 2>&1
fi


echo "Starting openvpn-as"
rm -rf /usr/local/openvpn_as/twistd.*
mkdir -p /usr/local/openvpn_as/log/
/usr/local/openvpn_as/scripts/openvpnas --nodaemon --umask=0077  --logfile=/usr/local/openvpn_as/log/openvpn.log