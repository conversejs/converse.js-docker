FROM nginx:latest

ARG BUILD_VERSION
ARG BUILD_DATE
ARG DEBIAN_FRONTEND=noninteractive
ARG CONVERSEJS_VERSION=9.1.0

LABEL org.label-schema.name="converse.js/converse.js"
LABEL org.label-schema.description="messaging freedom"
LABEL org.label-schema.url="https://conversejs.org/"
LABEL org.label-schema.application="converse.js"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.opencontainers.image.source="https://github.com/conversejs/converse.js-docker"

WORKDIR /workspace

# Update deps, install required & additional libraries
RUN apt-get --yes update \
  && apt-get --yes install \
    software-properties-common \
    unzip \
    git \
    gnupg \
    gosu \
    curl \
    ca-certificates \
  && apt-get --yes install \
    python3-dev \
    python3-twisted \
    python3-openssl

# "Install" converse.js itself
RUN curl -sLO \
  https://github.com/conversejs/converse.js/releases/download/v$CONVERSEJS_VERSION/converse.js-$CONVERSEJS_VERSION.tgz
RUN tar xzf converse.js-$CONVERSEJS_VERSION.tgz
RUN mv package/* /usr/share/nginx/html/

# Install Punjab as a BOSH connection manager
RUN curl -sLO https://github.com/twonds/punjab/archive/master.zip \
  && unzip master.zip \
  && cd punjab-master \
  && python3 setup.py install

# Replace nginx default configuration file
COPY default.conf /etc/nginx/conf.d/default.conf
# Replace default index.html with conversejs' fullscreen.html
COPY fullscreen.html /usr/share/nginx/html/index.html
# Setup entrypoint to setup commands to execute when the container is run
COPY ./start-punjab.sh /docker-entrypoint.d/90-start-punjab.sh

# Clean up
RUN rm -rf /workspace
