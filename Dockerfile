FROM nginx

#Setting up Dockerfile to install the version of Converse to retrieve

ENV CONVERSEJS_VERSION v4.2.0
ENV CONVERSEJS_VERSION_S 4.2.0

# Updating package lists then install Node.js and NPM for development purpose

RUN apt-get update -y
RUN apt-get install -y curl python-twisted python-openssl sudo unzip git apt-utils 
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN sudo apt-get install -y npm
RUN sudo apt-get install -y build-essential

#Retrieving the version of Converse setup earlier

RUN curl -L -O https://github.com/conversejs/converse.js/archive/${CONVERSEJS_VERSION}.zip \
    && unzip ${CONVERSEJS_VERSION}.zip \
    && rm -f ${CONVERSEJS_VERSION}.zip

#Moving Converse content in the correct directory and making the teamchat page the main one

RUN mv -v /converse.js-${CONVERSEJS_VERSION_S}/* /usr/share/nginx/html/
RUN rm -rf /converse.js-${CONVERSEJS_VERSION_S}/
RUN cd /usr/share/nginx/html/ && make dev 
RUN mv /usr/share/nginx/html/index.html /usr/share/nginx/html/index_bak.html \
    && cp /usr/share/nginx/html/fullscreen.html /usr/share/nginx/html/index.html 

# Install Punjab as a BOSH connection manager

RUN curl -L -O https://github.com/twonds/punjab/archive/master.zip \
    && unzip master.zip \
    && cd punjab-master \
    && python setup.py install \
    && rm -rf *

# Replace nginx default configuration file

RUN rm /etc/nginx/conf.d/*
COPY site.conf /etc/nginx/conf.d/

# Setup entrypoint to setup commands to execute when the container is run

COPY entrypoint /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint
ENTRYPOINT /usr/local/bin/entrypoint