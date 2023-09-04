# Dockerfile: openvpn
# OpenVPN Docker Image.

FROM        alpine:latest

RUN         apk upgrade --no-cache --update \
            && apk --no-cache --update add \
                openssl \
                openvpn

WORKDIR     '/etc/openvpn'

ENV         TZ=Europe/Paris

ENTRYPOINT  [ "/usr/sbin/openvpn" ]
CMD         [ "client.conf" ]