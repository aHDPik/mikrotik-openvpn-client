# Docker OpenVPN Client for Mikrotik
## What is this and what does it do?
RouterOS has several limitations in their openVPN implementation (for ex. doesn't support tls-auth).
This docker image can be run directly on mirotik and bring openvpn connections without any limitation from RouterOS.
This image can bring up multiple tunnels.

## How do I use it on my Mikrotik?
### Get your Mikrotik ready to run docker containers
Enable docker containers on you Mikrotik using official documantation: https://help.mikrotik.com/docs/display/ROS/Container

### Prepaire the config file(s)
Prepaire the working openvpn config/configs (with all cert files if required). You can test your config on any linux openvpvn.
Put the config/configs in a separate directory. This image will scan this directory for *.ovpn and *.conf files and bring a separate tunnel for each config found.
If user/password authentification is required for your tunnel, you need to create a separate file with credentials and put it's name to 'auth-user-pass' directive of openvpn config.

### Running the container
Put directory containing openvpvn config files (and all other cert/auth files) to you mikrotik storage (internal or USB).
Mount this directory to '/data/vpn' by creating a container mount:
```bash
/container/mounts/add name=openvpn_mount src=disk1/configs dst=/data/vpn
```
Create a container:
```bash
/container/add remote-image=sergeyrim/mikrotik-openvpn-client:1.0 interface=veth1 mounts=openvpn_mount
```
Start the container (and optionally enable logging):
```bash
/container/set 0 logging=yes
/container/start 0
```
Container will try to bring up an openvpn tunnels for each config in you mount directory.
Container also already has a NAT enabled, so you can route traffik thru running container.


## Test image on PC

#### You can test image on your PC
```bash
docker run --detach \
  --name=openvpn-client \
  --cap-add=NET_ADMIN \
  --device=/dev/net/tun \
  --volume <path/to/config/dir>:/data/vpn \
  sergeyrim/mikrotik-openvpn-client:1.0
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

#### Example of openvpn config
`my-client-config.ovpn`
```bash
dev tun
persist-tun
persist-key
cipher AES-256-CBC
auth SHA224
tls-client
client
resolv-retry infinite
remote cau.hostfarm.ch 1194 udp
verify-x509-name "OpenVPN" name
auth-user-pass my_credentials.auth
pkcs12 pkcs122cert.p12
tls-auth tls.key 1
remote-cert-tls server
lport 0
```

`my_credentials.auth`
```bash
my_username
some_password
```
