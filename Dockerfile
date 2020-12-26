FROM alpine:3.12

LABEL name="docker-deluge" \
      maintainer="Jee jee@eer.fr" \
      description="Deluge is a lightweight, Free Software, cross-platform BitTorrent client." \
      url="https://deluge-torrent.org/" \
      org.label-schema.vcs-url="https://github.com/jee-r/docker-deluge"

ENV PYTHON_EGG_CACHE=/config/.cache
RUN sed -i 's/http:\/\/dl-cdn.alpinelinux.org/https:\/\/mirrors.ircam.fr\/pub/' /etc/apk/repositories && \
    echo "https://mirrors.ircam.fr/pub/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk upgrade && \
    apk --no-cache add build-base \
      ca-certificates \
      libffi-dev \
      libjpeg-turbo-dev \
      linux-headers \
      p7zip \
      py3-libtorrent-rasterbar \
      py3-openssl \
      py3-pip \
      python3-dev \
      unrar \
      unzip \
      git \
      bash \
      zlib-dev \
      tzdata && \
    cd /tmp && \
    git clone git://deluge-torrent.org/deluge.git && \
    cd deluge && \
    python3 setup.py clean -a && \
    python3 setup.py build && \
    python3 setup.py install && \
    apk del \
      build-base \
      libffi-dev \
      libjpeg-turbo-dev \
      linux-headers \
      python3-dev \
      zlib-dev && \
    rm -rf /tmp/*

WORKDIR /config

COPY entrypoint.sh /usr/local/bin/
COPY healthcheck.sh /usr/local/bin/

VOLUME ["/config"]

HEALTHCHECK --interval=5m --timeout=3s --start-period=30s \
  CMD /usr/local/bin/healthcheck.sh 58846 8112

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
