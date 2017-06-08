FROM ubuntu:14.04
MAINTAINER Alejandro Gomez <agommor@gmail.com>

#================================
# Build arguments
#================================

ARG FIREFOX_VERSION
ARG CHROME_VERSION
ARG DISPLAY
ARG HOST_USER_UID
ARG HOST_USER_GID

#================================
# Env variables
#================================

ENV BUILD_TIMESTAMP='20161209_01' FIREFOX_VERSION=${FIREFOX_VERSION} CHROME_VERSION=${CHROME_VERSION} DISPLAY=${DISPLAY} HOST_USER_UID=${HOST_USER_UID} HOST_USER_GID=${HOST_USER_GID}

ADD assets/etc/apt/apt.conf.d/99norecommends /etc/apt/apt.conf.d/99norecommends
ADD assets/etc/apt/sources.list /etc/apt/sources.list

# Installing Firefox
RUN apt-get update -y --fix-missing -qq \
  && apt-get install -y software-properties-common python-software-properties \
  && add-apt-repository ppa:openjdk-r/ppa -y \
  && apt-get update -y --fix-missing -qq \
  && apt-get -y --no-install-recommends install \
  && DEBIAN_FRONTEND=noninteractive DEBCONF_PRIORITY=critical \
  && apt-get install -y wget libgtk-3-0 openjdk-8-jdk maven openssh-client git vim \
  # Firefox installation
  && wget -q http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2 -O /tmp/firefox.tar.bz2 \
  && tar -C /usr/local -xjf /tmp/firefox.tar.bz2 \
  && ln -s /usr/local/firefox/firefox /usr/bin/firefox \
  && apt-get install -y libdbus-glib-1-2

# Install Chromium.
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install ${CHROME_VERSION:-google-chrome-stable} \
  && rm /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN mkdir -p /home/developer && \
    echo "developer:x:$HOST_USER_UID:$HOST_USER_GID:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:$HOST_USER_UID:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown $HOST_USER_UID:$HOST_USER_GID -R /home/developer

# Adding the entrypoint
COPY ./assets/bin/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

USER developer
ENV HOME /home/developer