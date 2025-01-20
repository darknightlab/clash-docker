import os
import yaml

ConfigPath = os.getenv("CONFIG_PATH")
AllowFields = {
    "IPV6": {"name": "ipv6", "type": bool},
    "MIXED_PORT": {"name": "mixed-port", "type": int},
    "EXTERNAL_CONTROLLER": {"name": "external-controller", "type": str},
    "SECRET": {"name": "secret", "type": str},
    "ALLOW_LAN": {"name": "allow-lan", "type": bool},
    "LAN_ALLOWED_IPS": {"name": "lan-allowed-ips", "type": eval},
    "BIND_ADDRESS": {"name": "bind-address", "type": str},
}
# extra fields: dns.listen "DNS_LISTEN"
TunConfig="""
tun:
  enable: false
  stack: system
  auto-route: true
  auto-redirect: true
  auto-detect-interface: true
  device: mihomo
  strict-route: true
  gso: true
  route-exclude-address:
    - 10.0.0.0/8
    - 192.168.0.0/16
    - fc00::/7
"""

with open(ConfigPath, "r") as f:
    config = yaml.safe_load(f)
    tunConfig=yaml.safe_load(TunConfig)
    config["tun"]=tunConfig["tun"]
    for key, value in AllowFields.items():
        if os.getenv(key):
            config[value["name"]] = value["type"](os.getenv(key))
    if os.getenv("DNS_LISTEN") and "dns" in config:
        config["dns"]["listen"] = str(os.getenv("DNS_LISTEN"))
    if os.getenv("TUN") and "tun" in config:
        config["tun"]["enable"] = bool(os.getenv("TUN"))

with open(ConfigPath, "w") as f:
    yaml.safe_dump(config, f, allow_unicode=True, default_flow_style=False)
