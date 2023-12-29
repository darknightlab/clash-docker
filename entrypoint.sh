#!/bin/sh
export CONFIG_DIR=/root/.config/clash
export CONFIG_PATH=$CONFIG_DIR/config.yaml

download_config() {
    curl -s -o $CONFIG_PATH -L "$CONFIG_URL"
}

update_config() {
    while true; do
        sleep $UPDATE_INTERVAL
        download_config
        curl "127.0.0.1$EXTERNAL_CONTROLLER/configs?force=true" -X PUT -d '{"path": "'$CONFIG_PATH'", "payload": ""}'
    done
}

cp /geox/* $CONFIG_DIR/
download_config
update_config &

python3 /setenv.py
/mihomo "$@"