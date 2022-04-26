FROM nginx:latest

LABEL maintainer="iam@f4b.io"

ARG BUILD_VERSION
ARG BUILD_DATE
ARG DEBIAN_FRONTEND=noninteractive
ARG CONVERSEJS_VERSION=9.1.0

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="converse.js/converse.js"
LABEL org.label-schema.description="messaging freedom"
LABEL org.label-schema.url="https://conversejs.org/"
LABEL org.label-schema.application="converse.js"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.version=$BUILD_VERSION

WORKDIR /workspace

# # Replace nginx default configuration file
COPY default.conf /etc/nginx/conf.d/default.conf

# Update deps, install required & additional libraries
RUN apt-get --yes update
RUN apt-get --yes install \
  software-properties-common gnupg gosu curl ca-certificates zip unzip git
RUN apt-get --yes install python3-dev python3-twisted python3-openssl

RUN curl -sLO \
  https://github.com/conversejs/converse.js/releases/download/v$CONVERSEJS_VERSION/converse.js-$CONVERSEJS_VERSION.tgz
RUN tar xzf converse.js-$CONVERSEJS_VERSION.tgz
RUN mv package/* /usr/share/nginx/html/
RUN curl -sL \
  -o /usr/share/nginx/html/index.html \
  https://raw.githubusercontent.com/conversejs/converse.js/master/fullscreen.html
# Install Punjab as a BOSH connection manager
# RUN add-apt-repository ppa:karjala/jabber
# RUN apt-get --yes install punjab
RUN curl -sL -O https://github.com/twonds/punjab/archive/master.zip \
  && unzip master.zip \
  && cd punjab-master \
  && python3 setup.py install

# # Setup entrypoint to setup commands to execute when the container is run
COPY ./start-punjab.sh /docker-entrypoint.d/90-start-punjab.sh

RUN rm -rf /workspace

# WORKDIR /usr/share/nginx/html/
# CMD [ "/bin/bash" ]
