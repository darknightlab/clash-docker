#!/bin/sh
export CONFIG_DIR=/root/.config/clash
export CONFIG_PATH=$CONFIG_DIR/config.yaml

download_config() {
    TEMP_CONFIG=$CONFIG_PATH.temp
    if curl -m 60 -s -o "$TEMP_CONFIG" -L "$CONFIG_URL"; then
        mv "$TEMP_CONFIG" "$CONFIG_PATH"
        echo "Downloaded config from $CONFIG_URL"
    else
        rm -f "$TEMP_CONFIG"
        echo "Failed to download config from $CONFIG_URL"
    fi
}

update_config() {
    while true; do
        sleep $UPDATE_INTERVAL
        download_config
        curl -H "Authorization: Bearer $SECRET" "$EXTERNAL_CONTROLLER/configs?force=true" -X PUT -d '{"path": "'$CONFIG_PATH'", "payload": ""}'
    done
}

set_network() {
    nft -f /clash.nft
    ip rule add fwmark 7890 table 784 ; ip route add local default dev lo table 784
    ip -6 rule add fwmark 7890 table 786 ; ip -6 route add local ::/0 dev lo table 786
}

cleanup_network() {
    ip rule del fwmark 7890 table 784 ; ip route del local default dev lo table 784
    ip -6 rule del fwmark 7890 table 786 ; ip -6 route del local ::/0 dev lo table 786
    nft flush table inet clash
}

cp /geox/* $CONFIG_DIR/
download_config
update_config &

if [ "$TRANSPARENT_PROXY" = "true" ]; then
    set_network
    trap cleanup_network EXIT
fi

python3 /setenv.py
/mihomo "$@"