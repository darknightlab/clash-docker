#!/bin/sh
export CONFIG_DIR=/root/.config/clash
export CONFIG_PATH=$CONFIG_DIR/config.yaml

download_config() {
    if [ -f "$CONFIG_PATH" ] && [ $(( $(date +%s) - $(date -r "$CONFIG_PATH" +%s) )) -lt $UPDATE_INTERVAL ]; then
        echo "config is up to date, no need to download"
    else
        echo "config is outdated, downloading"
        TEMP_CONFIG=$CONFIG_PATH.temp
        if [ $(curl -m 60 -s -o "$TEMP_CONFIG" -L "$CONFIG_URL" -w "%{http_code}") = "200" ]; then
            mv "$TEMP_CONFIG" "$CONFIG_PATH"
            echo "Downloaded config from $CONFIG_URL"
            python3 /setenv.py
        else
            echo "Failed to download config from $CONFIG_URL"
            rm -f "$TEMP_CONFIG" 2>/dev/null
        fi
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
    sed "1i define iifname_clash={$TPROXY_INTERFACES}" /clash.nft > /clash.nft.autogen
    nft -f /clash.nft.autogen
    ip rule add fwmark 7890 table 784 ; ip route add local default dev lo table 784
    ip -6 rule add fwmark 7890 table 786 ; ip -6 route add local ::/0 dev lo table 786
}

cleanup_network() {
    ip rule del fwmark 7890 table 784 ; ip route del local default dev lo table 784
    ip -6 rule del fwmark 7890 table 786 ; ip -6 route del local ::/0 dev lo table 786
    nft delete table inet clash
}

exit_func() {
    if [ "$TRANSPARENT_PROXY" = "true" ]; then
        cleanup_network
    fi
    kill $MIHOMO_PID
    echo "clash will stop now"
    exit 0
}

cp /geox/* $CONFIG_DIR/
download_config
update_config &


if [ "$TRANSPARENT_PROXY" = "true" ]; then
    set_network
fi
trap exit_func SIGTERM

/mihomo "$@" &
MIHOMO_PID=$!
wait