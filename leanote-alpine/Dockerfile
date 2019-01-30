FROM alpine:latest

LABEL maintainer="klgd <slice1213@gmail.com>"

ENV LEANOTE_VERSION=2.6.1
ENV INSTALL_DIR=/opt
ENV LEANOTE_HOME=${INSTALL_DIR}/leanote
ENV LEANOTE_DATA_DIR=/data

# mongo
ENV LEANOTE_SITE_URL=http://localhost:9000
ENV LEANOTE_MONGO_HOST=mongo
ENV LEANOTE_MONGO_PORT=27017
ENV LEANOTE_MONGO_DATABASE=leanote
# ENV LEANOTE_MONGO_ADMIN_NAME=admin


RUN echo $'@community http://dl-cdn.alpinelinux.org/alpine/edge/community\n\
@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories


RUN apk --update add curl && \
    curl -L http://sourceforge.net/projects/leanote-bin/files/${LEANOTE_VERSION}/leanote-linux-amd64-v${LEANOTE_VERSION}.bin.tar.gz/download >> \
    /tmp/leanote-linux-amd64-v${LEANOTE_VERSION}.bin.tar.gz && \
    apk del --purge curl && \
    mkdir -p ${INSTALL_DIR} && \
    tar -xzvf /tmp/leanote-linux-amd64-v${LEANOTE_VERSION}.bin.tar.gz -C ${INSTALL_DIR} && \
    rm -rf /tmp/leanote-linux-amd64-v${LEANOTE_VERSION}.bin.tar.gz

# COPY ./conf/app.conf ${LEANOTE_HOME}/conf/

RUN apk add --no-cache \
            xvfb \
            # Additionnal dependencies for better rendering
            ttf-freefont \
            fontconfig \
            dbus && \
    # Install mongodb-tools from `community` repository
    apk add --no-cache \
            mongodb-tools@community && \
    # Install wkhtmltopdf from `testing` repository   ---- qt5-qtbase-dev \
    apk add --no-cache \
            wkhtmltopdf@testing \
            --allow-untrusted && \
    rm -rf /var/cache/apk/* && \
    # Wrapper for xvfb
    mv /usr/bin/wkhtmltopdf /usr/bin/wkhtmltopdf-origin && \
    echo $'#!/usr/bin/env sh\n\
Xvfb :0 -screen 0 1024x768x24 -ac +extension GLX +render -noreset & \n\
DISPLAY=:0.0 wkhtmltopdf-origin $@ \n\
killall Xvfb\
' > /usr/bin/wkhtmltopdf && \
    chmod +x /usr/bin/wkhtmltopdf


COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && \
    ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

WORKDIR  ${LEANOTE_HOME}/bin
VOLUME $LEANOTE_DATA_DIR

EXPOSE 9000

CMD ["sh","run.sh"]