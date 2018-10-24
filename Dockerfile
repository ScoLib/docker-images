FROM alpine:latest

ENV version=2.6.1

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories

RUN apk --update add curl && \
    curl -L http://sourceforge.net/projects/leanote-bin/files/${version}/leanote-linux-amd64-v${version}.bin.tar.gz/download >> \
    /usr/local/leanote-linux-amd64-v${version}.bin.tar.gz && \
    apk del --purge curl && \
    tar -xzvf /usr/local/leanote-linux-amd64-v${version}.bin.tar.gz -C /usr/local && \
    rm -rf /usr/local/leanote-linux-amd64-v${version}.bin.tar.gz

RUN apk add --no-cache \
            mongodb-tools \
            xvfb \
            # Additionnal dependencies for better rendering
            ttf-freefont \
            fontconfig \
            dbus && \
    # Install wkhtmltopdf from `testing` repository   ---- qt5-qtbase-dev \
    apk add wkhtmltopdf \
            --no-cache \
            --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
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
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 9000
WORKDIR  /usr/local/leanote/bin
CMD ["sh","run.sh"]