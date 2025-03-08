# Dockerfile: openvpn
# OpenVPN Docker Image.

LABEL       org.opencontainers.image.source https://github.com/kafouche/openvpn

# BUILD STAGE

FROM        ghcr.io/kafouche/alpine:latest as buildstage

ARG         RELEASE=2.6.13

            # MAKE PACKAGES
RUN         apk --no-cache --update upgrade \
            && apk --no-cache --update add \
                build-base \
                iproute2-minimal \
                openssl-dev \
                libcap-ng-dev \
                linux-headers \
                linux-pam-dev \
                lz4-dev \
                lzo-dev

            # CHECK PACKAGES
RUN         apk --no-cache --update upgrade \
            && apk --no-cache --update add \
                cmocka-dev

            # DOWNLOAD SOURCE
RUN         apk --no-cache --update add \
                curl \
            && curl \
                --location "https://build.openvpn.net/downloads/releases/openvpn-$RELEASE.tar.gz" \
                --output /tmp/openvpn.tar.gz \
            && mkdir --parents /tmp/openvpn \
            && tar --directory=/tmp/openvpn --extract --file=/tmp/openvpn.tar.gz --gzip --strip-components=1

RUN         cd /tmp/openvpn \
            && ./configure \
                --prefix=/usr \
                --mandir=/usr/share/man \
                --sysconfdir=/config \
                --enable-iproute2 \
                --enable-x509-alt-username \
            && make \
            && make check \
            && make DESTDIR=/tmp/openvpn/target install


# RUN STAGE

FROM        ghcr.io/kafouche/alpine:latest

RUN         apk --no-cache --update upgrade \
            && apk --no-cache --update add \
                iproute2-minimal \
                libcap-ng \
                lz4-libs \
                lzo \
                openssl

COPY        --from=buildstage /tmp/openvpn/target/ /

RUN         mkdir --parents /config

VOLUME      /config

WORKDIR     /config

ENTRYPOINT  [ "/usr/sbin/openvpn" ]
CMD         [ "client.conf" ]