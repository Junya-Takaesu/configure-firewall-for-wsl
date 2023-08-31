#!/usr/bin/bash

WSL_IP=$(ifconfig eth0 | grep 'inet ' | awk '{print $2}')

echo -e "\nSetting portproxy/portforward for the WSL's interface with ip address of \"$WSL_IP\"\n"

TARGET_PORTS=("22" "80")
TEMP_PORTS=()
CURRENT_LISTEN_PORTS=$(netsh.exe interface portproxy show v4tov4 | grep -Ev '(^Listen on|^Address|----------|^\s+$)' | awk '{print $2}')

mapfile -t TEMP_PORTS <<<"$CURRENT_LISTEN_PORTS"

for PORT in "${TEMP_PORTS[@]}"; do
    echo "Deleting setting for port number: $PORT"
    if [[ " ${TARGET_PORTS} " =~ " $PORT " ]]; then
        netsh.exe interface portproxy delete v4tov4 listenport=$PORT
    fi
done

for PORT in "${TARGET_PORTS[@]}"; do
    echo "Adding setting for port number: $PORT"
    netsh.exe interface portproxy add v4tov4 listenport=$PORT connectaddress=$WSL_IP
done

netsh.exe interface portproxy show v4tov4
