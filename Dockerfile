FROM armv7/armhf-ubuntu:15.04
MAINTAINER Joey Baker <joey@byjoeybaker.com>

ENV SYNCTHING_VERSION 0.12.16

RUN apt-get update \
  && apt-get install curl ca-certificates -y --no-install-recommends

# grab gosu for easy step-down from root
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
  && chmod +x /usr/local/bin/gosu

# get syncthing
WORKDIR /srv
RUN useradd --no-create-home -g users syncthing
RUN curl -L -o syncthing.tar.gz https://github.com/syncthing/syncthing/releases/download/v$SYNCTHING_VERSION/syncthing-linux-arm-v$SYNCTHING_VERSION.tar.gz \
  && tar -xzvf syncthing.tar.gz \
  && rm -f syncthing.tar.gz \
  && mv syncthing-linux-arm-v* syncthing \
  && rm -rf syncthing/etc \
  && rm -rf syncthing/*.pdf \
  && mkdir -p /srv/config \
  && mkdir -p /srv/data \

VOLUME ["/srv/data", "/srv/config"]

ADD ./start.sh /srv/start.sh
RUN chmod 770 /srv/start.sh

ENV UID=1027

ENTRYPOINT ["/srv/start.sh"]

