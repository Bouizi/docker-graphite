FROM alpine:3.5

# Install basic stuff =)
RUN apk add --no-cache \
  bash \
  ca-certificates \
  git \
  nginx \
  nodejs-lts \
  openssl \
  py2-pip \
  supervisor \
  tar \
  tini \
  uwsgi \
  uwsgi-python \
  && pip install supervisor-stdout

# Install graphite
ENV GRAPHITE_ROOT /opt/graphite

RUN apk add --no-cache \
  alpine-sdk \
  fontconfig \
  libffi \
  libffi-dev \
  python-dev \
  py-cairo \
  && export PYTHONPATH="/opt/graphite/lib/:/opt/graphite/webapp/" \
  && pip install https://github.com/graphite-project/whisper/tarball/master \
  && pip install https://github.com/graphite-project/carbon/tarball/master \
  && pip install https://github.com/graphite-project/graphite-web/tarball/master \
  && apk del \
  alpine-sdk \
  python-dev \
  libffi-dev

EXPOSE 8080

VOLUME ["/opt/graphite/storage"]
#VOLUME ["/opt/graphite/conf", "/opt/graphite/storage/whisper"]

COPY run.sh /run.sh
COPY etc/ /etc/

# Enable tiny init
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/bin/bash", "/run.sh"]
