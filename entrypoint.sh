#!/bin/sh
CONFIG_PATH=/root/.config/clash/config.yaml
wget -O $CONFIG_PATH "$CONFIG_URL"
python3 /setenv.py
/clash "$@"