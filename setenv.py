import os
import yaml

ConfigPath = os.getenv("CONFIG_PATH")
AllowFields = {
    "IPV6": {"name": "ipv6", "type": bool},
    "SOCKS_PORT": {"name": "socks-port", "type": int},
    "HTTP_PORT": {"name": "port", "type": int},
    "MIXED_PORT": {"name": "mixed-port", "type": int},
    "EXTERNAL_CONTROLLER": {"name": "external-controller", "type": str},
    "ALLOW_LAN": {"name": "allow-lan", "type": bool}
}

with open(ConfigPath, "r") as f:
    config = yaml.safe_load(f)
    for key, value in AllowFields.items():
        if os.getenv(key):
            config[value["name"]] = value["type"](os.getenv(key))

with open(ConfigPath, "w") as f:
    yaml.safe_dump(config, f, allow_unicode=True, default_flow_style=False)
