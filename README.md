# OpenVPN Client
This image is based on *Alpine Linux* latest stable image.

This image is *mainly* used to forward traffic from another container throught OpenVPN.

## Image
### Environment
| Parameter | Description                                          |
|-----------|------------------------------------------------------|
| `TZ`      | Set container's timezone (*default*: `Europe/Paris`) |

### Mount / Volume
| Volume           | Description                  |
|------------------|------------------------------|
| `/etc/openvpn` | Default server tcp/udp port. |


## Build
```
docker build -t kafouche/openvpn:latest .
```


## Run
The following `code blocks` are only there as **examples**.
### Manual
```
docker run --detach \
    --cap-add=NET_ADMIN \
    --device=/dev/net/tun:/dev/net/tun \
    #--dns 9.9.9.9 \          # Optional
    #--dns 149.112.112.112 \  # Optional
    --mount type=bind,src=$(pwd)/openvpn,dst=/etc/openvpn \
    --name openvpn \
    --network bridge \
    --publish XXXX:XXXX \     # Second container public ports.
    --restart unless-stopped \
    kafouche/openvpn:latest

docker run --detach \
    --name=image \
    --net=container:openvpn \
    --restart=unless-stopped \
    ... \
    repository/image:tagname
```

### Composer
```
---
version: "3"

services:
    openvpn:
        cap_add:
          - NET_ADMIN
        container_name: "openvpn"
        devices:
          - "/dev/net/tun:/dev/net/tun"
        #dns:
          #- 9.9.9.9
          #- 149.112.112.112
        image: "kafouche/openvpn:latest"
        network_mode: bridge
        ports:
          - XXXX:XXXX
        restart: unless-stopped
        volumes:
          - "./openvpn/:/etc/openvpn/:ro"

    image:
        container_name: "image"
        depends_on:
          - openvpn
        image: "repository/image:tagname"
        network_mode: "service:openvpn"
        restart: unless-stopped
        ...
```
