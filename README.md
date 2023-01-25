[Openvpn-as](https://openvpn.net/index.php/access-server/overview.html) is a full featured secure network tunneling VPN software solution that integrates OpenVPN server capabilities, enterprise management capabilities, simplified OpenVPN Connect UI, and OpenVPN Client software packages that accommodate Windows, MAC, Linux, Android, and iOS environments. OpenVPN Access Server supports a wide range of configurations, including secure and granular remote access to internal network and/ or private cloud network resources and applications with fine-grained access control.


## Usage

Here are some example snippets to help you get started creating a container.

### docker-compose (***recommended***)

Compatible with docker-compose v2 schemas.

```yaml
---
version: "2.8"
services:
  app:
    image: luanvt/openvpnas:latest
    cap_add:
      - NET_ADMIN
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - INTERFACE=eth0 #optional
    volumes:
      - "./data/etc:/app/etc"
      - "./data/log:/app/log"
    ports:
      - 943:943
      - 1194:1194
      - 1194:1194/udp
    restart: unless-stopped
```

### Change the limit of simultaneous connections (removed from 2.11.2)
From version 2.11.2, the number of concurrent connections was increased to 4096 (unofficially). So, the activation isn't necessary. If you want to adjust it, you can use the activation script (not sure of success)
1. Run inside docker: `activate`
2. Run through docker-compose: `docker compose exec <service-name> activate`

## Upgrade
Pull the latest image from docker-hub and restart the container.
