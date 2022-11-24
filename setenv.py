import os
import yaml

ConfigPath = os.getenv("CONFIG_PATH")
AllowFields = {
    "IPV6": "ipv6",
    "SOCKS_PORT": "socks-port",
    "HTTP_PORT": "port",
    "MIXED_PORT": "mixed-port",
    "EXTERNAL_CONTROLLER": "external-controller",
    "ALLOW_LAN": "allow-lan"
}

with open(ConfigPath, "r+") as f:
    config = yaml.safe_load(f)
    for key, value in AllowFields.items():
        if os.getenv(key):
            config[value] = os.getenv(key)
    f.seek(0)
    yaml.safe_dump(config, f, allow_unicode=True)
