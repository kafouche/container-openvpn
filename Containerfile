# Containerfile: openvpn
# Kafouche OpenVPN Image.

FROM        ghcr.io/kafouche/alpine:latest

LABEL       org.opencontainers.image.authors="kafouche"
LABEL       org.opencontainers.image.base.name="ghcr.io/kafouche/openvpn:latest"
LABEL       org.opencontainers.image.ref.name="ghcr.io/kafouche/alpine"
LABEL       org.opencontainers.image.source="https://github.com/kafouche/container-openvpn"
LABEL       org.opencontainers.image.title="OpenVPN"

# ------------------------------------------------------------------------------

RUN         apk --no-cache --update upgrade \
            && apk --no-cache --update add \
              openvpn

VOLUME      /etc/openvpn

WORKDIR     /etc/openvpn

ENTRYPOINT  [ "/usr/sbin/openvpn" ]
CMD         [ "client.conf" ]
