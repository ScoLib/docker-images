FROM phusion/baseimage

LABEL maintainer="klgd <slice1213@gmail.com>"

ENV SEAFILE_VERSION 6.3.7
ENV SEAFILE_DOWNLOAD_URL "https://download.seafile.com/d/6e5297246c/files/?p=/pro/seafile-pro-server_${SEAFILE_VERSION}_x86-64.tar.gz&dl=1"

ENV SEAFILE_HOME /opt/seafile

# RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
#     sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list

# install packaged dependencies
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y \ 
    # openjdk-8-jre \
    openjdk-8-jre-headless \
    poppler-utils \
    # python2.7 \
    libpython2.7 \
    python-pip \
    python-setuptools \
    python-imaging \
    python-mysqldb \
    # python-memcache \
    python-ldap \
    python-urllib3 \
\
    libreoffice \
    libreoffice-script-provider-python \
    ttf-wqy-microhei \
    ttf-wqy-zenhei \
    xfonts-wqy \
\
    python-dev \
    libmemcached-dev \
    zlib1g-dev \
    ffmpeg \
    # wget \
\
# install python dependencies
# && pip install --upgrade pip \
    && pip install \
        boto \
        pillow \
        requests \
        moviepy \
        pylibmc \
        django-pylibmc \
        # -i http://mirrors.aliyun.com/pypi/simple/ \
        # --trusted-host mirrors.aliyun.com \
\
# clean up pip as it is no longer required
    && apt-get remove -y \
        python-pip \
    && apt-get autoremove -y \
\
# clean up cache
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/*
# \
# # download seafile
RUN mkdir -p $SEAFILE_HOME \
    && cd $SEAFILE_HOME \
    # && wget -O seafile.tar.gz $SEAFILE_DOWNLOAD_URL \
    && curl -L -o seafile.tar.gz $SEAFILE_DOWNLOAD_URL \
    && tar xfz seafile.tar.gz \
    && rm seafile.tar.gz

# install services, scripts, config
ADD     services    /etc/service
ADD     init.d      /etc/my_init.d
ADD     config      /config
ADD     cron        /etc/cron.d
ADD     bin         /usr/local/sbin

# update permissions
RUN chmod 555 \
        /etc/my_init.d/* \
        /usr/local/sbin/* \
        /etc/service/seafile/* \
        /etc/service/seahub/* \
    && chmod 0644 \
        /etc/cron.d/*

WORKDIR ${SEAFILE_HOME}
VOLUME /data

EXPOSE 8000
EXPOSE 8082
EXPOSE 8080

CMD ["/sbin/my_init"]