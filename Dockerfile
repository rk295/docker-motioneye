FROM phusion/baseimage:0.11
MAINTAINER Robin Kearney <robin@kearney.co.uk>
EXPOSE 8081 8765

ENV MOTION_VERSION=4.2.2
ENV MOTIONEYE_VERSION=0.41

RUN curl -LOs https://github.com/Motion-Project/motion/releases/download/release-$MOTION_VERSION/bionic_motion_$MOTION_VERSION-1_amd64.deb
RUN apt update

RUN apt-get install -q -y --no-install-recommends \
        gcc \
        libavcodec57 \
        libavdevice57 \
        libavformat57 \
        libavutil55 \
        libcurl4-openssl-dev \
        libjpeg8 \
        libmicrohttpd12 \
        libmysqlclient20 \
        libpq5 \
        libssl-dev \
        libswscale4 \
        libwebp6 \
        libwebpmux3 \
        mosquitto-clients \
        python \
        python-dev \
        python-pip && \
        pip install setuptools wheel && \
        apt-get purge -y openssh-client openssh-server openssh-sftp-server && \
        apt-get -y clean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN dpkg -i bionic_motion_$MOTION_VERSION-1_amd64.deb && pip install motioneye==$MOTIONEYE_VERSION

WORKDIR /home/nobody/motioneye
VOLUME ["/config", "/home/nobody/motioneye"]

ADD init/*.sh /etc/my_init.d/
ADD services /etc/service

RUN chmod -v +x /etc/service/*/run /etc/service/*/finish /etc/my_init.d/*.sh