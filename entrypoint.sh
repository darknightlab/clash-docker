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
        curl "127.0.0.1$EXTERNAL_CONTROLLER/configs?force=true" -X PUT -d '{"path": "'$CONFIG_PATH'", "payload": ""}'
    done
}

cp /geox/* $CONFIG_DIR/
download_config
update_config &

python3 /setenv.py
/mihomo "$@"