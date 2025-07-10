# Dockerfile: openvpn
# Kafouche OpenVPN Image (source).

LABEL       org.opencontainers.image.authors="kafouche"
LABEL       org.opencontainers.image.base.name="ghcr.io/kafouche/openvpn:2.6.13"
LABEL       org.opencontainers.image.ref.name="ghcr.io/kafouche/alpine"
LABEL       org.opencontainers.image.source="https://github.com/kafouche/docker-openvpn"
LABEL       org.opencontainers.image.title="OpenVPN"
LABEL       org.opencontainers.image.version="2.6.13"
LABEL       image.tags[0]="ghcr.io/kafouche/openvpn:latest-src"


# ------------------------------------------------------------------------------

ARG         RELEASE=2.6.13

ARG         SOURCE_URL=https://build.openvpn.net/downloads/releases/openvpn-$RELEASE.tar.gz

ARG         SOURCE_DIR=/tmp/source

ARG         SOURCE_TAR=/tmp/archive.tar.gz

ARG         TARGET_DIR=/tmp/target


# BUILD STAGE

FROM        ghcr.io/kafouche/alpine:latest as buildstage

ARG         SOURCE_URL \
            SOURCE_DIR \
            SOURCE_TAR \
            TARGET_DIR

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
              --location "${SOURCE_URL}" \
              --output "${SOURCE_TAR}" \
            && mkdir --parents "${SOURCE_DIR}" \
            && tar \
              --directory="${SOURCE_DIR}" \
              --extract \
              --file="${SOURCE_TAR}" \
              --gzip \
              --strip-components=1

WORKDIR     "${SOURCE_DIR}"

RUN         ./configure \
              --prefix=/usr \
              --mandir=/usr/share/man \
              --sysconfdir=/etc/openvpn \
              --enable-iproute2 \
              --enable-x509-alt-username \
            && make \
            && make check \
            && DESTDIR="${TARGET_DIR}" make install


# RUN STAGE

FROM        ghcr.io/kafouche/alpine:latest

ARG         TARGET_DIR

RUN         apk --no-cache --update upgrade \
            && apk --no-cache --update add \
              iproute2-minimal \
              libcap-ng \
              lz4-libs \
              lzo \
              openssl

COPY        --from=buildstage "${TARGET_DIR}/" /

VOLUME      /etc/openvpn

WORKDIR     /etc/openvpn

ENTRYPOINT  [ "/usr/sbin/openvpn" ]
CMD         [ "client.conf" ]
