# Docker OpenVPN Client for Mikrotik
## What is this and what does it do?


## Why?


## How do I use it?
### Getting the image

### Creating and running a container
The image requires the container be created with the `NET_ADMIN` capability and `/dev/net/tun` accessible.


#### `docker run`
```bash
docker run --detach \
  --name=openvpn-client \
  --cap-add=NET_ADMIN \
  --device=/dev/net/tun \
  --volume <path/to/config/dir>:/data/vpn \
  openvpn-client
```


#### Environment variables
| Variable | Default (blank is unset) | Description |
| --- | --- | --- |
| `IPTABLES_RULES` | `` | Path to iptables rules to load |
| `VPN_CONFIG_FILE` | | The OpenVPN configuration file to use. If unset, the `VPN_CONFIG_PATTERN` is used. |
| `VPN_CONFIG_PATTERN` | | The search pattern to use when looking for an OpenVPN configuration file. If unset, the search will include `*.conf` and `*.ovpn`. |
| `VPN_LOG_LEVEL` | `3` | OpenVPN logging verbosity (`1`-`11`) |

##### Environment variable considerations

### Troubleshooting

#### VPN authentication
