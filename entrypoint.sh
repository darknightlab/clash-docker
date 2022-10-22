#!/bin/sh
echo "$CONFIG_URL"
curl -o /root/.config/clash/config.yaml "$CONFIG_URL"
if [ $IPV6 == true ]; then
    sed -i '1i\ipv6: true' /root/.config/clash/config.yaml
fi
/clash "$@"